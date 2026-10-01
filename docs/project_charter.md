# Project Charter

## Project
**Delta Air Lines Operational Performance & Delay Intelligence**

## Central Business Question
**How can Delta improve on-time performance, reduce operational disruption, and protect profitability?**

## Purpose
Build a portfolio-grade analytics solution that combines public operational, financial, and fuel-market data to identify where disruption occurs, quantify its scale, predict pre-departure delay risk, and translate findings into a focused Business Analyst improvement case.

## Scope

### Operational
- Delta-marketed U.S. domestic flights
- January 1, 2025 through December 31, 2025
- Delay, cancellation, diversion, airport, route, schedule, distance, and reported delay-cause analysis
- Operating-carrier information retained so Delta mainline and regional/partner operations can be distinguished where appropriate

### Financial
- Delta Air Lines consolidated financial performance
- Fiscal years 2021–2025
- Revenue, operating income, net income, operating margin, fuel expense, salaries/related costs, operating cash flow, and selected passenger/capacity metrics where consistently reported

### Fuel
- Monthly U.S. Gulf Coast kerosene-type jet-fuel spot prices
- 2021–2025

### Predictive Analytics
Classify whether an eligible completed flight will arrive at least 15 minutes late using only information reasonably available before departure.

## Stakeholders
- Chief Operating Officer
- VP / Airport Operations Leadership
- Network Planning
- Finance Leadership

## Objectives
1. Measure Delta's 2025 domestic operational performance.
2. Identify airports, routes, periods, and operating patterns associated with elevated disruption.
3. Analyze the reported causes of delays.
4. Determine whether disruption is concentrated in a relatively small set of locations or routes.
5. Place 2025 operations in the context of Delta's 2021–2025 financial performance and fuel-cost environment.
6. Build and evaluate a flight-delay risk model.
7. Convert one evidence-backed operational issue into a Business Analyst improvement case.
8. Present results in a three-page Power BI dashboard and a reproducible GitHub portfolio.

## Primary KPIs
- Total scheduled flights
- On-time arrival rate
- Arrival delay rate
- Average arrival delay
- Average delay among delayed flights
- Cancellation rate
- Diversion rate
- Total delay minutes
- Delay minutes per 100 flights
- Airport and route performance
- Operating revenue
- Operating income
- Net income
- Operating margin
- Fuel expense
- Operating cash flow

## Out of Scope for MVP
- Real-time data feeds or APIs
- AI chatbot
- Mobile application
- Cloud deployment
- Full competitor analysis
- Customer-level profitability
- Route profitability estimates without reliable route-level financial data
- 2026 partial-year operational analysis
- Claims that 2025 delays directly caused changes in annual financial performance

## Planned Deliverables
- Source register and data dictionary
- Raw and processed data workflow
- Python cleaning and validation scripts
- PostgreSQL database (DuckDB fallback)
- Documented SQL analysis
- Three-page Power BI dashboard
- Delay-risk predictive model
- Business Analyst improvement case
- Executive findings and recommendations
- GitHub-ready README and methodology documentation

## Analytical Principles
- Public information will not be represented as confidential Delta data.
- Reported, calculated, and estimated measures will be clearly distinguished.
- Correlation will not be presented as causation.
- Low-volume routes or airports will not be labelled poor performers without volume thresholds.
- Predictive features will exclude post-flight information to prevent data leakage.
- Findings and recommendations will be added only after validation and analysis.

## Definition of Done
The MVP is complete when the analytical workflow is reproducible, all major datasets have documented sources, SQL queries can be rerun, the Power BI report contains three usable pages, the predictive model has valid holdout evaluation, at least five findings are evidence-backed, and recommendations are explicitly linked to those findings.
