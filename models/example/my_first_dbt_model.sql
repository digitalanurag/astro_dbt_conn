{{ config(
    materialized='incremental',
    unique_key='ID'
) }}
 
SELECT
    ID,
    CREATED_AT,
    CURRENT_TIMESTAMP() AS DBT_LOADED_AT,
 
    DATEDIFF(
        'second',
        CREATED_AT,
        CURRENT_TIMESTAMP()
    ) AS WAIT_TIME_SECONDS
 
FROM DBT_DB.CORE.ASTRO_TASK_TEST
 
{% if is_incremental() %}
 
WHERE ID >
(
    SELECT COALESCE(MAX(ID), 0)
    FROM {{ this }}
)
 
{% endif %}
