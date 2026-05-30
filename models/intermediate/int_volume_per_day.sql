--{{ config(materialized='table') }}

select
    date,
    sum(volume)                                    as total_volume,
    count(distinct ticker)                         as num_stocks_traded
from {{ ref('stocks_raw') }}
group by date
order by date