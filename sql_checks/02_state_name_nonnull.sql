-- Expect: 0 rows (state_name must be present for geo_level='state')
SELECT
  COUNT(*) AS bad_rows
FROM `public_health_portfolio.cdc_nndss_weekly_curated_v2`
WHERE geo_level = 'state'
  AND state_name IS NULL;
