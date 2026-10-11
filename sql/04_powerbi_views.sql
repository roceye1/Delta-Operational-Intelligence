-- ===================================================
-- PHASE 4: POWER BI REPORTING VIEWS
-- VIEW 01: MONTHLY OPERATIONAL PERFORMANCE
-- ===================================================

CREATE OR REPLACE VIEW vw_monthly_operations AS

SELECT
    DATE_TRUNC('month', flight_date)::DATE
        AS month_start,

    COUNT(*) AS total_flights,

    COUNT(*) FILTER (
        WHERE cancelled = 0
          AND diverted = 0
          AND arrival_delay IS NOT NULL
    ) AS eligible_arrivals,

    COUNT(*) FILTER (
        WHERE cancelled = 0
          AND diverted = 0
          AND arrival_delay >= 15
    ) AS delayed_arrivals,

    COUNT(*) FILTER (
        WHERE cancelled = 1
    ) AS cancelled_flights,

    COUNT(*) FILTER (
        WHERE diverted = 1
    ) AS diverted_flights

FROM flights

GROUP BY DATE_TRUNC('month', flight_date)::DATE;


-- Verify the reporting view

SELECT *
FROM vw_monthly_operations
ORDER BY month_start;

-- ===================================================
-- POWER BI VIEW 02: AIRPORT MONTHLY PERFORMANCE
-- Delta Air Lines | 2025
-- ===================================================

CREATE OR REPLACE VIEW vw_airport_monthly_operations AS

SELECT
    DATE_TRUNC('month', f.flight_date)::DATE AS month_start,

    f.destination AS airport_code,
    a.city,
    a.state,

    COUNT(*) AS total_flights,

    COUNT(*) FILTER (
        WHERE f.cancelled = 0
          AND f.diverted = 0
          AND f.arrival_delay IS NOT NULL
    ) AS eligible_arrivals,

    COUNT(*) FILTER (
        WHERE f.cancelled = 0
          AND f.diverted = 0
          AND f.arrival_delay >= 15
    ) AS delayed_arrivals,

    COUNT(*) FILTER (
        WHERE f.cancelled = 1
    ) AS cancelled_flights,

    COUNT(*) FILTER (
        WHERE f.diverted = 1
    ) AS diverted_flights

FROM flights f

LEFT JOIN airports a
    ON f.destination = a.airport_code

GROUP BY
    DATE_TRUNC('month', f.flight_date)::DATE,
    f.destination,
    a.city,
    a.state;


-- ===================================================
-- VERIFY THE VIEW
-- ===================================================

SELECT
    COUNT(*) AS airport_month_records,
    SUM(total_flights) AS total_flights,
    SUM(delayed_arrivals) AS delayed_arrivals

FROM vw_airport_monthly_operations;

-- ===================================================
-- VIEW 02 VALIDATION RESULTS
-- ===================================================
-- Airport-month combinations: 2,520
-- Total flights: 1,626,898
-- Delayed arrivals: 311,211
--
-- VALIDATION STATUS: PASSED
-- Aggregated totals reconcile with the flights table.
--
-- PURPOSE:
-- Support airport-level and monthly operational
-- performance analysis in Power BI.

-- ===================================================
-- POWER BI VIEW 03: ROUTE MONTHLY PERFORMANCE
-- Delta Air Lines | 2025
-- ===================================================

CREATE OR REPLACE VIEW vw_route_monthly_operations AS

SELECT
    DATE_TRUNC('month', flight_date)::DATE
        AS month_start,

    origin,
    destination,

    origin || ' → ' || destination AS route,

    COUNT(*) AS total_flights,

    COUNT(*) FILTER (
        WHERE cancelled = 0
          AND diverted = 0
          AND arrival_delay IS NOT NULL
    ) AS eligible_arrivals,

    COUNT(*) FILTER (
        WHERE cancelled = 0
          AND diverted = 0
          AND arrival_delay >= 15
    ) AS delayed_arrivals,

    COUNT(*) FILTER (
        WHERE cancelled = 1
    ) AS cancelled_flights,

    COUNT(*) FILTER (
        WHERE diverted = 1
    ) AS diverted_flights

FROM flights

GROUP BY
    DATE_TRUNC('month', flight_date)::DATE,
    origin,
    destination;


