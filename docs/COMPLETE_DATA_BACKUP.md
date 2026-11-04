# Complete data backup and reproducibility checklist

This project must keep **the original, unchanged source files** and all reproducibility-relevant processed data in GitHub. The `data/raw/` folders on `main` currently contain placeholders only. **Do not delete any local originals until a separate fresh clone has retrieved and verified every file.**

## Upload from the existing backup (preferred)

1. Install Git and Git LFS, then run `git lfs install`.
2. Clone this repository, switch to the data-backup branch (or merge its PR first).
3. Copy original files from your existing backup into their respective paths, preserving filenames and bytes:
   - `data/raw/flights/`: 12 original 2025 BTS Marketing Carrier monthly ZIP archives **plus** any extracted CSV files used by `src/clean_flights.py`.
   - `data/raw/financials/`: 2025, 2023 and 2022 original SEC-derived Excel filing workbooks.
   - `data/raw/fuel/`: original EIA monthly jet-fuel-price workbook.
   - `data/processed/`: `flights_2025_delta_clean.csv`, `financials_clean.csv`, `fuel_prices_clean.csv`.
   - Include any other intermediate datasets necessary to run SQL/Power BI exactly as originally built.
4. Verify that the expected files exist locally, then use:
   ```bash
   git add .gitattributes .gitignore data/ outputs/
   git lfs ls-files
   git status
   git commit -m "Back up original raw and processed analytics datasets"
   git push
   ```
5. Confirm that LFS objects were uploaded successfully and that there are no size/quota errors.
6. **Make a fresh clone in another directory**, run `git lfs pull`, verify source file counts and SHA-256 checksums, and run the analytical pipeline. Only then consider deleting local duplicates.

## Source inventory to verify

| Source | Expected originals |
|---|---|
| BTS marketing-carrier on-time performance, Jan-Dec 2025 | 12 ZIP archives |
| Delta SEC filing workbooks | 2025, 2023, 2022 Excel workbooks |
| EIA U.S. Gulf Coast jet-fuel prices, 2021-2025 | 1 workbook |

The listed 16 original files are not currently present in GitHub. Their exact names, byte sizes and checksums must be recorded from the existing backup. Do not substitute newly downloaded versions without first comparing content and confirming transformation compatibility.

## Git LFS and verification

GitHub stores LFS pointers in Git, while the associated source bytes are uploaded to LFS storage. A repository ZIP download or a clone without LFS objects is **not a full backup**. Use a fresh clone and `git lfs pull` for verification.

On macOS, these commands can help create a manifest of backed-up originals:

```bash
find data/raw -type f ! -name .gitkeep -print0 | sort -z | xargs -0 shasum -a 256 > docs/raw_sha256_manifest.txt
shasum -a 256 -c docs/raw_sha256_manifest.txt
```

If the raw filenames contain unusual characters or GitHub LFS quota is insufficient, verify each file with a separate manifest or use an additional independent data archive. Never rely on a single hosting service as the only copy of irreplaceable data.

## Blocking engineering gaps

- `src/download_data.py` is currently empty; local originals are still necessary.
- `src/clean_flights.py` reads extracted CSVs, not the original monthly ZIPs.
- `src/clean_fuel.py` reads a prepared CSV and does not parse original EIA workbooks.
- A PostgreSQL ingest script, version lockfile and end-to-end validation automation are still needed.
- The two notebook files are 1-byte placeholders and should not be presented as runnable notebooks.

Data acquisition and test automation must be separately implemented and validated; adding LFS configuration alone does **not** make the project reproducible.
