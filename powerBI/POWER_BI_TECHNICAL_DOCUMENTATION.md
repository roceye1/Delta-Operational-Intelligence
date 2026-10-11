# Delta Air Lines | Power BI Technical Documentation

## Operational & Financial Intelligence

**Project Type:** Data Analytics, Business Intelligence & Financial Performance Analysis

**Platform:** Microsoft Power BI Online  
**Data Preparation:** Python, Pandas, PostgreSQL, SQL  
**Reporting:** Power BI, DAX, Data Modeling, Interactive Dashboards  
**Operational Period:** January–December 2025  
**Financial Period:** 2021–2025  

**Status:** Completed and validated descriptive reporting solution

---

# 1. Project Overview

This document explains the technical implementation of the Power BI
reporting solution developed for the Delta Air Lines Operational &
Financial Intelligence project.

The solution transforms publicly available aviation, financial, and
fuel-market data into interactive analytical dashboards.

The objective was to combine operational performance analysis with
financial intelligence to support business decision-making.

## Business Objectives

The reporting solution addresses five analytical questions:

1. How reliably did Delta-marketed domestic flights operate in 2025?
2. Which airports, routes, carriers, and months experienced elevated delays?
3. What were the major reported contributors to flight delays?
4. How did Delta's consolidated financial performance evolve from 2021–2025?
5. What drove changes in operating expenses and profitability?

## Skills Demonstrated

- Business Intelligence Development
- Power BI Semantic Modeling
- Data Transformation
- Relational Data Modeling
- DAX Calculations
- KPI Development
- Financial Performance Analysis
- Operating Expense Variance Analysis
- Interactive Dashboard Design
- Analytical Validation
- Executive Reporting

---

# 2. End-to-End Reporting Architecture

The reporting solution follows a structured analytical pipeline.

```text
DATA SOURCES
    |
    |-- BTS Flight Operations (2025)
    |-- Delta / SEC Financial Statements (2021–2025)
    |-- EIA Jet Fuel Prices (2021–2025)
    |
    v
PYTHON DATA PREPARATION
    |
    |-- Cleaning
    |-- Standardization
    |-- Validation
    |-- Derived Analytical Fields
    |
    v
POSTGRESQL DATABASE
    |
    |-- flights
    |-- financials
    |-- fuel_prices
    |-- calendar
    |-- airports
    |
    v
SQL ANALYTICAL LAYER
    |
    |-- Seven Reporting Views
    |-- KPI Aggregations
    |-- Airport & Route Comparisons
    |-- Financial Calculations
    |-- Fuel Economics
    |
    v
STRUCTURED EXCEL DATA EXPORT
    |
    |-- Seven Reporting Tables
    |
    v
POWER BI ONLINE
    |
    |-- Semantic Model
    |-- DimMonth
    |-- Model Relationships
    |-- DAX Measures
    |-- Interactive Filtering
    |
    v
REPORTING APPLICATION
    |
    |-- Executive Overview
    |-- Operational Intelligence
    |-- Financial Intelligence
```

## Implementation Approach

Python was used to prepare the analytical datasets.

PostgreSQL provided structured storage and SQL-based analytical
processing.

Seven reporting views were created to transform detailed datasets
into reporting-ready aggregations.

The reporting views were exported into a structured Excel workbook
and imported into Power BI Online.

Power BI's semantic model and DAX measures provided the analytical
and presentation layer.

This architecture separates data preparation, analytical processing,
semantic modeling, and report visualization.

---

# 3. SQL Reporting Layer

The Power BI solution uses seven PostgreSQL reporting views.

These views were implemented in:

[04_powerbi_views.sql](../sql/04_powerbi_views.sql)

## Reporting View Inventory

| SQL View | Analytical Grain | Purpose |
|---|---|---|
| vw_monthly_operations | Month | Executive operational KPIs |
| vw_airport_monthly_operations | Airport × Month | Airport performance |
| vw_route_monthly_operations | Directional Route × Month | Route performance |
| vw_monthly_delay_causes | Delay Cause × Month | Delay attribution |
| vw_carrier_monthly_operations | Operating Carrier × Month | Carrier benchmarking |
| vw_financial_performance | Fiscal Year | Financial performance |
| vw_fuel_economics | Fiscal Year | Fuel economics |

## Validated Reporting View Coverage

| Reporting View | Records |
|---|---:|
| Monthly Operations | 12 |
| Airport Monthly Operations | 2,520 |
| Route Monthly Operations | 17,143 |
| Monthly Delay Causes | 60 |
| Carrier Monthly Operations | 48 |
| Financial Performance | 5 |
| Fuel Economics | 5 |

