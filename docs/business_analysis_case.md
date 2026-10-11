# Delta Air Lines | Business Analyst Improvement Case

## Operational Performance & Process Improvement

**Project:** Delta Air Lines | Operational & Financial Intelligence

**Author:** Aamir Sohaib

**Business Analysis Phase:** Phase 3

**Current Status:** Planned — Preliminary Evidence Established

**Data Sources:** BTS Flight Operations, Delta Financial Reports

**Operational Analysis Period:** January–December 2025

---

## 1. Problem Statement

### Business Context

Airline operational disruptions create challenges
for scheduling, reliability, resource allocation,
and customer service.

The completed operational analysis identified
differences in delay performance across airports,
routes, operating carriers, and reporting periods.

These findings provide potential opportunities
for further business investigation.

### Preliminary Business Problem

Certain airports and operating periods exhibit
elevated arrival-delay volumes, delay rates,
or seasonal deterioration.

However, the analytical results do not yet
establish the underlying operational causes.

### Business Analysis Objective

Identify one material, evidence-backed operational
problem and develop a structured improvement proposal.

The proposal should:

- Define a specific business problem.
- Identify affected stakeholders.
- Investigate potential root causes.
- Document current operational processes.
- Identify opportunities for improvement.
- Define business requirements.
- Establish measurable success criteria.
- Assess implementation risks and constraints.

**Final problem selection: Pending Phase 3 investigation.**

---

## 2. Evidence

### 2.1 Network-Wide Operational Performance

The completed SQL analysis established the
following 2025 results:

| Metric | Result |
|---|---:|
| Total Flights | 1,626,898 |
| Eligible Arrivals | 1,600,753 |
| Delayed Arrivals | 311,211 |
| On-Time Arrival Rate | 80.56% |
| Arrival Delay Rate | 19.44% |
| Cancellation Rate | 1.36% |
| Diversion Rate | 0.24% |

These metrics establish the network-level
baseline for evaluating potential problems.

### 2.2 Candidate A — Atlanta Delay Volume

Atlanta (ATL) recorded:

- 46,481 delayed arrivals.
- Approximately 14.94% of analyzed network delays.
- A destination arrival-delay rate of 16.93%.

The network-wide delay rate was 19.44%.

### Interpretation

ATL had the highest delay volume, but its
delay rate was below the network average.

This suggests substantial operational exposure
due to flight volume.

It does not establish that ATL has unusually
poor delay performance.

### Potential Investigation

Examine whether specific routes, departure
periods, or disruption categories account
for a disproportionate share of ATL delays.

**Status: Candidate only**

---

### 2.3 Candidate B — LaGuardia Performance

LaGuardia (LGA) recorded:

- 18,554 delayed arrivals.
- A destination arrival-delay rate of 23.46%.
- A December-versus-September delay-rate
  increase of 21.18 percentage points.

The analysis identified LGA as a location
combining substantial delay volume with
an above-average delay rate.

### Potential Investigation

Examine:

- Seasonal delay patterns
- High-delay routes
- Operating-carrier differences
- Scheduled departure periods
- Reported delay attribution
- Operational processes relevant to disruption

### Important Limitation

The BTS destination airport does not
necessarily indicate where a delay originated.

**Status: Candidate only**

---

### 2.4 Candidate C — Seasonal Disruption

Network-wide monthly performance varied
substantially during 2025.

| Month | On-Time Arrival Rate |
|---|---:|
| September | 87.46% |
| December | 73.16% |

The difference was:

**14.30 percentage points**

Among six selected airports,
Chicago O'Hare (ORD) showed a
December-versus-September delay-rate
increase of 25.13 percentage points.

### Potential Investigation

Examine seasonal changes in:

- Operational demand
- Flight scheduling
- Delay attribution
- Airport-specific patterns
- Route exposure

Weather and capacity constraints may be
relevant hypotheses, but the observed data
alone does not establish their causal effects.

**Status: Candidate only**

---

### 2.5 Evidence Sources

The preliminary findings are supported by:

[SQL Operational Analysis](../sql/03_analysis.sql)

[Data Validation Report](validation_report.md)

[Operational Intelligence Dashboard](../powerBI/screenshots/02-Operational_Intelligence.png)

### Evidence Limitations

The existing analysis is primarily descriptive.

It identifies where disruptions occur but
does not independently establish why they occur.

Additional investigation is required before
recommending operational process changes.

---

## 3. Stakeholder Map

The following represents a preliminary
stakeholder assessment for the planned
improvement case.

These are proposed stakeholder roles,
not individuals who participated in
the independent project.

