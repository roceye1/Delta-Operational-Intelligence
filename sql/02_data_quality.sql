SELECT
    COUNT(*) AS total_flights,

    COUNT(*) FILTER (
        WHERE flight_date IS NULL
    ) AS missing_dates,

    COUNT(*) FILTER (
        WHERE origin IS NULL OR destination IS NULL
    ) AS missing_airport_codes,

    COUNT(*) FILTER (
        WHERE marketing_carrier IS DISTINCT FROM 'DL'
    ) AS non_delta_flights,

    COUNT(*) FILTER (
        WHERE cancelled NOT IN (0, 1)
           OR cancelled IS NULL
    ) AS invalid_cancellation_flags,

    COUNT(*) FILTER (
        WHERE cancelled = 0
          AND diverted = 0
          AND arrival_delay IS NULL
    ) AS missing_arrival_delays

FROM flights;
-- DATA QUALITY VALIDATION RESULTS
-- Total Delta-marketed flights: 1,626,898
-- Missing flight dates: 0
-- Missing airport codes: 0
-- Non-Delta flights: 0
-- Invalid cancellation flags: 0
-- Missing arrival delays: 1
--
-- Decision:
-- Retain the record with missing arrival delay.
-- Exclude it from arrival-delay KPI calculations.
-- Dataset: 2025 Delta-marketed domestic flights.
