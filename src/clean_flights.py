from pathlib import Path
import pandas as pd
import numpy as np

# ---------------------------------------------------------
# Project paths
# ---------------------------------------------------------

PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_FLIGHTS_DIR = PROJECT_ROOT / "data" / "raw" / "flights"
OUTPUT_DIR = PROJECT_ROOT / "data" / "processed"
OUTPUT_FILE = OUTPUT_DIR / "flights_2025_delta_clean.csv"

OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# ---------------------------------------------------------
# Columns required from the BTS source files
# ---------------------------------------------------------

USE_COLUMNS = [
    "Year",
    "Quarter",
    "Month",
    "DayofMonth",
    "DayOfWeek",
    "FlightDate",
    "IATA_Code_Marketing_Airline",
    "IATA_Code_Operating_Airline",
    "Flight_Number_Marketing_Airline",
    "Tail_Number",
    "Origin",
    "OriginCityName",
    "OriginState",
    "Dest",
    "DestCityName",
    "DestState",
    "CRSDepTime",
    "DepTime",
    "DepDelay",
    "DepDelayMinutes",
    "DepDel15",
    "CRSArrTime",
    "ArrTime",
    "ArrDelay",
    "ArrDelayMinutes",
    "ArrDel15",
    "Cancelled",
    "CancellationCode",
    "Diverted",
    "CRSElapsedTime",
    "ActualElapsedTime",
    "AirTime",
    "Distance",
    "DistanceGroup",
    "CarrierDelay",
    "WeatherDelay",
    "NASDelay",
    "SecurityDelay",
    "LateAircraftDelay",
]

# ---------------------------------------------------------
# Standardized analytical field names
# ---------------------------------------------------------

RENAME_COLUMNS = {
    "FlightDate": "flight_date",
    "IATA_Code_Marketing_Airline": "marketing_carrier",
    "IATA_Code_Operating_Airline": "operating_carrier",
    "Flight_Number_Marketing_Airline": "flight_number",
    "Tail_Number": "tail_number",
    "Origin": "origin",
    "OriginCityName": "origin_city",
    "OriginState": "origin_state",
    "Dest": "destination",
    "DestCityName": "destination_city",
    "DestState": "destination_state",
    "CRSDepTime": "scheduled_departure",
    "DepTime": "actual_departure",
    "DepDelay": "departure_delay",
    "DepDelayMinutes": "departure_delay_minutes",
    "DepDel15": "departure_delayed_15",
    "CRSArrTime": "scheduled_arrival",
    "ArrTime": "actual_arrival",
    "ArrDelay": "arrival_delay",
    "ArrDelayMinutes": "arrival_delay_minutes",
    "ArrDel15": "bts_arrival_delayed_15",
    "Cancelled": "cancelled",
    "CancellationCode": "cancellation_code",
    "Diverted": "diverted",
    "CRSElapsedTime": "scheduled_elapsed_time",
    "ActualElapsedTime": "actual_elapsed_time",
    "AirTime": "air_time",
    "Distance": "distance_miles",
    "DistanceGroup": "distance_group_bts",
    "CarrierDelay": "carrier_delay_minutes",
    "WeatherDelay": "weather_delay_minutes",
    "NASDelay": "nas_delay_minutes",
    "SecurityDelay": "security_delay_minutes",
    "LateAircraftDelay": "late_aircraft_delay_minutes",
}

DAY_NAMES = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday",
}


