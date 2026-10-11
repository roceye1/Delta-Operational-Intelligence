DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS financials;
DROP TABLE IF EXISTS fuel_prices;


CREATE TABLE flights (
    flight_date DATE,

    marketing_carrier VARCHAR(5),
    operating_carrier VARCHAR(5),
    flight_number INTEGER,
    tail_number VARCHAR(20),

    origin VARCHAR(5),
    origin_city VARCHAR(100),
    origin_state VARCHAR(10),

    destination VARCHAR(5),
    destination_city VARCHAR(100),
    destination_state VARCHAR(10),

    scheduled_departure NUMERIC,
    actual_departure NUMERIC,

    departure_delay NUMERIC,
    departure_delay_minutes NUMERIC,
    departure_delayed_15 NUMERIC,

    scheduled_arrival NUMERIC,
    actual_arrival NUMERIC,

    arrival_delay NUMERIC,
    arrival_delay_minutes NUMERIC,
    bts_arrival_delayed_15 NUMERIC,

    cancelled SMALLINT,
    cancellation_code VARCHAR(5),
    diverted SMALLINT,

    scheduled_elapsed_time NUMERIC,
    actual_elapsed_time NUMERIC,
    air_time NUMERIC,

    distance_miles NUMERIC,
    distance_group_bts NUMERIC,

    carrier_delay_minutes NUMERIC,
    weather_delay_minutes NUMERIC,
    nas_delay_minutes NUMERIC,
    security_delay_minutes NUMERIC,
    late_aircraft_delay_minutes NUMERIC,

    year INTEGER,
    month INTEGER,
    month_name VARCHAR(20),

    day_of_week_number INTEGER,
    day_of_week VARCHAR(20),

    route VARCHAR(20),
    departure_hour INTEGER,

    arrival_delayed_15 INTEGER,
    delay_category VARCHAR(30),
    distance_band VARCHAR(30)
);


CREATE TABLE financials (
    fiscal_year INTEGER PRIMARY KEY,

    passenger_revenue_usd_millions NUMERIC,
    total_operating_revenue_usd_millions NUMERIC,
    total_operating_expense_usd_millions NUMERIC,

    salaries_related_costs_usd_millions NUMERIC,
    fuel_expense_usd_millions NUMERIC,

    operating_income_usd_millions NUMERIC,
    net_income_usd_millions NUMERIC,
    operating_cash_flow_usd_millions NUMERIC,

    operating_margin_pct NUMERIC,

    rpm_millions NUMERIC,
    asm_millions NUMERIC,
    passenger_load_factor_pct NUMERIC,

    fuel_gallons_consumed_millions NUMERIC,
    average_fuel_price_usd_per_gallon NUMERIC,

    source_financials_10k_year INTEGER,
    source_operating_stats_10k_year INTEGER
);


CREATE TABLE fuel_prices (
    month DATE PRIMARY KEY,
    jet_fuel_price_usd_per_gallon NUMERIC
);
