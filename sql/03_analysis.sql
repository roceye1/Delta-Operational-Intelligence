-- DELTA AIR LINES
-- 2025 Operational Performance KPIs

WITH performance AS (
    SELECT
        COUNT(*) AS total_flights,

        COUNT(*) FILTER (
            WHERE cancelled = 1
        ) AS cancelled_flights,

        COUNT(*) FILTER (
            WHERE diverted = 1
        ) AS diverted_flights,

        COUNT(*) FILTER (
            WHERE cancelled = 0
              AND diverted = 0
              AND arrival_delay IS NOT NULL
        ) AS eligible_arrivals,

        COUNT(*) FILTER (
            WHERE cancelled = 0
              AND diverted = 0
              AND arrival_delay >= 15
        ) AS delayed_arrivals

    FROM flights
)

SELECT
    total_flights,
    eligible_arrivals,
    delayed_arrivals,

    ROUND(
        100.0 * (eligible_arrivals - delayed_arrivals)
        / NULLIF(eligible_arrivals, 0), 2
    ) AS on_time_arrival_pct,

    cancelled_flights,

    ROUND(
        100.0 * cancelled_flights
        / NULLIF(total_flights, 0), 2
    ) AS cancellation_rate_pct,

    diverted_flights,

    ROUND(
        100.0 * diverted_flights
        / NULLIF(total_flights, 0), 2
    ) AS diversion_rate_pct

FROM performance;

-- ===================================================
-- BUSINESS FINDING 01: OPERATIONAL PERFORMANCE
-- ===================================================
-- Analysis Period: January–December 2025
-- Dataset: Delta-marketed domestic flights
--
-- Total Flights: 1,626,898
-- On-Time Arrival Rate: 80.56%
-- Delayed Arrivals: 311,211
-- Cancellation Rate: 1.36%
-- Diversion Rate: 0.24%
--
-- Business Interpretation:
-- Approximately 19.44% of eligible completed arrivals
-- experienced delays of 15 minutes or more.
--
-- Next Investigation:
-- Identify monthly trends and seasonal delay patterns.
-- ===================================================
-- BUSINESS FINDING 02: MONTHLY PERFORMANCE
-- ===================================================
-- Dataset: Delta-marketed domestic flights, 2025
--
-- Worst On-Time Performance:
-- December: 73.16%
-- June:     75.19%
-- July:     76.12%
--
-- Best On-Time Performance:
-- September: 87.46%
--
-- Highest Cancellation Rate:
-- January: 2.76%
--
-- Most Delayed Arrivals:
-- December: 34,989
--
-- BUSINESS INTERPRETATION:
-- Operational performance deteriorated notably
-- during June, July, and December.
--
-- September achieved the strongest punctuality
-- and lowest cancellation rate.
--
-- NEXT INVESTIGATION:
-- Examine recorded delay causes to understand
-- the major contributors to disruption.
--
-- IMPORTANT:
-- Seasonal patterns do not establish causation.

-- ===================================================
-- ANALYSIS 03: DELAY CAUSE ANALYSIS
-- Delta Air Lines | 2025
-- ===================================================

WITH delay_causes AS (

    SELECT
        cause,
        SUM(COALESCE(minutes, 0)) AS total_delay_minutes

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

    GROUP BY cause
)

SELECT
    cause,
    total_delay_minutes,

    ROUND(
        total_delay_minutes / 60.0, 0
    ) AS total_delay_hours,

    ROUND(
        100.0 * total_delay_minutes
        / NULLIF(SUM(total_delay_minutes) OVER (), 0),
        2
    ) AS share_of_reported_cause_minutes_pct

FROM delay_causes

ORDER BY total_delay_minutes DESC;

