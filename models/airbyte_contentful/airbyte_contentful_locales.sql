{{ config(
    alias='locales',
    schema='contentful',
    pre_hook=[
              "SET json_serialization_enable TO true;" ,
              "SET json_serialization_parse_nested_strings TO true;"
    ],
    post_hook=[
              "GRANT ALL ON {{ this }} TO GROUP analytics"
    ],
    dist='id',
    sort='code'
) }}

SELECT
{% if target.type == 'redshift' %}
    -- Redshift-specific SQL query
       (_airbyte_raw_locales._airbyte_data."sys"."id")::varchar(25) as id,
       (_airbyte_raw_locales._airbyte_data."code")::varchar(12) as code,
       (_airbyte_raw_locales._airbyte_data."name")::varchar(25) as name,
       (_airbyte_raw_locales._airbyte_data."default")::boolean as "default",
       (_airbyte_raw_locales._airbyte_data."fallbackCode")::varchar(12) as fallback_code
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
       (_airbyte_raw_locales._airbyte_data->'sys'->>'id')::varchar(25) as id,
       (_airbyte_raw_locales._airbyte_data->>'code')::varchar(12) as code,
       (_airbyte_raw_locales._airbyte_data->>'name')::varchar(25) as name,
       (_airbyte_raw_locales._airbyte_data->>'default')::boolean as "default",
       (_airbyte_raw_locales._airbyte_data->>'fallbackCode')::varchar(12) as fallback_code
{% endif %}
    from _airbyte_raw_{{ this }}


