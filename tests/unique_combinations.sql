SELECT
  ua_channel,
  country,
  date
FROM
  {{ ref('ua_channel_revenue') }}
GROUP BY
  ua_channel,
  country,
  date
HAVING
  COUNT(*) > 1
