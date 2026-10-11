# Delta Air Lines | Project Charter

## Operational & Financial Intelligence

**Project Type:** Data Analytics, Business Intelligence, Financial Analysis & Predictive Analytics

**Project Owner:** Aamir Sohaib

**Primary Technologies:** Python, Pandas, PostgreSQL, SQL, Power BI, DAX, Excel

**Operational Period:** January–December 2025

**Financial Period:** Fiscal Years 2021–2025

**Project Status:** Phased Development — Descriptive Analytics & BI Completed

---

## 1. Project Background

Airline operations involve complex interactions between
flight scheduling, airport capacity, aircraft availability,
weather conditions, and network performance.

Operational disruptions can affect service reliability
and create additional business challenges.

At the same time, airline financial performance is
influenced by revenue development, operating expenses,
fuel costs, labor expenses, and other economic factors.

This independent project investigates these subjects
using publicly available operational and financial data.

The objective is to demonstrate how analytical techniques
can support operational performance assessment,
financial intelligence, and business decision-making.

The project is not affiliated with or endorsed by
Delta Air Lines.

---

## 2. Central Business Question

**How can historical operational and financial data
be used to identify performance patterns, investigate
business challenges, and support better decisions?**

The investigation is organized around three questions.

### Operational Intelligence

Where are delays and disruptions concentrated
across Delta-marketed domestic operations?

### Financial Intelligence

What do historical revenue, operating expense,
and profitability trends reveal about Delta's
financial performance?

### Predictive Intelligence

Can information available before departure
help estimate the probability of a flight
arriving at least 15 minutes late?

The predictive question will be addressed
in a future project phase.

---

## 3. Project Objectives

### Objective 1 — Operational Performance Analysis

Measure and evaluate:

- Total flight volume
- On-time arrival performance
- Arrival delays
- Cancellations
- Diversions
- Monthly performance trends
- Airport performance
- Directional route performance
- Operating-carrier performance
- Reported delay attribution

**Status: Completed**

### Objective 2 — Financial Performance Analysis

Analyze Delta's consolidated financial results,
including:

- Operating revenue
- Operating expenses
- Operating income
- Operating margins
- Net income
- Operating cash flow
- Fuel expenses
- Salaries and related costs
- Other non-fuel operating expenses
- Year-over-year financial changes

**Status: Completed**

### Objective 3 — Business Intelligence Development

Develop a reporting solution that translates
analytical findings into executive-level
visualizations.

Deliver three interactive dashboards:

1. Executive Overview
2. Operational Intelligence
3. Financial Intelligence

**Status: Completed**

### Objective 4 — Predictive Analytics

Develop and evaluate a machine learning model
to estimate pre-departure flight-delay risk.

The model will use only features available
before the prediction decision point.

**Status: Planned**

### Objective 5 — Business Analysis Improvement Case

Select an evidence-backed operational problem
and develop a structured business improvement case.

**Status: Planned**

---

## 4. Project Scope

### 4.1 Operational Data

**Source:** Bureau of Transportation Statistics

**Population:** Delta-marketed U.S. domestic flights

**Period:** January–December 2025

**Validated Records:** 1,626,898

The operational analysis includes flights marketed
by Delta and operated by Delta or qualifying
regional operating carriers.

The operating carrier is retained as a separate
analytical dimension.

### 4.2 Financial Data

**Source:** Delta Air Lines / SEC

**Period:** Fiscal Years 2021–2025

**Records:** Five annual observations

The financial analysis covers Delta's consolidated
company results.

Financial values are not assigned to individual
domestic flights, airports, or routes.

### 4.3 Fuel Data

**Source:** U.S. Energy Information Administration

**Period:** January 2021–December 2025

**Records:** 60 monthly observations

The EIA jet-fuel price series provides
external market context.

It does not represent Delta's actual
realized purchase price.

---

## 5. Intended Stakeholders

The project is designed around the analytical
requirements of several business functions.

| Stakeholder | Primary Interest |
|---|---|
| Executive Leadership | Overall business performance |
| Airport Operations | Delay concentration and operational reliability |
| Network Planning | Route and scheduling performance |
| Finance & FP&A | Profitability, cost trends, expense variances |
| Business Intelligence | KPI design, reporting, and visualization |
| Data Science | Predictive modeling and risk assessment |
| Business Analysis | Requirements and operational improvement |

