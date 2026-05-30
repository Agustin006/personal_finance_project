
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
            END AS daily_trend,
        max(high) OVER (PARTITION BY ticker) AS max_high
    FROM {{ ref('stocks_raw') }}
)
SELECT 
    *,
    CASE 
        WHEN high >= max_high THEN 'new_high'
        ELSE 'not_new_high'
    END AS is_new_high
FROM stocks_calculation