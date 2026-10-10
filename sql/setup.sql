-- =====================================================================
-- Delivery Delay Analysis  
-- =====================================================================

DROP DATABASE IF EXISTS delivery_db;
CREATE DATABASE delivery_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE delivery_db;

-- ---------------------------------------------------------------------
-- Lookup table: one row per route
-- ---------------------------------------------------------------------
CREATE TABLE routes (
    route_id VARCHAR(10) NOT NULL,          
    route VARCHAR(50) NOT NULL,
    service_type VARCHAR(20) NOT NULL,
    CONSTRAINT pk_routes PRIMARY KEY (route_id)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- Fact table: 
-- ---------------------------------------------------------------------
CREATE TABLE deliveries (
    record_id INT NOT NULL,        
    month VARCHAR(3) NOT NULL,         
    route_id VARCHAR(10) NOT NULL,         
    hub VARCHAR(20) NOT NULL,
    promised_days INT NOT NULL,         
    actual_days INT NOT NULL,        
    CONSTRAINT pk_deliveries PRIMARY KEY (record_id), 
    CONSTRAINT fk_deliveries_route
        FOREIGN KEY (route_id) REFERENCES routes (route_id),
    CONSTRAINT chk_month CHECK (month IN ('Jan', 'Feb', 'Mar'))
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- Load lookup data 
-- ---------------------------------------------------------------------
INSERT INTO routes (route_id, route, service_type) VALUES
    ('R1', 'Metro Link','Express'),
    ('R2', 'City Dash','Express'),
    ('R3', 'Highway Freight','Standard'),
    ('R4', 'Rural Feeder','Standard');

-- ---------------------------------------------------------------------
-- Load fact data 
-- ---------------------------------------------------------------------
INSERT INTO deliveries (record_id, month, route_id, hub, promised_days, actual_days) VALUES
    ( 1, 'Jan', 'R1', 'Mumbai',  2,  2),
    ( 2, 'Jan', 'R2', 'Chennai', 3,  4),
    ( 3, 'Jan', 'R3', 'Delhi',   5,  8),
    ( 4, 'Jan', 'R4', 'Mumbai',  6, 10),
    ( 5, 'Feb', 'R1', 'Chennai', 2,  5),
    ( 6, 'Feb', 'R2', 'Delhi',   3,  3),
    ( 7, 'Feb', 'R3', 'Delhi',   5, 10),
    ( 8, 'Feb', 'R4', 'Chennai', 6,  7),
    ( 9, 'Mar', 'R1', 'Delhi',   2,  8),
    (10, 'Mar', 'R2', 'Mumbai',  3,  5),
    (11, 'Mar', 'R3', 'Chennai', 5,  5),
    (12, 'Mar', 'R4', 'Mumbai',  6, 15);

-- ---------------------------------------------------------------------
-- Row-count check
-- ---------------------------------------------------------------------
SELECT 'deliveries' AS table_name, COUNT(*) AS row_count FROM deliveries
UNION ALL
SELECT 'routes', COUNT(*) FROM routes;