These represent hypothetical stakeholder groups
for this independent portfolio project.

No direct stakeholder engagement with Delta
is claimed.

---

## 6. Project Development Phases

The project is divided into three primary phases.

### Phase 1 — Data Analytics, Financial Analysis & BI

**Status: Completed**

The completed work includes:

- Public data collection
- Python data preparation
- PostgreSQL database development
- SQL data validation
- Operational performance analysis
- Financial statement analysis
- Expense variance analysis
- Fuel economics analysis
- SQL reporting views
- Power BI semantic modeling
- DAX KPI development
- Three interactive dashboards
- Technical documentation
- Executive analytical findings

#### Phase 1 Deliverables

| Deliverable | Status |
|---|---|
| Data source register | Completed |
| Python cleaning scripts | Completed |
| PostgreSQL database | Completed |
| SQL data quality queries | Completed |
| SQL operational analysis | Completed |
| SQL financial analysis | Completed |
| Seven Power BI reporting views | Completed |
| Power BI Executive Overview | Completed |
| Power BI Operational Intelligence | Completed |
| Power BI Financial Intelligence | Completed |
| Data dictionary | Completed |
| Methodology documentation | Completed |
| Validation report | Completed |
| Power BI technical documentation | Completed |

#### Phase 1 Reproducibility Follow-Up

The principal analytical scripts and documentation
are available in the project repository.

However, a complete automated rebuild from an
empty environment has not yet been demonstrated.

The full exported DAX measure definitions
and reusable Power BI model artifact are
also not yet published.

These are documentation and reproducibility
improvements rather than completed deliverables.

---

### Phase 2 — Exploratory & Predictive Analytics

**Status: Planned**

This phase will extend the existing
historical analysis into predictive modeling.

#### Part A — Exploratory Data Analysis

Develop:

`notebooks/01_exploration.ipynb`

Planned analysis includes:

- Data distributions
- Missing-value assessment
- Outlier investigation
- Arrival-delay distributions
- Temporal patterns
- Airport and route comparisons
- Departure-time relationships
- Statistical associations
- Feature exploration
- Data visualization
- Business interpretation

The objective is to identify patterns
and assess data suitability before
training predictive models.

#### Part B — Flight Delay Prediction

Develop:

`notebooks/02_delay_prediction.ipynb`

The modeling objective is to estimate
the probability that an eligible flight
will arrive at least 15 minutes late.

The model must use features reasonably
available before departure.

Planned tasks include:

1. Define prediction timing and target population.
2. Select leakage-safe predictors.
3. Establish a baseline model.
4. Create chronological training and test partitions.
5. Train candidate classification algorithms.
6. Compare model performance.
7. Evaluate class imbalance.
8. Analyze false positives and false negatives.
9. Assess feature importance and explainability.
10. Interpret potential operational applications.

#### Model Evaluation

Model performance should be assessed using
appropriate classification metrics, potentially
including:

- Precision
- Recall
- F1-score
- ROC-AUC
- PR-AUC
- Confusion matrix
- Probability calibration

The evaluation must account for the
business consequences of prediction errors.

A model will not be described as successful
without appropriate out-of-time evaluation.

#### Phase 2 Deliverables

- Completed EDA notebook
- Documented feature engineering
- Trained baseline and candidate models
- Chronological holdout evaluation
- Model comparison
- Explainability analysis
- Predictive findings and limitations

No model performance results are claimed
at this stage.

---

### Phase 3 — Business Analyst Improvement Case

**Status: Planned**

This phase will translate an evidence-backed
analytical finding into a structured
business improvement proposal.

The specific problem will be selected
after further investigation.

Potential deliverables include:

- Business problem statement
- Stakeholder analysis
- Current-state (AS-IS) process
- Root-cause investigation
- Proposed future-state (TO-BE) process
- Business requirements
- Functional requirements
- Non-functional requirements
- Process improvement recommendations
- KPIs and acceptance criteria
- Implementation considerations
- Risks and assumptions