The operational views summarize 2025 flight records.

The financial and fuel-economics views summarize fiscal years
2021–2025.

## Design Considerations

### Consistent Aggregation

Flight records are aggregated using predefined eligibility rules
to maintain consistency between SQL and Power BI reporting.

### Directional Route Analysis

Routes are directional.

For example:

ATL → MCO

and:

MCO → ATL

represent separate analytical routes.

### Delay Attribution

The delay-cause view contains five categories:

- Carrier
- Weather
- National Air System (NAS)
- Security
- Late Aircraft

Reported delay-attribution minutes are analyzed separately from
flight counts.

### Financial Units

Financial statement values are stored primarily in USD millions.

The Power BI presentation layer converts selected values into
billions for executive reporting.

---

# 4. Power BI Semantic Model

The Power BI semantic model combines seven imported reporting
tables with a dedicated month dimension.

## Reporting Tables

The following tables were imported into Power BI:

1. tblMonthlyOperations
2. tblAirportMonthlyOperations
3. tblRouteMonthlyOperations
4. tblMonthlyDelayCauses
5. tblCarrierMonthlyOperations
6. tblFinancialPerformance
7. tblFuelEconomics

An additional calculated table was created:

8. DimMonth

## Month Dimension

DimMonth contains the twelve reporting months from January
through December 2025.

The dimension supports consistent chronological filtering
across the operational reporting tables.

The underlying month key is maintained as a date.

Its display format uses abbreviated month labels:

Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec.

This improves readability without changing the underlying date
relationships.

## Operational Relationships

Five active one-to-many relationships connect the month
dimension to the operational tables.

```text
                     DimMonth
                    month_start
                         |
          +--------------+--------------+
          |              |              |
          v              v              v
  tblMonthly       tblAirport       tblRoute
  Operations       Monthly          Monthly
                   Operations       Operations

          |
          +---------------------------+
          |                           |
          v                           v
  tblMonthlyDelayCauses       tblCarrierMonthlyOperations
```

### Relationship Design

The operational relationships use:

- DimMonth as the dimension table
- month_start as the relationship key
- One-to-many cardinality
- Active relationships
- Single-direction filtering

This allows a common month selection to filter multiple
operational reporting tables.

## Financial Relationship

The financial and fuel reporting tables are related using
fiscal_year.

The recorded model uses an active one-to-one relationship
between:

- tblFinancialPerformance
- tblFuelEconomics

This supports the analysis of financial and fuel-economics
measures across the available fiscal years.

## Model Design Principles

The model avoids unnecessary direct relationships between
the operational reporting tables.

This reduces the risk of ambiguous filter paths.

Operational reporting and financial reporting retain
their separate analytical populations.

The model does not establish flight-level relationships
between domestic operational records and consolidated
company financial results.

---

# 5. DAX Development & KPI Design

DAX was used to implement business calculations within
the Power BI semantic model.

The completed development audit recorded 52 base measures,
with seven additional financial display-oriented measures.

These measures support KPI cards, charts, financial analysis,
filter-aware calculations, and report presentation.

The complete source-level DAX measure inventory has not yet
been exported to this repository. The definitions below
document business logic rather than reproducing the exact
measure source.

## Operational KPI Logic

### Total Flights

Total number of Delta-marketed domestic flight records
in the applicable reporting period.

### Eligible Arrivals

Flights satisfying all three conditions:

- Not cancelled
- Not diverted
- Valid arrival-delay value

### Delayed Arrivals

Eligible flights with an arrival delay of at least 15 minutes.

### On-Time Arrival Rate

```text
On-Time Arrival Rate =
    (Eligible Arrivals - Delayed Arrivals)
    / Eligible Arrivals
```

The validated annual result is:

**80.56%**

The Executive Overview card displays:

**81%**

The report retains greater numerical precision for supporting
analytical calculations and tooltips.

### Arrival Delay Rate

```text
Arrival Delay Rate =
    Delayed Arrivals
    / Eligible Arrivals
```

Validated annual result:

**19.44%**

### Cancellation Rate

```text
Cancellation Rate =
    Cancelled Flights
    / Total Flights
```

Validated annual result:

**1.36%**

### Diversion Rate

```text
Diversion Rate =
    Diverted Flights
    / Total Flights
```

Validated annual result:

**0.24%**

## Aggregation Considerations

