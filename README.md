# nndss-surveillance-dashboard

CDC NNDSS weekly surveillance prototype built end-to-end: BigQuery curation + coverage gating → Tableau dashboard for condition-specific trends, jurisdiction comparison, and explicit data-quality controls.

## Problem / stakeholder questions
1) What is happening over time (weekly)? Increasing or decreasing?
2) Where is burden highest right now (by jurisdiction)?
3) How does the current week compare to prior weeks / prior year (context)?
4) Within a jurisdiction, which conditions are driving recent movement?

## Data
Source: CDC NNDSS Weekly Data (public).  
Key time fields: MMWR year + MMWR week.  
Key modeling decision: `Reporting Area` is mixed grain in the raw feed (totals/regions/states/territories). This project restricts geography to **US states + DC only** via `geo_level='state'` in the curated table.

## Measurement rules (defensibility)
- Plotting rule: `current_week_0 = COALESCE(Current week, 0)` for stable visuals.
- Trend conclusions are gated by coverage metadata, not by `current_week_0` alone.
- Percent-change rankings require a baseline threshold (avoid small-denominator inflation).
- Extreme drops/spikes are flagged for QC review (do not treat as signal until verified).
- Direction is interpreted via a short moving average (4-week) rather than single-week noise.

## Build pipeline (BigQuery)
Authoritative scripts are in `/sql` and run in this order:

1) `sql/10_build_state_fact.sql`
   - Builds `public_health_portfolio.tbl_nndss_state_fact` at grain state × condition × MMWR week.

2) `sql/20_build_coverage_gating.sql`
   - Builds `public_health_portfolio.tbl_nndss_state_condition_coverage` at grain state × condition.
   - Fields: `last_yearweek_available`, `n_weeks_observed`, `weeks_behind_max`, `trend_mode`.

3) `sql/30_build_tableau_export.sql`
   - Builds `public_health_portfolio.tbl_tableau_export` (denormalized export for Tableau).

## Outputs
Tables:
- `public_health_portfolio.tbl_nndss_state_fact`
- `public_health_portfolio.tbl_nndss_state_condition_coverage`
- `public_health_portfolio.tbl_tableau_export`

Dashboard (Tableau):
- Trend view: selected state vs other states (avg), weekly, with smoothing (4-week MA).
- Coverage map: trendability/compliance status with explicit last-available week.

## Validation checks (quick)
- Geography: 51 jurisdictions (states + DC only); no territories.
- Join integrity: `tbl_tableau_export` retains fact rows via LEFT JOIN.
- Coverage: `trend_mode` reflects observed weeks and recency (`weeks_behind_max`).

## Tableau Public
Add your Tableau Public link here: <PASTE_LINK>

## Repo layout
- `/sql` BigQuery build scripts
- `/docs` notes (add KPI dictionary, validation notes, limitations)
