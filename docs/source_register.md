# Data Source Register

This document records all external datasets used in the project. Raw source files are stored unchanged in the `data/raw/` directory and are intentionally excluded from GitHub by `.gitignore`.

| ID | Source | Dataset / Document | Period | Purpose | Raw File Location | Download Date | Status |
|---|---|---|---|---|---|---|---|
| DS01 | Bureau of Transportation Statistics | Marketing Carrier On-Time Performance | Jan–Dec 2025 | Flight operations, delays, cancellations, routes and delay causes | `data/raw/flights/` | 2026-10-01 | Downloaded locally |
| DS02 | Delta Air Lines / SEC | Delta Air Lines Form 10-K filings (2025 and 2023 comparative filings) | 2021–2025 | Revenue, income, expenses, cash flow and operating metrics | `data/raw/financials/` | 2026-10-01 | Downloaded locally |
| DS03 | U.S. Energy Information Administration | U.S. Gulf Coast Kerosene-Type Jet Fuel Spot Price FOB | 2021–2025 monthly | Jet-fuel market-price analysis | `data/raw/fuel/` | 2026-10-01 | Downloaded locally |

## Files Collected

### DS01 — Bureau of Transportation Statistics
- Twelve monthly 2025 ZIP archives were downloaded.
- Dataset family: Marketing Carrier On-Time Performance.
- January–December 2025 are stored in `data/raw/flights/`.
- Original ZIP files are preserved unchanged.

### DS02 — Delta Air Lines / SEC
- Delta Air Lines 2025 Form 10-K Excel workbook.
- Delta Air Lines 2023 Form 10-K Excel workbook.
- Together, the comparative financial statements are intended to cover the main 2021–2025 financial metrics required by the project.
- Original workbooks are stored unchanged in `data/raw/financials/`.

### DS03 — U.S. Energy Information Administration
- Monthly U.S. Gulf Coast Kerosene-Type Jet Fuel Spot Price FOB spreadsheet.
- Original workbook is stored unchanged in `data/raw/fuel/`.

## Source URLs

### DS01 — Bureau of Transportation Statistics

Bureau of Transportation Statistics — Marketing Carrier On-Time Performance

https://www.transtats.bts.gov/Marketing_Annual.aspx

### DS02 — Delta Air Lines / SEC

Delta Air Lines Investor Relations

https://ir.delta.com/

U.S. Securities and Exchange Commission — Delta Air Lines filings

https://www.sec.gov/edgar/browse/?CIK=27904

### DS03 — U.S. Energy Information Administration

U.S. Gulf Coast Kerosene-Type Jet Fuel Spot Price FOB

https://www.eia.gov/dnav/pet/hist/eer_epjk_pf4_rgc_dpgM.htm

## Source Management Rules

- Original downloaded files will remain unchanged.
- Raw files will be stored only in `data/raw/`.
- Raw datasets are not committed to GitHub unless intentionally selected for publication.
- Cleaning and transformations will be performed using Python scripts.
- Processed files will be stored separately in `data/interim/` or `data/processed/`.
- Exact source filenames will be captured during the local inspection step before transformation begins.
