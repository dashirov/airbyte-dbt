{{ config(
    alias='tags',
    schema='contentful',
    pre_hook=[
    ],
    post_hook=[
              "GRANT ALL ON {{ this }} TO GROUP analytics"
    ],
    dist='id',
    sort='created_at'
) }}

SELECT
{% if target.type == 'redshift' %}
    -- Redshift-specific SQL query
       (_airbyte_raw_tags._airbyte_data."sys"."id")::varchar(500) as id,
       (_airbyte_raw_tags._airbyte_data."sys"."createdAt")::timestamp as created_at,
       (_airbyte_raw_tags._airbyte_data."sys"."updatedAt")::timestamp as updated_at,
       (_airbyte_raw_tags._airbyte_data."sys"."version")::int8 as version,
       (_airbyte_raw_tags._airbyte_data."sys"."createdBy"."sys"."id")::varchar(25) as created_by,
       (_airbyte_raw_tags._airbyte_data."sys"."updatedBy"."sys"."id")::varchar(25) as updated_by,
       (_airbyte_raw_tags._airbyte_data."sys"."visibility")::varchar(10) as visibility
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
       (_airbyte_raw_tags._airbyte_data->'sys'->>'id')::varchar(500) as id,
       (_airbyte_raw_tags._airbyte_data->'sys'->>'createdAt')::timestamp as created_at,
       (_airbyte_raw_tags._airbyte_data->'sys'->>'updatedAt')::timestamp as updated_at,
       (_airbyte_raw_tags._airbyte_data->'sys'->>'version')::int8 as version,
       (_airbyte_raw_tags._airbyte_data->'sys'->'createdBy'->'sys'->>'id')::varchar(25) as created_by,
       (_airbyte_raw_tags._airbyte_data->'sys'->'updatedBy'->'sys'->>'id')::varchar(25) as updated_by,
       (_airbyte_raw_tags._airbyte_data->'sys'->>'visibility')::varchar(10) as visibility
{% endif %}
    from _airbyte_raw_{{this}}


