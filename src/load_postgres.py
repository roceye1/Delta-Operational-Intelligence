"""Load verified processed CSVs into a new PostgreSQL schema and build views.

Set DELTA_DATABASE_URL (or pass --dsn) to a database you control. This command
refuses to reuse an existing schema so no pre-existing tables are replaced.
"""

import argparse
import csv
import os
from pathlib import Path

import psycopg2
from psycopg2 import sql

ROOT = Path(__file__).resolve().parents[1]
FILES = {
    "flights": ROOT / "data/processed/flights_2025_delta_clean.csv",
    "financials": ROOT / "data/processed/financials_clean.csv",
    "fuel_prices": ROOT / "data/processed/fuel_prices_clean.csv",
}
VIEWS = [
    "vw_monthly_operations", "vw_airport_monthly_operations",
    "vw_route_monthly_operations", "vw_monthly_delay_causes",
    "vw_carrier_monthly_operations", "vw_financial_performance",
    "vw_fuel_economics",
]


def load(dsn: str, schema: str) -> None:
    if not schema.replace("_", "").isalnum() or not schema[0].isalpha():
        raise ValueError("Schema must start with a letter and contain only letters, digits, underscores")
    for path in FILES.values():
        if not path.is_file():
            raise FileNotFoundError(path)
    with psycopg2.connect(dsn) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = %s)", (schema,))
            if cur.fetchone()[0]:
                raise ValueError(f"Schema {schema!r} already exists; use a new schema name")
            cur.execute(sql.SQL("CREATE SCHEMA {}").format(sql.Identifier(schema)))
            cur.execute(sql.SQL("SET LOCAL search_path TO {}").format(sql.Identifier(schema)))
            cur.execute((ROOT / "sql/01_create_tables.sql").read_text())
            for table, path in FILES.items():
                with path.open("r", newline="") as stream:
                    columns = next(csv.reader(stream))
                    stream.seek(0)
                    cur.execute(
                        "SELECT column_name FROM information_schema.columns "
                        "WHERE table_schema = %s AND table_name = %s",
                        (schema, table),
                    )
                    expected = {row[0] for row in cur.fetchall()}
                    if set(columns) != expected or len(columns) != len(expected):
                        raise ValueError(f"CSV columns do not match table {table}")
                    cur.copy_expert(
                        sql.SQL("COPY {} ({}) FROM STDIN WITH (FORMAT CSV, HEADER TRUE)")
                        .format(
                            sql.Identifier(table),
                            sql.SQL(", ").join(map(sql.Identifier, columns)),
                        ).as_string(cur), stream
                    )
            cur.execute((ROOT / "sql/01b_create_dimensions.sql").read_text())
            cur.execute((ROOT / "sql/04_powerbi_views.sql").read_text())
            for table in FILES:
                cur.execute(sql.SQL("SELECT COUNT(*) FROM {}").format(sql.Identifier(table)))
                print(f"{table}: {cur.fetchone()[0]:,} rows")
            for view in VIEWS:
                cur.execute(sql.SQL("SELECT COUNT(*) FROM {}").format(sql.Identifier(view)))
                print(f"{view}: {cur.fetchone()[0]:,} rows")
    print(f"Committed schema {schema}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dsn", default=os.environ.get("DELTA_DATABASE_URL"))
    parser.add_argument("--schema", default="delta_repro")
    args = parser.parse_args()
    if not args.dsn:
        parser.error("provide --dsn or DELTA_DATABASE_URL")
    load(args.dsn, args.schema)
