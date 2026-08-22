CREATE OR REPLACE TABLE `mifitness-503818.Health_Center.Fitness Data Sleep`
AS
SELECT
  Uid,
  local_datetime,
  -- Extracting scalar values from the JSON string
  SAFE_CAST(JSON_VALUE(Value, '$.avg_hr') AS INT64) AS avg_heart_rate,
  SAFE_CAST(JSON_VALUE(Value, '$.duration') AS INT64) AS total_duration_minutes,
  SAFE_CAST(JSON_VALUE(Value, '$.sleep_deep_duration') AS INT64) AS deep_sleep_minutes,
  SAFE_CAST(JSON_VALUE(Value, '$.sleep_light_duration') AS INT64) AS light_sleep_minutes,
  SAFE_CAST(JSON_VALUE(Value, '$.sleep_rem_duration') AS INT64) AS rem_sleep_minutes,
  -- Converting embedded JSON timestamps
  TIMESTAMP_SECONDS(SAFE_CAST(JSON_VALUE(Value, '$.bedtime') AS INT64)) AS actual_bedtime,
  TIMESTAMP_SECONDS(SAFE_CAST(JSON_VALUE(Value, '$.wake_up_time') AS INT64)) AS actual_wake_up
FROM `mifitness-503818.Health_Center.Fitness Data Cleaned View`
WHERE Key = 'sleep'
