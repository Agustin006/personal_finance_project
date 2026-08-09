--{{ config(materialized='table') }}

select
    cast(d.date as varchar) || '-' || d.ticker as stock_daily_id,
    d.date,
    d.ticker,
    c.sector,
    c.industry,
    c.market_cap_category,
    d.open,
    d.high,
    d.low,
    d.close,
    d.volume,
    d.daily_change,
    d.daily_change_pct,
    d.daily_trend,
    d.is_new_high
from {{ ref('int_stocks_daily') }} d
left join {{ ref('dim_ticker_category') }} c
    on d.ticker = c.ticker
order by d.date, d.ticker