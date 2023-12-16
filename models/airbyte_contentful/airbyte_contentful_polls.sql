{% set source_environment = var('source_environment','contentful_dev') %}
{% set target_schema = var('target_schema','contentful_delivery_dev') %}


{{ config(

    alias='polls',
    schema=target_schema,
    dist='id',
    sort='created_at'
) }}

SELECT
{% if target.type == 'redshift' %}
    -- Redshift-specific SQL query
       polls.id as id,
       polls.created_at as created_at,
       polls.fields."internalTitle"::varchar(100) as internal_title,
       polls.fields."header"::varchar(100) as header,
       polls.fields."campaign"::varchar(100) as campaign,
       polls.fields."description"::varchar(100) as description,
       polls.fields."options" as options,
       polls.fields."hideResponses"::boolean as hide_responses,
       polls.fields."hideSignup"::boolean as hide_signup,
       polls.fields."expertReference"."sys"."id"::varchar(36) as expert_rederence_id
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
    polls.id                                                     as id,
    polls.created_at                                             as created_at,
    (polls.fields->>'internalTitle')::varchar(100)               as internal_title,
    (polls.fields->>'header')::varchar(100)                      as header,
    (polls.fields->>'campaign')::varchar(100)                    as campaign,
    (polls.fields->>'description')::varchar(100)                 as description,
    polls.fields->'options'                                      as options,
    (polls.fields->>'hideResponses')::boolean                    as hide_responses,
    (polls.fields->>'hideSignup')::boolean                       as hide_signup,
    (polls.fields->'expertReference'->'sys'->>'id')::varchar(36) as expert_rederence_id
{% endif %}
FROM {{ ref('airbyte_contentful_entries') }} as   polls
WHERE polls.content_type='poll'
