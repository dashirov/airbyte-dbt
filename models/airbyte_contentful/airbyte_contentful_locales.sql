{{ config(
    alias='locales',
    schema='contentful',
    dist='id',
    sort='code'
) }}

SELECT
{% if target.type == 'redshift' %}
    -- Redshift-specific SQL query
       (_airbyte_data."sys"."id")::varchar(25) as id,
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
    from{{ source('contentful_raw','locales') }}


