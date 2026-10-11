from pathlib import Path
import pandas as pd
import re

# ---------------------------------------------------------
# Project paths
# ---------------------------------------------------------

PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = PROJECT_ROOT / "data" / "raw" / "financials"
OUTPUT_FILE = PROJECT_ROOT / "data" / "processed" / "financials_clean.csv"


# ---------------------------------------------------------
# Find Excel files by year
# ---------------------------------------------------------

def find_workbook(year):
    files = list(RAW_DIR.glob("*.xls")) + list(RAW_DIR.glob("*.xlsx"))

    matches = [
        file for file in files
        if str(year) in file.stem
    ]

    if len(matches) != 1:
        raise FileNotFoundError(
            f"Expected exactly one Excel file containing {year} "
            f"in its filename. Found: {[f.name for f in matches]}"
        )

    return matches[0]


FILE_2025 = find_workbook(2025)
FILE_2023 = find_workbook(2023)
FILE_2022 = find_workbook(2022)


# ---------------------------------------------------------
# Helpers
# ---------------------------------------------------------

def normalize_text(value):
    if pd.isna(value):
        return ""

    value = str(value).strip().lower()

    value = re.sub(r"\(\d+\)", "", value)
    value = re.sub(r"\s+", " ", value)

    return value.strip()


def numeric_values_from_row(row):
    """
    Extract numeric values from an SEC spreadsheet row,
    ignoring currency symbols, percent signs and blank cells.
    """

    values = []

    for value in row:

        if pd.isna(value):
            continue

        if isinstance(value, (int, float)):
            values.append(float(value))
            continue

        text = str(value).strip()

        if text in {"", "$", "%", "¢"}:
            continue

        text = text.replace(",", "")

        # Convert accounting negatives: (123) -> -123
        if re.fullmatch(r"\(\s*-?\d+(\.\d+)?\s*\)", text):
            text = "-" + text.strip("()").strip()

        try:
            values.append(float(text))
        except ValueError:
            pass

    return values


def extract_metric(
    workbook,
    sheet_name,
    metric_text,
    years,
    exclude_text=None,
):
    """
    Find a metric row by its label and assign the numeric
    values on that row to the supplied years in left-to-right
    order.
    """

    df = pd.read_excel(
        workbook,
        sheet_name=sheet_name,
        header=None,
        engine="xlrd" if workbook.suffix.lower() == ".xls" else None,
    )

    metric_text = normalize_text(metric_text)

    for _, row in df.iterrows():

        row_text = " | ".join(
            normalize_text(value)
            for value in row
            if normalize_text(value)
        )

        if metric_text not in row_text:
            continue

        if exclude_text:
            if normalize_text(exclude_text) in row_text:
                continue

        numbers = numeric_values_from_row(row)

        if len(numbers) < len(years):
            continue

        numbers = numbers[:len(years)]

        return dict(zip(years, numbers))

    raise ValueError(
        f"Could not find '{metric_text}' "
        f"in {workbook.name} / {sheet_name}"
    )


# ---------------------------------------------------------
# Main financial statements
# ---------------------------------------------------------

# 2025 filing contains 2025, 2024 and 2023
income_2025 = {
    "passenger_revenue": extract_metric(
        FILE_2025, "INCOME_STATEMENT", "Passenger",
        [2025, 2024, 2023]
    ),
    "total_operating_revenue": extract_metric(
        FILE_2025, "INCOME_STATEMENT", "Total operating revenue",
        [2025, 2024, 2023]
    ),
    "salaries_related": extract_metric(
        FILE_2025, "INCOME_STATEMENT", "Salaries and related costs",
        [2025, 2024, 2023]
    ),
    "fuel_expense": extract_metric(
        FILE_2025, "INCOME_STATEMENT",
        "Aircraft fuel and related taxes",
        [2025, 2024, 2023]
    ),
    "total_operating_expense": extract_metric(
        FILE_2025, "INCOME_STATEMENT",
        "Total operating expense",
        [2025, 2024, 2023]
    ),
    "operating_income": extract_metric(
        FILE_2025, "INCOME_STATEMENT", "Operating income",
        [2025, 2024, 2023]
    ),
    "net_income": extract_metric(
        FILE_2025, "INCOME_STATEMENT", "Net income",
        [2025, 2024, 2023]
    ),
}


# 2023 filing supplies 2022 and 2021
income_2023 = {
    "passenger_revenue": extract_metric(
        FILE_2023, "INCOME_STATEMENT2", "Passenger",
        [2023, 2022, 2021]
    ),
    "total_operating_revenue": extract_metric(
        FILE_2023, "INCOME_STATEMENT2", "Total operating revenue",
        [2023, 2022, 2021]
    ),
    "salaries_related": extract_metric(
        FILE_2023, "INCOME_STATEMENT2", "Salaries and related costs",
        [2023, 2022, 2021]
    ),
    "fuel_expense": extract_metric(
        FILE_2023, "INCOME_STATEMENT2",
        "Aircraft fuel and related taxes",
        [2023, 2022, 2021]
    ),
    "total_operating_expense": extract_metric(
        FILE_2023, "INCOME_STATEMENT2",
        "Total operating expense",
        [2023, 2022, 2021]
    ),
    "operating_income": extract_metric(
        FILE_2023, "INCOME_STATEMENT2", "Operating income",
        [2023, 2022, 2021]
    ),
    "net_income": extract_metric(
        FILE_2023, "INCOME_STATEMENT2", "Net income",
        [2023, 2022, 2021]
    ),
}


# ---------------------------------------------------------
# Operating cash flow
# ---------------------------------------------------------

