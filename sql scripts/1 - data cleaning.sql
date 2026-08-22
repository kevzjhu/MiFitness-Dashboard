CREATE OR REPLACE TABLE `mifitness-503818.Health_Center.Fitness_Data_Cleaned`
AS
SELECT
  CAST(Uid AS INT64) AS Uid,
  CAST(Sid AS STRING) AS Sid,
  Key,
  Value,
  -- Converts Unix seconds string to a proper Timestamp
  TIMESTAMP_SECONDS(SAFE_CAST(Time AS INT64)) AS timestamp_val,
  -- Converts Timestamp to your local Datetime (America/Toronto)
  DATETIME(TIMESTAMP_SECONDS(SAFE_CAST(Time AS INT64)), 'America/Toronto')
    AS local_datetime,
  -- Also cleaning the UpdateTime column
  TIMESTAMP_SECONDS(SAFE_CAST(UpdateTime AS INT64)) AS update_timestamp
FROM `mifitness-503818.Health_Center.Fitness Data`

