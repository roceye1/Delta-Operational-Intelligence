-- Create Calendar Table

CREATE TABLE IF NOT EXISTS calendar (
    date DATE PRIMARY KEY,
    year INTEGER,
    quarter INTEGER,
    month_number INTEGER,
    month_name VARCHAR(20),
    day_of_week_number INTEGER,
    day_of_week_name VARCHAR(20),
    is_weekend BOOLEAN
);

-- Generate calendar data: 2021–2025

INSERT INTO calendar
SELECT
    date_series::DATE,
    EXTRACT(YEAR FROM date_series),
    EXTRACT(QUARTER FROM date_series),
    EXTRACT(MONTH FROM date_series),
    TRIM(TO_CHAR(date_series, 'Month')),
    EXTRACT(ISODOW FROM date_series),
    TRIM(TO_CHAR(date_series, 'Day')),
    EXTRACT(ISODOW FROM date_series) IN (6, 7)

FROM generate_series(
    '2021-01-01'::DATE,
    '2025-12-31'::DATE,
    '1 day'::INTERVAL
) AS date_series

ON CONFLICT (date) DO NOTHING;

-- Verify Calendar Table

SELECT
    COUNT(*) AS total_days,
    MIN(date) AS first_date,
    MAX(date) AS last_date
FROM calendar;
-- Create Airports Table

CREATE TABLE IF NOT EXISTS airports (
    airport_code VARCHAR(5) PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(10)
);

-- Extract unique airports from flight data

WITH airport_list AS (

    SELECT
        origin AS airport_code,
        origin_city AS city,
        origin_state AS state
    FROM flights

    UNION ALL

    SELECT
        destination AS airport_code,
        destination_city AS city,
        destination_state AS state
    FROM flights
)

INSERT INTO airports (
    airport_code,
    city,
    state
)

SELECT
    airport_code,
    MAX(city),
    MAX(state)
FROM airport_list
WHERE airport_code IS NOT NULL
GROUP BY airport_code

ON CONFLICT (airport_code) DO NOTHING;

-- Verify Airports Table

SELECT
    COUNT(*) AS total_airports
FROM airports;