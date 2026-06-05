-- PRAGMA 
/** show the structure of the flights table to understand its columns and data types **/
PRAGMA table_info(flights);

-- sample
/** sample the first 10 rows of the flights table to understand its structure and data **/
SELECT
    airline,
    source_city || ' → ' || destination_city AS route,
    class,
    price
FROM flights
LIMIT 10;