
{{ config(
    alias='metrics',
    schema='megaphone',
    dist='episode_id',
    sort='created_at'
) }}

SELECT
{% if target.type == 'redshift' %}
    -- Redshift-specific SQL query
       (metrics._airbyte_data.id)::varchar(128)                         as id,
       (metrics._airbyte_data.podcast_id)::varchar(36)                  as podcast_id,
       (metrics._airbyte_data.episode_id)::varchar(36)                  as episode_id,
       (metrics._airbyte_data.country)::varchar(2)                      as country,                       -- US
       (metrics._airbyte_data.dma_name)::varchar(150)                   as dma_name,                      -- Dallas-Ft. Worth, TX,
       (metrics._airbyte_data.normalized_user_agent)::varchar(150)      as normalized_user_agent,         -- Apple Podcasts,
       (metrics._airbyte_data.city)::varchar(50)                        as city,                          -- Dallas,
       (metrics._airbyte_data.ip)::varchar(32)                          as ip,                            -- c19af70f3fb71c0f7adfb4d89dacccd3,
       (metrics._airbyte_data.created_at)::timestamp                    as created_at,                    -- 2022-03-21T15:19:12.000Z,
       (metrics._airbyte_data.source)::int8                             as source,                        -- 0,
       (metrics._airbyte_data.filesize)::int8                           as filesize,                      -- 67332401,
       (metrics._airbyte_data.bytes_sent)::int8                         as bytes_sent,                    -- 149313406,
       (metrics._airbyte_data.seconds_downloaded)::int8                 as seconds_downloaded,            -- 3720,
       (metrics._airbyte_data.duration)::double precision               as duration,                      --  1679.36,
       (metrics._airbyte_data.blacklisted_ip)::boolean                  as blacklisted_ip,                --  false,
       (metrics._airbyte_data.blacklisted_ua)::boolean                  as blacklisted_ua,                -- false,
       (metrics._airbyte_data.region)::varchar(2)                       as region,                        -- TX,
       (metrics._airbyte_data.user_agent)::varchar(4096)                as user_agent,                    -- Podcasts/1630.11 CFNetwork/1329 Darwin/21.3.0,
       (metrics._airbyte_data._ab_source_file_last_modified)::timestamp as _ab_source_file_last_modified, -- 2022-03-22T05:16:17.000000Z,
       (metrics._airbyte_data._ab_source_file_url)::varchar(500)        as _ab_source_file_url
{% elif target.type == 'postgres' %}
    -- PostgreSQL-specific SQL query
       (metrics->_airbyte_data->>id)::varchar(128)                         as id,
       (metrics->_airbyte_data->>podcast_id)::varchar(36)                  as podcast_id,
       (metrics->_airbyte_data->>episode_id)::varchar(36)                  as episode_id,
       (metrics->_airbyte_data->>country)::varchar(2)                      as country,                       -- US
       (metrics->_airbyte_data->>dma_name)::varchar(150)                   as dma_name,                      -- Dallas-Ft. Worth, TX,
       (metrics->_airbyte_data->>normalized_user_agent)::varchar(150)      as normalized_user_agent,         -- Apple Podcasts,
       (metrics->_airbyte_data->>city)::varchar(50)                        as city,                          -- Dallas,
       (metrics->_airbyte_data->>ip)::varchar(32)                          as ip,                            -- c19af70f3fb71c0f7adfb4d89dacccd3,
       (metrics->_airbyte_data->>created_at)::timestamp                    as created_at,                    -- 2022-03-21T15:19:12.000Z,
       (metrics->_airbyte_data->>source)::int8                             as source,                        -- 0,
       (metrics->_airbyte_data->>filesize)::int8                           as filesize,                      -- 67332401,
       (metrics->_airbyte_data->>bytes_sent)::int8                         as bytes_sent,                    -- 149313406,
       (metrics->_airbyte_data->>seconds_downloaded)::int8                 as seconds_downloaded,            -- 3720,
       (metrics->_airbyte_data->>duration)::double precision               as duration,                      --  1679.36,
       (metrics->_airbyte_data->>blacklisted_ip)::boolean                  as blacklisted_ip,                --  false,
       (metrics->_airbyte_data->>blacklisted_ua)::boolean                  as blacklisted_ua,                -- false,
       (metrics->_airbyte_data->>region)::varchar(2)                       as region,                        -- TX,
       (metrics->_airbyte_data->>user_agent)::varchar(4096)                as user_agent,                    -- Podcasts/1630.11 CFNetwork/1329 Darwin/21.3.0,
       (metrics->_airbyte_data->>_ab_source_file_last_modified)::timestamp as _ab_source_file_last_modified, -- 2022-03-22T05:16:17.000000Z,
       (metrics->_airbyte_data->>_ab_source_file_url)::varchar(500)        as _ab_source_file_url
{% endif %}
    from {{ source('megaphone','metrics') }} as metrics
