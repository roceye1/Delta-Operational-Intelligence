"""Build the monthly fuel-price CSV from the unchanged EIA Excel source."""

import argparse
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SOURCE = ROOT / "data/raw/fuel/EER_EPJK_PF4_RGC_DPGm.xls"
DEFAULT_OUTPUT = ROOT / "data/processed/fuel_prices_clean.csv"


def clean(source: Path, output: Path) -> pd.DataFrame:
    raw = pd.read_excel(source, engine="xlrd", usecols=[0, 1])
    raw.columns = ["month", "jet_fuel_price_usd_per_gallon"]
    # EIA dates are mid-month in Excel; analytical rows use month starts.
    raw["month"] = pd.to_datetime(raw["month"]).dt.to_period("M").dt.to_timestamp()
    raw["jet_fuel_price_usd_per_gallon"] = pd.to_numeric(
        raw["jet_fuel_price_usd_per_gallon"], errors="coerce"
    )
    fuel = raw.dropna().loc[
        lambda df: df["month"].between("2021-01-01", "2025-12-31")
    ].sort_values("month")
    if len(fuel) != 60 or fuel["month"].dt.to_period("M").nunique() != 60:
        raise ValueError("Expected one EIA fuel price for every month of 2021–2025")
    output.parent.mkdir(parents=True, exist_ok=True)
    fuel.to_csv(output, index=False)
    return fuel


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    result = clean(args.source, args.output)
    print(f"Wrote {len(result)} monthly prices to {args.output}")
