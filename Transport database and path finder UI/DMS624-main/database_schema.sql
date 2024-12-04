
CREATE DATABASE IF NOT EXISTS transit_system;
USE transit_system;


CREATE TABLE IF NOT EXISTS languages (
    language_code CHAR(2) PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL
);


CREATE TABLE IF NOT EXISTS corporations (
    corporation_id INT AUTO_INCREMENT PRIMARY KEY,
    corporation_name VARCHAR(100) NOT NULL,
    corporation_url VARCHAR(200),
    language_code CHAR(2) NOT NULL,
    corporation_phone VARCHAR(20),
    FOREIGN KEY (language_code) REFERENCES languages(language_code)
);


CREATE TABLE IF NOT EXISTS stops (
    stop_id INT AUTO_INCREMENT PRIMARY KEY,
    stop_code VARCHAR(10),
    stop_name VARCHAR(100) NOT NULL,
    stop_desc VARCHAR(200),
    latitude DECIMAL(10,6) NOT NULL,
    longitude DECIMAL(10,6) NOT NULL,
    zone_id INT,
    stop_url VARCHAR(200),
    stop_type TINYINT(1) NOT NULL CHECK (stop_type IN (0,1))
);


CREATE TABLE IF NOT EXISTS routes (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    corporation_id INT NOT NULL,
    short_route_name VARCHAR(50) NOT NULL,
    long_route_name VARCHAR(100),
    route_desc VARCHAR(200),
    route_type TINYINT(1) NOT NULL CHECK (route_type BETWEEN 0 AND 7),
    route_url VARCHAR(200),
    route_color CHAR(6),
    FOREIGN KEY (corporation_id) REFERENCES corporations(corporation_id)
);


CREATE TABLE IF NOT EXISTS services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    monday TINYINT(1) NOT NULL,
    tuesday TINYINT(1) NOT NULL,
    wednesday TINYINT(1) NOT NULL,
    thursday TINYINT(1) NOT NULL,
    friday TINYINT(1) NOT NULL,
    saturday TINYINT(1) NOT NULL,
    sunday TINYINT(1) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);


CREATE TABLE IF NOT EXISTS trips (
    trip_id INT AUTO_INCREMENT PRIMARY KEY,
    service_id INT NOT NULL,
    route_id INT NOT NULL,
    trip_headsign VARCHAR(100),
    trip_short_name VARCHAR(50),
    direction_id TINYINT(1) NOT NULL CHECK (direction_id IN (0,1)),
    block_id INT,
    FOREIGN KEY (service_id) REFERENCES services(service_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);


CREATE TABLE IF NOT EXISTS stop_times (
    trip_id INT NOT NULL,
    arrival_time TIME NOT NULL,
    departure_time TIME NOT NULL,
    stop_id INT NOT NULL,
    stop_sequence INT NOT NULL,
    pickup_type TINYINT(1) NOT NULL CHECK (pickup_type BETWEEN 0 AND 3),
    drop_off_type TINYINT(1) NOT NULL CHECK (drop_off_type BETWEEN 0 AND 3),
    PRIMARY KEY (trip_id, stop_sequence),
    FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
    FOREIGN KEY (stop_id) REFERENCES stops(stop_id)
);


CREATE TABLE IF NOT EXISTS fare_attributes (
    fare_id INT AUTO_INCREMENT PRIMARY KEY,
    price INT NOT NULL, 
    currency_type CHAR(3) NOT NULL,
    payment_method TINYINT(1) NOT NULL CHECK (payment_method IN (0,1)),
    transfers TINYINT(1) NOT NULL CHECK (transfers BETWEEN 0 AND 2)
);


CREATE TABLE IF NOT EXISTS fare_rules (
    fare_rule_id INT AUTO_INCREMENT PRIMARY KEY,
    fare_id INT NOT NULL,
    route_id INT,
    origin_id INT NULL,
    destination_id INT NULL,
    FOREIGN KEY (fare_id) REFERENCES fare_attributes(fare_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id),
    FOREIGN KEY (origin_id) REFERENCES stops(stop_id),
    FOREIGN KEY (destination_id) REFERENCES stops(stop_id)
);


CREATE TABLE IF NOT EXISTS tyre_inventory (
    tyre_id INT AUTO_INCREMENT PRIMARY KEY,
    bus_id INT NOT NULL,
    tyre_condition VARCHAR(20) NOT NULL,
    stock_quantity INT NOT NULL,
    last_updated DATE NOT NULL
);


CREATE TABLE IF NOT EXISTS stop_distances (
    from_stop_id INT,
    to_stop_id INT,
    distance INT NOT NULL,
    PRIMARY KEY (from_stop_id, to_stop_id),
    FOREIGN KEY (from_stop_id) REFERENCES stops(stop_id),
    FOREIGN KEY (to_stop_id) REFERENCES stops(stop_id)
);
