# Delta Air Lines | Operational & Financial Intelligence

### End-to-End Data Analytics, Financial Performance Analysis & Business Intelligence

**Python | SQL | PostgreSQL | Power BI | DAX | Financial Analysis | FP&A | Business Intelligence**

An independent portfolio project analyzing **1.63 million Delta-marketed domestic flights** and **five years of consolidated financial performance** to investigate operational efficiency, profitability, cost drivers, and business performance.

The project demonstrates the integration of data preparation, database development, analytical SQL, financial analysis, data modeling, and interactive executive reporting.

> **Project status:** Operational analysis, financial analysis, and three Power BI dashboards completed. Predictive modeling and the formal business improvement case are planned extensions.
>
> **Disclaimer:** Independent analysis using publicly available information. This project is not affiliated with or endorsed by Delta Air Lines.

---

## 1. Executive Overview

### Business Problem

Airline performance depends on operational reliability, effective resource utilization, and financial discipline.

Flight delays create operational challenges, while changes in fuel prices, labor costs, and other operating expenses affect profitability.

This project investigates two complementary business questions:

**Operational Intelligence**

Where and when do flight disruptions occur, and which airports, routes, operating carriers, and scheduling patterns warrant closer investigation?

**Financial Intelligence**

How have Delta's revenue, operating expenses, profitability, and fuel economics evolved, and what explains changes in reported operating performance?

### Project Highlights

| Metric | Result |
|---|---:|
| Delta-marketed domestic flights analyzed | 1,626,898 |
| Eligible completed flights | 1,600,753 |
| On-time arrival rate | 80.56% |
| Delayed arrivals (15+ minutes) | 311,211 |
| Cancelled flights | 22,207 |
| Cancellation rate | 1.36% |
| Diversion rate | 0.24% |
| Airports represented | 216 |
| Directional routes analyzed | 1,685 |
| Financial analysis period | 2021–2025 |
| 2025 operating revenue | $63.36B |
| 2025 operating income | $5.82B |
| 2025 operating margin | 9.19% |

**Important:** On-time arrival performance is calculated using eligible completed flights. Cancellations and diversions are measured separately.

---

## 2. Executive Performance Dashboard

![Delta Executive Overview](powerBI/screenshots/01-Executive_Overview.png)

The Executive Overview provides an integrated summary of Delta-marketed domestic flight operations during 2025.

### Key Capabilities

- Executive KPI monitoring
- On-time arrival performance tracking
- Flight-delay volume analysis
- Cancellation and diversion monitoring
- Monthly operational trend analysis
- Interactive month filtering
- Business-focused performance summaries

### Key Findings

- The annual on-time arrival rate was **80.56%**, displayed as 81% on the executive dashboard.
- September recorded the strongest monthly on-time performance at **87.46%**.
- December recorded the weakest monthly on-time performance at **73.16%**.
- June, July, and December experienced particularly high delayed-arrival volumes.

**Business application:** Identify periods of elevated disruption and support operational performance reviews and resource-planning discussions.

---

## 3. Operational Intelligence Dashboard

![Delta Operational Intelligence](powerBI/screenshots/02-Operational_Intelligence.png)

The Operational Intelligence dashboard investigates performance differences across airports, directional routes, operating carriers, and reported delay categories.

### Analysis Performed

- Airport-level delay volume and rate comparisons
- Route-level operational performance analysis
- Operating-carrier delay comparisons
- Delay-cause contribution analysis
- Seasonal and monthly disruption patterns
- Minimum-volume thresholds for meaningful comparisons
- Operational performance concentration analysis

### Selected Findings

**Airport Performance**

Atlanta (ATL) accounted for **46,481 delayed arrivals**, representing approximately **14.94%** of delayed arrivals in the analyzed network.

**Route Performance**

The ATL → MCO route recorded **1,777 delayed arrivals**, placing it among the routes with the highest delay volumes.

**Delay Attribution**

Among reported delay-attribution minutes for qualifying delayed arrivals:

| Delay Category | Share |
|---|---:|
| Carrier | 42.87% |
| Late Aircraft | 28.79% |
| National Aviation System (NAS) | 20.88% |
| Weather | 7.39% |
| Security | 0.07% |

Carrier and Late Aircraft categories jointly represented approximately **71.66%** of reported delay-attribution minutes.

These categories describe reported attribution, not independently established root causes.

**Business application:** Support targeted investigation of high-disruption locations, scheduling windows, and operational processes.

---

## 4. Financial Intelligence Dashboard

