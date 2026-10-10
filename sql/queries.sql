-- =====================================================================
--  Delivery Delay Analysis  
-- =====================================================================

USE delivery_db;

-- =====================================================================
-- S2a - Total delay_days by service type
-- =====================================================================
SELECT
    r.service_type,
    SUM(GREATEST(d.actual_days - d.promised_days, 0)) AS total_delay_days
FROM deliveries AS d
JOIN routes AS r ON r.route_id = d.route_id
GROUP BY r.service_type
ORDER BY total_delay_days DESC;

-- =====================================================================
-- S2b - Routes with significant delay
-- =====================================================================
SELECT
    d.route_id,
    r.route,
    SUM(GREATEST(d.actual_days - d.promised_days, 0)) AS total_delay_days
FROM deliveries AS d
JOIN routes     AS r ON r.route_id = d.route_id
GROUP BY d.route_id, r.route
HAVING SUM(GREATEST(d.actual_days - d.promised_days, 0)) > 8
ORDER BY total_delay_days DESC, d.route_id;

-- =====================================================================
-- S2c - Top two hubs by summed delay_days
-- =====================================================================
SELECT
    d.hub,
    SUM(GREATEST(d.actual_days - d.promised_days, 0)) AS total_delay_days
FROM deliveries AS d
GROUP BY d.hub
ORDER BY total_delay_days DESC, d.hub ASC
LIMIT 2;

-- =====================================================================
-- S3 - Data integrity check (LEFT JOIN deliveries)
-- Counts fact rows whose route_id has NO matching lookup row.
-- =====================================================================
SELECT
    COUNT(*) AS total_fact_rows,
    SUM(CASE WHEN r.route_id IS NULL THEN 1 ELSE 0 END) AS unmatched_keys
FROM deliveries AS d
LEFT JOIN routes AS r ON r.route_id = d.route_id;

-- Row-level view of any unmatched keys 
SELECT d.record_id, d.route_id
FROM deliveries AS d
LEFT JOIN routes AS r ON r.route_id = d.route_id
WHERE r.route_id IS NULL;
