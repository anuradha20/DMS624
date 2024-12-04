USE transit_system;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE languages;
TRUNCATE TABLE corporations;
TRUNCATE TABLE stops;
TRUNCATE TABLE routes;
TRUNCATE TABLE services;
TRUNCATE TABLE trips;
TRUNCATE TABLE stop_times;
TRUNCATE TABLE fare_attributes;
TRUNCATE TABLE fare_rules;
TRUNCATE TABLE tyre_inventory;
TRUNCATE TABLE stop_distances;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO languages (language_code, language_name) VALUES
('EN', 'English'),
('ES', 'Spanish');

INSERT INTO corporations (corporation_name, corporation_url, language_code, corporation_phone) VALUES
('State Transit Corp', 'http://statetransit.example.com', 'EN', '123-456-7890'),
('City Transit Authority', 'http://citytransit.example.com', 'EN', '098-765-4321');

INSERT INTO stops (stop_code, stop_name, stop_desc, latitude, longitude, zone_id, stop_url, stop_type) VALUES
('ST001', 'Main Street Station', 'Central bus station', 40.712776, -74.005974, 1, 'http://statetransit.example.com/stops/1', 1),
('ST002', 'Second Avenue Stop', 'Near the mall', 40.713776, -74.005874, 1, 'http://statetransit.example.com/stops/2', 0),
('ST003', 'Third Street Stop', 'Residential area', 40.714776, -74.005774, 2, 'http://statetransit.example.com/stops/3', 0),
('ST004', 'Fourth Avenue', 'Office district', 40.715776, -74.005674, 2, 'http://statetransit.example.com/stops/4', 0),
('ST005', 'Fifth Street', 'University area', 40.716776, -74.005574, 3, 'http://statetransit.example.com/stops/5', 0),
('ST006', 'Sixth Avenue', 'Park entrance', 40.717776, -74.005474, 3, 'http://statetransit.example.com/stops/6', 0),
('ST007', 'Seventh Street', 'Museum district', 40.718776, -74.005374, 4, 'http://statetransit.example.com/stops/7', 0),
('ST008', 'Eighth Avenue', 'Stadium', 40.719776, -74.005274, 4, 'http://statetransit.example.com/stops/8', 0),
('ST009', 'Ninth Street', 'Suburb area', 40.720776, -74.005174, 5, 'http://statetransit.example.com/stops/9', 0),
('ST010', 'Tenth Avenue', 'Industrial zone', 40.721776, -74.005074, 5, 'http://statetransit.example.com/stops/10', 0),
('ST011', 'Eleventh Street', 'Airport', 40.722776, -74.004974, 6, 'http://statetransit.example.com/stops/11', 0),
('ST012', 'Twelfth Avenue', 'Harbor', 40.723776, -74.004874, 6, 'http://statetransit.example.com/stops/12', 0);

INSERT INTO routes (corporation_id, short_route_name, long_route_name, route_desc, route_type, route_url, route_color) VALUES
(1, 'R1', 'Route 1', 'Main Street to Sixth Avenue', 3, 'http://statetransit.example.com/routes/1', 'FF0000'),
(1, 'R2', 'Route 2', 'Second Avenue to Twelfth Avenue', 3, 'http://statetransit.example.com/routes/2', '00FF00'),
(2, 'R3', 'Route 3', 'Main Street to Twelfth Avenue via Ninth Street', 3, 'http://citytransit.example.com/routes/3', '0000FF'),
(2, 'R4', 'Route 4', 'Fourth Avenue to Eleventh Street', 3, 'http://citytransit.example.com/routes/4', 'FFFF00');

INSERT INTO services (monday, tuesday, wednesday, thursday, friday, saturday, sunday, start_date, end_date) VALUES
(1,1,1,1,1,1,1,'2023-01-01','2023-12-31');

INSERT INTO trips (service_id, route_id, trip_headsign, trip_short_name, direction_id, block_id) VALUES
(1, 1, 'Sixth Avenue', 'Trip 1', 0, 1),
(1, 2, 'Twelfth Avenue', 'Trip 2', 0, 2),
(1, 3, 'Twelfth Avenue', 'Trip 3', 0, 3),
(1, 4, 'Eleventh Street', 'Trip 4', 0, 4);


