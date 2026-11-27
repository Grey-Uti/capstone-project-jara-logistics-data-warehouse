--============= ================
-- ISSUE 1: Missing customer_id data in the deliveries fact table  -- DROP TABLE JARA_DB.RAW.deliveries_quarantine; --select * from JARA_DB.RAW.RIDERS Group by all Having count(*) = 1
CREATE OR REPLACE TABLE JARA_DB.RAW.deliveries_quarantine AS 
SELECT delivery_id, 
customer_id, 
rider_id, 
pickup_city, 
distance_km, 
delivery_fee, 
status, 
fleet, 
created_at,
CAST('Missing Customer_id data' AS VARCHAR(60)) AS data_quality_issues
FROM JARA_DB.RAW.DELIVERIES
WHERE customer_id IS NULL;   -- 6 records affected


---=============================
-- ISSUE 2: 'Duplicated transaction id or records'
INSERT INTO JARA_DB.RAW.deliveries_quarantine (
delivery_id, 
customer_id, 
rider_id, 
pickup_city, 
distance_km, 
delivery_fee, 
status, 
fleet, 
created_at,
data_quality_issues
)
SELECT DISTINCT 
delivery_id, 
customer_id, 
rider_id, 
pickup_city, 
distance_km, 
delivery_fee, 
status, 
fleet, 
created_at,
'Duplicated delivery id or records' AS data_quality_issues
FROM JARA_DB.RAW.DELIVERIES
WHERE delivery_id IN (
    SELECT distinct delivery_id  --, COUNT(*) AS RowCount
    FROM JARA_DB.RAW.DELIVERIES
    GROUP BY delivery_id
    HAVING COUNT(*) > 1
);   --9 delivery_ids witrh duplicate issues

--=========================
-- ISSUES 3: Inconsistent Status value (delivered & Delivered)
INSERT INTO JARA_DB.RAW.deliveries_quarantine (
delivery_id, 
customer_id, 
rider_id, 
pickup_city, 
distance_km, 
delivery_fee, 
status, 
fleet, 
created_at,
data_quality_issues
)
SELECT delivery_id, 
customer_id, 
rider_id, 
pickup_city, 
distance_km, 
delivery_fee, 
status, 
fleet, 
created_at,
'Inconsistent Status value (delivered & Delivered)' AS data_quality_issues
FROM JARA_DB.RAW.DELIVERIES
WHERE status = 'Delivered';  --12 records affected


--=========================
-- ISSUES 4: Inconsistent Status value (failed & Failed)
INSERT INTO JARA_DB.RAW.deliveries_quarantine (
delivery_id, 
customer_id, 
rider_id, 
pickup_city, 
distance_km, 
delivery_fee, 
status, 
fleet, 
created_at,
data_quality_issues
)
SELECT delivery_id, 
customer_id, 
rider_id, 
pickup_city, 
distance_km, 
delivery_fee, 
status, 
fleet, 
created_at,
'Inconsistent Status value (failed & Failed)' AS data_quality_issues
FROM JARA_DB.RAW.DELIVERIES
WHERE status = 'Failed';   --5 records


--=========================
-- ISSUES 5: Unmatching and Unmapped rider_ids
INSERT INTO JARA_DB.RAW.deliveries_quarantine (
delivery_id, 
customer_id, 
rider_id, 
pickup_city, 
distance_km, 
delivery_fee, 
status, 
fleet, 
created_at,
data_quality_issues
)
SELECT 
dl.delivery_id, 
dl.customer_id, 
dl.rider_id, 
dl.pickup_city, 
dl.distance_km, 
dl.delivery_fee, 
dl.status, 
dl.fleet, 
dl.created_at,
'Unmatching and Unmapped rider_ids' AS data_quality_issues
FROM JARA_DB.RAW.DELIVERIES dl
LEFT JOIN JARA_DB.RAW.RIDERS rl 
   ON dl.rider_id = rl.rider_id
WHERE rl.rider_id IS NULL;   --4 records affected

--=========================
-- ISSUES 6: Unrealistic or impossible Distance_KM values
INSERT INTO JARA_DB.RAW.deliveries_quarantine (
delivery_id, 
customer_id, 
rider_id, 
pickup_city, 
distance_km, 
delivery_fee, 
status, 
fleet, 
created_at,
data_quality_issues
)
SELECT 
delivery_id, 
customer_id, 
rider_id, 
pickup_city, 
distance_km, 
delivery_fee, 
status, 
fleet, 
created_at,
'Impossible or unrealistic distance km' AS data_quality_issues
FROM JARA_DB.RAW.DELIVERIES
WHERE distance_km > 41.0;   --107 records affected


