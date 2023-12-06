{% set source_environment = var('source_environment','contentful_dev') %}
{% set target_schema = var('target_schema','contentful_delivery_dev') %}


{{ config(
    alias='section_channels',
    schema=target_schema,
    dist='id'
) }}

SELECT
{% if target.type == 'redshift' %}
       -- Redshift-specific SQL query
       id,
       ("fields"."title")::varchar(150) as channel_title
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
       id,
       ("fields"->>'title')::varchar(150) as channel_title
{% endif %}
from
     {{ ref('airbyte_contentful_entries') }} as channels
where
    content_type = 'sectionChannel'



