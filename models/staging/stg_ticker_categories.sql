


SELECT
    ticker,
    sector,
    industry,
    market_cap_category
FROM {{ ref('ticker_categories') }}