Financial benefits will be quantified
only when a defensible methodology
and sufficient evidence are available.

---

## 7. Primary KPIs

### Operational KPIs

| KPI | Business Purpose |
|---|---|
| Total Flights | Measure operating volume |
| Eligible Arrivals | Define punctuality population |
| On-Time Arrival Rate | Measure arrival reliability |
| Arrival Delay Rate | Measure late-arrival frequency |
| Delayed Arrivals | Measure disruption volume |
| Cancellation Rate | Measure cancelled operations |
| Diversion Rate | Measure diverted operations |
| Delay Attribution Minutes | Compare reported delay causes |
| Airport Delay Rate | Compare airport performance |
| Route Delay Rate | Compare directional route performance |

### Financial KPIs

| KPI | Business Purpose |
|---|---|
| Operating Revenue | Measure revenue generation |
| Operating Expenses | Measure operating cost |
| Operating Income | Measure operating profitability |
| Operating Margin | Measure profitability relative to revenue |
| Net Income | Evaluate bottom-line results |
| Operating Cash Flow | Assess cash generated by operations |
| Fuel Expense | Monitor a major cost component |
| Salary Expense | Analyze labor-related costs |
| Expense Variance | Evaluate year-over-year cost changes |

---

## 8. Selected Phase 1 Findings

The following results were validated
during the descriptive analysis.

### Operational Results

| Metric | 2025 Result |
|---|---:|
| Total Flights | 1,626,898 |
| Eligible Arrivals | 1,600,753 |
| Delayed Arrivals | 311,211 |
| On-Time Arrival Rate | 80.56% |
| Cancellation Rate | 1.36% |
| Diversion Rate | 0.24% |

### Monthly Performance

- September recorded the strongest on-time performance: 87.46%.
- December recorded the weakest on-time performance: 73.16%.

### Airport Concentration

Atlanta recorded 46,481 delayed arrivals,
representing approximately 14.94%
of the analyzed delayed-arrival population.

This indicates a concentration of
delay volume, not proof of an
airport-specific root cause.

### Financial Results

| Metric | FY2025 |
|---|---:|
| Operating Revenue | $63.36B |
| Operating Expenses | $57.54B |
| Operating Income | $5.82B |
| Operating Margin | 9.19% |
| Fuel Expense | $9.82B |

### Expense Variance

Between FY2024 and FY2025:

- Fuel expense decreased by $747M.
- Salaries and related costs increased by $1,359M.
- Other non-fuel expenses increased by $1,282M.
- Total operating expenses increased by $1,894M.

These figures reconcile to the
reported change in operating expenses.

---

## 9. Analytical Principles

The following principles apply across
all phases of the project.

### Data Integrity

Source information should be preserved
and transformations should be documented.

### Transparent Calculations

KPI definitions must clearly specify
their numerators, denominators,
units, and reporting populations.

### Evidence-Based Conclusions

Descriptive findings must be distinguished
from statistical associations,
hypotheses, and causal claims.

### Comparable Populations

Operational and financial measures
must not be combined in ways that
imply unsupported relationships.

### Sample Size Awareness

Selected comparisons should use
appropriate volume thresholds
to reduce misleading interpretations.

### Predictive Data Leakage Prevention

Predictive features must be evaluated
against the information available
at the intended prediction time.

### Responsible Financial Interpretation

Financial conclusions must distinguish
reported results from estimates
and hypothetical business benefits.

---

## 10. Out of Scope

Unless a future phase explicitly
expands the project, the following
are outside its current scope:

- Real-time operational monitoring
- Live airline reservation systems
- Customer-level profitability
- Unverified route profitability estimates
- Proprietary Delta operational systems
- Production airline dispatch integration
- Live model deployment
- Mobile application development
- Claims that domestic flight delays directly
  caused changes in consolidated profitability

The project is an independent analytical
portfolio and not an operational system
used by Delta.

---

## 11. Risks & Constraints

