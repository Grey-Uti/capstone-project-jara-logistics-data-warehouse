--==================================================
--Data Profiling for the Deliveries Fact table
--==================================================

-- CHECK 1:  CHECK FOR DUPLICATES
Select dl.*, COUNT(*) AS RowCount 
From JARA_DB.RAW.DELIVERIES dl 
GROUP BY ALL
HAVING COUNT(*) > 1
ORDER BY RowCount DESC;

/* 9 duplicated delivery_id 
80449, 82677, 82565, 80182, 83186, 81275, 81982, 80602, 82558  --select * from JARA_DB.RAW.RIDERS where delivery_id = 80449

*/

--============================================================================

-- CHECK 2: Missing delivery_id
Select * from JARA_DB.RAW.DELIVERIES where DELIVERY_ID is NULL;  --No missing delivery_id


--==================================================================================

-- CHECK 3: Missing customer_id
Select * from JARA_DB.RAW.DELIVERIES where CUSTOMER_ID is NULL;  
/* 6 delivery_ids missing customer information
80283, 82426, 80342, 81239, 82388, 82303
*/
--==================================================================================

-- CHECK 4: INCONSISTENT STATUS (Delivered, delivered) VALUES 
SELECT status, COUNT(*) AS RowCount
FROM JARA_DB.RAW.DELIVERIES 
GROUP BY status
ORDER BY RowCount DESC;

SELECT  count(distinct DELIVERY_ID) as CountAffectedTransaction  
FROM JARA_DB.RAW.DELIVERIES WHERE status = 'Delivered';  -- 12 Records affected



--========================================================================================
-- CHECK 5: INCONSISTENT STATUS (failed, Failed) VALUES 


SELECT * FROM JARA_DB.RAW.DELIVERIES WHERE status = 'Failed';  -- 5 Records affected




--====================================================


-- CHECK 6: IMPOSSIBLE Distance (KM) VALUES 
SELECT MIN(DISTANCE_KM) AS smallest, MAX(DISTANCE_KM) AS largest 
FROM JARA_DB.RAW.DELIVERIES;
/*
Smallest distance = 1.2 KM
Largest Distance = 26100.00 KM   --Impossible distance, the distance from Lagos Nigeria to heathrow airport UK is about 5,000 KM
*/

 ----------------------- /* Check for the minimum, maximum and average distances (KM) in October for all Pick-Up Cities */  -------------
Select 
 -- distance_km Lagos in October -----
MIN(CASE WHEN LOWER(PICKUP_CITY) = 'lagos' THEN DISTANCE_KM END) AS "minimum_distance_lagos_october",
MAX(CASE WHEN LOWER(PICKUP_CITY) = 'lagos' THEN DISTANCE_KM END) AS "maximum_distance_lagos_october",
ROUND(AVG(CASE WHEN LOWER(PICKUP_CITY) = 'lagos' THEN DISTANCE_KM END), 2) AS "average_distance_lagos_october",

 -- distance_km Port Harcourt in October -----
MIN(CASE WHEN PICKUP_CITY LIKE '%Port Harcourt%' THEN DISTANCE_KM END) AS "minimum_distance_ph_october",
MAX(CASE WHEN PICKUP_CITY LIKE '%Port Harcourt%' THEN DISTANCE_KM END) AS "maximum_distance_ph_october",
ROUND(AVG(CASE WHEN PICKUP_CITY LIKE '%Port Harcourt%' THEN DISTANCE_KM END), 2) AS "average_distance_ph_october",

 -- distance_km abuja in October -----
MIN(CASE WHEN LOWER(PICKUP_CITY) = 'abuja' THEN DISTANCE_KM END) AS "minimum_distance_abuja_october",
MAX(CASE WHEN LOWER(PICKUP_CITY) = 'abuja' THEN DISTANCE_KM END) AS "maximum_distance_abuja_october",
ROUND(AVG(CASE WHEN LOWER(PICKUP_CITY) = 'abuja' THEN DISTANCE_KM END), 2) AS "average_distance_abuja_october",

 -- distance_km Ibadan in October -----
MIN(CASE WHEN LOWER(PICKUP_CITY) = 'ibadan' THEN DISTANCE_KM END) AS "minimum_distance_ibadan_october",
MAX(CASE WHEN LOWER(PICKUP_CITY) = 'ibadan' THEN DISTANCE_KM END) AS "maximum_distance_ibadan_october",
ROUND(AVG(CASE WHEN LOWER(PICKUP_CITY) = 'ibadan' THEN DISTANCE_KM END), 2) AS "average_distance_ibadan_october",

 -- distance_km kano in October -----
MIN(CASE WHEN LOWER(PICKUP_CITY) = 'kano' THEN DISTANCE_KM END) AS "minimum_distance_kano_october",
MAX(CASE WHEN LOWER(PICKUP_CITY) = 'kano' THEN DISTANCE_KM END) AS "maximum_distance_kano_october",
ROUND(AVG(CASE WHEN LOWER(PICKUP_CITY) = 'kano' THEN DISTANCE_KM END), 2) AS "average_distance_kano_october"

From JARA_DB.RAW.DELIVERIES
where MONTH(Created_at) = 12
--AND Status IN ('delivered') 
--AND Status IN ('delivered', 'completed') 
AND FLEET LIKE '%partner%'

-----Capture Delivery_ids with distance_km over 41.0km (max possible distance_km between October - December )
Select Count(*) As RowCount From JARA_DB.RAW.DELIVERIES Where DISTANCE_KM > 41.0
/* 107 Delivery_ids are having impossible DISTANCE_KM values, mostly in the 1000s */

/* How spread-out is the issue */
SELECT
MONTH(Created_at)              AS month,
TO_CHAR(Created_at, 'MM-YYYY') AS monthyear,
COUNT(*) As RowCount
FROM JARA_DB.RAW.DELIVERIES Where DISTANCE_KM > 41.0
GROUP BY ALL
ORDER BY  month;

/* The issue is concentrated on the November delivery records */




--==================================================
--CHECK 7: Check for invalid/unmapped Rider_ID
WITH cte_rid AS (SELECT
dl.delivery_id,
dl.created_at,
dl.customer_id,
dl.rider_id,
dl.pickup_city,
dl.distance_km,
dl.delivery_fee,
dl.status,
CASE WHEN dl.rider_id = rd.rider_id THEN 'Y'
ELSE 'N' END AS "Rider_existence"
FROM JARA_DB.RAW.DELIVERIES dl
LEFT JOIN JARA_DB.RAW.RIDERS  rd 
   ON dl.rider_id = rd.rider_id
--where MONTH(dl.created_at) = 11
) select * from cte_rid where "Rider_existence" = 'N';

/* Rider_Id 9999 is not properly mapped in the riders dimension table. 4 delivery_ids are impacted by the unmapped rider_id 
- 80324
- 80985
- 82059
- 80386
*/