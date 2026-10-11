# Delta Air Lines | Data Dictionary & Database Schema

**Project:** Operational & Financial Intelligence  
**Database:** PostgreSQL  
**Data Preparation:** Python and Pandas  
**Reporting:** SQL, Power BI, DAX  
**Operational Period:** January–December 2025  
**Financial & Fuel Period:** 2021–2025  
**Status:** Implemented analytical schema

---

## 1. Overview

This document describes the implemented analytical database,
its data structures, source fields, derived variables,
relationships, and reporting definitions.

The project integrates three publicly available datasets:

1. Bureau of Transportation Statistics (BTS) flight operations
2. Delta Air Lines consolidated financial disclosures
3. U.S. Energy Information Administration (EIA) fuel prices

Python was used to prepare and standardize the source datasets.

PostgreSQL was used for relational data storage, validation,
SQL analysis, and reporting-view development.

Power BI was used to develop interactive operational and
financial intelligence dashboards.

---

## 2. Database Architecture

The PostgreSQL database is named:

`delta_operations`

It contains five analytical tables:

| Table | Description | Records |
|---|---|---:|
| `flights` | Delta-marketed domestic flight operations | 1,626,898 |
| `financials` | Delta consolidated annual financial results | 5 |
| `fuel_prices` | Monthly U.S. Gulf Coast jet-fuel benchmark | 60 |
| `calendar` | Daily calendar dimension | 1,826 |
| `airports` | Airport reference dimension | 216 |

### Analytical Structure

```text
DELTA OPERATIONS DATABASE
|
|-- flights
|   |-- Flight operations
|   |-- Airports and routes
|   |-- Departure and arrival performance
|   |-- Cancellations and diversions
|   |-- Delay attribution
|
|-- financials
|   |-- Revenue
|   |-- Operating expenses
|   |-- Operating income
|   |-- Profitability
|   |-- Fuel expenditure
|
|-- fuel_prices
|   |-- EIA market fuel prices
|
|-- calendar
|   |-- Dates
|   |-- Months
|   |-- Quarters
|   |-- Weekdays
|
|-- airports
    |-- Airport codes
    |-- Cities
    |-- States
```

The tables support several analytical populations.

Operational reporting covers Delta-marketed domestic flights
in 2025.

Financial reporting covers Delta Air Lines' consolidated
company performance from 2021 through 2025.

These populations are not directly equivalent.

---

# 3. Flights Table

**Table:** `flights`

**Source:** Bureau of Transportation Statistics

**Dataset:** Marketing Carrier On-Time Performance

**Period:** January–December 2025

**Records:** 1,626,898

**Grain:** One reported flight record

The table contains flight schedules, actual operating
performance, airport information, cancellations,
diversions, delay attribution, and analytical features.

## 3.1 Flight Identification

| Column | PostgreSQL Type | Description |
|---|---|---|
| `flight_date` | DATE | Flight operating date |
| `marketing_carrier` | VARCHAR(5) | Marketing carrier code |
| `operating_carrier` | VARCHAR(5) | Carrier operating the flight |
| `flight_number` | INTEGER | Marketing flight number |
| `tail_number` | VARCHAR(20) | Aircraft registration identifier, when reported |

### Marketing Carrier Definition

The operational dataset was filtered to:

`marketing_carrier = 'DL'`

This includes Delta-marketed flights operated by
Delta and qualifying regional operating carriers.

Marketing carrier and operating carrier are retained
as separate analytical fields.

---

## 3.2 Airport and Route Fields

| Column | PostgreSQL Type | Description |
|---|---|---|
| `origin` | VARCHAR(5) | Origin airport code |
| `origin_city` | VARCHAR(100) | Origin city/market |
| `origin_state` | VARCHAR(10) | Origin state |
| `destination` | VARCHAR(5) | Destination airport code |
| `destination_city` | VARCHAR(100) | Destination city/market |
| `destination_state` | VARCHAR(10) | Destination state |
| `route` | VARCHAR(20) | Derived directional origin-destination pair |

