-- 10_build_state_fact.sql
-- Purpose: Create state-level weekly fact table (state × condition × MMWR year/week).
-- Notes:
--   * geo_level='state' is states + DC only (per curated_v2 rules).
--   * current_week_0 = COALESCE(Current week, 0) for plotting; interpret trendability via coverage/gating layer.

CREATE OR REPLACE TABLE `public_health_portfolio.tbl_nndss_state_fact` AS
SELECT
  state_name,
  `Label` AS condition,
  `Current MMWR Year` AS mmwr_year,
  `MMWR WEEK` AS mmwr_week,
  COALESCE(`Current week`, 0) AS current_week_0,
  `Current week_ flag` AS current_week_flag,
  `Cumulative YTD Current MMWR Year` AS ytd_current_year,
  `Cumulative YTD Current MMWR Year_ flag` AS ytd_current_year_flag,
  `Cumulative YTD Previous MMWR Year` AS ytd_previous_year,
  `Cumulative YTD Previous MMWR Year_ flag` AS ytd_previous_year_flag
FROM `public_health_portfolio.cdc_nndss_weekly_curated_v2`
WHERE geo_level = 'state';