-- ===================================================
-- VERIFY THE VIEW
-- ===================================================

SELECT
    COUNT(*) AS route_month_records,

    SUM(total_flights) AS total_flights,

    SUM(delayed_arrivals) AS delayed_arrivals,

    SUM(cancelled_flights) AS cancelled_flights

FROM vw_route_monthly_operations;

-- ===================================================
-- VIEW 03 VALIDATION RESULTS
-- ===================================================
-- Route-month combinations: 17,143
-- Total flights: 1,626,898
-- Delayed arrivals: 311,211
-- Cancelled flights: 22,207
--
-- VALIDATION STATUS: PASSED
-- Aggregated totals reconcile with the flights table.
--
-- PURPOSE:
-- Support route-level operational analysis,
-- monthly performance comparisons, and
-- directional route comparisons in Power BI.
--
-- NOTE:
-- ATL -> MCO and MCO -> ATL are treated
-- as separate routes.

-- ===================================================
-- POWER BI VIEW 04: MONTHLY DELAY CAUSES
-- Delta Air Lines | 2025
-- ===================================================

CREATE OR REPLACE VIEW vw_monthly_delay_causes AS

SELECT
    DATE_TRUNC('month', f.flight_date)::DATE
        AS month_start,

    reasons.cause AS delay_cause,

    SUM(
        COALESCE(reasons.minutes, 0)
    ) AS attributed_delay_minutes,

    COUNT(*) FILTER (
        WHERE reasons.minutes > 0
    ) AS flights_with_reported_cause

FROM flights f

CROSS JOIN LATERAL (
    VALUES
        ('Carrier', f.carrier_delay_minutes),
        ('Weather', f.weather_delay_minutes),
        ('NAS', f.nas_delay_minutes),
        ('Security', f.security_delay_minutes),
        ('Late Aircraft', f.late_aircraft_delay_minutes)
) AS reasons(cause, minutes)

WHERE f.cancelled = 0
  AND f.diverted = 0
  AND f.arrival_delay >= 15

GROUP BY
    DATE_TRUNC('month', f.flight_date)::DATE,
    reasons.cause;


-- ===================================================
-- VERIFY THE VIEW
-- ===================================================

SELECT
    COUNT(*) AS total_records,

    COUNT(DISTINCT month_start) AS months,

    COUNT(DISTINCT delay_cause) AS delay_categories,

    SUM(attributed_delay_minutes)
        AS total_attributed_delay_minutes

FROM vw_monthly_delay_causes;

-- ===================================================
-- VIEW 04 VALIDATION RESULTS
-- ===================================================
-- Monthly delay cause records: 60
-- Months: 12
-- Delay categories: 5
-- Total attributed minutes: 23,717,749
--
-- VALIDATION STATUS: PASSED
-- Total delay minutes reconcile with Analysis 03.
--
-- PURPOSE:
-- Support monthly delay-cause comparisons,
-- seasonal disruption analysis, and
-- delay attribution visualizations.
--
-- DATA QUALITY NOTE:
-- SkyWest (OO) has an unusual late-aircraft
-- attribution pattern identified in Analysis 09.
--
-- LIMITATION:
-- Reported delay categories are not proof
-- of underlying root causes.

-- ===================================================
-- POWER BI VIEW 05: OPERATING CARRIER PERFORMANCE
-- Delta Air Lines | 2025
-- ===================================================

CREATE OR REPLACE VIEW vw_carrier_monthly_operations AS

SELECT
    DATE_TRUNC('month', flight_date)::DATE
        AS month_start,

    operating_carrier,

    COUNT(*) AS total_flights,

    COUNT(*) FILTER (
        WHERE cancelled = 0
          AND diverted = 0
          AND arrival_delay IS NOT NULL
    ) AS eligible_arrivals,

    COUNT(*) FILTER (
        WHERE cancelled = 0
          AND diverted = 0
          AND arrival_delay >= 15
    ) AS delayed_arrivals,

    COUNT(*) FILTER (
        WHERE cancelled = 1
    ) AS cancelled_flights,

    COUNT(*) FILTER (
        WHERE diverted = 1
    ) AS diverted_flights,

    COALESCE(
        SUM(late_aircraft_delay_minutes) FILTER (
            WHERE cancelled = 0
              AND diverted = 0
              AND arrival_delay >= 15
        ), 0
    ) AS late_aircraft_delay_minutes