![Delta Financial Intelligence](powerBI/screenshots/03-Financial_Intelligence.png)

The Financial Intelligence dashboard analyzes Delta Air Lines' consolidated financial results from 2021 through 2025.

### Financial Analysis Performed

- Operating revenue trends
- Operating expense trends
- Operating income and margin analysis
- Profitability performance comparisons
- Aircraft fuel expense analysis
- Fuel-price benchmarking
- Operating cost composition
- Year-over-year expense variance analysis
- Financial performance reporting

### 2025 Financial Performance

| Financial Metric | FY2025 |
|---|---:|
| Operating Revenue | $63.36B |
| Operating Expenses | $57.54B |
| Operating Income | $5.82B |
| Operating Margin | 9.19% |
| Aircraft Fuel Expense | $9.82B |

### Operating Margin Analysis

Delta's operating margin decreased from:

**9.73% in 2024 → 9.19% in 2025**

This represents a decline of approximately **0.54 percentage points**.

### Operating Expense Variance Analysis

The analysis identified the following changes between 2024 and 2025:

| Expense Category | Change |
|---|---:|
| Aircraft fuel expenses | -$0.75B |
| Salaries and related costs | +$1.36B |
| Other non-fuel operating expenses | +$1.28B |
| **Total operating expense increase** | **+$1.89B** |

### Financial Interpretation

Despite lower aircraft fuel expenses, increases in salaries and other non-fuel operating costs contributed to higher overall operating expenses.

This demonstrates the importance of examining expense composition rather than relying exclusively on total cost movements.

**FP&A application:** Profitability assessment, operating expense analysis, financial performance reporting, and identification of cost drivers for management review.

**Scope note:** Financial results are Delta's consolidated company results. They are not allocated to the domestic flight population analyzed in the operational dashboards.

---

## 5. End-to-End Technical Implementation

This project demonstrates the complete analytical workflow from public-source data to executive reporting.

### Technology Stack

| Technology | Application |
|---|---|
| Python | Data preparation, cleaning, transformation, validation |
| Pandas & NumPy | Data processing and analytical transformations |
| PostgreSQL | Relational database storage |
| SQL | Data quality checks, aggregation, analysis, reporting views |
| Power BI | Interactive dashboards and executive reporting |
| DAX | KPI calculations and analytical measures |
| Excel / CSV | Structured data exchange with Power BI Online |
| Git & GitHub | Version control and project documentation |

### Analytical Architecture

```text
PUBLIC DATA SOURCES
        |
        v
Bureau of Transportation Statistics
Delta Air Lines / SEC Financial Filings
U.S. Energy Information Administration
        |
        v
PYTHON DATA PROCESSING
        |
        |-- Data Cleaning
        |-- Standardization
        |-- Data Validation
        |-- Feature Derivation
        |
        v
POSTGRESQL DATABASE
        |
        |-- Flights
        |-- Financials
        |-- Fuel Prices
        |-- Calendar
        |-- Airports
        |
        v
SQL ANALYTICAL LAYER
        |
        |-- Operational KPI Analysis
        |-- Airport & Route Analysis
        |-- Delay Attribution Analysis
        |-- Financial Performance Analysis
        |-- Expense Variance Analysis
        |
        v
SEVEN REPORTING VIEWS
        |
        v
POWER BI SEMANTIC MODEL
        |
        |-- Reporting Tables
        |-- Date Relationships
        |-- DAX Measures
        |-- Interactive Filters
        |
        v
THREE EXECUTIVE DASHBOARDS
        |
        |-- Executive Overview
        |-- Operational Intelligence
        |-- Financial Intelligence
```

---

## 6. Python Data Preparation & Validation

Python was used to process and standardize the project datasets before database analysis.

### Implemented Work

- Processing large flight datasets in chunks to manage memory usage
- Filtering Delta-marketed domestic flight records
- Standardizing column names and data types
- Preparing dates, schedules, and operational indicators
- Deriving analytical fields such as routes and departure hours
- Handling missing values and identifying anomalies
- Preparing consolidated financial information
- Standardizing monthly fuel-price information
- Validating reporting periods and core operational metrics

### Source Code

- [Flight Data Cleaning](src/clean_flights.py)
- [Financial Data Cleaning](src/clean_financials.py)
- [Fuel Data Cleaning](src/clean_fuel.py)
- [Data Validation](src/validate_data.py)

Large source datasets are intentionally excluded from version control.

---

## 7. PostgreSQL Database & SQL Analytics

The project uses PostgreSQL to organize operational, financial, and fuel-market information for structured analysis.