| Risk or Constraint | Management Approach |
|---|---|
| Public-data limitations | Document coverage and missing fields |
| Different reporting populations | Separate operational and financial analysis |
| Source-reported delay attribution | Avoid unsupported causal claims |
| Uneven observation counts | Use relevant volume thresholds |
| Historical-data limitations | Restrict findings to supported periods |
| Predictive data leakage | Use pre-departure feature controls |
| Model generalization | Use chronological holdout testing |
| Financial attribution limitations | Avoid unsupported route-level profitability |
| Incomplete reproducibility artifacts | Document gaps and add missing assets |

---

## 12. Definition of Done

Project completion is evaluated
separately for each development phase.

### Phase 1 — Descriptive Analytics & BI

Phase 1 is considered analytically complete
because:

- The principal datasets have been prepared.
- Core data quality checks have been performed.
- Operational and financial KPIs have been calculated.
- SQL analytical queries have been implemented.
- Seven reporting views have been created.
- Three Power BI dashboard pages have been completed.
- Principal analytical findings have been documented.
- Report-level validation has been performed.

Independent end-to-end rebuild evidence
and selected reusable Power BI artifacts
remain follow-up improvements.

### Phase 2 — Predictive Analytics

Phase 2 will be considered complete when:

- EDA has been performed and documented.
- The prediction target has been defined.
- Feature leakage controls have been applied.
- Baseline and candidate models have been evaluated.
- Chronological holdout testing has been completed.
- Model limitations have been documented.
- Findings can be reproduced from the supplied code
  and appropriately accessible datasets.

### Phase 3 — Business Analysis

Phase 3 will be considered complete when:

- A specific business problem is selected.
- Evidence supporting the problem is documented.
- Stakeholder needs are defined.
- Current and proposed processes are examined.
- Business requirements are developed.
- Recommendations are linked to analytical findings.
- Risks, assumptions, and success criteria are documented.

---

## 13. Project Repository & Documentation

The repository is organized to provide
technical evidence and business context.

### Technical Implementation

- Python cleaning scripts
- SQL database definitions
- SQL analytical queries
- SQL reporting views
- Jupyter notebooks for future modeling

### Business Intelligence

- Executive Overview dashboard
- Operational Intelligence dashboard
- Financial Intelligence dashboard
- Power BI technical documentation

### Project Documentation

- [Data Source Register](source_register.md)
- [Data Dictionary](data_dictionary.md)
- [Project Methodology](methodology.md)
- [Validation Report](validation_report.md)
- [Power BI Technical Documentation](../powerBI/POWER_BI_TECHNICAL_DOCUMENTATION.md)

---

## 14. Portfolio Objectives

The completed and planned work is designed
to demonstrate capabilities relevant to
multiple analytical career paths.

### Data Analyst

- Python and Pandas
- SQL
- Data cleaning
- Exploratory analysis
- Data validation
- Statistical reasoning

### Business Intelligence Analyst

- Power BI
- DAX
- Semantic modeling
- KPI design
- Dashboard development
- Executive reporting

### Financial Analyst / FP&A Analyst

- Financial statement analysis
- Operating margin analysis
- Expense variance analysis
- Cost driver investigation
- Profitability reporting
- Financial performance interpretation

### Business Analyst

- Business problem definition
- Stakeholder analysis
- Business requirements
- Process improvement
- Evidence-based recommendations

### Predictive Analytics

- Machine learning
- Feature engineering
- Model evaluation
- Classification
- Predictive risk analysis

Predictive modeling and the structured
Business Analyst case remain planned
until completed and validated.

---

## 15. Project Success Criteria

The project is intended to demonstrate
more than the ability to produce dashboards.

Its success depends on showing the ability to:

1. Define meaningful business questions.
2. Acquire and prepare real-world data.
3. Develop and validate analytical calculations.
4. Build structured databases and reporting models.
5. Interpret operational and financial performance.
6. Communicate findings to business stakeholders.
7. Recognize analytical limitations.
8. Document reproducible technical work.
9. Extend descriptive analysis into predictive modeling.
10. Translate findings into actionable business proposals.

---

**Author:** Aamir Sohaib

**Project:** Delta Air Lines | Operational & Financial Intelligence

**Disclaimer:** This is an independent portfolio project
based on publicly available information.
It is not affiliated with or endorsed by Delta Air Lines.