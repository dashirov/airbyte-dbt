{{ config(
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
        interval '1 second')                       as responded_at
FROM {{ schema }}._airbyte_raw_poll_feedback_results