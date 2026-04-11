-- # FINAL CHALLENGE: Executive Performance Report
-- Student Name: __________________________

-- ## Task 1: Recursive Route Discovery (MAD -> Germany)
-- Goal: Find paths with 1 stop.
WITH FlightPaths (Path, Last_Dest, Stops) AS (
    SELECT 
        CAST(AER_ID_AERO || ' -> ' || AER_ID_AERO_DESTINO AS VARCHAR2(200)),
        AER_ID_AERO_DESTINO,
        1
    FROM VUELOS WHERE AER_ID_AERO = 'MAD'
    UNION ALL
    SELECT 
        CAST(fp.Path || ' -> ' || v.AER_ID_AERO_DESTINO AS VARCHAR2(200)),
        v.AER_ID_AERO_DESTINO,
        fp.Stops + 1
    FROM FlightPaths fp
    JOIN VUELOS v ON fp.Last_Dest = v.AER_ID_AERO
    WHERE fp.Stops < 2
)
SELECT DISTINCT Path FROM FlightPaths 
WHERE Last_Dest IN ('MUC', 'FRA', 'BER');


-- ## Task 2: Masked Loyalty Ranking
-- Goal: Use REGEXP_REPLACE and DENSE_RANK.
SELECT * FROM (
    SELECT 
        REGEXP_REPLACE(cl.NIF, '^[0-9]{8}', '********') as Masked_NIF,
        cl.NOMBRE || ' ' || cl.APELLIDOS as Full_Name,
        SUM(r.IMPORTE) as Total_Spend,
        DENSE_RANK() OVER (ORDER BY SUM(r.IMPORTE) DESC) as Rank
    FROM CLIENTES cl
    JOIN RESERVAS r ON cl.NIF = r.CLI_NIF
    GROUP BY cl.NIF, cl.NOMBRE, cl.APELLIDOS
) WHERE Rank <= 5;


-- ## Task 3: Hub Category Matrix
-- Goal: Use the PIVOT clause on the Virtual Column.
SELECT * FROM (
    SELECT AER_ID_AERO, FLIGHT_SIZE_CAT 
    FROM VUELOS 
    WHERE AER_ID_AERO IN ('MAD', 'BCN', 'CDG')
) PIVOT (
    COUNT(*) FOR FLIGHT_SIZE_CAT IN ('SMALL' as S, 'MEDIUM' as M, 'LARGE' as L)
);


-- ## Task 4: Iberia Weekly Growth
-- Goal: Use SUM() OVER with ORDER BY.
SELECT 
    FECHA_VUELO,
    Daily_Revenue,
    SUM(Daily_Revenue) OVER (ORDER BY FECHA_VUELO) as Running_Total
FROM (
    SELECT v.FECHA_VUELO, SUM(r.IMPORTE) as Daily_Revenue
    FROM VUELOS v
    JOIN RESERVAS r ON v.ID_VUELO = r.VUE_ID_VUELO
    WHERE v.COMP_ID_COMP = 'IBERI' 
      AND v.FECHA_VUELO BETWEEN TO_DATE('2026-03-01','YYYY-MM-DD') 
                            AND TO_DATE('2026-03-07','YYYY-MM-DD')
    GROUP BY v.FECHA_VUELO
);
