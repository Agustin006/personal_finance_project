{{ config(
    materialized='table'
) }}

select *
from {{ ref('df_denormalized') }}