-- ===================================================
-- BUSINESS FINDING 03: DELAY CAUSE ANALYSIS
-- ===================================================
-- Dataset: Delta-marketed domestic flights, 2025
--
-- Reported Delay Minutes by Category:
--
-- Carrier:        42.87%
-- Late Aircraft:  28.79%
-- NAS:            20.88%
-- Weather:         7.39%
-- Security:        0.07%
--
-- KEY BUSINESS FINDING:
-- Carrier and Late Aircraft together account for
-- 71.66% of reported delay-cause minutes.
--
-- BUSINESS IMPLICATION:
-- Investigate airline operational processes,
-- aircraft turnaround performance, and
-- delay propagation across the flight network.
--
-- LIMITATION:
-- Reported categories do not establish root causation.
-- Weather and other disruptions may have indirect effects.
--
-- NEXT ANALYSIS:
-- Compare delay causes during December, June,
-- and July against better-performing months.

-- ===================================================
-- ANALYSIS 04: MONTHLY DELAY CAUSE COMPARISON
-- Delta Air Lines | 2025
-- ===================================================

WITH eligible_flights AS (

    SELECT
        EXTRACT(MONTH FROM flight_date)::INTEGER AS month_number,
        TRIM(TO_CHAR(flight_date, 'Month')) AS month_name,
        arrival_delay,

        COALESCE(carrier_delay_minutes, 0) AS carrier_minutes,
        COALESCE(late_aircraft_delay_minutes, 0) AS late_minutes,
        COALESCE(nas_delay_minutes, 0) AS nas_minutes,
        COALESCE(weather_delay_minutes, 0) AS weather_minutes,
        COALESCE(security_delay_minutes, 0) AS security_minutes

    FROM flights

    WHERE cancelled = 0
      AND diverted = 0
      AND arrival_delay IS NOT NULL
),

monthly AS (

    SELECT
        month_number,
        MIN(month_name) AS month_name,
        COUNT(*) AS eligible_arrivals,

        SUM(carrier_minutes) FILTER (WHERE arrival_delay >= 15)
            AS carrier_minutes,

        SUM(late_minutes) FILTER (WHERE arrival_delay >= 15)
            AS late_minutes,

        SUM(nas_minutes) FILTER (WHERE arrival_delay >= 15)
            AS nas_minutes,

        SUM(weather_minutes) FILTER (WHERE arrival_delay >= 15)
            AS weather_minutes,

        SUM(security_minutes) FILTER (WHERE arrival_delay >= 15)
            AS security_minutes

    FROM eligible_flights

    GROUP BY month_number
),

totals AS (

    SELECT *,
        carrier_minutes + late_minutes + nas_minutes
        + weather_minutes + security_minutes
            AS total_attributed_minutes

    FROM monthly
)

SELECT
    month_name,
    eligible_arrivals,

    ROUND(
        total_attributed_minutes / NULLIF(eligible_arrivals, 0), 2
    ) AS attributed_minutes_per_eligible_arrival,

    ROUND(
        100.0 * carrier_minutes / NULLIF(total_attributed_minutes, 0), 2
    ) AS carrier_pct,

    ROUND(
        100.0 * late_minutes / NULLIF(total_attributed_minutes, 0), 2
    ) AS late_aircraft_pct,

    ROUND(
        100.0 * nas_minutes / NULLIF(total_attributed_minutes, 0), 2
    ) AS nas_pct,

    ROUND(
        100.0 * weather_minutes / NULLIF(total_attributed_minutes, 0), 2
    ) AS weather_pct,

    ROUND(
        100.0 * security_minutes / NULLIF(total_attributed_minutes, 0), 2
    ) AS security_pct

FROM totals

ORDER BY month_number;

-- ===================================================
-- BUSINESS FINDING 04: SEASONAL DISRUPTION
-- ===================================================
-- Dataset: Delta-marketed domestic flights, 2025
--
-- Attributed Delay Minutes per Eligible Arrival:
--
-- September:  8.42
-- July:      19.55
-- June:      20.09
-- December:  22.28
--
-- KEY FINDING:
-- December experienced approximately 2.65 times
-- September's attributed delay minutes per
-- eligible arrival.
--
-- Carrier and Late Aircraft together account for
-- approximately 74% of the September-to-December
-- increase in attributed minutes per eligible arrival.
--
-- BUSINESS IMPLICATION:
-- Investigate seasonal operational pressure,
-- aircraft turnaround processes, and potential
-- delay propagation.
--
-- LIMITATION:
-- The analysis identifies associations and
-- reported attribution, not proven root causes.
-- Cancelled and diverted flights are excluded.
--
-- NEXT INVESTIGATION:
-- Airport-level operational performance.