FROM flights

GROUP BY
    DATE_TRUNC('month', flight_date)::DATE,
    operating_carrier;


-- ===================================================
-- VERIFY THE VIEW
-- ===================================================

SELECT
    COUNT(*) AS carrier_month_records,

    COUNT(DISTINCT operating_carrier)
        AS operating_carriers,

    SUM(total_flights)
        AS total_flights,

    SUM(eligible_arrivals)
        AS eligible_arrivals,

    SUM(delayed_arrivals)
        AS delayed_arrivals,

    SUM(cancelled_flights)
        AS cancelled_flights,

    SUM(late_aircraft_delay_minutes)
        AS late_aircraft_delay_minutes

FROM vw_carrier_monthly_operations;

-- ===================================================
-- VIEW 05 VALIDATION RESULTS
-- ===================================================
-- Carrier-month combinations: 48
-- Operating carriers: 4
-- Total flights: 1,626,898
-- Eligible arrivals: 1,600,753
-- Delayed arrivals: 311,211
-- Cancelled flights: 22,207
-- Late-aircraft delay minutes: 6,828,778
--
-- VALIDATION STATUS: PASSED
-- All seven checks matched expected results.
--
-- PURPOSE:
-- Support operating-carrier benchmarking,
-- monthly performance comparisons, and
-- operational risk analysis in Power BI.
--
-- DATA QUALITY NOTE:
-- SkyWest reported unusually low late-aircraft
-- delay attribution despite substantial
-- arrival delays.
--
-- LIMITATION:
-- Carrier comparisons are not adjusted
-- for differences in routes, schedules,
-- airports, or seasonal exposure.

-- ===================================================
-- VIEW 06: FINANCIAL PERFORMANCE
-- Delta Air Lines | 2021–2025
-- Financial values in USD millions
-- ===================================================

CREATE OR REPLACE VIEW vw_financial_performance AS

SELECT
    fiscal_year,

    total_operating_revenue_usd_millions
        AS revenue_millions,

    total_operating_expense_usd_millions
        AS operating_expenses_millions,

    operating_income_usd_millions
        AS operating_income_millions,

    net_income_usd_millions
        AS net_income_millions,

    operating_margin_pct,

    fuel_expense_usd_millions
        AS fuel_expenses_millions,

    salaries_related_costs_usd_millions
        AS salary_expenses_millions,

    total_operating_expense_usd_millions
        - fuel_expense_usd_millions
        AS non_fuel_expenses_millions,

    total_operating_expense_usd_millions
        - fuel_expense_usd_millions
        - salaries_related_costs_usd_millions
        AS other_non_fuel_expenses_millions,

    operating_cash_flow_usd_millions
        AS operating_cash_flow_millions,

    ROUND(
        100.0 * fuel_expense_usd_millions
        / NULLIF(total_operating_expense_usd_millions, 0),
        2
    ) AS fuel_share_of_expenses_pct,

    ROUND(
        100.0 * (
            total_operating_revenue_usd_millions
            - LAG(total_operating_revenue_usd_millions)
              OVER (ORDER BY fiscal_year)
        )
        / NULLIF(
            LAG(total_operating_revenue_usd_millions)
              OVER (ORDER BY fiscal_year),
            0
        ),
        2
    ) AS revenue_growth_yoy_pct

FROM financials;


-- ===================================================
-- VIEW 06: VALIDATION QUERY
-- ===================================================

SELECT
    COUNT(*) AS financial_records,
    MIN(fiscal_year) AS first_year,
    MAX(fiscal_year) AS last_year,

    MAX(revenue_millions) FILTER (
        WHERE fiscal_year = 2025
    ) AS revenue_2025,

    MAX(operating_income_millions) FILTER (
        WHERE fiscal_year = 2025
    ) AS operating_income_2025,

    MAX(fuel_expenses_millions) FILTER (
        WHERE fiscal_year = 2025
    ) AS fuel_expenses_2025

FROM vw_financial_performance;


