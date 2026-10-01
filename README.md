# Delta Air Lines Operational Performance & Delay Intelligence

## Project Overview

This project analyzes Delta Air Lines' operational performance, flight delays, financial performance, and fuel-cost environment using publicly available data.

The goal is to combine SQL, Python, Power BI, predictive analytics, and Business Analysis techniques to identify operational problems and translate them into actionable management insights.

## Central Business Question

**How can Delta improve on-time performance, reduce operational disruption, and protect profitability?**

## Project Scope

### Operational Analysis
- Delta domestic flight operations for **2025**
- Flight delays and cancellations
- Airport performance
- Route performance
- Delay causes
- Monthly, weekday, and departure-time patterns
- Flight-distance patterns
- Delay concentration across airports and routes

### Financial Analysis
- Delta Air Lines financial performance from **2021–2025**
- Operating revenue
- Operating income
- Net income
- Operating margin
- Fuel expense
- Labour / salary expense where consistently reported
- Operating cash flow
- Passenger and capacity metrics where available

### Fuel Analysis
- Monthly U.S. jet-fuel price trends
- Comparison of fuel-market conditions with Delta's reported fuel expenses

### Predictive Analytics
Build a classification model to estimate whether a scheduled flight is at risk of arriving **15 or more minutes late**, using information that could reasonably be known before departure.

### Business Analysis
Use analytical findings to identify one specific operational problem and develop an improvement case containing:

- Root-cause analysis
- AS-IS process
- TO-BE process
- Business requirements
- KPIs
- Acceptance criteria
- Recommended actions
- Expected business benefits

## Key Stakeholders

### Chief Operating Officer
Interested in overall operational reliability, network disruption, delays, cancellations, and opportunities to improve on-time performance.

### VP / Airport Operations Leadership
Interested in identifying airport-level operational bottlenecks, delay concentrations, cancellation patterns, and improvement opportunities.

### Network Planning
Interested in route performance, scheduling patterns, airport congestion, and areas of the network associated with higher operational risk.

### Finance Leadership
Interested in revenue, operating margins, fuel costs, major operating expenses, and the financial context surrounding operational performance.

## Key Performance Indicators

The project will track a focused set of operational and financial KPIs to evaluate Delta's performance and identify areas requiring management attention.

### Operational KPIs

**Total Flights**  
Total number of scheduled Delta domestic flights in the analysis period.

**On-Time Arrival Rate**  
Percentage of eligible completed flights arriving less than 15 minutes after their scheduled arrival time.

**Arrival Delay Rate**  
Percentage of eligible completed flights arriving 15 minutes or more after scheduled arrival.

**Average Arrival Delay**  
Average number of arrival-delay minutes across completed flights.

**Average Delay Among Delayed Flights**  
Average delay minutes calculated only for flights arriving at least 15 minutes late.

**Cancellation Rate**  
Percentage of scheduled flights that were cancelled.

**Diversion Rate**  
Percentage of scheduled flights that were diverted.

**Total Delay Minutes**  
Total accumulated arrival-delay minutes.

**Delay Minutes per 100 Flights**  
Normalized delay measure used to compare airports and routes with different traffic volumes.

**Worst-Performing Airports**  
Airports with the weakest performance based on delay rate, cancellation rate, average delay, and normalized delay minutes.

**Worst-Performing Routes**  
Routes with consistently weak on-time performance after applying minimum-flight-volume thresholds.

### Financial KPIs

**Operating Revenue**  
Delta's reported annual operating revenue.

**Operating Income**  
Delta's reported annual operating income.

**Net Income**  
Delta's reported annual net income.

**Operating Margin**  
Operating income divided by operating revenue.

**Fuel Expense**  
Delta's reported annual aircraft-fuel and related tax expense.

**Operating Cash Flow**  
Cash generated from operating activities.

### Supporting Metrics

The analysis will also examine performance by:

- Month
- Day of week
- Scheduled departure hour
- Origin airport
- Destination airport
- Route
- Flight distance
- Operating carrier
- Delay cause

## Data Sources

This project uses publicly available data from official U.S. government and Delta Air Lines sources.

### 1. Bureau of Transportation Statistics — Flight Operations

**Dataset:** Marketing Carrier On-Time Performance  
**Period used:** January–December 2025  
**Purpose:** Flight-level operational analysis

The dataset contains domestic flight records including:

- Flight date
- Marketing carrier
- Operating carrier
- Flight number
- Origin airport
- Destination airport
- Scheduled departure and arrival times
- Actual departure and arrival times
- Departure and arrival delays
- Cancellations
- Diversions
- Flight distance
- Carrier delay
- Weather delay
- National Air System delay
- Security delay
- Late-arriving aircraft delay

The project will use Delta-marketed flights and retain the operating-carrier field so Delta mainline and regional operations can be distinguished where appropriate.

**Source:** U.S. Department of Transportation — Bureau of Transportation Statistics

---

### 2. Delta Air Lines / SEC — Financial Performance

**Period used:** 2021–2025  
**Purpose:** Financial and business-performance analysis

Financial information will be collected primarily from Delta Air Lines annual Form 10-K filings.

Metrics will include, where consistently reported:

- Operating revenue
- Operating income
- Net income
- Operating margin
- Aircraft fuel expense
- Salaries and related costs
- Operating cash flow
- Passenger revenue
- Revenue passenger miles
- Available seat miles
- Passenger load factor

**Primary sources:** Delta Air Lines Investor Relations and U.S. Securities and Exchange Commission filings

---

### 3. U.S. Energy Information Administration — Jet Fuel Prices

**Dataset:** U.S. Gulf Coast Kerosene-Type Jet Fuel Spot Price FOB  
**Frequency:** Monthly  
**Primary analysis period:** 2021–2025

The dataset provides monthly jet-fuel spot prices measured in U.S. dollars per gallon.

It will be used to provide external fuel-market context and compare fuel-price trends with Delta's reported aircraft-fuel expenses.

**Source:** U.S. Energy Information Administration