-- ===================================================
-- ANALYSIS 05: AIRPORT PERFORMANCE
-- Delta Air Lines | 2025
-- Top 15 Destination Airports by Delayed Arrivals
-- ===================================================

WITH airport_performance AS (

    SELECT
        destination AS airport_code,

        COUNT(*) FILTER (
            WHERE cancelled = 0
              AND diverted = 0
              AND arrival_delay IS NOT NULL
        ) AS eligible_arrivals,

        COUNT(*) FILTER (
            WHERE cancelled = 0
              AND diverted = 0
              AND arrival_delay >= 15
        ) AS delayed_arrivals

    FROM flights

    GROUP BY destination
)

SELECT
    ap.airport_code,
    a.city,
    a.state,

    ap.eligible_arrivals,
    ap.delayed_arrivals,

    ROUND(
        100.0 * ap.delayed_arrivals
        / NULLIF(ap.eligible_arrivals, 0),
        2
    ) AS delay_rate_pct,

    ROUND(
        100.0 * ap.delayed_arrivals
        / NULLIF(SUM(ap.delayed_arrivals) OVER (), 0),
        2
    ) AS share_of_network_delays_pct

FROM airport_performance ap

LEFT JOIN airports a
    ON ap.airport_code = a.airport_code

ORDER BY ap.delayed_arrivals DESC

LIMIT 15;

-- ===================================================
-- BUSINESS FINDING 05: AIRPORT PERFORMANCE
-- ===================================================
-- Dataset: Delta-marketed domestic flights, 2025
--
-- HIGHEST DELAY VOLUME:
-- ATL: 46,481 delayed arrivals (14.94% of network)
-- DTW: 18,986 delayed arrivals
-- LGA: 18,554 delayed arrivals
-- MSP: 18,432 delayed arrivals
--
-- HIGHEST DELAY RATES AMONG TOP 15 BY VOLUME:
-- DCA: 28.01%
-- ORD: 27.84%
-- MCO: 26.63%
-- BOS: 24.00%
-- LGA: 23.46%
--
-- KEY BUSINESS FINDINGS:
-- 1. Atlanta has the highest delay volume,
--    but its delay rate (16.93%) is below
--    the network average (19.44%).
--
-- 2. LaGuardia combines high delay volume
--    with an above-average delay rate.
--
-- 3. Airports should be assessed using
--    both delay volume and delay rate.
--
-- BUSINESS IMPLICATION:
-- Investigate high-volume airports for
-- opportunities to reduce total disruption.
--
-- Investigate high-rate airports to identify
-- persistent operational performance issues.
--
-- LIMITATION:
-- Destination airport does not necessarily
-- indicate where the delay originated.
--
-- NEXT INVESTIGATION:
-- Monthly performance of priority airports.

-- ===================================================
-- ANALYSIS 06: AIRPORT SEASONAL PERFORMANCE
-- Delta Air Lines | 2025
-- ===================================================

WITH airport_monthly AS (

    SELECT
        destination AS airport_code,
        month AS month_number,

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
        ) AS cancelled_flights

    FROM flights

    WHERE destination IN (
        'ATL', 'LGA', 'BOS',
        'MCO', 'DCA', 'ORD'
    )

    AND month IN (6, 7, 9, 12)

    GROUP BY destination, month
)

SELECT
    airport_code,

    CASE month_number
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 9 THEN 'September'
        WHEN 12 THEN 'December'
    END AS month_name,

    eligible_arrivals,
    delayed_arrivals,

    ROUND(
        100.0 * delayed_arrivals
        / NULLIF(eligible_arrivals, 0), 2
    ) AS delay_rate_pct,

    ROUND(
        100.0 * cancelled_flights
        / NULLIF(total_flights, 0), 2
    ) AS cancellation_rate_pct

