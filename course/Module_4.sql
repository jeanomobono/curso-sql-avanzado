-- # Module 4: Performance & Data Manipulation
-- Advanced techniques for managing and optimizing data 
-- beyond simple CRUD operations.

-- ## 4.1 Regular Expressions: REGEXP_LIKE and REGEXP_SUBSTR
-- Use Case: Validating and extracting patterns from raw text.

-- Explanation:
-- REGEXP_LIKE: Check if a column matches a complex pattern.
-- REGEXP_SUBSTR: Extract a specific piece of data from a string.

-- 1. Validate NIF format (e.g., "12345678-X")
SELECT 
    NIF, 
    NOMBRE, 
    APELLIDOS
FROM CLIENTES
WHERE NOT REGEXP_LIKE(NIF, '^[0-9]{1,8}-[A-Z]$'); -- Finds invalid NIFs

-- 2. Extract the numeric ID from the DETALLES column (e.g., "VUELO123" -> "123")
SELECT 
    ID_VUELO,
    DETALLES,
    REGEXP_SUBSTR(DETALLES, '[0-9]+') as Extracted_Number,
    REGEXP_REPLACE(DETALLES, 'VUELO', 'Flight No. ') as Readable_Detail
FROM VUELOS
FETCH FIRST 10 ROWS ONLY;


-- ## 4.2 Virtual Columns: Automatic Calculations
-- Use Case: Adding a "Flight Size" category without storing extra data.

-- Explanation:
-- Virtual columns are derived from other columns. 
-- They take NO storage space (except for indexes) and are 
-- calculated on the fly during the SELECT.

-- Let's define a flight size based on capacity:
-- 1-60: Small, 61-120: Medium, >120: Large
ALTER TABLE VUELOS ADD (
    FLIGHT_SIZE_CAT AS (
        CASE 
            WHEN CAPACIDAD_AVION <= 60 THEN 'SMALL'
            WHEN CAPACIDAD_AVION <= 120 THEN 'MEDIUM'
            ELSE 'LARGE'
        END
    )
);

-- Now we can query it like any other column:
SELECT 
    ID_VUELO, 
    CAPACIDAD_AVION, 
    FLIGHT_SIZE_CAT 
FROM VUELOS 
FETCH FIRST 10 ROWS ONLY;


-- ## 4.3 Materialized Views: Caching Results
-- Use Case: Speeding up a dashboard for Top Airlines by Revenue.

-- Explanation:
-- A standard VIEW runs the query every time it's called. 
-- A MATERIALIZED VIEW stores the result on disk. 
-- Ideal for slow, complex reports that don't need real-time data.

CREATE MATERIALIZED VIEW MV_AIRLINE_PERFORMANCE
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT 
    c.CN_COMP as Airline,
    COUNT(DISTINCT v.ID_VUELO) as Total_Flights,
    SUM(r.IMPORTE) as Total_Revenue
FROM COMPANIAS c
JOIN VUELOS v ON c.ID_COMP = v.COMP_ID_COMP
JOIN RESERVAS r ON v.ID_VUELO = r.VUE_ID_VUELO
GROUP BY c.CN_COMP;

-- To update the data in the materialized view:
-- EXEC DBMS_MVIEW.REFRESH('MV_AIRLINE_PERFORMANCE');

-- Query the cached result instantly:
SELECT * FROM MV_AIRLINE_PERFORMANCE ORDER BY Total_Revenue DESC;


-- ## 4.4 Advanced Indexing: Function-Based Indexes
-- Use Case: Optimizing queries that use functions in the WHERE clause.

-- Explanation:
-- Normally, an index on NIF is ignored if you use 'WHERE UPPER(NIF)'. 
-- A function-based index solves this.

CREATE INDEX IDX_CLIENTE_UPPER_NIF ON CLIENTES(UPPER(NIF));

-- Now this query is lightning fast:
SELECT * FROM CLIENTES WHERE UPPER(NIF) = '35046296-K';
