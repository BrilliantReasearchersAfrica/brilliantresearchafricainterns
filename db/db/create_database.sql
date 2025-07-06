CREATE DATABASE fire_suppression_iot;
USE fire_suppression_iot;




CREATE TABLE Buildings (
    Building_ID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Location VARCHAR(255) NOT NULL
);

CREATE TABLE Devices (
    Device_ID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(255) NOT NULL,
    Status VARCHAR(50) NOT NULL,
    Building_ID INT NOT NULL,
    FOREIGN KEY (Building_ID) REFERENCES Buildings(Building_ID)
);

CREATE TABLE Events (
    Event_ID SERIAL PRIMARY KEY,
    Device_ID INT NOT NULL,
    Timestamp TIMESTAMP NOT NULL,
    Type VARCHAR(255) NOT NULL,
    Value VARCHAR(255),
    FOREIGN KEY (Device_ID) REFERENCES Devices(Device_ID)
);

CREATE TABLE Admins (
    Admin_ID SERIAL PRIMARY KEY,
    Username VARCHAR(255) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Role VARCHAR(50) NOT NULL
);




-- Sample INSERT statements

INSERT INTO Buildings (Name, Location) VALUES
    ('Headquarters', '123 Tech Lane, Silicon Valley, USA'),
    ('Branch Office A', '456 Business Park, New York, USA'),
    ('Warehouse 1', '789 Industrial Road, London, UK');

INSERT INTO Devices (Name, Type, Status, Building_ID) VALUES
    ('Smoke Detector 001', 'Smoke', 'Active', 1),
    ('Heat Sensor 001', 'Heat', 'Active', 1),
    ('Sprinkler System 001', 'Sprinkler', 'Active', 2),
    ('Smoke Detector 002', 'Smoke', 'Inactive', 2),
    ('Heat Sensor 002', 'Heat', 'Active', 3);

INSERT INTO Events (Device_ID, Timestamp, Type, Value) VALUES
    (1, '2025-07-01 10:00:00', 'Temperature Reading', '22.5'),
    (1, '2025-07-01 10:05:00', 'Temperature Reading', '23.1'),
    (1, '2025-07-01 10:10:00', 'Alarm', 'True'),
    (2, '2025-07-01 10:00:00', 'Temperature Reading', '28.0'),
    (2, '2025-07-01 10:15:00', 'Alarm', 'True'),
    (3, '2025-07-01 10:20:00', 'Suppression Activated', 'True'),
    (4, '2025-07-01 10:25:00', 'Temperature Reading', '20.0'),
    (5, '2025-07-01 10:30:00', 'Temperature Reading', '24.5'),
    (5, '2025-07-01 10:35:00', 'Alarm', 'False'),
    (5, '2025-07-01 10:40:00', 'Temperature Reading', '25.0');

INSERT INTO Admins (Username, Password, Role) VALUES
    ('super_admin_faustin', 'hashed_password_1', 'Super Admin'),
    ('technician_john', 'hashed_password_2', 'Technician');