FROM airport_monthly

ORDER BY airport_code, month_number;

-- ===================================================
-- BUSINESS FINDING 06: AIRPORT SEASONAL PERFORMANCE
-- ===================================================
-- Dataset: Delta-marketed domestic flights, 2025
--
-- DECEMBER VS SEPTEMBER DELAY RATE CHANGE:
--
-- ORD: +25.13 percentage points
-- LGA: +21.18 percentage points
-- MCO: +15.05 percentage points
-- DCA: +12.90 percentage points
-- ATL: +11.40 percentage points
-- BOS:  -9.44 percentage points
--
-- KEY FINDINGS:
--
-- 1. ORD experienced the greatest deterioration
--    among the six selected airports.
--
-- 2. LGA combines high delay volume,
--    substantial seasonal deterioration,
--    and elevated cancellation rates.
--
-- 3. ATL experienced 5,792 delayed arrivals
--    in June, highlighting its operational scale.
--
-- 4. BOS had a 34.12% delay rate in September,
--    despite strong overall network performance.
--
-- BUSINESS IMPLICATION:
-- Prioritize LGA, ATL, and ORD for deeper
-- investigation using route-level analysis
-- and reported delay categories.
--
-- LIMITATION:
-- Destination-level performance does not
-- establish where disruptions originated.
--
-- NEXT ANALYSIS:
-- Route-level operational performance.

-- ===================================================
-- ANALYSIS 07: ROUTE-LEVEL OPERATIONAL PERFORMANCE
-- Delta Air Lines | 2025
-- ===================================================

WITH route_performance AS (

    SELECT
        origin,
        destination,

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
        ) AS cancelled_flights

    FROM flights

    GROUP BY origin, destination
)

SELECT
    origin || ' → ' || destination AS route,

    total_flights,
    eligible_arrivals,
    delayed_arrivals,

    ROUND(
        100.0 * delayed_arrivals
        / NULLIF(eligible_arrivals, 0), 2
    ) AS delay_rate_pct,

    cancelled_flights,

    ROUND(
        100.0 * cancelled_flights
        / NULLIF(total_flights, 0), 2
    ) AS cancellation_rate_pct

FROM route_performance

WHERE eligible_arrivals >= 500

ORDER BY delayed_arrivals DESC

LIMIT 15;

-- ===================================================
-- BUSINESS FINDING 07: ROUTE-LEVEL PERFORMANCE
-- ===================================================
-- Dataset: Delta-marketed domestic flights, 2025
-- Minimum volume: 500 eligible arrivals per route
--
-- HIGHEST DELAY VOLUME:
-- ATL -> MCO: 1,777 delayed arrivals
-- ATL -> DCA: 1,314 delayed arrivals
-- MCO -> ATL: 1,298 delayed arrivals
--
-- HIGHEST DELAY RATE AMONG TOP 15 BY VOLUME:
-- ATL -> EWR: 38.62%
--
-- KEY FINDINGS:
--
-- 1. Atlanta appears in 13 of the top 15 routes
--    ranked by delayed arrival count.
--
-- 2. Directional performance differs:
--    ATL -> MCO: 33.54%
--    MCO -> ATL: 24.45%
--    Difference: 9.09 percentage points.
--
-- 3. LGA <-> BOS has elevated cancellation rates:
--    LGA -> BOS: 3.32%
--    BOS -> LGA: 4.01%
--
-- BUSINESS IMPLICATION:
-- Investigate directional operational differences,
-- departure timing, and late-aircraft propagation.
--
-- LIMITATION:
-- Route-level delay rates do not establish
-- where disruptions originated or their causes.
--
-- NEXT ANALYSIS:
-- Departure-hour and operating-carrier performance.

-- ===================================================
-- ANALYSIS 08: DEPARTURE TIME INTELLIGENCE
-- Delta Air Lines | 2025
-- ===================================================

