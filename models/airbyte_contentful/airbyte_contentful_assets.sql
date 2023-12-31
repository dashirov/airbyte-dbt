{{ config(
    alias='assets',
    schema='contentful',
    dist='id',
    sort='created_at'
) }}

SELECT
{% if target.type == 'redshift' %}
    -- Redshift-specific SQL query
       (_airbyte_data."sys"."id")::varchar(25) as id,
       (_airbyte_data."sys"."locale")::varchar(12) as locale,
       (_airbyte_data."sys"."revision")::int8 as revision,
       (_airbyte_data."sys"."createdAt")::timestamp as created_at,
       (_airbyte_data."sys"."updatedAt")::timestamp as updated_at,
       (_airbyte_data."sys"."environment"."sys"."id")::varchar(6) as environemnt_id,
        _airbyte_data."fields" as fields,
        _airbyte_data."metadata" as metadata
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
       (_airbyte_data->'sys'->>'id')::varchar(25) as id,
       (_airbyte_data->'sys'->>'locale')::varchar(12) as locale,
       (_airbyte_data->'sys'->>'revision')::int8 as revision,
       (_airbyte_data->'sys'->>'createdAt')::timestamp as created_at,
       (_airbyte_data->'sys'->>'updatedAt')::timestamp as updated_at,
       (_airbyte_data->'sys'->'environment'->'sys'->>'id')::varchar(6) as environemnt_id,
        _airbyte_data->'fields' as fields,
        _airbyte_data->'metadata' as metadata
{% endif %}
    from {{ source('contentful_raw','assets') }}


