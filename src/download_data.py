"""Retrieve this project's exact public source files from Git LFS and verify them.

Vendor downloads can change over time. The original BTS CSVs and EIA workbook
are stored in this repository; the EDGAR Online XLS files are private.
"""

import argparse
import subprocess
from verify_manifest import ROOT, verify


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--verify-only", action="store_true")
    args = parser.parse_args()
    if not args.verify_only:
        subprocess.run(["git", "lfs", "pull"], cwd=ROOT, check=True)
    verify(ROOT, "public")


if __name__ == "__main__":
    main()