### Database Components

**Operational and Financial Tables**

- `flights`
- `financials`
- `fuel_prices`

**Supporting Dimension Tables**

- `calendar`
- `airports`

### SQL Work Completed

- Database table definitions
- Calendar and airport dimension creation
- Data-quality analysis
- Operational KPI calculations
- Monthly performance analysis
- Airport and route comparisons
- Delay attribution analysis
- Operating-carrier comparisons
- Financial trend analysis
- Operating cost variance calculations
- Reporting views for Power BI

### SQL Files

| File | Purpose |
|---|---|
| [01_create_tables.sql](sql/01_create_tables.sql) | Core database table definitions |
| [01b_create_dimensions.sql](sql/01b_create_dimensions.sql) | Calendar and airport dimensions |
| [02_data_quality.sql](sql/02_data_quality.sql) | Data-quality analysis |
| [03_analysis.sql](sql/03_analysis.sql) | Operational and financial analytical queries |
| [04_powerbi_views.sql](sql/04_powerbi_views.sql) | Reporting views for Power BI |

**Important:** `01_create_tables.sql` contains `DROP TABLE` statements. It is intended for initial database setup and should not be rerun against a populated database without reviewing its destructive operations.

### Reporting Views

Seven SQL reporting views were developed:

1. `vw_monthly_operations`
2. `vw_airport_monthly_operations`
3. `vw_route_monthly_operations`
4. `vw_monthly_delay_causes`
5. `vw_carrier_monthly_operations`
6. `vw_financial_performance`
7. `vw_fuel_economics`

These views support consistent KPI definitions and structured reporting.

---

## 8. Power BI Data Modeling & Dashboard Engineering

The Power BI reporting solution was developed using Power BI Online.

### Semantic Model

The model contains:

- Seven reporting tables
- A dedicated month dimension
- Relationships supporting monthly analysis
- Financial-year relationships
- DAX calculations for operational and financial KPIs

More than 50 DAX measures were developed or configured across the semantic model, with additional display-oriented measures supporting financial reporting.

### Dashboard Pages

**Page 1 — Executive Overview**

High-level operational KPIs and monthly performance trends.

**Page 2 — Operational Intelligence**

Airport, route, carrier, and delay-cause analysis.

**Page 3 — Financial Intelligence**

Financial trends, expense composition, operating margins, and cost variance analysis.

### Dashboard Validation

Validation activities included:

- Reconciling Power BI KPI results with SQL outputs
- Reviewing numerical precision and display formatting
- Testing month slicer interactions
- Testing financial-year filtering
- Verifying chart calculations and aggregation behavior
- Checking semantic model relationships
- Reviewing cross-page consistency
- Verifying financial cost reconciliations

The report is based on historical data and is not a live operational monitoring system.

---

## 9. Business Insights & Decision Support

The analysis was designed to translate data into business questions relevant to different stakeholders.

| Stakeholder | Decision-Support Application |
|---|---|
| Executive Leadership | Monitor overall operational and financial performance |
| Airport Operations | Investigate locations with elevated disruption rates |
| Network Planning | Examine route and departure-time performance |
| Finance / FP&A | Analyze profitability, expense composition, and cost variances |
| Business Intelligence Teams | Standardize KPIs and deliver interactive reporting |

### Potential Management Applications

**Operational**

- Investigate airport and route disruption concentrations.
- Review scheduling windows associated with elevated delay rates.
- Compare carrier performance while accounting for different operating profiles.
- Monitor seasonal changes in operational reliability.

**Financial**

- Track operating margins and profitability trends.
- Evaluate fuel and non-fuel expense movements.
- Identify material changes in expense composition.
- Support financial planning discussions with historical performance evidence.

These represent analytical applications and investigation priorities, not proven savings opportunities.

---

## 10. Data Sources

All datasets were obtained from publicly available sources.

### Operational Data

**U.S. Department of Transportation — Bureau of Transportation Statistics**

Marketing Carrier On-Time Performance data, January–December 2025.

https://www.transtats.bts.gov/Marketing_Annual.aspx

### Financial Data

**Delta Air Lines / U.S. Securities and Exchange Commission**

Delta consolidated annual financial statements and operating statistics, 2021–2025.

https://ir.delta.com/

https://www.sec.gov/edgar/browse/?CIK=27904

### Fuel Market Data

**U.S. Energy Information Administration**

U.S. Gulf Coast Kerosene-Type Jet Fuel Spot Price FOB, monthly observations from 2021–2025.

