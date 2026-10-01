# Methodology

## 1. Analytical Design
This project uses a reproducible workflow:

1. Collect official public source data.
2. Preserve source files unchanged in `data/raw/`.
3. Inspect structure, field quality, and coverage.
4. Clean and standardize with Python.
5. Store analysis-ready outputs in `data/processed/`.
6. Load analytical tables into PostgreSQL (DuckDB fallback).
7. Validate row counts, keys, dates, nulls, and KPI logic.
8. Conduct SQL-based operational and financial analysis.
9. Build Power BI views and a three-page dashboard.
10. Train and evaluate a pre-departure flight-delay risk model.
11. Convert one evidence-backed issue into a Business Analyst improvement case.

## 2. Operational Population
The primary operational population is Delta-marketed U.S. domestic flights during calendar year 2025. Operating-carrier information will be retained to distinguish mainline and regional/partner operations where analytically relevant.

## 3. Delay Definition
A flight is considered delayed for the predictive target when its eligible arrival delay is **15 minutes or more**, consistent with the common U.S. on-time-performance threshold.

Cancelled or diverted flights will not be silently treated as on-time or delayed arrivals. Their treatment will be documented separately for each KPI/model population.

## 4. Comparison Rules
Airport and route comparisons will use both scale and normalized measures. Total disruption alone can overstate problems at high-volume hubs, so analysis will include rates and measures such as delay minutes per 100 flights. Minimum-volume thresholds will be applied before identifying weak-performing routes or locations.

## 5. Financial Interpretation
Delta financial metrics for 2021–2025 provide business context. Because the operational dataset is flight-level 2025 data while many financial measures are annual and consolidated, the project will **not** claim that observed delays caused changes in Delta's annual revenue or profitability. Associations and contextual comparisons will be labelled accordingly.

## 6. Fuel Interpretation
Monthly U.S. Gulf Coast jet-fuel spot prices from EIA provide an external market benchmark. They are not the same as Delta's realized fuel price or hedged/contracted cost and will not be presented as such.

## 7. Predictive Modeling
### Target
`arrival_delayed_15 = 1` when an eligible completed flight arrives at least 15 minutes late.

### Candidate Pre-Departure Features
- Month
- Day of week
- Scheduled departure hour
- Origin airport
- Destination airport
- Route
- Distance

### Leakage Controls
Post-flight fields such as actual arrival delay, actual arrival time, delay causes, and other information only known after operations occur will not be used as model predictors.

### Evaluation
The model will be evaluated on unseen test data using:
- Precision
- Recall
- F1 score
- ROC-AUC
- Confusion matrix

A simple baseline will be compared with one stronger model. Model usefulness, class imbalance, and limitations will be discussed explicitly.

## 8. Evidence Standards
- Raw data remains unchanged.
- Transformations are scripted.
- Reported, calculated, and estimated values are labelled.
- Findings require validated evidence.
- Recommendations must trace back to analytical findings.
- Public information is never represented as confidential Delta information.
