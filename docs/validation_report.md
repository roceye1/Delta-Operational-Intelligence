# Delta Air Lines | Data Quality & Validation Report

**Project:** Operational & Financial Intelligence  
**Analysis Period:** 2025 Flight Operations | 2021–2025 Financial & Fuel Data  
**Technologies:** Python, Pandas, PostgreSQL, SQL, Power BI, DAX  
**Status:** Descriptive analysis validated with documented exceptions

---

## 1. Executive Summary

This report documents the data-quality framework and validation results
supporting the Delta Air Lines Operational & Financial Intelligence project.

The analysis combines three independent public datasets:

1. U.S. Bureau of Transportation Statistics (BTS) flight operations
2. Delta Air Lines consolidated financial statements
3. U.S. Energy Information Administration (EIA) fuel-price data

Data preparation was performed using Python and Pandas.

PostgreSQL and SQL were used to validate operational records, calculate
KPIs, and prepare reporting views.

Power BI calculations and dashboard interactions were subsequently
reviewed against the analytical results.

### Validated Dataset Scope

| Dataset | Records | Period |
|---|---:|---|
| Delta-marketed domestic flights | 1,626,898 | 2025 |
| Delta consolidated financials | 5 annual records | 2021–2025 |
| EIA monthly fuel prices | 60 observations | 2021–2025 |
| Calendar dimension | 1,826 dates | 2021–2025 |
| Airports dimension | 216 airports | 2025 operational population |

**Important:** These datasets represent different reporting populations.
They are used together for business context, not direct flight-level
profitability attribution.

---

## 2. Flight Data Validation

### 2.1 Population and Record Counts

| Metric | Verified Result |
|---|---:|
| Total Delta-marketed domestic flights | 1,626,898 |
| Operating carriers represented | 4 |
| Airports represented | 216 |
| Directional routes represented | 1,685 |
| Cancelled flights | 22,207 |
| Diverted flights | 3,937 |
| Completed flights with missing arrival delay | 1 |
| Eligible flights for arrival-performance KPIs | 1,600,753 |
| Delayed arrivals (15+ minutes) | 311,211 |
| On-time arrival rate | 80.56% |

### 2.2 Flight Quality Checks

The PostgreSQL validation query recorded:

| Validation Check | Result | Status |
|---|---:|---|
| Missing flight dates | 0 | Passed |
| Missing origin/destination airport codes | 0 | Passed |
| Non-Delta marketing-carrier records | 0 | Passed |
| Invalid cancellation indicators | 0 | Passed |
| Missing arrival delays among non-cancelled, non-diverted flights | 1 | Documented exception |

The validated operational population contains Delta-marketed domestic
flights, including flights operated by regional partner carriers.

The operating-carrier field is retained for carrier-level comparisons.

### 2.3 Documented Data Exception

**Issue:** One flight was neither cancelled nor diverted but had
a missing arrival-delay value.

**Resolution:**

- Retained the record in the source-aligned operational dataset.
- Excluded it from arrival-delay and on-time-arrival calculations.
- Did not automatically classify the flight as on-time or delayed.
- Preserved cancellation and diversion metrics independently.

This prevents missing information from artificially improving
or worsening reported punctuality.

### 2.4 Arrival Delay Definition

A flight is considered delayed when its arrival delay is
15 minutes or more.

The eligible population is:

- Not cancelled
- Not diverted
- Arrival delay available

The arrival-delay rate is calculated as:

Delayed Eligible Flights / Total Eligible Flights

Using the validated population:

311,211 / 1,600,753 = approximately 19.44%

Therefore:

**On-Time Arrival Rate = approximately 80.56%**

Power BI displays this as **81%** on the executive KPI card,
while the underlying calculations retain their precision.

### 2.5 Cancellation and Diversion Validation

Cancellation and diversion metrics use the full flight population.

| Metric | Count | Rate |
|---|---:|---:|
| Cancellations | 22,207 | 1.36% |
| Diversions | 3,937 | 0.24% |

These rates are not calculated using the eligible completed-flight
denominator.

### 2.6 Additional Quality Considerations

The Python validation script also examines:

- Flight reporting dates
- Marketing and operating carriers
- Unique origins and destinations
- Route coverage
- Cancellation and diversion counts
- Eligible arrival-delay population
- Records with missing arrival delay

A separate, archived execution log demonstrating zero unexplained
duplicate flight records has not yet been included in this repository.