WITH hourly_performance AS (

    SELECT
        departure_hour,

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

        SUM(
            CASE
                WHEN cancelled = 0
                 AND diverted = 0
                 AND arrival_delay >= 15
                THEN COALESCE(late_aircraft_delay_minutes, 0)
                ELSE 0
            END
        ) AS late_aircraft_minutes

    FROM flights

    WHERE departure_hour BETWEEN 0 AND 23

    GROUP BY departure_hour
)

SELECT
    departure_hour,
    total_flights,
    eligible_arrivals,
    delayed_arrivals,

    ROUND(
        100.0 * delayed_arrivals
        / NULLIF(eligible_arrivals, 0), 2
    ) AS delay_rate_pct,

    ROUND(
        late_aircraft_minutes
        / NULLIF(eligible_arrivals, 0), 2
    ) AS late_aircraft_minutes_per_arrival

FROM hourly_performance

ORDER BY departure_hour;

-- ===================================================
-- BUSINESS FINDING 08: DEPARTURE TIME INTELLIGENCE
-- ===================================================
-- Dataset: Delta-marketed domestic flights, 2025
--
-- LOWEST DELAY RATE:
-- 5 AM: 8.38%
--
-- HIGHEST DELAY RATE:
-- 7 PM: 29.39%
--
-- DIFFERENCE:
-- 21.01 percentage points.
--
-- LATE AIRCRAFT MINUTES PER ELIGIBLE ARRIVAL:
-- 5 AM: 1.22
-- 7 PM: 9.25
--
-- KEY FINDINGS:
--
-- 1. Delay rates generally increase from
--    early morning through early evening.
--
-- 2. Late-aircraft delay burden also increases
--    substantially during this period.
--
-- 3. Scheduled departure hour is a promising
--    feature for future delay-risk prediction.
--
-- BUSINESS IMPLICATION:
-- Investigate evening scheduling, aircraft
-- turnaround performance, and delay propagation.
--
-- LIMITATION:
-- Association does not establish causation.
-- Airport, route, carrier, and seasonal effects
-- require further analysis.
--
-- Very low-volume departure hours should
-- not be interpreted without sample-size checks.
--
-- NEXT ANALYSIS:
-- Operating-carrier performance comparison.

-- ===================================================
-- ANALYSIS 09: OPERATING CARRIER PERFORMANCE
-- Delta Air Lines | 2025
-- ===================================================

WITH carrier_performance AS (

    SELECT
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
        ) AS late_aircraft_minutes

    FROM flights

    GROUP BY operating_carrier
)

SELECT
    operating_carrier,
    total_flights,
    eligible_arrivals,
    delayed_arrivals,

    ROUND(
        100.0 * delayed_arrivals
        / NULLIF(eligible_arrivals, 0), 2
    ) AS delay_rate_pct,

    cancelled_flights,

    ROUND(
        100.0 * cancelled_flights
        / NULLIF(total_flights, 0), 2
    ) AS cancellation_rate_pct,

    ROUND(
        100.0 * diverted_flights
        / NULLIF(total_flights, 0), 2
    ) AS diversion_rate_pct,

    ROUND(
        late_aircraft_minutes
        / NULLIF(eligible_arrivals, 0), 2
    ) AS late_aircraft_minutes_per_arrival

FROM carrier_performance

ORDER BY total_flights DESC;

-- ===================================================
-- ANALYSIS 09A: DELAY ATTRIBUTION DATA QUALITY
-- Investigate unusual SkyWest delay reporting
-- ===================================================