### Route Derivation

The Python cleaning script constructs:

```python
df["route"] = (
    df["origin"].astype(str)
    + "-"
    + df["destination"].astype(str)
)
```

Example:

`ATL-MCO`

Routes are directional.

`ATL-MCO` and `MCO-ATL` are considered separate
analytical routes.

The dataset contains 1,685 distinct directional routes.

---

## 3.3 Departure Fields

| Column | PostgreSQL Type | Description |
|---|---|---|
| `scheduled_departure` | NUMERIC | Scheduled departure time in BTS HHMM format |
| `actual_departure` | NUMERIC | Actual departure time in BTS HHMM format |
| `departure_delay` | NUMERIC | Signed departure delay in minutes |
| `departure_delay_minutes` | NUMERIC | Nonnegative departure delay minutes |
| `departure_delayed_15` | NUMERIC | Source-reported departure delay indicator |
| `departure_hour` | INTEGER | Derived scheduled departure hour |

### Scheduled Departure Hour

The Python cleaning script derives:

```python
departure_hour = scheduled_departure // 100
```

BTS may represent midnight as `2400`.

The cleaning logic converts a derived hour of 24 to 0.

This enables departure-time performance analysis.

**Important:** BTS HHMM values are numeric time
representations, not PostgreSQL timestamp values.

---

## 3.4 Arrival Fields

| Column | PostgreSQL Type | Description |
|---|---|---|
| `scheduled_arrival` | NUMERIC | Scheduled arrival time in BTS HHMM format |
| `actual_arrival` | NUMERIC | Actual arrival time in BTS HHMM format |
| `arrival_delay` | NUMERIC | Signed arrival delay in minutes |
| `arrival_delay_minutes` | NUMERIC | Nonnegative arrival delay minutes |
| `bts_arrival_delayed_15` | NUMERIC | Original BTS arrival-delay indicator |
| `arrival_delayed_15` | INTEGER | Derived analytical arrival-delay target |

### Arrival Delay Indicator

The analytical indicator is derived using:

```text
arrival_delayed_15 = 1
```

when an eligible flight arrives at least 15 minutes late.

```text
arrival_delayed_15 = 0
```

when an eligible flight arrives less than 15 minutes late.

The value remains missing when arrival-delay
classification is not applicable or cannot be determined.

### Eligibility Rules

An arrival is eligible when:

```text
cancelled = 0
AND diverted = 0
AND arrival_delay IS NOT NULL
```

### Validated Population

| Metric | Count |
|---|---:|
| Total Flights | 1,626,898 |
| Eligible Arrivals | 1,600,753 |
| Delayed Arrivals (15+ minutes) | 311,211 |

One non-cancelled, non-diverted flight had a missing
arrival-delay value.

It was retained in the operational data but excluded
from arrival-punctuality calculations.

---

## 3.5 Cancellation and Diversion Fields

| Column | PostgreSQL Type | Description |
|---|---|---|
| `cancelled` | SMALLINT | Cancellation flag: 1 = cancelled, 0 = not cancelled |
| `cancellation_code` | VARCHAR(5) | BTS cancellation reason code |
| `diverted` | SMALLINT | Diversion flag: 1 = diverted, 0 = not diverted |

### Validated Results

| Metric | Count | Rate |
|---|---:|---:|
| Cancelled Flights | 22,207 | 1.36% |
| Diverted Flights | 3,937 | 0.24% |

Cancellation and diversion rates use the full
flight-record population as their denominator.

They do not use the eligible-arrival denominator.

---

## 3.6 Flight Duration and Distance

| Column | PostgreSQL Type | Description |
|---|---|---|
| `scheduled_elapsed_time` | NUMERIC | Scheduled elapsed flight time in minutes |
| `actual_elapsed_time` | NUMERIC | Actual elapsed flight time in minutes |
| `air_time` | NUMERIC | Reported airborne time in minutes |
| `distance_miles` | NUMERIC | Flight distance in miles |
| `distance_group_bts` | NUMERIC | Original BTS distance-group classification |
| `distance_band` | VARCHAR(30) | Derived analytical distance category |