Duplicate-key testing should be documented before claiming
a fully independently reproducible end-to-end validation.

---

## 3. Delay Attribution Validation

The SQL analytical layer examined the five BTS delay-attribution
categories.

### Reported Delay Minutes

| Category | Minutes | Share |
|---|---:|---:|
| Carrier | 10,168,510 | 42.87% |
| Late Aircraft | 6,828,778 | 28.79% |
| National Air System (NAS) | 4,952,646 | 20.88% |
| Weather | 1,752,057 | 7.39% |
| Security | 15,758 | 0.07% |
| **Total** | **23,717,749** | **100%** |

The reported categories reconcile to the analyzed delay-attribution
minutes for the qualifying delayed-arrival population.

### Important Attribution Limitation

Reported delay-cause distribution differs substantially across
operating carriers.

For example, the SkyWest-operated population showed unusually low
Late Aircraft attribution despite a substantial number of delayed
arrivals.

The data contains reported zero values rather than simply missing
values for these attribution fields.

Consequently:

- Reported attribution is preserved as supplied.
- The category totals are treated as accounting-style reconciliations.
- Attribution shares are not interpreted as verified operational causes.
- Comparisons across carriers require additional investigation.

Reconciliation does not establish the independent accuracy of
the underlying cause classification.

---

## 4. Financial Data Validation

### 4.1 Reporting Coverage

The financial dataset covers five fiscal years:

**2021, 2022, 2023, 2024, and 2025**

The source information was collected from Delta Air Lines
consolidated financial disclosures.

Financial values are stored using consistent units,
primarily USD millions.

### 4.2 FY2025 Financial Reconciliation

| Financial Metric | FY2025 |
|---|---:|
| Operating Revenue | $63,364 million |
| Operating Expenses | $57,542 million |
| Operating Income | $5,822 million |
| Operating Margin | 9.19% |
| Aircraft Fuel Expense | $9,819 million |

### Operating Income Reconciliation

Operating Revenue - Operating Expenses = Operating Income

$63,364M - $57,542M = $5,822M

**Result: Reconciled**

### Operating Margin Recalculation

Operating Margin = Operating Income / Operating Revenue

$5,822M / $63,364M = approximately 9.19%

**Result: Reconciled**

### 4.3 Year-over-Year Expense Reconciliation

The 2024–2025 operating expense analysis identified:

| Expense Component | FY2025 vs FY2024 |
|---|---:|
| Fuel expense | -$747 million |
| Salaries and related costs | +$1,359 million |
| Other non-fuel operating expenses | +$1,282 million |
| **Total operating expense change** | **+$1,894 million** |

Reconciliation:

-$747M + $1,359M + $1,282M = +$1,894M

**Result: Reconciled**

### 4.4 Financial Interpretation Controls

The financial analysis distinguishes:

- Reported financial figures
- Calculated financial ratios
- Year-over-year financial changes
- Consolidated financial performance
- Operational performance indicators

Financial and operational datasets have different scopes.

No claim is made that flight delays directly caused
the observed change in Delta's consolidated profitability.

The project also does not estimate route-level profitability
from consolidated financial statements.

---

## 5. Fuel-Price Dataset Validation

### Data Scope

| Metric | Value |
|---|---|
| Source | U.S. Energy Information Administration |
| Series | U.S. Gulf Coast Kerosene-Type Jet Fuel Spot Price FOB |
| Reporting Frequency | Monthly |
| Reporting Period | January 2021–December 2025 |
| Expected Observations | 60 |
| Analysis Observations | 60 |
| Unit | USD per gallon |

### Validation Approach

The Python validation script checks:

- Date conversion
- Numeric price conversion
- Missing monthly observations
- Duplicate months
- Missing prices
- Non-positive prices
- Reporting-period completeness

The analyzed dataset contains the expected 60 monthly observations.

### Financial Interpretation

EIA fuel prices are external market benchmarks.

They are not equivalent to Delta's realized average fuel cost
because of differences in purchasing arrangements, taxes,
timing, and other company-specific factors.

The external benchmark is used for market context.

---

## 6. PostgreSQL and SQL Validation

### Database Structure

The analytical database contains five primary tables:

1. `flights`
2. `financials`
3. `fuel_prices`
4. `calendar`
5. `airports`

### SQL Validation Activities

The analytical workflow included:

- Record-count reconciliation
- Missing-value checks
- Marketing-carrier filtering
- Cancellation and diversion checks
- Delay eligibility validation
- Monthly performance analysis
- Airport and route analysis
- Delay-cause reconciliation
- Financial calculations
- Expense variance analysis

### Relevant Source Files

- `sql/01_create_tables.sql`
- `sql/01b_create_dimensions.sql`
- `sql/02_data_quality.sql`
- `sql/03_analysis.sql`
- `sql/04_powerbi_views.sql`

The SQL reporting layer contains seven views supporting
operational and financial reporting.

**Execution warning:** The initial table-creation script contains
DROP TABLE statements. It must not be rerun against a populated
database without understanding the destructive effects.

---

## 7. Power BI Reporting Validation

The Power BI solution contains three report pages:

1. Executive Overview
2. Operational Intelligence
3. Financial Intelligence

### Semantic Model

The reporting model uses seven imported reporting tables
and a dedicated month dimension.

The model includes active relationships supporting
monthly operational analysis and financial-year comparisons.

### Validation Performed

The dashboard review covered:

- KPI consistency with SQL findings
- DAX calculations and reporting logic
- Month filtering
- Financial-year filtering
- Relationship behavior
- Operating expense reconciliation
- Chart presentation and formatting
- Executive KPI readability
- Dashboard reading-view behavior

### Selected Verification Results

| Test | Expected Result | Recorded Result |
|---|---|---|
| Full-year on-time KPI | Approximately 80.56% | Passed |
| Executive KPI display | 81% | Passed |
| September on-time rate | 87.46% | Passed |
| December on-time rate | 73.16% | Passed |
| FY2025 revenue | $63.36B | Passed |
| FY2025 operating income | $5.82B | Passed |
| FY2025 operating margin | 9.19% | Passed |
| Monthly axis ordering | January–December | Passed |
| Month slicer interactions | Correct filtered results | Passed |
| Financial-year slicer interactions | Correct year selection | Passed |

The operational and financial dashboards were reviewed
for numerical consistency and interactive behavior.

Full automated accessibility conformance testing and
complete independent re-execution evidence are not
included in this validation report.

---

## 8. Validation Evidence and Reproducibility

### Implemented Code

**Python**

- `src/clean_flights.py`
- `src/clean_financials.py`
- `src/clean_fuel.py`
- `src/validate_data.py`

**SQL**

- `sql/02_data_quality.sql`
- `sql/03_analysis.sql`
- `sql/04_powerbi_views.sql`

### Evidence Currently Documented

- Recorded PostgreSQL quality-check results
- Operational population and KPI reconciliations
- Financial reconciliation calculations
- Documented missing-arrival-delay exception
- Historical fuel-price dataset coverage
- Power BI model and report-review results

### Evidence Still Recommended for Publication

To strengthen independent reproducibility, future repository
updates should include:

- Saved output from the complete Python validation run
- Explicit duplicate-flight investigation results
- Financial extraction-to-source comparison evidence
- Full fuel validation output, including missing/duplicate checks
- Power BI measure and semantic-model documentation
- Reproduction instructions for loading and analyzing public data

These are documentation improvements, not claims that the
underlying analysis was never performed.

---

## 9. Known Limitations

1. Operational reporting covers Delta-marketed domestic flights
   during 2025, not all Delta operations worldwide.

2. Financial reporting covers consolidated Delta results
   across 2021–2025.

3. Cancelled and diverted flights are excluded from
   arrival-punctuality calculations but remain in
   cancellation and diversion metrics.

4. One otherwise eligible flight has a missing arrival-delay
   value and is excluded from arrival-punctuality calculations.

5. BTS delay-cause fields represent reported attribution,
   not independently established root causes.

6. EIA fuel-price data is an external market benchmark,
   not Delta's realized purchase price.

7. The dashboards provide historical analysis and
   are not real-time operational monitoring tools.

8. Predictive modeling has not yet been completed.

---

## 10. Validation Conclusion

The recorded results support the project's completed
descriptive operational analysis, financial reporting,
and Power BI dashboards.

The key operational and financial KPIs have been reconciled
against the documented analytical populations and calculations.

A missing-arrival-delay exception and delay-attribution
interpretation limitations have been explicitly documented.

Further archived execution evidence would improve
third-party reproducibility and the strength of a
formal end-to-end validation sign-off.

**Overall status: Suitable for portfolio presentation
with documented limitations and remaining evidence tasks.**

---

*Independent analysis using publicly available information.
Not affiliated with or endorsed by Delta Air Lines.*