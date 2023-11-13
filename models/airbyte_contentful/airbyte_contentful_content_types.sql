{% set source_environment = var('source_environment') %}
{% set target_schema = var('target_schema') %}

{{ config(
    alias='content_types',
    schema=target_schema,
    dist='id',
    sort='created_at'
) }}

SELECT
{% if target.type == 'redshift' %}
    -- Redshift-specific SQL query
       (_airbyte_data."sys"."id")::varchar(25) as id,
       (_airbyte_data."sys"."revision")::int8 as revision,
       (_airbyte_data."sys"."createdAt")::timestamp as created_at,
       (_airbyte_data."sys"."updatedAt")::timestamp as updated_at,
       (_airbyte_data."sys"."environment"."sys"."id")::varchar(6) as environment_id,
       (_airbyte_data."name")::varchar(255) as name,
       (_airbyte_data."description")::varchar(255) as description,
       (_airbyte_data."displayField")::varchar(150) as display_field,
        _airbyte_data."fields" as fields
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
       (_airbyte_data->'sys'->>'id')::varchar(25) as id,
       (_airbyte_data->'sys'->>'revision')::int8 as revision,
       (_airbyte_data->'sys'->>'createdAt')::timestamp as created_at,
       (_airbyte_data->'sys'->>'updatedAt')::timestamp as updated_at,
       (_airbyte_data->'sys'->'environment'->'sys'->>'id')::varchar(6) as environment_id,
       (_airbyte_data->>'name')::varchar(255) as name,
       (_airbyte_data->>'description')::varchar(255) as description,
       (_airbyte_data->>'displayField')::varchar(150) as display_field,
        _airbyte_data->'fields' as fields

{% endif %}
    from {{ source(source_environment,'content_types') }} as content_types


