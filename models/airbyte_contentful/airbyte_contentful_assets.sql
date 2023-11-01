{{ config(
    alias='assets',
    schema='contentful',
    pre_hook=[
              "SET json_serialization_enable TO true;" ,
              "SET json_serialization_parse_nested_strings TO true;"
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
       (_airbyte_raw_assets._airbyte_data."sys"."id")::varchar(25) as id,
       (_airbyte_raw_assets._airbyte_data."sys"."locale")::varchar(12) as locale,
       (_airbyte_raw_assets._airbyte_data."sys"."revision")::int8 as revision,
       (_airbyte_raw_assets._airbyte_data."sys"."createdAt")::timestamp as created_at,
       (_airbyte_raw_assets._airbyte_data."sys"."updatedAt")::timestamp as updated_at,
       (_airbyte_raw_assets._airbyte_data."sys"."environment"."sys"."id")::varchar(6) as environemnt_id,
        _airbyte_raw_assets._airbyte_data."fields" as fields,
        _airbyte_raw_assets._airbyte_data."metadata" as metadata
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
       (_airbyte_raw_assets._airbyte_data->'sys'->>'id')::varchar(25) as id,
       (_airbyte_raw_assets._airbyte_data->'sys'->>'locale')::varchar(12) as locale,
       (_airbyte_raw_assets._airbyte_data->'sys'->>'revision')::int8 as revision,
       (_airbyte_raw_assets._airbyte_data->'sys'->>'createdAt')::timestamp as created_at,
       (_airbyte_raw_assets._airbyte_data->'sys'->>'updatedAt')::timestamp as updated_at,
       (_airbyte_raw_assets._airbyte_data->'sys'->'environment'->'sys'->>'id')::varchar(6) as environemnt_id,
        _airbyte_raw_assets._airbyte_data->'fields' as fields,
        _airbyte_raw_assets._airbyte_data->'metadata' as metadata
{% endif %}
    from _airbyte_raw_{{ this }}


