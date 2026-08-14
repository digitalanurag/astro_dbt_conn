{{ config(
    materialized='incremental',
    unique_key='id'
) }}
 
select
    id,
    created_at,
    current_timestamp() as dbt_loaded_at,
 
    datediff(
        'second',
        created_at,
        current_timestamp()
    ) as wait_time_seconds
 
from DBT_DB.CORE.ASTRO_TASK_AUDIT
 
{% if is_incremental() %}
 
where task_value >
(
    select coalesce(max(id), 0)
    from {{ this }}
)
 
{% endif %}
