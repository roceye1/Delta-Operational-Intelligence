"""Verify exact dataset bytes against docs/source_manifest.csv."""

import argparse
import csv
import hashlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "docs/source_manifest.csv"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(8 * 1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def verify(root: Path, scope: str) -> None:
    with MANIFEST.open(newline="") as stream:
        rows = list(csv.DictReader(stream))
    selected = [row for row in rows if scope == "all" or row["storage"] == scope]
    failures = []
    for row in selected:
        path = root / row["path"]
        if not path.is_file():
            failures.append(f"missing: {row['path']}")
        elif path.stat().st_size != int(row["size_bytes"]):
            failures.append(f"size mismatch: {row['path']}")
        elif sha256(path) != row["sha256"]:
            failures.append(f"SHA-256 mismatch: {row['path']}")
    if failures:
        raise SystemExit("\n".join(failures))
    print(f"Verified {len(selected)} files ({sum(int(r['size_bytes']) for r in selected):,} bytes)")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument("--scope", choices=("public", "private", "all"), default="public")
    args = parser.parse_args()
    verify(args.root, args.scope)
