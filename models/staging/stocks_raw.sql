{{ config(
    materialized='table'
) }}

select 
    date::date      as date,
    "Ticker"        as ticker,
    "Open"::double  as open,
    "High"::double  as high,
    "Low"::double   as low,
    "Close"::double as close,
    "Volume"::bigint as volume
from {{ source('raw', 'stock_prices') }}
