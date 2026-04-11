-- # Module 1: Analytic & Window Functions
-- Analytic functions compute an aggregate value based on a group of rows. 
-- Unlike aggregate functions (SUM, AVG), they do not collapse rows; 
-- they return a result for every row in the result set.

-- ## 1.1 Ranking Functions: ROW_NUMBER, RANK, and DENSE_RANK
-- Use Case: Comparing the popularity of airlines based on their flight volume.

-- Explanation:
-- ROW_NUMBER(): Unique sequential number (1, 2, 3...).
-- RANK(): Identical values get the same rank, but the next rank is skipped (1, 2, 2, 4).
-- DENSE_RANK(): Identical values get the same rank, and no ranks are skipped (1, 2, 2, 3).

SELECT 
    c.CN_COMP as Airline,
    COUNT(v.ID_VUELO) as Total_Flights,
    ROW_NUMBER() OVER (ORDER BY COUNT(v.ID_VUELO) DESC) as Row_Num,
    RANK()       OVER (ORDER BY COUNT(v.ID_VUELO) DESC) as Rank_Val,
    DENSE_RANK() OVER (ORDER BY COUNT(v.ID_VUELO) DESC) as Dense_Rank_Val
FROM VUELOS v
JOIN COMPANIAS c ON v.COMP_ID_COMP = c.ID_COMP
GROUP BY c.CN_COMP
FETCH FIRST 10 ROWS ONLY;


-- ## 1.2 Navigational Functions: LAG and LEAD
-- Use Case: Comparing a flight's revenue with the previous flight of the same airline.

-- Explanation:
-- LAG(): Accesses data from a previous row in the same result set.
-- LEAD(): Accesses data from a subsequent row.

WITH DailyRevenue AS (
    SELECT 
        v.COMP_ID_COMP,
        v.FECHA_VUELO,
        SUM(r.IMPORTE) as Daily_Total
    FROM VUELOS v
    JOIN RESERVAS r ON v.ID_VUELO = r.VUE_ID_VUELO
    WHERE v.COMP_ID_COMP = 'IBERI' -- Filter for Iberia to simplify the view
    GROUP BY v.COMP_ID_COMP, v.FECHA_VUELO
)
SELECT 
    FECHA_VUELO,
    Daily_Total as Today_Revenue,
    LAG(Daily_Total) OVER (ORDER BY FECHA_VUELO) as Yesterday_Revenue,
    Daily_Total - LAG(Daily_Total) OVER (ORDER BY FECHA_VUELO) as Revenue_Delta
FROM DailyRevenue
ORDER BY FECHA_VUELO;


-- ## 1.3 Aggregates with OVER(): Running Totals
-- Use Case: Tracking cumulative revenue at an airport throughout the month.

-- Explanation:
-- By adding 'ORDER BY' inside the OVER() clause, Oracle treats the 
-- aggregate as a "running" calculation from the start of the partition.

SELECT 
    v.FECHA_VUELO,
    v.AER_ID_AERO as Origin,
    SUM(r.IMPORTE) as Flight_Revenue,
    SUM(SUM(r.IMPORTE)) OVER (
        PARTITION BY v.AER_ID_AERO 
        ORDER BY v.FECHA_VUELO
    ) as Running_Total_Revenue
FROM VUELOS v
JOIN RESERVAS r ON v.ID_VUELO = r.VUE_ID_VUELO
WHERE v.AER_ID_AERO IN ('MAD', 'BCN') -- Focus on main Spanish airports
GROUP BY v.FECHA_VUELO, v.AER_ID_AERO
ORDER BY v.AER_ID_AERO, v.FECHA_VUELO;


-- ## 1.4 String Aggregation: LISTAGG
-- Use Case: Generating a clean report of all destinations served by each airline.

-- Explanation:
-- LISTAGG concatenates column values into a single string. 
-- The 'DISTINCT' keyword (available in Oracle 19c+) is crucial here 
-- to avoid repeating destinations.

SELECT 
    c.CN_COMP as Airline,
    COUNT(DISTINCT v.AER_ID_AERO_DESTINO) as Unique_Destinations,
    LISTAGG(DISTINCT v.AER_ID_AERO_DESTINO, ', ') 
        WITHIN GROUP (ORDER BY v.AER_ID_AERO_DESTINO) as Destination_List
FROM VUELOS v
JOIN COMPANIAS c ON v.COMP_ID_COMP = c.ID_COMP
GROUP BY c.CN_COMP
HAVING COUNT(DISTINCT v.AER_ID_AERO_DESTINO) < 10 -- Filter for shorter lists
ORDER BY Unique_Destinations DESC;
