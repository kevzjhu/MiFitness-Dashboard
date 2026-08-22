DECLARE min_date DATE;
DECLARE max_date DATE;

-- 1. Find the date range of your data
SET (min_date, max_date) = (
  SELECT AS STRUCT MIN(DATE(local_datetime)), MAX(DATE(local_datetime))
  FROM `mifitness-503818.Health_Center.Fitness Data Cleaned View`
);

-- 2. Generate every single day between those two dates
WITH calendar AS (
  SELECT report_date
  FROM UNNEST(GENERATE_DATE_ARRAY(min_date, max_date)) AS report_date
),

daily_steps AS (
  SELECT 
    DATE(local_datetime) as report_date,
    SUM(steps) as total_steps,
    SUM(calories) as total_calories
  FROM `mifitness-503818.Health_Center.Fitness Data Steps`
  GROUP BY 1
),

daily_hr AS (
  SELECT 
    DATE(local_datetime) as report_date,
    ROUND(AVG(bpm),2) as avg_bpm,
    MIN(bpm) as resting_hr,
    MAX(bpm) as peak_hr
  FROM `mifitness-503818.Health_Center.Fitness Data Heart Rate`
  GROUP BY 1
),

daily_sleep AS (
  SELECT 
    DATE(local_datetime) as report_date,
    total_duration_minutes,
    deep_sleep_minutes,
    light_sleep_minutes,
    rem_sleep_minutes,
    avg_heart_rate as sleep_avg_hr,
    DATETIME(actual_bedtime, 'America/Toronto') as bedtime_toronto,
    DATETIME(actual_wake_up, 'America/Toronto') as wakeup_toronto
  FROM `mifitness-503818.Health_Center.Fitness Data Sleep`
)

-- 3. LEFT JOIN the calendar against your metrics so missing days stay in the results
SELECT 
  c.report_date,
  COALESCE(s.total_steps, 0) as total_steps,
  ROUND(AVG(s.total_steps) OVER (
    ORDER BY s.report_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ), 0) AS rolling_7d_steps,
  COALESCE(s.total_calories, 0) as total_calories,
  hr.avg_bpm,
  hr.resting_hr,
  hr.peak_hr,
  COALESCE(sl.total_duration_minutes, 0) as sleep_mins,
  COALESCE(sl.deep_sleep_minutes, 0) as deep_sleep_minutes,
  COALESCE(sl.light_sleep_minutes, 0) as light_sleep_minutes,
  COALESCE(sl.rem_sleep_minutes, 0) as rem_sleep_minutes,
  sl.sleep_avg_hr,
  sl.bedtime_toronto,
  sl.wakeup_toronto,
  ROUND(TIME_DIFF(TIME(sl.bedtime_toronto), TIME(0, 0, 0), MINUTE) / 60.0, 2) AS bedtime_decimal,
  ROUND(TIME_DIFF(TIME(sl.wakeup_toronto), TIME(0, 0, 0), MINUTE) / 60.0, 2) AS wakeup_decimal
FROM calendar c
LEFT JOIN daily_steps s ON c.report_date = s.report_date
LEFT JOIN daily_hr hr ON c.report_date = hr.report_date
LEFT JOIN daily_sleep sl ON c.report_date = sl.report_date
ORDER BY c.report_date DESC
