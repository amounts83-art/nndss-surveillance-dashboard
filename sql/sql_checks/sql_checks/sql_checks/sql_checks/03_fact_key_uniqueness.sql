-- Expect: 0 rows (no duplicate keys)
SELECT
  state_name,
  condition,
  mmwr_year,
  mmwr_week,
  COUNT(*) AS n
FROM `public_health_portfolio.tbl_nndss_state_fact`
GROUP BY 1,2,3,4
HAVING COUNT(*) > 1;
