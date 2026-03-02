-- Expect: 51 distinct jurisdictions (50 states + DC)
SELECT
  COUNT(DISTINCT state_name) AS n_states_dc
FROM `public_health_portfolio.cdc_nndss_weekly_curated_v2`
WHERE geo_level = 'state';
