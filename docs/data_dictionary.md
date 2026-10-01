# Data Dictionary

> **Status:** Provisional schema. Exact source column names, data types, null rules, and accepted values will be confirmed after the raw datasets are downloaded and inspected.

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

## Planned Table: `financials`

| Field | Description | Planned Type | Source |
|---|---|---|---|
| fiscal_year | Delta fiscal year | integer | Delta / SEC |
| operating_revenue | Reported operating revenue | numeric | Delta / SEC |
| operating_income | Reported operating income | numeric | Delta / SEC |
| net_income | Reported net income | numeric | Delta / SEC |
| operating_margin | Operating income / operating revenue | numeric | Calculated unless directly reported |
| fuel_expense | Reported aircraft fuel and related tax expense | numeric | Delta / SEC |
| salaries_related | Salaries and related costs where consistently reported | numeric | Delta / SEC |
| operating_cash_flow | Net cash provided by operating activities | numeric | Delta / SEC |
| passenger_revenue | Passenger revenue where consistently reported | numeric | Delta / SEC |
| rpm | Revenue passenger miles where consistently reported | numeric | Delta / SEC |
| asm | Available seat miles where consistently reported | numeric | Delta / SEC |
| load_factor | Passenger load factor where consistently reported | numeric | Delta / SEC |

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
- Final data types and null-handling rules will be documented after source inspection.
