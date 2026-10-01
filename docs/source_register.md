# Data Source Register

This document records all external datasets used in the project. Raw source files will be stored unchanged in the `data/raw/` directory.

| ID | Source | Dataset / Document | Period | Purpose | Raw File Location | Download Date | Status |
|---|---|---|---|---|---|---|---|
| DS01 | Bureau of Transportation Statistics | Marketing Carrier On-Time Performance | Jan–Dec 2025 | Flight operations, delays, cancellations, routes and delay causes | `data/raw/flights/` | — | Not downloaded |
| DS02 | Delta Air Lines / SEC | Delta Air Lines Form 10-K filings | 2021–2025 | Revenue, income, expenses, cash flow and operating metrics | `data/raw/financials/` | — | Not downloaded |
| DS03 | U.S. Energy Information Administration | U.S. Gulf Coast Kerosene-Type Jet Fuel Spot Price FOB | 2021–2025 monthly | Jet-fuel market-price analysis | `data/raw/fuel/` | — | Not downloaded |

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
- Cleaning and transformations will be performed using Python scripts.
- Processed files will be stored separately in `data/interim/` or `data/processed/`.
- Download dates and final filenames will be recorded when each dataset is collected.