### Distance Categories

The Python cleaning script creates:

| Distance Band | Distance Range |
|---|---|
| `<500 miles` | 0–499 miles |
| `500-999 miles` | 500–999 miles |
| `1,000-1,499 miles` | 1,000–1,499 miles |
| `1,500-2,499 miles` | 1,500–2,499 miles |
| `2,500+ miles` | 2,500 miles and above |

These categories support flight-distance comparisons.

---

## 3.7 Delay Attribution Fields

| Column | PostgreSQL Type | Description |
|---|---|---|
| `carrier_delay_minutes` | NUMERIC | BTS carrier-attributed delay minutes |
| `weather_delay_minutes` | NUMERIC | BTS weather-attributed delay minutes |
| `nas_delay_minutes` | NUMERIC | National Air System-attributed delay minutes |
| `security_delay_minutes` | NUMERIC | BTS security-attributed delay minutes |
| `late_aircraft_delay_minutes` | NUMERIC | Late-arriving-aircraft-attributed delay minutes |

### Delay Attribution Interpretation

These fields represent source-reported delay attribution.

They do not independently establish the root cause
of a delay.

Reported attribution patterns may differ across
operating carriers.

The project preserves those differences rather than
assuming that all carriers use identical attribution
patterns.

---

## 3.8 Calendar and Derived Analytical Fields

| Column | PostgreSQL Type | Description |
|---|---|---|
| `year` | INTEGER | Derived flight year |
| `month` | INTEGER | Derived month number |
| `month_name` | VARCHAR(20) | Derived month name |
| `day_of_week_number` | INTEGER | BTS day-of-week number |
| `day_of_week` | VARCHAR(20) | Derived weekday name |
| `delay_category` | VARCHAR(30) | Derived operational outcome/severity category |

### Delay Severity Categories

The Python cleaning script classifies flights as:

| Category | Definition |
|---|---|
| Cancelled | Cancellation indicator equals 1 |
| Diverted | Diversion indicator equals 1 |
| On time / <15 min | Eligible arrival delay below 15 minutes |
| 15-29 min | Arrival delay from 15 to under 30 minutes |
| 30-59 min | Arrival delay from 30 to under 60 minutes |
| 60-119 min | Arrival delay from 60 to under 120 minutes |
| 120+ min | Arrival delay of at least 120 minutes |
| Unknown | No matching classification |

The classification supports operational
performance and delay-severity analysis.

---

# 4. Financials Table

**Table:** `financials`

**Source:** Delta Air Lines / SEC

**Period:** Fiscal years 2021–2025

**Records:** 5

**Grain:** One consolidated financial record per fiscal year

**Primary Key:** `fiscal_year`

### Financial Fields

| Column | PostgreSQL Type | Description |
|---|---|---|
| `fiscal_year` | INTEGER | Reporting fiscal year |
| `passenger_revenue_usd_millions` | NUMERIC | Reported passenger revenue |
| `total_operating_revenue_usd_millions` | NUMERIC | Total operating revenue |
| `total_operating_expense_usd_millions` | NUMERIC | Total operating expenses |
| `salaries_related_costs_usd_millions` | NUMERIC | Salaries and related costs |
| `fuel_expense_usd_millions` | NUMERIC | Aircraft fuel and related taxes |
| `operating_income_usd_millions` | NUMERIC | Operating income |
| `net_income_usd_millions` | NUMERIC | Net income |
| `operating_cash_flow_usd_millions` | NUMERIC | Cash flow from operating activities |
| `operating_margin_pct` | NUMERIC | Calculated operating margin percentage |
| `rpm_millions` | NUMERIC | Revenue passenger miles, in millions |
| `asm_millions` | NUMERIC | Available seat miles, in millions |
| `passenger_load_factor_pct` | NUMERIC | Passenger load factor percentage |
| `fuel_gallons_consumed_millions` | NUMERIC | Fuel consumed, in millions of gallons |
| `average_fuel_price_usd_per_gallon` | NUMERIC | Delta-reported average fuel price per gallon |
| `source_financials_10k_year` | INTEGER | Annual filing used for financial-statement data |
| `source_operating_stats_10k_year` | INTEGER | Annual filing used for operating statistics |