def clean_chunk(df):
    """Filter one BTS data chunk to Delta and create analytical fields."""

    # Remove accidental spaces from BTS column names.
    df.columns = df.columns.str.strip()

    # Keep only Delta-marketed flights.
    df = df[df["IATA_Code_Marketing_Airline"] == "DL"].copy()

    if df.empty:
        return df

    df = df.rename(columns=RENAME_COLUMNS)

    # Standardize date.
    df["flight_date"] = pd.to_datetime(
        df["flight_date"],
        errors="coerce"
    )

    # Convert flags to integer-like values.
    df["cancelled"] = pd.to_numeric(
        df["cancelled"], errors="coerce"
    ).fillna(0).astype("int8")

    df["diverted"] = pd.to_numeric(
        df["diverted"], errors="coerce"
    ).fillna(0).astype("int8")

    # -----------------------------------------------------
    # Derived calendar fields
    # -----------------------------------------------------

    df["year"] = df["flight_date"].dt.year
    df["month"] = df["flight_date"].dt.month
    df["month_name"] = df["flight_date"].dt.month_name()

    df["day_of_week_number"] = pd.to_numeric(
        df["DayOfWeek"], errors="coerce"
    )

    df["day_of_week"] = df["day_of_week_number"].map(DAY_NAMES)

    # -----------------------------------------------------
    # Route
    # -----------------------------------------------------

    df["route"] = (
        df["origin"].astype(str)
        + "-"
        + df["destination"].astype(str)
    )

    # -----------------------------------------------------
    # Scheduled departure hour
    # BTS CRSDepTime is stored as HHMM.
    # -----------------------------------------------------

    scheduled_dep_numeric = pd.to_numeric(
        df["scheduled_departure"],
        errors="coerce"
    )

    df["departure_hour"] = (
        scheduled_dep_numeric // 100
    ).astype("Int64")

    # BTS can occasionally use 2400.
    df.loc[df["departure_hour"] == 24, "departure_hour"] = 0

    # -----------------------------------------------------
    # Delay target
    #
    # Only completed, non-diverted flights are eligible for
    # the arrival-delay classification.
    # -----------------------------------------------------

    arrival_delay_numeric = pd.to_numeric(
        df["arrival_delay"],
        errors="coerce"
    )

    eligible_arrival = (
        (df["cancelled"] == 0)
        & (df["diverted"] == 0)
        & arrival_delay_numeric.notna()
    )

    df["arrival_delayed_15"] = pd.Series(
        pd.NA,
        index=df.index,
        dtype="Int64"
    )

    df.loc[
        eligible_arrival,
        "arrival_delayed_15"
    ] = (
        arrival_delay_numeric.loc[eligible_arrival] >= 15
    ).astype(int)

    # -----------------------------------------------------
    # Delay category
    # -----------------------------------------------------

    conditions = [
        df["cancelled"] == 1,
        df["diverted"] == 1,
        eligible_arrival & (arrival_delay_numeric < 15),
        eligible_arrival
        & (arrival_delay_numeric >= 15)
        & (arrival_delay_numeric < 30),
        eligible_arrival
        & (arrival_delay_numeric >= 30)
        & (arrival_delay_numeric < 60),
        eligible_arrival
        & (arrival_delay_numeric >= 60)
        & (arrival_delay_numeric < 120),
        eligible_arrival & (arrival_delay_numeric >= 120),
    ]

    categories = [
        "Cancelled",
        "Diverted",
        "On time / <15 min",
        "15-29 min",
        "30-59 min",
        "60-119 min",
        "120+ min",
    ]

    df["delay_category"] = np.select(
        conditions,
        categories,
        default="Unknown"
    )

    # -----------------------------------------------------
    # Distance band
    # -----------------------------------------------------

    distance = pd.to_numeric(
        df["distance_miles"],
        errors="coerce"
    )

    df["distance_band"] = pd.cut(
        distance,
        bins=[0, 500, 1000, 1500, 2500, np.inf],
        labels=[
            "<500 miles",
            "500-999 miles",
            "1,000-1,499 miles",
            "1,500-2,499 miles",
            "2,500+ miles",
        ],
        right=False,
    )

    # Columns no longer needed after derivation.
    df = df.drop(
        columns=[
            "Year",
            "Quarter",
            "Month",
            "DayofMonth",
            "DayOfWeek",
        ],
        errors="ignore",
    )

    return df


def main():

    # Search both the flight folder and any monthly subfolders.
    csv_files = sorted(RAW_FLIGHTS_DIR.rglob("*.csv"))

    if not csv_files:
        raise FileNotFoundError(
            f"No CSV files found inside: {RAW_FLIGHTS_DIR}"
        )

    print(f"Found {len(csv_files)} CSV files.")

    # Start clean each time the script runs.
    if OUTPUT_FILE.exists():
        OUTPUT_FILE.unlink()

    total_source_rows = 0
    total_delta_rows = 0
    first_write = True

    for file_number, csv_file in enumerate(csv_files, start=1):

        print(
            f"\nProcessing file {file_number}/{len(csv_files)}:"
            f"\n{csv_file.name}"
        )

        # Read in chunks so the computer does not need to load
        # the entire 2025 dataset into memory at once.
        for chunk in pd.read_csv(
            csv_file,
            usecols=lambda column: column.strip() in USE_COLUMNS,
            chunksize=200_000,
            low_memory=False,
        ):

            total_source_rows += len(chunk)

            cleaned = clean_chunk(chunk)

            if cleaned.empty:
                continue

            total_delta_rows += len(cleaned)

            cleaned.to_csv(
                OUTPUT_FILE,
                mode="w" if first_write else "a",
                header=first_write,
                index=False,
            )

            first_write = False

    print("\n---------------------------------------")
    print("FLIGHT CLEANING COMPLETE")
    print("---------------------------------------")
    print(f"Source rows scanned: {total_source_rows:,}")
    print(f"Delta rows retained: {total_delta_rows:,}")
    print(f"Output file: {OUTPUT_FILE}")
    print("---------------------------------------")


if __name__ == "__main__":
    main()