-- ===================================================
-- VIEW 06: VALIDATION RESULTS
-- ===================================================
-- Financial records: 5
-- First year: 2021
-- Last year: 2025
--
-- 2025 VERIFIED FIGURES (USD MILLIONS):
-- Operating Revenue: 63,364
-- Operating Income:   5,822
-- Fuel Expenses:      9,819
--
-- VALIDATION STATUS: PASSED
--
-- PURPOSE:
-- Support financial performance reporting,
-- profitability trends, operating cost analysis,
-- and year-over-year comparisons in Power BI.
--
-- IMPORTANT LIMITATION:
-- Financial figures represent consolidated
-- Delta Air Lines operations.
-- They must not be attributed directly to
-- individual domestic flights, airports, or routes.

-- ===================================================
-- POWER BI VIEW 07: FUEL ECONOMICS
-- Delta Air Lines | 2021–2025
-- ===================================================

CREATE OR REPLACE VIEW vw_fuel_economics AS

WITH annual_eia AS (

    SELECT
        EXTRACT(YEAR FROM month)::INTEGER AS fiscal_year,

        COUNT(*) AS months_available,

        ROUND(
            AVG(jet_fuel_price_usd_per_gallon), 3
        ) AS eia_avg_spot_price

    FROM fuel_prices

    GROUP BY EXTRACT(YEAR FROM month)
),

fuel_data AS (

    SELECT
        f.fiscal_year,

        e.months_available,

        f.fuel_gallons_consumed_millions
            AS gallons_consumed_millions,

        f.average_fuel_price_usd_per_gallon
            AS delta_avg_fuel_price,

        e.eia_avg_spot_price,

        f.fuel_expense_usd_millions
            AS fuel_expense_millions

    FROM financials f

    LEFT JOIN annual_eia e
        ON f.fiscal_year = e.fiscal_year
)

SELECT
    fiscal_year,
    months_available,
    gallons_consumed_millions,
    delta_avg_fuel_price,
    eia_avg_spot_price,
    fuel_expense_millions,

    ROUND(
        100.0 * (
            gallons_consumed_millions
            - LAG(gallons_consumed_millions)
                OVER (ORDER BY fiscal_year)
        )
        / NULLIF(
            LAG(gallons_consumed_millions)
                OVER (ORDER BY fiscal_year), 0
        ), 2
    ) AS consumption_growth_yoy_pct,

    ROUND(
        100.0 * (
            delta_avg_fuel_price
            - LAG(delta_avg_fuel_price)
                OVER (ORDER BY fiscal_year)
        )
        / NULLIF(
            LAG(delta_avg_fuel_price)
                OVER (ORDER BY fiscal_year), 0
        ), 2
    ) AS fuel_price_change_yoy_pct,

    ROUND(
        100.0 * (
            fuel_expense_millions
            - LAG(fuel_expense_millions)
                OVER (ORDER BY fiscal_year)
        )
        / NULLIF(
            LAG(fuel_expense_millions)
                OVER (ORDER BY fiscal_year), 0
        ), 2
    ) AS fuel_expense_change_yoy_pct

FROM fuel_data;


-- ===================================================
-- VERIFY VIEW 07
-- ===================================================

SELECT
    COUNT(*) AS total_records,

    MIN(fiscal_year) AS first_year,

    MAX(fiscal_year) AS last_year,

    SUM(months_available) AS eia_months,

    MAX(gallons_consumed_millions) FILTER (
        WHERE fiscal_year = 2025
    ) AS fuel_gallons_2025,

    MAX(fuel_expense_millions) FILTER (
        WHERE fiscal_year = 2025
    ) AS fuel_expenses_2025

FROM vw_fuel_economics;

-- ===================================================
-- VIEW 07 VALIDATION RESULTS
-- ===================================================
-- Financial records: 5
-- Coverage: 2021-2025
-- EIA monthly observations: 60
--
-- 2025 VERIFIED FIGURES:
-- Fuel consumption: 4,269 million gallons
-- Fuel expenses: $9,819 million
--
-- VALIDATION STATUS: PASSED
-- All six checks matched expected results.
--
-- PURPOSE:
-- Support fuel consumption analysis,
-- annual fuel expense comparisons,
-- market fuel-price trends, and
-- year-over-year fuel economics.
--
-- IMPORTANT LIMITATIONS:
-- EIA spot prices are external market benchmarks,
-- not Delta's actual purchase prices.
--
-- Financial data represents consolidated
-- Delta Air Lines operations.