| Stakeholder | Potential Interest | Information Required |
|---|---|---|
| Executive Leadership | Operational reliability | Business impact and proposed outcomes |
| Airport Operations | Ground and airport processes | Operational workflows and constraints |
| Network Planning | Schedules and route performance | Scheduling patterns and capacity |
| Flight Operations | Aircraft and crew coordination | Operational dependencies |
| Finance / FP&A | Financial feasibility | Implementation costs and benefits |
| Business Intelligence | KPI monitoring | Reporting requirements and data definitions |
| Data Analytics | Evidence and measurement | Analytical findings and limitations |

### Phase 3 Task

Refine the stakeholder map after selecting
the specific business problem.

---

## 4. Root-Cause Analysis

### Current Status

**Not yet performed.**

The completed SQL analysis identified
performance patterns and potential
investigation areas.

It did not establish a verified
root-cause explanation.

### Proposed Investigation Methods

Depending on the selected problem,
Phase 3 may use:

- Five Whys analysis
- Fishbone diagrams
- Process mapping
- Pareto analysis
- Comparative performance analysis
- Stakeholder requirement analysis

### Required Evidence

The final case should distinguish:

1. Observed operational outcomes.
2. Statistical associations.
3. Potential contributing factors.
4. Verified root causes, where evidence permits.

Correlation must not be presented as causation.

---

## 5. AS-IS Process

### Objective

Document the existing operational process
associated with the selected problem.

### Planned Deliverables

- Current process map
- Process activities
- Decision points
- Responsible stakeholder roles
- Inputs and outputs
- Operational dependencies
- Known constraints
- Identified process inefficiencies

### Evidence Requirement

Public data may not provide sufficient
information to reconstruct Delta's
actual internal operating procedures.

Where necessary, the case will use
an explicitly labeled illustrative
process model.

An illustrative model must not be
represented as a verified Delta process.

**Status: Pending**

---

## 6. TO-BE Process

### Objective

Design a potential improved process
based on the selected business problem
and available evidence.

### Planned Deliverables

- Proposed process map
- Recommended changes
- Decision-support requirements
- Relevant monitoring KPIs
- Stakeholder responsibilities
- Implementation considerations
- Expected operational outcomes

The TO-BE process will be developed
only after the problem and available
root-cause evidence have been assessed.

**Status: Pending**

---

## 7. Business Requirements

Business requirements will be finalized
during Phase 3.

The following table defines the
documentation structure.

| ID | Requirement | Priority | Rationale | Status |
|---|---|---|---|---|
| BR-01 | Define selected operational problem | TBD | Establish business scope | Pending |
| BR-02 | Establish measurable baseline | TBD | Enable performance evaluation | Pending |
| BR-03 | Identify required operational information | TBD | Support decision-making | Pending |
| BR-04 | Define proposed process improvement | TBD | Address selected problem | Pending |
| BR-05 | Establish monitoring and reporting needs | TBD | Track results | Pending |

These entries describe requirements
development activities.

They are not approved requirements
from Delta or any external stakeholder.

### Planned Requirement Categories

- Business requirements
- Functional requirements
- Non-functional requirements
- Reporting requirements
- Data requirements
- Acceptance criteria

---

## 8. KPI Definitions

Final KPIs will depend on the
selected business problem.

Candidate measures include:

| KPI | Definition |
|---|---|
| Arrival Delay Rate | Delayed eligible arrivals / eligible arrivals |
| On-Time Arrival Rate | On-time eligible arrivals / eligible arrivals |
| Cancellation Rate | Cancelled flights / total flights |
| Diversion Rate | Diverted flights / total flights |
| Delay Attribution Minutes | Source-reported minutes by category |
| Route Delay Rate | Delayed eligible arrivals on a route / eligible route arrivals |
| Airport Delay Rate | Delayed eligible arrivals at a destination / eligible destination arrivals |

### Measurement Principles

KPIs should have:

- Clearly defined populations
- Consistent denominators
- Appropriate reporting periods
- Documented data sources
- Defined comparison groups
- Transparent calculation rules

The final case will select only
those KPIs relevant to its problem.

---

## 9. Acceptance Criteria

Acceptance criteria have not
yet been established.

During Phase 3, they should be:

- Specific
- Measurable
- Relevant to the business problem
- Supported by reliable data
- Realistic for the proposed intervention
- Linked to business requirements

### Acceptance Criteria Template

| ID | Related Requirement | Acceptance Criterion | Validation Method |
|---|---|---|---|
| AC-01 | TBD | TBD | TBD |
| AC-02 | TBD | TBD | TBD |
| AC-03 | TBD | TBD | TBD |

Performance targets will not be
invented without an appropriate
baseline and supporting rationale.

---

## 10. Recommended Actions

### Current Status

**Final recommendations: Pending**

The completed analysis supports
further investigation rather than
a specific untested intervention.

### Preliminary Investigation Priorities