For aggregated reporting, rates must be calculated from
appropriately summed numerators and denominators.

For example:

```text
Network Delay Rate =
    SUM(Delayed Arrivals)
    / SUM(Eligible Arrivals)
```

A simple arithmetic average of individual airport,
route, or monthly percentages would not necessarily
represent the correct network-wide rate.

This distinction is important when working with
aggregated reporting tables.

---

# 6. Financial KPI Design

The Financial Intelligence page focuses on business
performance and financial reporting.

## Operating Revenue

Delta's consolidated operating revenue.

FY2025:

**$63.36 billion**

## Operating Expenses

Delta's consolidated operating expenses.

FY2025:

**$57.54 billion**

## Operating Income

```text
Operating Income =
    Operating Revenue - Operating Expenses
```

FY2025:

**$5.82 billion**

## Operating Margin

```text
Operating Margin =
    Operating Income / Operating Revenue
```

FY2025:

**9.19%**

## Fuel Expense

Reported aircraft fuel and related tax expense.

FY2025:

**$9.82 billion**

## Financial Display Measures

Additional presentation-oriented measures were used to
display financial values in billions.

The underlying reporting data remains in the units
provided by the SQL reporting layer.

This separates analytical values from presentation
formatting.

## Year-over-Year Analysis

Financial comparisons include:

- Revenue changes
- Operating expense changes
- Operating income and margin changes
- Fuel expense changes
- Salary and related cost changes
- Other non-fuel expense changes

## Expense Variance Reconciliation

FY2025 versus FY2024:

| Expense Category | Change |
|---|---:|
| Aircraft Fuel | -$747M |
| Salaries and Related Costs | +$1,359M |
| Other Non-Fuel Expenses | +$1,282M |
| Total Expense Change | +$1,894M |

The components reconcile:

```text
-$747M + $1,359M + $1,282M = +$1,894M
```

This analysis demonstrates the importance of examining
expense components rather than relying exclusively on
changes in total operating expenses.

---

# 7. Dashboard 1 — Executive Overview

**Purpose:** Executive-level operational performance reporting.

[View Executive Dashboard](screenshots/01-Executive_Overview.png)

## Key Visual Components

- Total Flights KPI
- On-Time Arrival Rate KPI
- Delayed Arrivals KPI
- Cancellation KPI
- Diversion KPI
- Monthly On-Time Arrival Rate Trend
- Monthly Delayed Arrivals Trend
- Full-Year Executive Insights
- Month Filtering

## Analytical Capabilities

The dashboard provides an overview of operational reliability
across the analyzed domestic flight population.

Users can investigate changes in punctuality and disruption
across months.

### Validated Findings

- Total flights: 1,626,898
- Eligible arrivals: 1,600,753
- Delayed arrivals: 311,211
- Annual on-time arrival rate: 80.56%
- September on-time arrival rate: 87.46%
- December on-time arrival rate: 73.16%

## Visual Design Decisions

Percentage display precision was optimized for executive
readability.

For example:

80.56% is displayed as 81% in the primary KPI card.

Small percentages, including cancellation and diversion
rates, retain two decimal places to avoid misleading
rounding.

Month labels use abbreviated names without repeatedly
displaying the reporting year.

The full-year insights section is explicitly labeled to
distinguish static annual findings from slicer-sensitive
visualizations.

---

# 8. Dashboard 2 — Operational Intelligence

**Purpose:** Identify and compare operational disruption patterns.

[View Operational Dashboard](screenshots/02-Operational_Intelligence.png)

## Key Visual Components

- Airport Delay Volume Analysis
- Elevated Airport Delay Rate Analysis
- Directional Route Performance
- Operating-Carrier Performance
- Delay-Cause Attribution
- Monthly Filtering
- Operational Findings

## Airport Analysis

The reporting solution supports comparisons of airports
using delay volume and delay rates.

### Example Finding

Atlanta (ATL) recorded:

**46,481 delayed arrivals**

Approximately:

**14.94% of the analyzed network's delayed arrivals**

High delay volume does not automatically establish
poor relative performance.

High-volume airports may naturally account for more
total delays.

Normalized comparisons are necessary when assessing
operational performance.

## Route Analysis

Directional routes are evaluated independently.

Example:

ATL → MCO recorded 1,777 delayed arrivals.

Route analysis supports the identification of
high-disruption operating patterns.

## Volume Thresholds

Minimum observation thresholds were applied to selected
airport and route comparisons.

The recorded dashboard implementation used:

- At least 1,000 eligible arrivals for selected airport
  delay-rate comparisons within the selected period
- An annual threshold of at least 500 eligible arrivals
  for selected route comparisons

These thresholds help reduce the influence of
small-sample percentage fluctuations.

They are analytical presentation rules rather than
proof that the displayed routes or airports are
operationally deficient.

## Delay Attribution

Reported attribution categories were compared using
accumulated delay minutes.

| Cause | Share |
|---|---:|
| Carrier | 42.87% |
| Late Aircraft | 28.79% |
| NAS | 20.88% |
| Weather | 7.39% |
| Security | 0.07% |

These are reported attribution categories, not
independently established root causes.

Comparisons across operating carriers must also
account for differences in routes, schedules,
operating environments, and reporting patterns.

---

# 9. Dashboard 3 — Financial Intelligence

**Purpose:** Consolidated financial performance and FP&A reporting.

[View Financial Dashboard](screenshots/03-Financial_Intelligence.png)

## Key Visual Components

- Operating Revenue KPI
- Operating Income KPI
- Operating Margin KPI
- Operating Expenses KPI
- Fuel Expenses KPI
- Revenue and Expense Trends
- Operating Margin Trends
- Fuel-Price Comparisons
- Operating Expense Composition
- Year-over-Year Cost Variances
- Fiscal-Year Filtering
- Executive Financial Findings

## Financial Analysis

The dashboard enables historical performance comparisons
from 2021 through 2025.

It supports analysis of:

- Revenue development
- Profitability trends
- Operating cost structures
- Fuel-cost movements
- Financial efficiency indicators
- Expense variance composition

## Selected FY2025 Results

| KPI | Result |
|---|---:|
| Operating Revenue | $63.36B |
| Operating Expenses | $57.54B |
| Operating Income | $5.82B |
| Operating Margin | 9.19% |
| Fuel Expense | $9.82B |

## Profitability Finding

Operating margin declined from 9.73% in FY2024
to 9.19% in FY2025.

This represents a reduction of approximately
0.54 percentage points.

## Fuel Economics

The financial analysis compares Delta's reported
fuel expense, fuel consumption, and average fuel
price with the EIA jet-fuel market benchmark.

The EIA series provides external market context.

It should not be interpreted as the price Delta
actually paid for all fuel purchases.

## FP&A Applications

This dashboard demonstrates capabilities relevant to:

- Financial Performance Analysis
- Profitability Assessment
- Management Reporting
- Operating Expense Analysis
- Year-over-Year Variance Analysis
- Cost Driver Identification
- Financial Decision Support

This is historical financial analysis and does not
represent a completed forward-looking budget or
forecast model.

---

# 10. Interactive Reporting & User Experience

The dashboards were designed to support practical
exploration without requiring users to understand
the underlying SQL or DAX.

## Interactive Features

- Month filtering for operational analysis
- Fiscal-year filtering for financial analysis
- Dynamic KPI evaluation
- Cross-visual analytical consistency
- Context-aware measure calculations
- Readable chart labels
- Financial unit formatting
- Supporting tooltips

## Presentation Principles

The report uses a consistent visual style:

- Deep navy
- White
- Light gray
- Teal
- Muted orange

The design prioritizes clear KPI identification,
visual hierarchy, and readable comparisons.

## Numerical Formatting

Formatting distinguishes between:

- Counts
- Percentages
- Financial values
- Ratios
- Dates
- Reporting units

Whole-percent formatting is used for selected
executive operational KPIs.

Small percentages retain sufficient precision.

Financial values are presented using appropriate
millions or billions conventions.

---

# 11. Validation & Quality Assurance

The Power BI reporting solution underwent a documented
review of calculations, relationships, filtering behavior,
and presentation consistency.

## Validation Activities

### Analytical Validation

- Reconciled operational KPIs against SQL outputs
- Confirmed eligible-arrival definitions
- Validated cancellation and diversion denominators
- Checked financial operating-income reconciliation
- Confirmed expense variance components

### Semantic Model Validation

- Reviewed table relationships
- Verified active month relationships
- Checked operational filtering behavior
- Reviewed fiscal-year reporting behavior
- Preserved the validated measure inventory

### Report Testing

- Verified September and December operational results
- Tested monthly slicer interactions
- Tested financial-year selections
- Checked chart aggregation and labels
- Reviewed reading-view presentation
- Restored default report views following testing

## Selected Validation Results