SELECT
    operating_carrier,

    COUNT(*) AS delayed_arrivals,

    COUNT(*) FILTER (
        WHERE late_aircraft_delay_minutes IS NULL
    ) AS missing_late_aircraft_values,

    COUNT(*) FILTER (
        WHERE late_aircraft_delay_minutes = 0
    ) AS zero_late_aircraft_values,

    COUNT(*) FILTER (
        WHERE late_aircraft_delay_minutes > 0
    ) AS positive_late_aircraft_values,

    SUM(
        COALESCE(late_aircraft_delay_minutes, 0)
    ) AS total_late_aircraft_minutes,

    COUNT(*) FILTER (
        WHERE carrier_delay_minutes IS NULL
          AND weather_delay_minutes IS NULL
          AND nas_delay_minutes IS NULL
          AND security_delay_minutes IS NULL
          AND late_aircraft_delay_minutes IS NULL
    ) AS all_delay_causes_missing

FROM flights

WHERE cancelled = 0
  AND diverted = 0
  AND arrival_delay >= 15

GROUP BY operating_carrier

ORDER BY operating_carrier;

-- ===================================================
-- ANALYSIS 09B: DELAY ATTRIBUTION BY OPERATING CARRIER
-- Delta Air Lines | 2025
-- ===================================================

SELECT
    operating_carrier,

    COUNT(*) AS delayed_arrivals,

    SUM(COALESCE(carrier_delay_minutes, 0))
        AS carrier_minutes,

    SUM(COALESCE(weather_delay_minutes, 0))
        AS weather_minutes,

    SUM(COALESCE(nas_delay_minutes, 0))
        AS nas_minutes,

    SUM(COALESCE(security_delay_minutes, 0))
        AS security_minutes,

    SUM(COALESCE(late_aircraft_delay_minutes, 0))
        AS late_aircraft_minutes

FROM flights

WHERE cancelled = 0
  AND diverted = 0
  AND arrival_delay >= 15

GROUP BY operating_carrier

ORDER BY operating_carrier;

-- ===================================================
-- ANALYSIS 09C: DELAY MINUTE RECONCILIATION
-- Delta Air Lines | 2025
-- ===================================================

WITH delay_records AS (

    SELECT
        operating_carrier,
        arrival_delay,

        COALESCE(carrier_delay_minutes, 0)
        + COALESCE(weather_delay_minutes, 0)
        + COALESCE(nas_delay_minutes, 0)
        + COALESCE(security_delay_minutes, 0)
        + COALESCE(late_aircraft_delay_minutes, 0)
        AS attributed_minutes

    FROM flights

    WHERE cancelled = 0
      AND diverted = 0
      AND arrival_delay >= 15
)

SELECT
    operating_carrier,

    COUNT(*) AS delayed_arrivals,

    COUNT(*) FILTER (
        WHERE ABS(attributed_minutes - arrival_delay) <= 0.01
    ) AS matching_records,

    COUNT(*) FILTER (
        WHERE ABS(attributed_minutes - arrival_delay) > 0.01
    ) AS mismatched_records,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE ABS(attributed_minutes - arrival_delay) <= 0.01
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS reconciliation_pct,

    SUM(arrival_delay) AS actual_delay_minutes,

    SUM(attributed_minutes) AS attributed_delay_minutes

FROM delay_records

GROUP BY operating_carrier

ORDER BY operating_carrier;

-- ===================================================
-- BUSINESS FINDING 09: OPERATING CARRIER PERFORMANCE
-- ===================================================
-- Dataset: Delta-marketed domestic flights, 2025
--
-- ARRIVAL DELAY RATES:
-- DL (Delta):    19.79%
-- OO (SkyWest):  14.79%
-- 9E (Endeavor): 22.23%
-- YX (Republic): 21.04%
--
-- HIGHEST CANCELLATION RATE:
-- Republic Airways: 2.74%
--
-- DATA QUALITY INVESTIGATION:
-- SkyWest reported only 786 late-aircraft delay
-- minutes across 37,362 delayed arrivals.
--
-- RECONCILIATION:
-- 311,211 delayed flights checked.
-- 311,211 records reconciled.
-- 0 mismatches.
-- Reconciliation rate: 100%.
--
-- KEY FINDING:
-- Recorded delay minutes reconcile perfectly
-- with the five BTS attribution categories.
--
-- LIMITATION:
-- Reconciliation does not independently validate
-- the accuracy of attribution categories.
-- SkyWest's unusual attribution pattern requires
-- caution in carrier comparisons.
--
-- Carrier performance comparisons are unadjusted
-- for routes, schedules, seasonality, and other
-- operational differences.
--
-- NEXT PHASE:
-- Financial performance and fuel-cost analysis.