### Financial Units

Most monetary values are recorded in:

**USD millions**

Example:

```text
total_operating_revenue_usd_millions = 63364
```

Represents:

```text
$63,364 million = $63.364 billion
```

The `operating_margin_pct` field stores percentage
points, not a decimal fraction.

For example:

```text
9.19 represents 9.19%
```

### Operating Margin

```text
Operating Margin (%) =
    Operating Income
    / Operating Revenue
    × 100
```

### Source Lineage

The financial cleaning script records the source
10-K year used for each financial and operating
statistics observation.

This supports traceability when different annual
filings are used to assemble the five-year series.

### Important Limitation

Financial figures represent Delta's consolidated
company performance.

They are not direct financial results for the
specific 2025 domestic flight population.

---

# 5. Fuel Prices Table

**Table:** `fuel_prices`

**Source:** U.S. Energy Information Administration

**Series:** U.S. Gulf Coast Kerosene-Type Jet Fuel Spot Price FOB

**Period:** January 2021–December 2025

**Records:** 60

**Grain:** One observation per month

**Primary Key:** `month`

### Fields

| Column | PostgreSQL Type | Description |
|---|---|---|
| `month` | DATE | Reporting month |
| `jet_fuel_price_usd_per_gallon` | NUMERIC | Monthly EIA fuel spot price in USD/gallon |

### Analytical Applications

- Fuel-price trend analysis
- Annual fuel-market benchmarking
- Comparison with Delta-reported fuel information
- Fuel economics reporting

### Limitation

EIA spot prices represent an external market benchmark.

They are not identical to Delta's realized average
fuel purchase price.

---

# 6. Calendar Dimension

**Table:** `calendar`

**Period:** January 1, 2021–December 31, 2025

**Records:** 1,826

**Grain:** One calendar date

**Primary Key:** `date`

### Fields

| Column | PostgreSQL Type | Description |
|---|---|---|
| `date` | DATE | Calendar date |
| `year` | INTEGER | Calendar year |
| `quarter` | INTEGER | Calendar quarter |
| `month_number` | INTEGER | Month number |
| `month_name` | VARCHAR(20) | Month name |
| `day_of_week_number` | INTEGER | ISO weekday number |
| `day_of_week_name` | VARCHAR(20) | Weekday name |
| `is_weekend` | BOOLEAN | Weekend classification |

### Weekend Logic

```text
Saturday = TRUE
Sunday = TRUE
Monday–Friday = FALSE
```

The SQL implementation uses ISO weekday numbering:

Monday = 1  
Sunday = 7

This dimension supports date-oriented analysis.

---

# 7. Airports Dimension

**Table:** `airports`

**Records:** 216

**Grain:** One distinct airport code

**Primary Key:** `airport_code`

### Fields

| Column | PostgreSQL Type | Description |
|---|---|---|
| `airport_code` | VARCHAR(5) | Airport code |
| `city` | VARCHAR(100) | Airport city/market |
| `state` | VARCHAR(10) | State or territory code |

The airport dimension was populated using distinct
origin and destination airport information from
the flight dataset.

### Analytical Applications

- Airport-level reporting
- Destination airport comparisons
- Airport performance benchmarking
- Geographic segmentation

**Note:** The implemented dimension does not contain
airport latitude, longitude, or full airport-name fields.

---

# 8. Keys, Relationships & Data Integrity

## Declared Primary Keys

| Table | Primary Key |
|---|---|
| `financials` | `fiscal_year` |
| `fuel_prices` | `month` |
| `calendar` | `date` |
| `airports` | `airport_code` |
| `flights` | No primary key declared in the current SQL schema |

