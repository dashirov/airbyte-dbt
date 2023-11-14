{% set source_environment = var('source_environment') %}
{% set target_schema = var('target_schema') %}


{{ config(
    alias='locales',
    dist='id',
    schema=target_schema,
    sort='code'
) }}

SELECT
{% if target.type == 'redshift' %}
    -- Redshift-specific SQL query
       (_airbyte_data."sys"."id")::varchar(36) as id,
       (_airbyte_data."code")::varchar(12) as code,
       (_airbyte_data."name")::varchar(25) as name,
       (_airbyte_data."default")::boolean as "default",
       (_airbyte_data."fallbackCode")::varchar(12) as fallback_code
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
       (_airbyte_data->'sys'->>'id')::varchar(25) as id,
       (_airbyte_data->>'code')::varchar(12) as code,
       (_airbyte_data->>'name')::varchar(25) as name,
       (_airbyte_data->>'default')::boolean as "default",
       (_airbyte_data->>'fallbackCode')::varchar(12) as fallback_code
{% endif %}
    from{{ source(source_environment,'locales') }} as locales


