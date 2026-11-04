# Restore and reproduce the Delta analysis

## What is backed up

`docs/source_manifest.csv` records the relative path, source, storage location, byte count, and SHA-256 for every available raw input and processed dataset. The 12 BTS monthly CSVs are the raw flight inputs. ZIP archives were not found and are not needed by the pipeline. The three EDGAR Online-derived financial workbooks are reserved for the private archive because their public redistribution rights are unclear.

The public GitHub repository holds the BTS CSVs, their bundled readmes, the EIA workbook, and all three processed CSVs. The large flight CSVs use Git LFS. A GitHub ZIP download or a clone with only LFS pointer files is incomplete.

## Fresh retrieval and integrity check

```bash
git clone https://github.com/roceye1/Delta-Operational-Intelligence.git
cd Delta-Operational-Intelligence
git lfs pull
python3 src/verify_manifest.py --scope public
```

The verifier checks file existence, byte count, and SHA-256. It must report 28 public files. To verify the three private workbooks, put them at the manifest paths from the private archive, then run `python3 src/verify_manifest.py --scope all`. Do not substitute similarly named workbooks without matching hashes.

## Recreate processed data

Create a Python environment and install `requirements.txt`. The source workbook readers require `xlrd`; `.xlsx` support uses `openpyxl`. To avoid replacing the backed-up output while checking reproducibility, write into another directory:

```bash
python3 src/clean_flights.py --output /tmp/flights_regenerated.csv
python3 src/clean_fuel.py --output /tmp/fuel_regenerated.csv
python3 src/clean_financials.py --output /tmp/financials_regenerated.csv
python3 src/validate_data.py
```

`clean_financials.py` needs the three private workbooks in `data/raw/financials/`. `src/download_data.py` retrieves the public Git LFS inputs from this repository and verifies them; the exact EDGAR Online workbooks must be obtained from the private archive.

## Database and Power BI

Run `src/load_postgres.py` against a **new, dedicated database/schema** to load the three processed CSVs and create the reporting views from `sql/`. See its `--help` for arguments. Existing `powerBI/vw_*.csv` exports and `powerBI/Delta_Operational_Intelligence_PowerBI_Data.xlsx` are reporting artifacts. The interactive PBIX requires Power BI Desktop, which is unavailable on macOS; compare exported view counts and columns in a PostgreSQL environment before refreshing it.

## Before reclaiming Mac storage

Keep the original clone and raw-data backup intact until a fresh GitHub clone has retrieved every LFS object, all public and private checksums match, and the analytical outputs have been reproduced. A second independent backup is preferable. Deleting local originals requires explicit user approval; nothing in this runbook grants it.
