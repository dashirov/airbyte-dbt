{% set source_environment = var('source_environment','contentful_dev') %}
{% set target_schema = var('target_schema','contentful_delivery_dev') %}

{{ config(
    alias='audience_targets',
    schema=target_schema,
    dist='id',
    sort='created_at'
) }}

SELECT
{% if target.type == 'redshift' %}
    -- Redshift-specific SQL query
     targets.id,
     targets.created_at,
     targets.updated_at,
     (targets.fields."title")::varchar(100)      AS title,
     (targets.fields."dataType")::varchar(50)    AS data_type,
     (targets.fields."fieldName")::varchar(150)  AS field_name,
     (targets.fields."operator")::varchar(20)    AS "operator",
     (targets.fields."fieldValue")::varchar(50)  AS field_value
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
     targets.id,
     targets.created_at,
     targets.updated_at,
     (targets.fields->>'title')::varchar(100)      AS title,
     (targets.fields->>'dataType')::varchar(50)    AS data_type,
     (targets.fields->>'fieldName')::varchar(150)  AS field_name,
     (targets.fields->>'operator')::varchar(20)    AS "operator",
     (targets.fields->>'fieldValue')::varchar(50)  AS field_value
{% endif %}
FROM {{ ref('airbyte_contentful_entries') }} targets
WHERE content_type = 'audienceTarget'