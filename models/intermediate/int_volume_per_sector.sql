{{ config(materialized='table') }}

with stocks as (
    select
        date,
        ticker,
        volume
    from {{ ref('stocks_raw') }}
),

categories as (
    select
        ticker,
        sector
    from {{ ref('stg_ticker_categories') }}
),

joined as (
    select
        s.date,
        s.ticker,
        c.sector,
        s.volume
    from stocks s
    left join categories c on s.ticker = c.ticker
)

select
    date,
    sector,
    sum(volume)            as total_volume,
    count(distinct ticker) as num_stocks_traded
from joined
group by date, sector
order by date, sector