-- Trip 1: R1 from Main Street to Sixth Avenue
INSERT INTO stop_times (trip_id, arrival_time, departure_time, stop_id, stop_sequence, pickup_type, drop_off_type) VALUES
(1, '08:00:00', '08:05:00', 1, 1, 0, 0),
(1, '08:10:00', '08:10:00', 2, 2, 0, 0),
(1, '08:15:00', '08:15:00', 3, 3, 0, 0),
(1, '08:20:00', '08:20:00', 4, 4, 0, 0),
(1, '08:25:00', '08:25:00', 5, 5, 0, 0),
(1, '08:30:00', '08:30:00', 6, 6, 0, 0);

-- Trip 2: R2 from Second Avenue to Twelfth Avenue
INSERT INTO stop_times VALUES
(2, '09:00:00', '09:05:00', 2, 1, 0, 0),
(2, '09:10:00', '09:10:00', 7, 2, 0, 0),
(2, '09:15:00', '09:15:00', 8, 3, 0, 0),
(2, '09:20:00', '09:20:00', 9, 4, 0, 0),
(2, '09:25:00', '09:25:00', 10, 5, 0, 0),
(2, '09:30:00', '09:30:00', 11, 6, 0, 0),
(2, '09:35:00', '09:35:00', 12, 7, 0, 0);

-- Trip 3: R3 from Main Street to Twelfth Avenue via Ninth Street
INSERT INTO stop_times VALUES
(3, '10:00:00', '10:05:00', 1, 1, 0, 0),
(3, '10:10:00', '10:10:00', 3, 2, 0, 0),
(3, '10:15:00', '10:15:00', 5, 3, 0, 0),
(3, '10:20:00', '10:20:00', 7, 4, 0, 0),
(3, '10:25:00', '10:25:00', 9, 5, 0, 0),
(3, '10:30:00', '10:30:00', 12, 6, 0, 0);

-- Trip 4: R4 from Fourth Avenue to Eleventh Street
INSERT INTO stop_times VALUES
(4, '11:00:00', '11:05:00', 4, 1, 0, 0),
(4, '11:10:00', '11:10:00', 6, 2, 0, 0),
(4, '11:15:00', '11:15:00', 8, 3, 0, 0),
(4, '11:20:00', '11:20:00', 10, 4, 0, 0),
(4, '11:25:00', '11:25:00', 11, 5, 0, 0);

INSERT INTO fare_attributes (fare_id, price, currency_type, payment_method, transfers) VALUES
(1, 250, 'USD', 0, 0),
(2, 300, 'USD', 0, 1),
(3, 150, 'USD', 0, 0),
(4, 400, 'USD', 0, 2);

INSERT INTO fare_rules (fare_id, route_id, origin_id, destination_id) VALUES
(1, 1, NULL, NULL),
(2, 2, NULL, NULL),
(3, 3, NULL, NULL),
(4, 4, NULL, NULL);

INSERT INTO tyre_inventory (bus_id, tyre_condition, stock_quantity, last_updated) VALUES
(1, 'New', 50, '2023-01-01'),
(2, 'Used', 20, '2023-01-10'),
(3, 'Retread', 30, '2023-02-15'),
(4, 'New', 60, '2023-03-20');


DELIMITER $$

CREATE PROCEDURE insert_stop_distances()
BEGIN
    TRUNCATE TABLE stop_distances;
    INSERT INTO stop_distances (from_stop_id, to_stop_id, distance)
    SELECT DISTINCT
        st1.stop_id AS from_stop_id,
        st2.stop_id AS to_stop_id,
        ROUND(
            ST_Distance_Sphere(
                POINT(s1.longitude, s1.latitude),
                POINT(s2.longitude, s2.latitude)
            )
        ) AS distance
    FROM
        stop_times st1
    JOIN stop_times st2 ON st1.trip_id = st2.trip_id AND st2.stop_sequence = st1.stop_sequence + 1
    JOIN stops s1 ON st1.stop_id = s1.stop_id
    JOIN stops s2 ON st2.stop_id = s2.stop_id;
END$$

DELIMITER ;

CALL insert_stop_distances();

DROP PROCEDURE insert_stop_distances;
