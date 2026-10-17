"""
Export the fct_stock_daily mart from the DuckDB state to a Parquet file.
"""

import duckdb
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
DB_PATH = PROJECT_ROOT / "dev.duckdb"
OUTPUT_PATH = PROJECT_ROOT / "fct_stock_daily.parquet"


def export_fct_to_parquet(db_path=DB_PATH, output_path=OUTPUT_PATH):
    con = duckdb.connect(str(db_path), read_only=True)

    # COPY writes the query result straight to a Parquet file.
    # ORDER BY keeps the file sorted by date and ticker.
    con.execute(f"""
        COPY (SELECT * FROM main.fct_stock_daily ORDER BY date, ticker)
        TO '{output_path}' (FORMAT PARQUET)
    """)

    row_count = con.sql("SELECT COUNT(*) FROM main.fct_stock_daily").fetchone()[0]
    con.close()

    print(f"Exported {row_count} rows to {output_path}")


if __name__ == "__main__":
    export_fct_to_parquet()