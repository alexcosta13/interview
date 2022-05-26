WITH
  events AS (
  SELECT
    user_id,
    CASE
      WHEN item.currency LIKE "USD" THEN item.price
      WHEN item.currency LIKE "EUR" THEN item.price * {{ var('eur_to_usd') }}
      WHEN item.currency LIKE "SEK" THEN item.price * {{ var('sek_to_usd') }}
      WHEN item.currency LIKE "NOK" THEN item.price * {{ var('nok_to_usd') }}
  END
    revenue
  FROM
    {{ source('interview', 'events')  }}
  WHERE
    item IS NOT NULL
  UNION ALL
  SELECT
    user_id,
    revenue
  FROM
    {{ source('interview', 'events')  }}
  WHERE
    revenue IS NOT NULL )
SELECT
  reg_ua_channel AS ua_channel,
  ROUND(IFNULL(SUM(revenue),
      0),2) AS revenue,
  -- to usd
  reg_country AS country,
  EXTRACT(date
  FROM
    reg_ts) AS date
FROM
  events
LEFT JOIN
  {{ source('interview', 'registrations') }} reg
ON
  events.user_id = reg.user_id
GROUP BY
  reg_ua_channel,
  reg_country,
  EXTRACT(date
  FROM
    reg_ts)
