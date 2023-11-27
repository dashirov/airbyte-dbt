{% set source_environment = var('source_environment','contentful_dev') %}
{% set target_schema = var('target_schema','contentful_delivery_dev') %}


{{ config(
    alias='spaces',
    dist='id',
    schema=target_schema,
    sort='name'
) }}

SELECT
{% if target.type == 'redshift' %}
    -- Redshift-specific SQL query
       (_airbyte_data."sys"."id")::varchar(500) as id,
       (_airbyte_data."name")::varchar(50) as name,
       _airbyte_data."locales" as locales
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
      (_airbyte_data->'sys'->>'id')::varchar(500) as id,
       (_airbyte_data->>'name')::varchar(50) as name,
       _airbyte_data->'locales' as locales
{% endif %}
    from {{ source(source_environment,'spaces') }} as spaces


