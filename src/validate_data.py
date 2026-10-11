from pathlib import Path
import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parents[1]
FILE = PROJECT_ROOT / "data" / "processed" / "flights_2025_delta_clean.csv"

df = pd.read_csv(
    FILE,
    usecols=[
        "flight_date",
        "marketing_carrier",
        "operating_carrier",
        "origin",
        "destination",
        "cancelled",
        "diverted",
        "arrival_delayed_15",
        "arrival_delay",
        "route",
    ],
    low_memory=False,
)

df["flight_date"] = pd.to_datetime(df["flight_date"], errors="coerce")

print("\nFLIGHT DATA VALIDATION")
print("----------------------------------")
print(f"Rows: {len(df):,}")
print(f"Date range: {df['flight_date'].min()} to {df['flight_date'].max()}")
print(f"Marketing carriers: {df['marketing_carrier'].dropna().unique()}")
print(f"Unique operating carriers: {df['operating_carrier'].nunique()}")
print(f"Unique origins: {df['origin'].nunique()}")
print(f"Unique destinations: {df['destination'].nunique()}")
print(f"Unique routes: {df['route'].nunique()}")
print(f"Cancelled flights: {int(df['cancelled'].sum()):,}")
print(f"Diverted flights: {int(df['diverted'].sum()):,}")

eligible = (
    (df["cancelled"] == 0)
    & (df["diverted"] == 0)
    & df["arrival_delay"].notna()
)

print(f"Eligible completed flights: {eligible.sum():,}")
print(
    "15+ minute delayed flights:",
    f"{(df.loc[eligible, 'arrival_delayed_15'] == 1).sum():,}"
)

print(
    "Missing delay target among eligible flights:",
    df.loc[eligible, "arrival_delayed_15"].isna().sum()
)

print("----------------------------------")
anomaly = df[
    (df["cancelled"] == 0)
    & (df["diverted"] == 0)
    & (df["arrival_delay"].isna())
]

print("\nCompleted flights with missing arrival delay:")
print(
    anomaly[
        [
            "flight_date",
            "origin",
            "destination",
            "operating_carrier",
            "cancelled",
            "diverted",
            "arrival_delay",
        ]
    ]
)
print("\nFINANCIAL DATA VALIDATION")
print("----------------------------------")

financial_file = (
    PROJECT_ROOT
    / "data"
    / "processed"
    / "financials_clean.csv"
)

fin = pd.read_csv(financial_file)

print(f"Rows: {len(fin)}")
print(f"Years: {sorted(fin['fiscal_year'].tolist())}")
print(f"Duplicate years: {fin['fiscal_year'].duplicated().sum()}")

key_columns = [
    "total_operating_revenue_usd_millions",
    "total_operating_expense_usd_millions",
    "operating_income_usd_millions",
    "net_income_usd_millions",
    "operating_cash_flow_usd_millions",
    "operating_margin_pct",
]

print("\nMissing values in key financial fields:")
print(fin[key_columns].isna().sum())

calculated_margin = (
    fin["operating_income_usd_millions"]
    / fin["total_operating_revenue_usd_millions"]
    * 100
)

margin_difference = (
    calculated_margin - fin["operating_margin_pct"]
).abs()

print(
    "\nMaximum operating-margin difference:",
    round(margin_difference.max(), 4),
    "percentage points"
)

print("----------------------------------")
print("\nFUEL PRICE DATA VALIDATION")
print("----------------------------------")

fuel_file = (
    PROJECT_ROOT
    / "data"
    / "processed"
    / "fuel_prices_clean.csv"
)

fuel = pd.read_csv(fuel_file)

# Use the first two columns regardless of their long original EIA names.
fuel = fuel.iloc[:, :2].copy()
fuel.columns = ["month", "jet_fuel_price_usd_per_gallon"]

fuel["month"] = pd.to_datetime(
    fuel["month"],
    errors="coerce"
)

fuel["jet_fuel_price_usd_per_gallon"] = pd.to_numeric(
    fuel["jet_fuel_price_usd_per_gallon"],
    errors="coerce"
)

print(f"Rows: {len(fuel)}")
print(f"Date range: {fuel['month'].min()} to {fuel['month'].max()}")
print(f"Duplicate months: {fuel['month'].duplicated().sum()}")
print(
    "Missing dates:",
    fuel["month"].isna().sum()
)
print(
    "Missing fuel prices:",
    fuel["jet_fuel_price_usd_per_gallon"].isna().sum()
)
print(
    "Non-positive fuel prices:",
    (fuel["jet_fuel_price_usd_per_gallon"] <= 0).sum()
)

expected_months = pd.date_range(
    start="2021-01-01",
    end="2025-12-01",
    freq="MS"
)

actual_months = pd.DatetimeIndex(
    fuel["month"].dropna()
).to_period("M")

expected_periods = expected_months.to_period("M")

missing_months = expected_periods.difference(actual_months)

print(f"Expected months: {len(expected_months)}")
print(f"Missing months: {len(missing_months)}")

if len(missing_months) > 0:
    print("Missing month list:")
    print(missing_months)

print("----------------------------------")
print("\nInvalid fuel rows:")
print(
    fuel[
        fuel["month"].isna()
        | fuel["jet_fuel_price_usd_per_gallon"].isna()
    ]
)