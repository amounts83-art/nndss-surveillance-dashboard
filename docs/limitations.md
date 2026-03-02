# Limitations and interpretation rules

1) Mixed-grain geography in the raw feed
- `Reporting Area` includes totals, regions, states, and territories. This project restricts analysis to U.S. states + Washington, D.C. using `geo_level='state'` from a reference mapping.

2) Structural sparsity and zero handling
- `Current week` is frequently NULL for rare conditions. The plotting field `current_week_0` uses COALESCE to 0 for stable visuals, but zeros must not be interpreted as reporting failure without coverage context.

3) Trend eligibility is gated
- Trend inference is conditioned on `trend_mode` and coverage fields (`n_weeks_observed`, `weeks_behind_max`). Do not interpret “insufficient” series as trending.

4) Percent-change pitfalls
- Percent-change rankings are not shown without a minimum baseline to avoid small-denominator inflation.

5) Reporting artifacts
- Extreme spikes/drops may reflect reporting delays or revisions rather than true epidemiologic change. These are routed to a QC review queue before operational interpretation.

6) Portfolio scope
- This is a monitoring prototype to demonstrate data curation, measurement governance, and BI delivery; it does not attempt causal attribution.
