-- # Bonus A: JSON Features in Oracle 23ai
-- Oracle 23ai treats JSON as a first-class citizen. 
-- We can store, query, and even join JSON data with regular tables.

-- ## A.1 Storing JSON: The New 'JSON' Data Type
-- In 23ai, we have a native JSON type that is optimized for performance.
CREATE TABLE LOGS_VUELO (
    ID_LOG NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ID_VUELO NUMBER,
    INFO_JSON JSON -- Native 23ai JSON type
);

-- ## A.2 Inserting JSON Data
-- Let's store complex, nested data about flight events.
INSERT INTO LOGS_VUELO (ID_VUELO, INFO_JSON) VALUES (
    971, 
    JSON('{
        "status": "Delayed",
        "reason": "Weather",
        "crew": {
            "pilot": "Capt. Smith",
            "copilot": "First Officer Jones"
        },
        "incidents": ["Gate change", "Late fuel delivery"]
    }')
);

-- ## A.3 Simple Dot-Notation Access
-- 23ai allows you to query JSON like it's a regular object.
SELECT 
    v.DETALLES,
    l.INFO_JSON.status as Flight_Status,
    l.INFO_JSON.crew.pilot as Pilot_In_Command
FROM VUELOS v
JOIN LOGS_VUELO l ON v.ID_VUELO = l.ID_VUELO;

-- ## A.4 JSON_TABLE: Turning JSON into Rows
-- Use Case: Relational reporting from a JSON array of incidents.
SELECT 
    v.ID_VUELO,
    jt.incident_desc
FROM LOGS_VUELO l
JOIN VUELOS v ON l.ID_VUELO = v.ID_VUELO,
JSON_TABLE(l.INFO_JSON, '$.incidents[*]'
    COLUMNS (
        incident_desc VARCHAR2(100) PATH '$'
    )
) jt;

-- ## A.5 JSON Relational Duality (Conceptual)
-- Explain to students that 23ai can now present relational data 
-- as JSON and vice-versa, allowing Developers to use JSON 
-- while DBAs maintain relational integrity.

-- # Bonus B: Flashback Query & Versioning
-- Flashback is Oracle's "Temporal Database" feature. 
-- It allows you to see the past.

-- ## B.1 Flashback Table: The Ultimate Undo
-- Scenario: You accidentally updated all flight capacities to 0.

-- 1. Enable row movement (required for Flashback Table)
ALTER TABLE VUELOS ENABLE ROW MOVEMENT;

-- 2. The Disaster:
UPDATE VUELOS SET CAPACIDAD_AVION = 0;
COMMIT; -- Oops!

-- 3. The Recovery:
-- Roll the entire table back to its state 5 minutes ago.
FLASHBACK TABLE VUELOS TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE);

-- Check it - it's like the update never happened!
SELECT ID_VUELO, CAPACIDAD_AVION FROM VUELOS FETCH FIRST 5 ROWS ONLY;


-- ## B.2 Flashback Transaction Query
-- Find out EXACTLY which SQL statement caused a change 
-- and get the "Undo SQL" to reverse it.

-- This requires specific DB permissions, but you can show the metadata:
SELECT 
    XID, 
    OPERATION, 
    UNDO_SQL 
FROM FLASHBACK_TRANSACTION_QUERY 
WHERE TABLE_NAME = 'VUELOS'
ORDER BY START_TIMESTAMP DESC;


-- ## B.3 Flashback Drop: The Recycle Bin
-- Did someone drop a table? No problem.
DROP TABLE LOGS_VUELO;

-- See it in the "Recycle Bin"
SELECT ORIGINAL_NAME, TYPE, DROPTIME FROM USER_RECYCLEBIN;

-- Bring it back!
FLASHBACK TABLE LOGS_VUELO TO BEFORE DROP;
