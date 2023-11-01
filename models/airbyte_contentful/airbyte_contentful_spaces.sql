{{ config(
    alias='spaces',
    schema='contentful',
    pre_hook=[
    ],
    post_hook=[
              "GRANT ALL ON {{ this }} TO GROUP analytics"
    ],
    dist='id',
    sort='name'
) }}

SELECT
{% if target.type == 'redshift' %}
    -- Redshift-specific SQL query
       (_airbyte_raw_spaces._airbyte_data."sys"."id")::varchar(500) as id,
       (_airbyte_raw_spaces._airbyte_data."name")::varchar(50) as name,
       _airbyte_raw_spaces._airbyte_data."locales" as locales
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
      (_airbyte_raw_spaces._airbyte_data->'sys'->>'id')::varchar(500) as id,
       (_airbyte_raw_spaces._airbyte_data->>'name')::varchar(50) as name,
       _airbyte_raw_spaces._airbyte_data->'locales' as locales
{% endif %}
    from _airbyte_raw_{{this}}