1. Evaluate LGA's combination of elevated
   delay volume, delay rate, and seasonality.
2. Examine ATL's contribution to total
   delayed arrivals.
3. Investigate the seasonal deterioration
   observed at selected airports.
4. Compare route-level and operating-carrier
   performance within candidate locations.
5. Review the reported delay categories
   and their analytical limitations.

These are investigation priorities,
not verified solutions.

### Final Recommendation Requirements

Any final recommendation should include:

- Supporting evidence
- Business rationale
- Affected stakeholders
- Implementation assumptions
- Relevant risks
- Measurement approach
- Expected operational outcomes

---

## 11. Expected Business Benefits

### Current Status

**Not quantified.**

The project has not established
a defensible relationship between
a proposed operational intervention
and a measurable financial benefit.

### Potential Benefit Categories

Depending on the selected problem:

- Improved service reliability
- Lower arrival-delay frequency
- Better operational visibility
- Improved management reporting
- More consistent decisions
- More effective disruption monitoring

These are potential outcomes,
not achieved results.

### Financial Benefits

Financial savings will not be
estimated without:

1. A clearly defined intervention.
2. An evidence-supported impact estimate.
3. Relevant operational cost information.
4. Transparent assumptions.
5. A defensible calculation method.

Delta's consolidated financial results
will not be used to invent route-level
or airport-level savings.

---

## 12. Risks and Limitations

| Risk or Limitation | Consideration |
|---|---|
| Descriptive evidence | Observed delays do not establish causes |
| Public-data limitations | Internal processes may not be observable |
| Airport attribution | Destination does not necessarily indicate delay origin |
| Seasonal variation | Comparisons must account for changing conditions |
| Route differences | Operational comparisons may not be directly equivalent |
| Sample size | Small groups can produce unstable percentages |
| Financial attribution | Consolidated costs cannot be assigned directly to domestic routes |
| Stakeholder assumptions | Actual Delta stakeholder requirements are unavailable |
| Implementation feasibility | Changes require operational assessment |
| Benefit estimates | Financial outcomes require defensible evidence |

### Analytical Integrity

This independent portfolio project
does not claim:

- Access to Delta's internal systems
- Direct engagement with Delta management
- Verified internal process documentation
- Implementation of operational changes
- Proven cost savings
- Causal proof from descriptive analysis

---

## 13. Case Selection Framework

Before developing the final improvement
proposal, candidate problems should
be compared using consistent criteria.

| Selection Criterion | Assessment Question |
|---|---|
| Business Materiality | Is the problem operationally meaningful? |
| Data Evidence | Is it supported by validated observations? |
| Performance Gap | Is the problem significant after normalization? |
| Actionability | Can a realistic intervention be proposed? |
| Stakeholder Relevance | Does it affect meaningful business decisions? |
| Measurement | Can improvement be evaluated? |
| Feasibility | Can the case be developed using available information? |

The selected problem must be documented
with its supporting rationale.

### Candidate Problems

- Atlanta delay-volume concentration
- LaGuardia performance and seasonality
- Seasonal disruption at selected airports

**Final selection: Pending**

---

## 14. Phase 3 Deliverables

The completed Business Analyst case
should contain:

1. Selected business problem
2. Supporting analytical evidence
3. Stakeholder assessment
4. Root-cause investigation
5. AS-IS process representation
6. TO-BE process proposal
7. Business requirements
8. Functional and non-functional requirements
9. Defined KPIs
10. Acceptance criteria
11. Recommended actions
12. Risks and assumptions
13. Benefits assessment
14. Executive recommendation

All conclusions must distinguish
verified findings from proposed
changes and assumptions.

---

## 15. Current Project Position

### Completed

- Python data preparation
- PostgreSQL database development
- SQL operational analysis
- SQL financial analysis
- Data quality validation
- Power BI dashboards
- Operational and financial findings
- Technical documentation

### Planned — Phase 2

- Exploratory Data Analysis
- Feature engineering
- Flight-delay prediction
- Machine learning evaluation

### Planned — Phase 3

- Final business problem selection
- Root-cause investigation
- Business process analysis
- Requirements development
- Improvement proposal
- Acceptance criteria
- Benefits assessment

This document will be expanded
during Phase 3 using the completed
analytical work and any additional
evidence developed during Phase 2.

---

## Supporting Documentation

[Project Charter](project_charter.md)

[Project Methodology](methodology.md)

[Data Dictionary](data_dictionary.md)

[SQL Analytical Findings](../sql/03_analysis.sql)

[Power BI Technical Documentation](../powerBI/POWER_BI_TECHNICAL_DOCUMENTATION.md)

---

**Author:** Aamir Sohaib

**Disclaimer:** Independent analytical portfolio project
using publicly available data. Not affiliated with
or endorsed by Delta Air Lines.