import duckdb
import yfinance as yf
from datetime import datetime, timedelta
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_DB_PATH = PROJECT_ROOT / "dev.duckdb"

# Top S&P 500 companies (same list as before)
TICKERS = [
    "AAPL", "MSFT", "NVDA", "AMZN", "GOOGL",
    "META", "BRK-B", "TSLA", "UNH", "XOM",
    "LLY", "JPM", "V", "AVGO", "JNJ",
    "WMT", "PG", "MA", "HD", "COST",
    "MRK", "ABBV", "ORCL", "CVX", "BAC"
]

def fetch_ticker_data():
    df = yf.download(TICKERS, period="1mo")

    df_denormalized = (
        df.stack(level=1)
          .reset_index()
          .rename(columns={
              'level_1': 'ticker',
              df.index.name if df.index.name else 'level_0': 'date'
          })
    )
    
    before = len(df_denormalized)
    df_denormalized = df_denormalized.dropna()
    after = len(df_denormalized)
    if before != after:
        print(f"Dropped {before - after} row(s) with missing data")

    df_denormalized['date'] = df_denormalized['date'].dt.strftime('%Y-%m-%d')
    df_denormalized['Close'] = df_denormalized['Close'].round(2)
    df_denormalized['High'] = df_denormalized['High'].round(2)
    df_denormalized['Low'] = df_denormalized['Low'].round(2)
    df_denormalized['Open'] = df_denormalized['Open'].round(2)
    df_denormalized['Volume'] = df_denormalized['Volume'].astype(int)

    return df_denormalized


def load_to_duckdb(df_denormalized, db_path=DEFAULT_DB_PATH):
    con = duckdb.connect(db_path)
    con.execute("CREATE SCHEMA IF NOT EXISTS raw")
    con.execute("""
        CREATE OR REPLACE TABLE raw.stock_prices AS
        SELECT * FROM df_denormalized
    """)
    con.close()
    print(f"Loaded {len(df_denormalized)} rows into raw.stock_prices")


if __name__ == "__main__":
    df = fetch_ticker_data()
    print(df.columns.tolist())   # <-- important, see note below
    load_to_duckdb(df)