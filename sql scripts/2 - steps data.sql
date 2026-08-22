CREATE OR REPLACE TABLE `mifitness-503818.Health_Center.Fitness Data Steps`
AS
SELECT 
  Uid,
  local_datetime,
  SAFE_CAST(JSON_VALUE(Value, '$.steps') AS INT64) AS steps,
  SAFE_CAST(JSON_VALUE(Value, '$.distance') AS INT64) AS distance,
  SAFE_CAST(JSON_VALUE(Value, '$.calories') AS INT64) AS calories
FROM `mifitness-503818.Health_Center.Fitness_Data_Cleaned` 
WHERE Key = "steps"