-- ===================================================
-- ANALYSIS 10: FINANCIAL PERFORMANCE & PROFITABILITY
-- Delta Air Lines | 2021–2025
-- Financial values in USD millions
-- ===================================================

SELECT
    fiscal_year,

    total_operating_revenue_usd_millions
        AS revenue_millions,

    total_operating_expense_usd_millions
        AS operating_expenses_millions,

    operating_income_usd_millions
        AS operating_income_millions,

    ROUND(
        operating_margin_pct, 2
    ) AS operating_margin_pct,

    fuel_expense_usd_millions
        AS fuel_expense_millions,

    ROUND(
        100.0 * fuel_expense_usd_millions
        / NULLIF(total_operating_expense_usd_millions, 0),
        2
    ) AS fuel_share_of_operating_expenses_pct,

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

FROM financials

ORDER BY fiscal_year;

-- ===================================================
-- BUSINESS FINDING 10: FINANCIAL PERFORMANCE
-- ===================================================
-- Dataset: Delta consolidated financials, 2021-2025
-- Financial values in USD millions.
--
-- 2025 FINANCIAL RESULTS:
-- Revenue:          $63,364M
-- Operating Income:  $5,822M
-- Operating Margin:     9.19%
-- Fuel Expenses:     $9,819M
--
-- 2024 VS 2025:
-- Revenue Growth:            +2.79%
-- Operating Expense Growth:  +3.40%
-- Operating Income Change:   -2.89%
-- Operating Margin Change:   -0.54 pp
-- Fuel Expense Change:       -7.07%
--
-- KEY BUSINESS FINDING:
-- Operating expenses grew faster than revenue
-- in 2025, despite declining fuel expenses.
--
-- Non-fuel operating expenses increased by
-- $2,641M (approximately 5.86%).
--
-- BUSINESS IMPLICATION:
-- Investigate non-fuel expense growth and
-- opportunities to improve operating efficiency.
--
-- LIMITATION:
-- Financial data represents consolidated Delta
-- operations, not individual domestic routes.
-- Association does not establish that flight
-- disruptions caused changes in profitability.
--
-- NEXT ANALYSIS:
-- Fuel prices, fuel consumption and cost trends.

-- ===================================================
-- ANALYSIS 11: FUEL ECONOMICS
-- Delta Air Lines | 2021–2025
-- ===================================================

WITH annual_eia_prices AS (

    SELECT
        EXTRACT(YEAR FROM month)::INTEGER AS year,

        COUNT(*) AS months_available,

        ROUND(
            AVG(jet_fuel_price_usd_per_gallon), 3
        ) AS eia_avg_spot_price

    FROM fuel_prices

    GROUP BY EXTRACT(YEAR FROM month)
),

fuel_analysis AS (

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

    LEFT JOIN annual_eia_prices e
        ON f.fiscal_year = e.year
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
    ) AS fuel_consumption_yoy_pct,

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
    ) AS delta_fuel_price_yoy_pct,

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
    ) AS fuel_expense_yoy_pct

FROM fuel_analysis

ORDER BY fiscal_year;

