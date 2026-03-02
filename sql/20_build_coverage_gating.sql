-- 20_build_coverage_gating.sql
-- Purpose: Build state × condition coverage metadata and trend gating labels.
-- Outputs: public_health_portfolio.tbl_nndss_state_condition_coverage
-- Key fields:
--   * last_yearweek_available (YYYYWW) per state×condition
--   * n_weeks_observed (distinct weeks observed) per state×condition
--   * weeks_behind_max (recency vs global max week index)
--   * trend_mode (historical_3y / historical_1y / recent_monitoring_partial / insufficient)

CREATE OR REPLACE TABLE `public_health_portfolio.tbl_nndss_state_condition_coverage` AS
WITH distinct_weeks AS (
  SELECT DISTINCT
    `Current MMWR Year` AS mmwr_year,
    `MMWR WEEK` AS mmwr_week
  FROM `public_health_portfolio.cdc_nndss_weekly_curated_v2`
  WHERE geo_level = 'state'
),
week_index AS (
  SELECT
    mmwr_year,
    mmwr_week,
    ROW_NUMBER() OVER (ORDER BY mmwr_year, mmwr_week) AS week_idx
  FROM distinct_weeks
),
coverage AS (
  SELECT
    c.state_name,
    c.`Label` AS condition,
    MAX(c.`Current MMWR Year` * 100 + c.`MMWR WEEK`) AS last_yearweek_available,
    COUNT(DISTINCT (c.`Current MMWR Year` * 100 + c.`MMWR WEEK`)) AS n_weeks_observed,
    MAX(wi.week_idx) AS last_week_idx
  FROM `public_health_portfolio.cdc_nndss_weekly_curated_v2` c
  JOIN week_index wi
    ON c.`Current MMWR Year` = wi.mmwr_year
   AND c.`MMWR WEEK` = wi.mmwr_week
  WHERE c.geo_level = 'state'
  GROUP BY 1,2
),
global_max AS (
  SELECT MAX(last_week_idx) AS max_week_idx
  FROM coverage
)
SELECT
  c.state_name,
  c.condition,
  c.last_yearweek_available,
  c.n_weeks_observed,
  (g.max_week_idx - c.last_week_idx) AS weeks_behind_max,
  CASE
    WHEN (g.max_week_idx - c.last_week_idx) <= 12 AND c.n_weeks_observed >= 8
      THEN 'recent_monitoring_partial'
    WHEN c.n_weeks_observed >= 156
      THEN 'historical_3y'
    WHEN c.n_weeks_observed >= 52
      THEN 'historical_1y'
    ELSE 'insufficient'
  END AS trend_mode
FROM coverage c
CROSS JOIN global_max g;
