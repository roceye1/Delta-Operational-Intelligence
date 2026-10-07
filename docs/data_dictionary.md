# Data Dictionary

> **Status:** Financial schema confirmed. Flight, airport, fuel-price, and calendar fields will be finalized after raw source inspection and cleaning.

## Planned Table: `flights`

| Field | Description | Planned Type | Source / Derivation |
|---|---|---|---|
| flight_date | Calendar date of flight | date | BTS |
| marketing_carrier | Marketing carrier code | text | BTS |
| operating_carrier | Operating carrier code | text | BTS |
| flight_number | Marketing flight number | text/integer | BTS |
| origin | Origin airport IATA code | text | BTS |
| destination | Destination airport IATA code | text | BTS |
| scheduled_departure | Scheduled local departure time | time / integer | BTS |
| actual_departure | Actual local departure time | time / integer | BTS |
| scheduled_arrival | Scheduled local arrival time | time / integer | BTS |
| actual_arrival | Actual local arrival time | time / integer | BTS |
| departure_delay_minutes | Departure delay in minutes | numeric | BTS |
| arrival_delay_minutes | Arrival delay in minutes | numeric | BTS |
| cancelled | Cancellation indicator | boolean | BTS |
| cancellation_code | BTS cancellation reason code | text | BTS |
| diverted | Diversion indicator | boolean | BTS |
| distance_miles | Scheduled flight distance | numeric | BTS |
| carrier_delay_minutes | Carrier-attributed delay minutes | numeric | BTS |
| weather_delay_minutes | Weather-attributed delay minutes | numeric | BTS |
| nas_delay_minutes | National Air System delay minutes | numeric | BTS |
| security_delay_minutes | Security-attributed delay minutes | numeric | BTS |
| late_aircraft_delay_minutes | Late-arriving-aircraft delay minutes | numeric | BTS |
| arrival_delayed_15 | 1 when eligible arrival delay is >=15 minutes | boolean | Calculated |
| departure_hour | Scheduled departure hour | integer | Calculated |
| day_of_week | Day name or number | text/integer | Calculated |
| month | Month number/name | integer/text | Calculated |
| route | Origin-destination pair (e.g. ATL-LGA) | text | Calculated |
| distance_band | Grouped flight-distance category | text | Calculated |
| delay_category | Analytical delay-severity category | text | Calculated |

## Planned Table: `airports`

| Field | Description | Planned Type |
|---|---|---|
| airport_code | IATA airport code | text |
| airport_name | Airport name | text |
| city | Airport city/market | text |
| state | U.S. state/territory | text |
| latitude | Latitude, if available from approved source | numeric |
| longitude | Longitude, if available from approved source | numeric |

## Confirmed Table: `financials`

Cleaned file: `data/processed/financials_clean.csv`

| Field | Description | Type | Source |
|---|---|---|---|
| fiscal_year | Delta fiscal year | integer | Delta / SEC |
| passenger_revenue_usd_millions | Reported passenger revenue | numeric | Delta / SEC |
| total_operating_revenue_usd_millions | Reported total operating revenue | numeric | Delta / SEC |
| total_operating_expense_usd_millions | Reported total operating expense | numeric | Delta / SEC |
| salaries_related_costs_usd_millions | Reported salaries and related costs | numeric | Delta / SEC |
| fuel_expense_usd_millions | Reported aircraft fuel and related tax expense | numeric | Delta / SEC |
| operating_income_usd_millions | Reported operating income | numeric | Delta / SEC |
| net_income_usd_millions | Reported net income | numeric | Delta / SEC |
| operating_cash_flow_usd_millions | Net cash provided by operating activities | numeric | Delta / SEC |
| operating_margin_pct | Operating income / total operating revenue × 100 | numeric | Calculated |
| rpm_millions | Revenue passenger miles | numeric | Delta / SEC operating statistics |
| asm_millions | Available seat miles | numeric | Delta / SEC operating statistics |
| passenger_load_factor_pct | Passenger load factor | numeric | Delta / SEC operating statistics |
| fuel_gallons_consumed_millions | Fuel gallons consumed | numeric | Delta / SEC operating statistics |
| average_fuel_price_usd_per_gallon | Reported average price per fuel gallon | numeric | Delta / SEC operating statistics |
| source_financials_10k_year | 10-K used for financial-statement values | integer | Data lineage |
| source_operating_stats_10k_year | 10-K used for operating-statistics values | integer | Data lineage |

## Planned Table: `fuel_prices`

| Field | Description | Planned Type | Source |
|---|---|---|---|
| month | Observation month | date | EIA |
| jet_fuel_price_usd_per_gallon | U.S. Gulf Coast kerosene-type jet-fuel spot price FOB | numeric | EIA |

## Planned Table: `calendar`

| Field | Description | Planned Type |
|---|---|---|
| date | Calendar date | date |
| year | Calendar year | integer |
| quarter | Calendar quarter | integer |
| month_number | Month number | integer |
| month_name | Month name | text |
| day_of_week_number | Day-of-week number | integer |
| day_of_week_name | Day-of-week name | text |
| is_weekend | Weekend indicator | boolean |

## KPI Definitions

### On-Time Arrival Rate
Eligible completed flights arriving less than 15 minutes after scheduled arrival divided by eligible completed flights.

### Arrival Delay Rate
Eligible completed flights arriving 15 minutes or more after scheduled arrival divided by eligible completed flights.

### Cancellation Rate
Cancelled scheduled flights divided by scheduled flights.

### Diversion Rate
Diverted scheduled flights divided by scheduled flights.

### Average Arrival Delay
Mean arrival-delay minutes among completed flights. A separate measure will be calculated only for flights delayed at least 15 minutes.

### Delay Minutes per 100 Flights
Total relevant delay minutes divided by scheduled flights, multiplied by 100.

## Notes
- Cancelled and diverted records require explicit treatment when calculating arrival metrics.
- Exact BTS field names will be mapped to these standardized analytical names during cleaning.
- Financial values are consolidated Delta Air Lines values and are not route-level profitability measures.