The analytical SQL joins airport information using
airport codes.

The implemented database scripts do not define
a complete set of enforced foreign-key constraints.

Therefore, analytical joins should not be confused
with database-enforced referential integrity.

## Flight Record Identification

The flight table contains identifiers such as:

- Flight date
- Marketing carrier
- Operating carrier
- Flight number
- Origin
- Destination

However, no formal composite flight primary key
is declared in the current schema.

Duplicate-record investigations should account for
the source dataset's reporting grain.

---

# 9. SQL Reporting Views

Seven reporting views were created to support
Power BI analysis.

**Source File:** `sql/04_powerbi_views.sql`

| SQL View | Grain | Primary Purpose |
|---|---|---|
| `vw_monthly_operations` | Month | Network operational KPIs |
| `vw_airport_monthly_operations` | Airport × Month | Airport performance |
| `vw_route_monthly_operations` | Directional Route × Month | Route analysis |
| `vw_monthly_delay_causes` | Delay Cause × Month | Delay attribution |
| `vw_carrier_monthly_operations` | Carrier × Month | Operating-carrier comparisons |
| `vw_financial_performance` | Fiscal Year | Financial reporting |
| `vw_fuel_economics` | Fiscal Year | Fuel economics |

### Reporting View Record Counts

| View | Records |
|---|---:|
| Monthly Operations | 12 |
| Airport Monthly Operations | 2,520 |
| Route Monthly Operations | 17,143 |
| Monthly Delay Causes | 60 |
| Carrier Monthly Operations | 48 |
| Financial Performance | 5 |
| Fuel Economics | 5 |

### Reporting Design

The reporting views aggregate flight-level
and annual financial information before export
to Power BI Online.

This reduces the volume of data required for
the interactive reporting model.

Operational metrics are aggregated separately
from consolidated financial metrics.

This prevents unsupported flight-level
financial attribution.

---

# 10. Power BI Reporting Tables

The reporting views were imported into
Power BI Online using structured Excel tables.

### Imported Tables

1. `tblMonthlyOperations`
2. `tblAirportMonthlyOperations`
3. `tblRouteMonthlyOperations`
4. `tblMonthlyDelayCauses`
5. `tblCarrierMonthlyOperations`
6. `tblFinancialPerformance`
7. `tblFuelEconomics`

### Calculated Dimension

`DimMonth`

The Power BI month dimension contains the twelve
months of the 2025 operational reporting period.

It is separate from the PostgreSQL `calendar`
table described earlier.

The Power BI model uses `DimMonth` to provide
consistent filtering across five operational tables.

The financial and fuel-economics reporting tables
are related through `fiscal_year`.

Detailed model information is available in:

`powerBI/POWER_BI_TECHNICAL_DOCUMENTATION.md`

---

# 11. KPI & Business Metric Definitions

## 11.1 Total Flights

```text
Total Flights =
    COUNT(All Flight Records)
```

**2025 Result:** 1,626,898

## 11.2 Eligible Arrivals

```text
Eligible Arrivals =
    Flights where:

    cancelled = 0
    AND diverted = 0
    AND arrival_delay IS NOT NULL
```

**2025 Result:** 1,600,753

## 11.3 Delayed Arrivals

```text
Delayed Arrivals =
    Eligible flights with arrival_delay >= 15
```

**2025 Result:** 311,211

## 11.4 On-Time Arrival Rate

```text
On-Time Arrival Rate =
    (Eligible Arrivals - Delayed Arrivals)
    / Eligible Arrivals
    × 100
```

**2025 Result:** 80.56%

## 11.5 Arrival Delay Rate

```text
Arrival Delay Rate =
    Delayed Arrivals
    / Eligible Arrivals
    × 100
```

**2025 Result:** 19.44%

## 11.6 Cancellation Rate

```text
Cancellation Rate =
    Cancelled Flights
    / Total Flights
    × 100
```

**2025 Result:** 1.36%

## 11.7 Diversion Rate

```text
Diversion Rate =
    Diverted Flights
    / Total Flights
    × 100
```

