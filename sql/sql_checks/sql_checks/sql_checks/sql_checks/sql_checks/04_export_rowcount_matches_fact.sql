-- Expect: export_rows = fact_rows
SELECT
  (SELECT COUNT(*) FROM `public_health_portfolio.tbl_nndss_state_fact`) AS fact_rows,
  (SELECT COUNT(*) FROM `public_health_portfolio.tbl_tableau_export`)  AS export_rows;
