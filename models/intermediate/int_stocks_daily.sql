{{ config(
    materialized='incremental',
    unique_key=['date', 'ticker']
) }}

with stocks_calculation as ( 
    SELECT
        date,
        ticker,
        open,
        close,
        high,
        low,
        volume,
        cast((close - open) AS DOUBLE) AS daily_change,
        cast(((close - open) / open) * 100 AS DOUBLE) AS daily_change_pct,
            CASE
                WHEN close > open THEN 'up'
                WHEN close < open THEN 'down'
                ELSE 'no_change'
            END AS daily_trend
    FROM {{ ref('stocks_raw') }}
)
SELECT 
    *
FROM stocks_calculation

{% if is_incremental() %}
where date > (select max(date) from {{ this }})
{% endif %}