| Validation Test | Recorded Result |
|---|---|
| Full-year operational KPI | Passed |
| September punctuality | Passed |
| December punctuality | Passed |
| Cancellation and diversion metrics | Passed |
| FY2025 financial KPIs | Passed |
| Operating expense reconciliation | Passed |
| Month slicer behavior | Passed |
| Financial-year filtering | Passed |
| Month ordering and display formatting | Passed |
| Reading-view review | Passed |

A complete automated accessibility certification was
not performed.

The report's validation evidence is summarized in:

[Data Validation Report](../docs/validation_report.md)

---

# 12. Analytical Scope & Limitations

## Operational Population

The operational datasets cover Delta-marketed domestic
flights during calendar year 2025.

The population includes regional partner operations
where flights were marketed by Delta.

## Financial Population

Financial reporting covers Delta's consolidated
company performance from 2021 through 2025.

These populations should not be treated as directly
equivalent.

## No Flight-Level Profitability Attribution

The solution does not allocate consolidated financial
performance to individual domestic flights or routes.

Reported delays are not assumed to have caused
changes in consolidated profitability.

## Historical Data

The dashboards provide historical descriptive analysis.

They are not connected to a real-time airline
operations monitoring system.

## Reported Delay Causes

Delay attribution follows categories reported in
the source operational dataset.

The analysis does not independently establish
the underlying causes of each disruption.

## Predictive Modeling

The predictive flight-delay model has not yet
been developed.

Predictive analytics is a planned extension and
is not represented as a completed capability
of these three dashboards.

---

# 13. Reproducibility & Repository Assets

## Available Source Files

### Python

- [Flight Cleaning](../src/clean_flights.py)
- [Financial Cleaning](../src/clean_financials.py)
- [Fuel Cleaning](../src/clean_fuel.py)
- [Data Validation](../src/validate_data.py)

### SQL

- [Database Tables](../sql/01_create_tables.sql)
- [Dimension Tables](../sql/01b_create_dimensions.sql)
- [Data Quality Queries](../sql/02_data_quality.sql)
- [Analytical Queries](../sql/03_analysis.sql)
- [Power BI Reporting Views](../sql/04_powerbi_views.sql)

### Reporting Evidence

- [Executive Overview](screenshots/01-Executive_Overview.png)
- [Operational Intelligence](screenshots/02-Operational_Intelligence.png)
- [Financial Intelligence](screenshots/03-Financial_Intelligence.png)

## Additional Reproducibility Work

The current repository includes the upstream Python
and SQL implementation and report screenshots.

The following items would further strengthen
independent Power BI reproducibility:

- Exported DAX measure definitions
- Semantic-model metadata
- A documented report deployment procedure
- An accessible report or exportable Power BI file,
  where supported
- Detailed measures-to-visuals mapping

The reporting workbook and Power BI service model
were used during development but are not currently
published as a complete reusable Power BI project
artifact in this repository.

This distinction is important when assessing what
a third party can reproduce directly from GitHub.

---

# 14. Technical & Business Skills Demonstrated

| Competency | Evidence |
|---|---|
| Python & Pandas | Data cleaning and validation |
| PostgreSQL | Relational storage and analytical tables |
| SQL | Aggregation, joins, window functions, reporting views |
| Data Modeling | Semantic model and shared date dimension |
| DAX | KPI calculations and financial measures |
| Power BI | Three interactive executive dashboards |
| Data Validation | SQL/Python checks and metric reconciliations |
| Financial Analysis | Revenue, income, margin, expense trends |
| FP&A | Cost variance, profitability, management reporting |
| Business Intelligence | KPI design, dashboard delivery |
| Business Analysis | Stakeholder-oriented performance investigations |
| Data Visualization | Trend, comparison, and composition reporting |

---

# 15. Conclusion

The completed Power BI reporting solution combines
data engineering, analytical SQL, financial analysis,
semantic modeling, DAX, and executive reporting.

It demonstrates the ability to work across the
analytical lifecycle:

**Prepare Data → Validate Data → Model Data →
Analyze Performance → Build KPIs → Deliver Insights**

The three dashboards provide a structured foundation
for operational performance review and consolidated
financial analysis.

The project demonstrates complementary competencies
relevant to Data Analyst, Business Intelligence Analyst,
Financial Analyst, and FP&A Analyst roles.

---

**Independent portfolio project using publicly available data.**

**Not affiliated with or endorsed by Delta Air Lines.**

**Author:** Aamir Sohaib  
**LinkedIn:** https://www.linkedin.com/in/aamir-sohaib-706889104/