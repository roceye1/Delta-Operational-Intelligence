# Data source register

The exact files used by this project are listed with byte counts and SHA-256 hashes in [source_manifest.csv](source_manifest.csv). The 2025 BTS downloads in the local backup are **12 extracted monthly CSV files**, each accompanied by a `readme.html`. No ZIP archive was found in either supplied folder or the backup's reachable Git history. The CSV files are the inputs used by `src/clean_flights.py`; ZIP files are not required to reproduce this analysis.

| Source | Files found | Scope | Provenance |
|---|---:|---|---|
| U.S. Bureau of Transportation Statistics, Marketing Carrier On-Time Performance | 12 CSVs and 12 identical `readme.html` copies | January–December 2025 | [BTS table](https://www.transtats.bts.gov/TableInfo.asp?QO_fu146_anzr=b0-gvzr&V0s1_b0yB=D&gnoyr_VQ=FGK) |
| EDGAR Online-derived Delta Air Lines 10-K workbooks | `2022.xls`, `2023.xls`, `2025.xls` | 2021–2025 | Workbooks identify EDGAR Online, Inc. as creator. They are held in the private archive pending redistribution-rights review. |
| U.S. Energy Information Administration, U.S. Gulf Coast Kerosene-Type Jet Fuel Spot Price FOB | `EER_EPJK_PF4_RGC_DPGm.xls` | January 2021–December 2025 | [EIA series](https://www.eia.gov/dnav/pet/hist/eer_epjk_pf4_rgc_dpgM.htm) |

The backup also held `flights_2025_delta_clean.csv`, `fuel_prices_clean.csv`, and `financials_clean.csv`. Their exact hashes are in the manifest. The first two were absent from the original clone. `financials_clean.csv` matched the clone byte for byte.

The original source-register download dates (October 2026) are unverified local notes. The manifest records the files actually available on November 4, 2026. Re-downloading BTS or EIA later could yield revised source bytes; use the recorded files to reproduce the existing outputs.
