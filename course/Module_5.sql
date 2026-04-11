-- # Module 5: Data Recovery & Security
-- High-level Oracle features to protect data integrity and 
-- control granular access.

-- ## 5.1 Flashback Query: "Time Travel" for Data
-- Use Case: A user accidentally updated or deleted a reservation.

-- Explanation:
-- Flashback allows you to query the state of a table as it 
-- existed at a specific point in time (using SCN or Timestamp), 
-- provided it's within the 'undo_retention' period.

-- 1. Check current data (e.g., IMPORTE for a specific reservation)
SELECT ID_RESERVA, IMPORTE 
FROM RESERVAS 
WHERE ID_RESERVA = 'RES-001'
FETCH FIRST 1 ROW ONLY;

-- 2. Mock Error: Update the importe by mistake
UPDATE RESERVAS SET IMPORTE = 0 WHERE ID_RESERVA = 'RES-001';
COMMIT;

-- 3. Recover: See the value as it was 5 minutes ago
SELECT ID_RESERVA, IMPORTE 
FROM RESERVAS AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE)
WHERE ID_RESERVA = 'RES-001';

-- 4. Restore: Correct the mistake using the historical data
UPDATE RESERVAS r
SET r.IMPORTE = (
    SELECT old.IMPORTE 
    FROM RESERVAS AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '10' MINUTE) old
    WHERE old.ID_RESERVA = r.ID_RESERVA
)
WHERE r.ID_RESERVA = 'RES-001';
COMMIT;


-- ## 5.2 Flashback Versions Query: Tracking Changes
-- Use Case: Auditing who changed what and when.

-- Explanation:
-- This query returns a row for every version of a record 
-- that existed during a specific interval.

SELECT 
    VERSIONS_STARTTIME, 
    VERSIONS_ENDTIME, 
    VERSIONS_OPERATION, 
    ID_RESERVA, 
    IMPORTE
FROM RESERVAS
VERSIONS BETWEEN TIMESTAMP 
    (SYSTIMESTAMP - INTERVAL '10' MINUTE) AND SYSTIMESTAMP
WHERE ID_RESERVA = 'RES-001'
ORDER BY VERSIONS_STARTTIME;


-- ## 5.3 Virtual Private Database (VPD) Concepts
-- Use Case: Restricting travel agencies to see ONLY their own reservations.

-- Explanation:
-- Instead of complex WHERE clauses in every query, VPD 
-- automatically appends a hidden predicate (a filter) 
-- to any query executed against the table.

-- Note: This requires PL/SQL to implement the policy function.
-- Here is the conceptual framework:

/*
-- Step 1: Create the function that defines the filter
CREATE OR REPLACE FUNCTION F_LIMIT_AGENCY_RESERVAS (
    schema_p IN VARCHAR2,
    table_p  IN VARCHAR2
) RETURN VARCHAR2 AS
    v_user VARCHAR2(100);
BEGIN
    v_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    -- If the user is an admin, return no filter (1=1)
    IF v_user = 'DBA_ADMIN' THEN
        RETURN '1=1';
    ELSE
        -- Otherwise, filter by the agency ID associated with this user
        -- (Assumes the DB user matches the agency ID/code)
        RETURN 'AGE_ID_AGENCIA = ' || v_user;
    END IF;
END;
/

-- Step 2: Add the policy to the RESERVAS table
BEGIN
    DBMS_RLS.ADD_POLICY (
        object_schema => 'VUELOS',
        object_name   => 'RESERVAS',
        policy_name   => 'AGENCY_DATA_SECURITY',
        function_schema => 'VUELOS',
        policy_function => 'F_LIMIT_AGENCY_RESERVAS',
        statement_types => 'SELECT, UPDATE, DELETE'
    );
END;
/
*/


-- ## 5.4 Data Redaction (Security Masking)
-- Use Case: Hiding the middle part of a NIF for unauthorized users.

-- Explanation:
-- Oracle can mask data on-the-fly without changing the physical table.

/*
BEGIN
    DBMS_REDACT.ADD_POLICY(
        object_schema => 'VUELOS',
        object_name   => 'CLIENTES',
        column_name   => 'NIF',
        policy_name   => 'MASK_CLIENT_NIF',
        function_type => DBMS_REDACT.PARTIAL,
        function_parameters => '1,5,4,*,X,1', -- Result: 12345XXXX-X
        expression    => 'SYS_CONTEXT(''USERENV'',''SESSION_USER'') != ''HR_ADMIN'''
    );
END;
/
*/