-- ===================================================
-- BUSINESS FINDING 11: FUEL ECONOMICS
-- ===================================================
-- Dataset: Delta SEC financials + EIA fuel prices
-- Period: 2021-2025
--
-- 2024 VS 2025:
--
-- Fuel Consumption:      +3.77%
-- Delta Avg Fuel Price:  -10.51%
-- EIA Market Fuel Price:  -9.37%
-- Total Fuel Expenses:    -7.07%
--
-- KEY FINDING:
-- Delta consumed more fuel in 2025 but
-- reported $747M lower fuel expenses.
--
-- APPROXIMATE PRICE-VOLUME ANALYSIS:
-- Additional volume effect: +$398M
-- Lower price effect:     -$1,153M
--
-- BUSINESS IMPLICATION:
-- Lower fuel prices helped offset higher
-- fuel consumption.
--
-- Despite these savings, operating margin
-- declined from 9.73% to 9.19%.
--
-- LIMITATIONS:
-- Price-volume effects are approximate
-- because reported values are rounded.
--
-- EIA spot prices are external benchmarks,
-- not Delta's actual purchase prices.
--
-- Financial figures represent consolidated
-- Delta operations.
--
-- NEXT ANALYSIS:
-- Non-fuel operating expense growth.

-- ===================================================
-- ANALYSIS 12: OPERATING COST INTELLIGENCE
-- Delta Air Lines | 2024–2025
-- All financial values in USD millions
-- ===================================================

WITH expense_breakdown AS (

    SELECT
        fiscal_year,

        total_operating_expense_usd_millions
            AS total_expenses,

        fuel_expense_usd_millions
            AS fuel_expenses,

        salaries_related_costs_usd_millions
            AS salary_expenses,

        total_operating_expense_usd_millions
        - fuel_expense_usd_millions
            AS non_fuel_expenses,

        total_operating_expense_usd_millions
        - fuel_expense_usd_millions
        - salaries_related_costs_usd_millions
            AS other_non_fuel_expenses

    FROM financials
),

yearly_changes AS (

    SELECT
        *,

        total_expenses
        - LAG(total_expenses)
            OVER (ORDER BY fiscal_year)
            AS total_expense_change,

        fuel_expenses
        - LAG(fuel_expenses)
            OVER (ORDER BY fiscal_year)
            AS fuel_expense_change,

        salary_expenses
        - LAG(salary_expenses)
            OVER (ORDER BY fiscal_year)
            AS salary_expense_change,

        other_non_fuel_expenses
        - LAG(other_non_fuel_expenses)
            OVER (ORDER BY fiscal_year)
            AS other_non_fuel_change

    FROM expense_breakdown
)

SELECT
    fiscal_year,

    total_expenses,
    fuel_expenses,
    salary_expenses,
    other_non_fuel_expenses,

    ROUND(
        100.0 * salary_expenses
        / NULLIF(total_expenses, 0), 2
    ) AS salaries_share_pct,

    total_expense_change,
    fuel_expense_change,
    salary_expense_change,
    other_non_fuel_change

FROM yearly_changes

WHERE fiscal_year IN (2024, 2025)

ORDER BY fiscal_year;

-- ===================================================
-- BUSINESS FINDING 12: OPERATING COST INTELLIGENCE
-- ===================================================
-- Dataset: Delta consolidated financials
-- Comparison: 2024 vs 2025
-- Financial values in USD millions
--
-- 2025 EXPENSE CHANGES:
--
-- Fuel Expenses:          -$747M
-- Salaries & Related:   +$1,359M
-- Other Non-Fuel:       +$1,282M
--
-- Total Expense Change: +$1,894M
--
-- VALIDATION:
-- -747 + 1359 + 1282 = 1894
-- Expense changes reconcile.
--
-- KEY BUSINESS FINDINGS:
--
-- 1. Salaries and related costs increased
--    by 8.41% year over year.
--
-- 2. Other non-fuel expenses increased
--    by 4.43%.
--
-- 3. Combined non-fuel expense growth
--    exceeded fuel savings.
--
-- 4. Operating expenses increased faster
--    than operating revenue.
--
-- BUSINESS IMPLICATION:
-- Investigate employee-related and other
-- non-fuel operating expense drivers.
--
-- LIMITATIONS:
-- Aggregated financial data does not identify
-- specific causes of non-fuel expense growth.
--
-- Higher costs do not automatically
-- indicate operational inefficiency.
--
-- Financial results are consolidated and
-- cannot be attributed to domestic routes.
--
-- NEXT PHASE:
-- SQL reporting views and Power BI dashboards.