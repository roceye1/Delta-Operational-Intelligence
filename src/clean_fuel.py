from pathlib import Path
import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parents[1]

FILE = (
    PROJECT_ROOT
    / "data"
    / "processed"
    / "fuel_prices_clean.csv"
)

fuel = pd.read_csv(FILE)

# Keep only first two columns
fuel = fuel.iloc[:, :2].copy()

# Standardize column names
fuel.columns = [
    "month",
    "jet_fuel_price_usd_per_gallon"
]

# Convert data types
fuel["month"] = pd.to_datetime(
    fuel["month"],
    errors="coerce"
)

fuel["jet_fuel_price_usd_per_gallon"] = pd.to_numeric(
    fuel["jet_fuel_price_usd_per_gallon"],
    errors="coerce"
)

# Remove blank / invalid rows
fuel = fuel.dropna(
    subset=[
        "month",
        "jet_fuel_price_usd_per_gallon"
    ]
)

# Keep project period only
fuel = fuel[
    (fuel["month"] >= "2021-01-01")
    & (fuel["month"] <= "2025-12-31")
]

fuel = fuel.sort_values("month")

fuel.to_csv(
    FILE,
    index=False
)

print("FUEL CLEANING COMPLETE")
print(f"Rows: {len(fuel)}")
print(
    f"Date range: "
    f"{fuel['month'].min()} to "
    f"{fuel['month'].max()}"
)
