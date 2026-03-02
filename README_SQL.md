# SQL build scripts (BigQuery)

This folder contains the authoritative BigQuery scripts used to build the curated Tableau-ready dataset for the NNDSS surveillance prototype.

## Execution order

1. `10_build_state_fact.sql`
   - Builds `public_health_portfolio.tbl_nndss_state_fact` at grain **state × condition × MMWR year/week**.
   - Applies the project’s plotting rule: `current_week_0 = COALESCE(Current week, 0)`.
   - Restricts to `geo_level = 'state'` (states + DC only) as defined in `cdc_nndss_weekly_curated_v2`.

## Data source assumptions

- Source curated table: `public_health_portfolio.cdc_nndss_weekly_curated_v2`
- Required fields (as referenced):
  - `state_name`, `Label`, `Current MMWR Year`, `MMWR WEEK`, `Current week`
  - `Current week_ flag`, `Cumulative YTD Current MMWR Year`, `Cumulative YTD Current MMWR Year_ flag`
  - `Cumulative YTD Previous MMWR Year`, `Cumulative YTD Previous MMWR Year_ flag`
- Trend conclusions must be gated by the **coverage/gating layer** (provided in separate scripts when added), not by `current_week_0` alone.
