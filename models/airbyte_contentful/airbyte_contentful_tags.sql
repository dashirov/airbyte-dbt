{% set source_environment = var('source_environment') %}
{% set target_schema = var('target_schema') %}


{{ config(
    alias='tags',
    schema=target_schema,
    dist='id',
    sort='created_at'
) }}

SELECT
{% if target.type == 'redshift' %}
    -- Redshift-specific SQL query
       (_airbyte_data."sys"."id")::varchar(500) as id,
       (_airbyte_data."name")::varchar(500) as name,
       (_airbyte_data."sys"."createdAt")::timestamp as created_at,
       (_airbyte_data."sys"."updatedAt")::timestamp as updated_at,
       (_airbyte_data."sys"."version")::int8 as version,
       (_airbyte_data."sys"."createdBy"."sys"."id")::varchar(25) as created_by,
       (_airbyte_data."sys"."updatedBy"."sys"."id")::varchar(25) as updated_by,
       (_airbyte_data."sys"."visibility")::varchar(10) as visibility
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
       (_airbyte_data->'sys'->>'id')::varchar(500) as id,
       (_airbyte_data->>'name')::varchar(500) as name,
       (_airbyte_data->'sys'->>'createdAt')::timestamp as created_at,
       (_airbyte_data->'sys'->>'updatedAt')::timestamp as updated_at,
       (_airbyte_data->'sys'->>'version')::int8 as version,
       (_airbyte_data->'sys'->'createdBy'->'sys'->>'id')::varchar(25) as created_by,
       (_airbyte_data->'sys'->'updatedBy'->'sys'->>'id')::varchar(25) as updated_by,
       (_airbyte_data->'sys'->>'visibility')::varchar(10) as visibility
{% endif %}
    from {{ source(source_environment,'tags') }} as tags


