{% set source_environment = var('source_environment','contentful_dev') %}
{% set target_schema = var('target_schema','contentful_delivery_dev') %}


{{ config(
    alias='poll_options',
    schema=target_schema,
    dist='poll_id',
    sort='id'
) }}


    {% if target.type == 'redshift' %}

    -- Redshift-specific SQL query
SELECT
    polls.id                                 as poll_id,
    poll_option.sys."id"::varchar(36)        as id,
    poll_option_ordinal::int2                as ordinal,
    poll_options.fields."text"::varchar(512) as option
FROM {{ ref('airbyte_contentful_polls') }} as   polls
    CROSS JOIN polls.options as poll_option
        AT poll_option_ordinal
    LEFT JOIN {{ ref('airbyte_contentful_entries') }} as poll_options
        ON poll_option.sys."id"::varchar(36) = poll_options.id

    {% elif target.type == 'postgres' %}

    -- PostgreSQL-specific SQL query
SELECT polls.id                                as poll_id,
       poll_options.id                         as id,
       a."index"                               as ordinal,
       poll_options.fields->>'text'            as option
FROM {{ ref('airbyte_contentful_polls') }} as   polls
    LEFT JOIN LATERAL  jsonb_array_elements( polls.options)
        WITH ORDINALITY AS a(poll_option, "index") ON true
    LEFT JOIN entries as poll_options
       ON a.poll_option->'sys'->>'id'::varchar(36) = poll_options.id

    {% endif %}