cash_2025 = extract_metric(
    FILE_2025,
    "CASH_FLOW",
    "Net cash provided by operating activities",
    [2025, 2024, 2023],
)

cash_2023 = extract_metric(
    FILE_2023,
    "CASH_FLOW",
    "Net cash provided by operating activities",
    [2023, 2022, 2021],
)


# ---------------------------------------------------------
# Operating statistics
# ---------------------------------------------------------

# 2025 filing: 2025 and 2024
stats_2025 = {
    "rpm": extract_metric(
        FILE_2025, "TABLE17",
        "Revenue passenger miles",
        [2025, 2024]
    ),
    "asm": extract_metric(
        FILE_2025, "TABLE17",
        "Available seat miles",
        [2025, 2024]
    ),
    "load_factor": extract_metric(
        FILE_2025, "TABLE17",
        "Passenger load factor",
        [2025, 2024]
    ),
    "fuel_gallons": extract_metric(
        FILE_2025, "TABLE17",
        "Fuel gallons consumed",
        [2025, 2024]
    ),
    "fuel_price": extract_metric(
        FILE_2025, "TABLE17",
        "Average price per fuel gallon",
        [2025, 2024],
        exclude_text="adjusted",
    ),
}


# 2023 filing: 2023 and 2022
stats_2023 = {
    "rpm": extract_metric(
        FILE_2023, "TABLE17",
        "Revenue passenger miles",
        [2023, 2022]
    ),
    "asm": extract_metric(
        FILE_2023, "TABLE17",
        "Available seat miles",
        [2023, 2022]
    ),
    "load_factor": extract_metric(
        FILE_2023, "TABLE17",
        "Passenger load factor",
        [2023, 2022]
    ),
    "fuel_gallons": extract_metric(
        FILE_2023, "TABLE17",
        "Fuel gallons consumed",
        [2023, 2022]
    ),
    "fuel_price": extract_metric(
        FILE_2023, "TABLE17",
        "Average price per fuel gallon",
        [2023, 2022],
        exclude_text="adjusted",
    ),
}


# 2022 filing: used specifically to complete 2021 statistics
stats_2022 = {
    "rpm": extract_metric(
        FILE_2022, "TABLE18",
        "Revenue passenger miles",
        [2022, 2021, 2019]
    ),
    "asm": extract_metric(
        FILE_2022, "TABLE18",
        "Available seat miles",
        [2022, 2021, 2019]
    ),
    "load_factor": extract_metric(
        FILE_2022, "TABLE18",
        "Passenger load factor",
        [2022, 2021, 2019]
    ),
    "fuel_gallons": extract_metric(
        FILE_2022, "TABLE18",
        "Fuel gallons consumed",
        [2022, 2021, 2019]
    ),
    "fuel_price": extract_metric(
        FILE_2022, "TABLE18",
        "Average price per fuel gallon",
        [2022, 2021, 2019],
        exclude_text="adjusted",
    ),
}


# ---------------------------------------------------------
# Build final 2021–2025 table
# ---------------------------------------------------------

records = []

for year in range(2021, 2026):

    # Financial statement source
    income_source = income_2025 if year >= 2023 else income_2023

    # Cash-flow source
    cash_source = cash_2025 if year >= 2023 else cash_2023

    # Operating-statistics source
    if year >= 2024:
        stats_source = stats_2025
        stats_10k_year = 2025
    elif year >= 2022:
        stats_source = stats_2023
        stats_10k_year = 2023
    else:
        stats_source = stats_2022
        stats_10k_year = 2022

    revenue = income_source[
        "total_operating_revenue"
    ][year]

    operating_income = income_source[
        "operating_income"
    ][year]

    record = {
        "fiscal_year": year,

        "passenger_revenue_usd_millions":
            income_source["passenger_revenue"][year],

        "total_operating_revenue_usd_millions":
            revenue,

        "total_operating_expense_usd_millions":
            income_source["total_operating_expense"][year],

        "salaries_related_costs_usd_millions":
            income_source["salaries_related"][year],

        "fuel_expense_usd_millions":
            income_source["fuel_expense"][year],

        "operating_income_usd_millions":
            operating_income,

        "net_income_usd_millions":
            income_source["net_income"][year],

        "operating_cash_flow_usd_millions":
            cash_source[year],

        "operating_margin_pct":
            round(
                operating_income / revenue * 100,
                2
            ),

        "rpm_millions":
            stats_source["rpm"][year],

        "asm_millions":
            stats_source["asm"][year],

        "passenger_load_factor_pct":
            stats_source["load_factor"][year],

        "fuel_gallons_consumed_millions":
            stats_source["fuel_gallons"][year],

        "average_fuel_price_usd_per_gallon":
            stats_source["fuel_price"][year],

        "source_financials_10k_year":
            2025 if year >= 2023 else 2023,

        "source_operating_stats_10k_year":
            stats_10k_year,
    }

    records.append(record)


financials = pd.DataFrame(records)


# ---------------------------------------------------------
# Validation checks before writing
# ---------------------------------------------------------

expected_years = [2021, 2022, 2023, 2024, 2025]

if financials["fiscal_year"].tolist() != expected_years:
    raise ValueError("Unexpected fiscal-year sequence.")

if financials.isna().any().any():
    raise ValueError(
        "Missing values found in cleaned financial dataset."
    )


# ---------------------------------------------------------
# Save
# ---------------------------------------------------------

financials.to_csv(
    OUTPUT_FILE,
    index=False
)

print("\nFINANCIAL CLEANING COMPLETE")
print("----------------------------------")
print(f"Rows: {len(financials)}")
print(
    "Years:",
    financials["fiscal_year"].tolist()
)
print(f"Output: {OUTPUT_FILE}")
print("----------------------------------")
