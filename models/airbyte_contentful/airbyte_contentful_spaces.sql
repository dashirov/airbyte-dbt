{{ config(
    alias='spaces',
    schema='contentful',
    dist='id',
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
    from {{ source('contentful_raw','spaces') }}


