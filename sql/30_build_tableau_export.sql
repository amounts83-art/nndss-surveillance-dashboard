-- 30_build_tableau_export.sql
-- Purpose: Build a single denormalized Tableau-ready table (fact + coverage join).
-- Output: public_health_portfolio.tbl_tableau_export
-- Grain: state × condition × MMWR week
-- Notes:
--   * yearweek_key = (mmwr_year*100 + mmwr_week) used for sorting/labels in Tableau.
--   * Coverage fields are LEFT JOINed so every fact row retains gating metadata.

CREATE OR REPLACE TABLE `public_health_portfolio.tbl_tableau_export` AS
SELECT
  f.state_name,
  f.condition,
  f.mmwr_year,
  f.mmwr_week,
  (f.mmwr_year * 100 + f.mmwr_week) AS yearweek_key,
  f.current_week_0,
  f.current_week_flag,
  f.ytd_current_year,
  f.ytd_current_year_flag,
  f.ytd_previous_year,
  f.ytd_previous_year_flag,
  c.last_yearweek_available,
  c.n_weeks_observed,
  c.weeks_behind_max,
  c.trend_mode
FROM `public_health_portfolio.tbl_nndss_state_fact` f
LEFT JOIN `public_health_portfolio.tbl_nndss_state_condition_coverage` c
  ON f.state_name = c.state_name
 AND f.condition = c.condition;