**2025 Result:** 0.24%

## 11.8 Operating Income

```text
Operating Income =
    Operating Revenue - Operating Expenses
```

**FY2025 Result:** $5,822 million

## 11.9 Operating Margin

```text
Operating Margin (%) =
    Operating Income
    / Operating Revenue
    × 100
```

**FY2025 Result:** 9.19%

## 11.10 Expense Variance

```text
Expense Variance =
    Current Period Expense
    - Prior Period Expense
```

The financial analysis separates:

- Fuel expense changes
- Salaries and related cost changes
- Other non-fuel expense changes

These components support FP&A-style
historical expense variance analysis.

---

# 12. Data Quality & Validation Rules

The implemented analytical workflow included checks for:

- Missing flight dates
- Missing airport codes
- Marketing-carrier eligibility
- Cancellation indicators
- Missing arrival-delay values
- Eligible flight populations
- Financial reporting coverage
- Operating margin reconciliation
- Fuel-price coverage
- Monthly reporting completeness
- SQL-to-Power BI KPI consistency

### Documented Exception

One non-cancelled, non-diverted flight was missing
an arrival-delay value.

It remains in the source-aligned operational
population but is excluded from eligible-arrival KPIs.

### Financial Reconciliation

For FY2025:

```text
Operating Revenue = $63,364M
Operating Expenses = $57,542M

Operating Income = $5,822M
```

Reconciliation:

```text
$63,364M - $57,542M = $5,822M
```

### Data Quality Documentation

For detailed results and limitations, see:

[Data Validation Report](validation_report.md)

---

# 13. Analytical Scope & Limitations

### Operational Scope

The `flights` table contains Delta-marketed
domestic flight records for 2025.

It does not represent all worldwide Delta operations.

### Financial Scope

The `financials` table contains consolidated
Delta financial results for 2021–2025.

### Different Reporting Populations

Operational and financial datasets have different
reporting periods and populations.

The project does not allocate consolidated
financial results to individual domestic routes.

### Delay Attribution

Delay-cause fields represent reported BTS
attribution rather than independently verified
operational causes.

### Fuel Economics

EIA prices are external benchmarks rather than
Delta's actual realized purchase prices.

### Historical Analysis

The implemented dashboards provide descriptive
historical analysis.

Predictive flight-delay modeling is a planned
extension and has not yet been completed.

---

# 14. Supporting Technical Files

### Database Schema

[Core Tables](../sql/01_create_tables.sql)

[Dimension Tables](../sql/01b_create_dimensions.sql)

### SQL Analytics

[Data Quality Queries](../sql/02_data_quality.sql)

[Operational & Financial Analysis](../sql/03_analysis.sql)

[Power BI Reporting Views](../sql/04_powerbi_views.sql)

### Python

[Flight Data Preparation](../src/clean_flights.py)

[Financial Data Preparation](../src/clean_financials.py)

[Fuel Data Preparation](../src/clean_fuel.py)

[Data Validation](../src/validate_data.py)

### Power BI

[Power BI Technical Documentation](../powerBI/POWER_BI_TECHNICAL_DOCUMENTATION.md)

---

# 15. Skills Demonstrated

This database and data dictionary demonstrate:

**Database Development**
- PostgreSQL
- SQL
- Relational Data Modeling
- Database Schema Design
- Analytical Views

**Data Engineering**
- Python
- Pandas
- Data Cleaning
- Data Transformation
- Derived Feature Development

**Data Quality**
- Data Validation
- Missing-Value Handling
- KPI Reconciliation
- Documentation
- Data Lineage

**Analytics & Business Intelligence**
- KPI Definition
- Operational Performance Analysis
- Financial Analysis
- Power BI Data Modeling
- Business Intelligence Reporting

---

**Author:** Aamir Sohaib

**Project:** Delta Air Lines | Operational & Financial Intelligence

**Disclaimer:** Independent analysis using publicly
available information. Not affiliated with or endorsed
by Delta Air Lines.