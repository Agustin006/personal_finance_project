--{{ config(materialized='table') }}

select
    ticker,
    sector,
    industry,
    market_cap_category
from {{ ref('stg_ticker_categories') }}