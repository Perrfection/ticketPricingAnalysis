-- avg_airfare_overall
SELECT
    ROUND(AVG(price),2) AS avg_price
FROM flights;   

-- avg_airline_airfare_hl
SELECT
    airline,
    ROUND(AVG(price),2) AS avg_price
FROM flights
GROUP BY airline
ORDER BY avg_price DESC;

-- avg_route_airfare_hl
SELECT
    source_city || ' → ' || destination_city AS route,
    ROUND(AVG(price),2) AS avg_price
FROM flights
GROUP BY route
ORDER BY avg_price DESC;

-- avg_airfare_days_left
SELECT
    days_left,
    ROUND(AVG(price),2) AS avg_price,
    ROUND(ROUND(AVG(price),2)/(SELECT ROUND(AVG(price),2) FROM flights),2) AS price_ratio
FROM flights
GROUP BY days_left
ORDER BY days_left;

-- avg_airfare_days_left_Chennai_Bangalore_SpiceJet
SELECT
    days_left,
    ROUND(AVG(price),2) AS avg_price,
    ROUND(ROUND(AVG(price),2)/(SELECT ROUND(AVG(price),2) FROM flights WHERE destination_city = 'Chennai' AND source_city = 'Bangalore'),2) AS price_ratio
FROM flights
WHERE destination_city = 'Chennai' AND source_city = 'Bangalore' AND airline = 'SpiceJet'
GROUP BY days_left
ORDER BY days_left;

-- avg_airfare_days_left_Chennai_Bangalore_Vistara
SELECT
    days_left,
    ROUND(AVG(price),2) AS avg_price,
    ROUND(ROUND(AVG(price),2)/(SELECT ROUND(AVG(price),2) FROM flights WHERE destination_city = 'Chennai' AND source_city = 'Bangalore'),2) AS price_ratio
FROM flights
WHERE destination_city = 'Chennai' AND source_city = 'Bangalore' AND airline = 'Vistara'
GROUP BY days_left
ORDER BY days_left;

-- avg_airfare_days_left_Bangalore_Chennai_Vistara
/* Define parameters */
WITH InputParameters AS (
    SELECT 
        'Bangalore' AS p_source,
        'Chennai'   AS p_destination,
        'Vistara'   AS p_airline
),

/* Calculate the average for this route */
RouteAverage AS (
    SELECT 
        ROUND(AVG(price), 2) AS route_avg_price
    FROM flights
    CROSS JOIN InputParameters
    WHERE source_city = p_source 
      AND destination_city = p_destination
)

/* Run the main analytical query */
SELECT
    f.days_left,
    ROUND(AVG(f.price), 2) AS avg_price,
    ROUND(ROUND(AVG(f.price), 2) / r.route_avg_price, 2) AS price_ratio
FROM flights f
CROSS JOIN InputParameters ip
CROSS JOIN RouteAverage r
WHERE f.source_city = ip.p_source 
  AND f.destination_city = ip.p_destination 
  AND f.airline = ip.p_airline
GROUP BY f.days_left, r.route_avg_price
ORDER BY f.days_left;
