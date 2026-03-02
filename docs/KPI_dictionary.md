# KPI Dictionary — NNDSS Surveillance Prototype

## Keys / grain
- state_name: US states + DC only (canonical uppercase).
- condition: NNDSS condition label (`Label` in source).
- mmwr_year: MMWR year (integer).
- mmwr_week: MMWR week (integer).
- yearweek_key: YYYYWW integer = (mmwr_year * 100 + mmwr_week). Used for sorting and labels.

## Core weekly measure
- current_week_0: COALESCE(`Current week`, 0). Plotting-stable weekly count.
  - Interpretation note: zeros may reflect structural sparsity; trend inference must be gated by coverage fields below.

## YTD measures
- ytd_current_year: Cumulative YTD (current MMWR year).
- ytd_previous_year: Cumulative YTD (previous MMWR year).
- *_flag fields: source-provided flags for the respective measures.

## Coverage / gating (state × condition)
- last_yearweek_available: most recent YYYYWW observed for that state×condition.
- n_weeks_observed: number of distinct weeks observed for that state×condition.
- weeks_behind_max: (global max week_idx − last_week_idx) where week_idx is a dense index over distinct observed MMWR weeks.
- trend_mode:
  - recent_monitoring_partial: weeks_behind_max ≤ 12 AND n_weeks_observed ≥ 8
  - historical_1y: n_weeks_observed ≥ 52
  - historical_3y: n_weeks_observed ≥ 156
  - insufficient: otherwise

## Tableau semantics (how to read the dashboard)
- Coverage map: color encodes trendability status (Trendable vs Insufficient coverage). Tooltip shows last available week and weeks observed.
- Trend view: compares selected state vs other states (average) over weekly time; interpret direction using a 4-week moving average.
