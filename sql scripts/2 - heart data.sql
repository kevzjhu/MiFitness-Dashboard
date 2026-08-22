CREATE OR REPLACE TABLE `mifitness-503818.Health_Center.Fitness Data Heart Rate`
AS
SELECT 
  Uid,
  local_datetime,
  SAFE_CAST(JSON_VALUE(Value, '$.bpm') AS INT64) AS bpm
  FROM `mifitness-503818.Health_Center.Fitness_Data_Cleaned` 
WHERE Key = "heart_rate"