{{ config(
    materialized='incremental',
    unique_key='id'
) }}
 
SELECT
    CAST(ID AS NUMBER(38,0)) AS ID,
    CREATED_AT
FROM DBT_DB.CORE.ASTRO_TASK_TEST
 
{% if is_incremental() %}
 
WHERE ID > (
    SELECT COALESCE(MAX(ID), 0)
    FROM {{ this }}
)
 
{% endif %}