https://www.eia.gov/dnav/pet/hist/eer_epjk_pf4_rgc_dpgM.htm

Detailed source information is available in the [Data Source Register](docs/source_register.md).

---

## 11. Data Quality, Interpretation & Limitations

### Data Quality

The analysis included checks covering:

- Source and retained record counts
- Date coverage
- Missing operational values
- Cancellation and diversion treatment
- Delay classification
- Airport and route coverage
- Financial reporting units
- Fuel-price period completeness
- Cross-system KPI reconciliation

### Analytical Limitations

**Different populations**

Operational data covers Delta-marketed domestic flights during 2025, including flights operated by regional partners.

Financial reporting covers Delta Air Lines' consolidated company performance from 2021–2025.

Consequently, operational findings cannot be used to directly allocate consolidated revenue, expenses, or profitability to individual flights or routes.

**Delay attribution**

Reported delay categories reflect source-system attribution and should not be interpreted as independently established root causes. Attribution patterns may also differ across operating carriers.

**Fuel benchmark**

EIA jet-fuel spot prices are external market benchmarks and should not be treated as identical to Delta's realized fuel purchase prices.

**Historical analysis**

The dashboards describe historical performance. They do not establish causal relationships or predict future flight disruptions.

---

## 12. Repository Structure

```text
Delta-Operational-Intelligence/
|
|-- README.md
|-- requirements.txt
|
|-- src/
|   |-- clean_flights.py
|   |-- clean_financials.py
|   |-- clean_fuel.py
|   |-- validate_data.py
|
|-- sql/
|   |-- 01_create_tables.sql
|   |-- 01b_create_dimensions.sql
|   |-- 02_data_quality.sql
|   |-- 03_analysis.sql
|   |-- 04_powerbi_views.sql
|
|-- docs/
|   |-- project_charter.md
|   |-- source_register.md
|   |-- data_dictionary.md
|   |-- methodology.md
|   |-- validation_report.md
|   |-- business_analysis_case.md
|
|-- powerBI/
|   |-- screenshots/
|   |   |-- 01-Executive_Overview.png
|   |   |-- 02-Operational_Intelligence.png
|   |   |-- 03-Financial_Intelligence.png
|   |
|   |-- Reporting CSV exports
|   |-- Power BI reporting data workbook
|
|-- data/
|   |-- raw/          # Source datasets stored locally
|   |-- processed/    # Analysis-ready datasets
|
|-- notebooks/
|
|-- outputs/
|
|-- .gitignore
```

Some documentation and notebooks are being updated as the portfolio is finalized. Large flight-level datasets are not included in the public repository.

---

## 13. Planned Extensions

### Predictive Flight Delay Intelligence

Develop and evaluate a model estimating the probability of a flight arriving at least 15 minutes late using information available before departure.

Planned work includes:

- Feature engineering
- Chronological training and testing
- Baseline and machine learning model comparisons
- Predictive performance evaluation
- Model explainability
- Risk segmentation
- Power BI integration

**Status: Not yet implemented.**

### Business Analysis Improvement Case

Develop a structured business improvement proposal based on validated operational findings.

Planned deliverables include:

- Problem statement
- Stakeholder analysis
- Process assessment
- Business requirements
- Proposed interventions
- KPIs and acceptance criteria
- Implementation considerations

**Status: Not yet implemented.**

---

## 14. Skills Demonstrated

### Data Analytics & Engineering

Python · Pandas · SQL · PostgreSQL · Data Cleaning · Data Validation · Data Transformation · Data Modeling · Analytical Query Development

### Business Intelligence

Microsoft Power BI · DAX · Semantic Modeling · Dashboard Development · KPI Reporting · Data Visualization · Executive Reporting

### Financial Analysis & FP&A

Financial Statement Analysis · Profitability Analysis · Financial Performance Analysis · Operating Expense Analysis · Expense Variance Analysis · Fuel Economics · Business Performance Reporting

### Business Analysis

Problem Identification · Operational Performance Analysis · KPI Definition · Stakeholder-Oriented Reporting · Evidence-Based Decision Support

---

## About the Author

**Aamir Sohaib**

FP&A & Data Analytics | SQL · Python · Power BI | Financial Analysis & Business Intelligence

ACCA Affiliate | MS in Business Analytics Candidate, Kent State University

[Connect on LinkedIn](https://www.linkedin.com/in/aamir-sohaib-706889104/)

---

*Independent portfolio case study. All company names and financial figures are used for educational and analytical purposes. No affiliation with Delta Air Lines is implied.*