{{ config(
    materialize='table',
    alias='poll_feedback_results',
    schema='poll_feedback_results',
    dist='feedback_id',
    sort='responded_at'
) }}

select _airbyte_data."feedback_id"::varchar(36)    as feedback_id,
       _airbyte_data."path"::varchar(254)          as path,
       _airbyte_data."amplitude_id"::varchar(254)  as amplitude_id,
       OBJECT(
               'utm_source', _airbyte_data."utms"."utm_source"."S",
               'utm_medium', _airbyte_data."utms"."utm_medium"."S",
               'utm_campaign', _airbyte_data."utms"."utm_campaign"."S",
               'utm_content', _airbyte_data."utms"."utm_content"."S",
               'utm_term', _airbyte_data."utms"."utm_term"."S"
       )                                           AS utms,
       _airbyte_data."segment_id"::varchar(36)     as segment_id,
       OBJECT(
               'utm_source', _airbyte_data."first_touch_utms"."utm_source"."S",
               'utm_medium', _airbyte_data."first_touch_utms"."utm_medium"."S",
               'utm_campaign', _airbyte_data."first_touch_utms"."utm_campaign"."S",
               'utm_content', _airbyte_data."first_touch_utms"."utm_content"."S",
               'utm_term', _airbyte_data."first_touch_utms"."utm_term"."S"
       )                                           AS first_touch_utms,
       _airbyte_data."fbp"::varchar(100)           as fbp,
       _airbyte_data."fbc"::varchar(1024)          as fbc,
       _airbyte_data."doc_referrer"::varchar(1024) as doc_referrer,
       (timestamp 'epoch' +
        _airbyte_data."createdAt"::bigint::numeric /
        1000::numeric *
        interval '1 second')                       as responded_at,
       cp.id as poll_id,
       cp.internal_title,
       cp.header,
       cp.campaign,
       cp.description,
       cp.options,
       cp.hide_responses,
       cp.hide_signup,
       cp.expert_rederence_id,
       cpo.option as poll_option,
       cpo.id as poll_option_id,
       cpo.ordinal as poll_option_ordinal
FROM {{ schema }}._airbyte_raw_poll_feedback_results pr
         JOIN contentful_delivery.polls AS cp
              ON cp.id = pr._airbyte_data."poll_id"::varchar(36)
         JOIN contentful_delivery.poll_options AS cpo
              ON cpo.poll_id = cp.id AND  cpo.id = pr._airbyte_data."response_id"::varchar(36)