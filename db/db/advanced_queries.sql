-- Advanced Querying Tasks

-- 1. Retrieve all events from devices installed in a specific building (e.g., Headquarters)
SELECT
    E.*,
    D.Name AS DeviceName,
    B.Name AS BuildingName
FROM
    Events E
JOIN
    Devices D ON E.Device_ID = D.Device_ID
JOIN
    Buildings B ON D.Building_ID = B.Building_ID
WHERE
    B.Name = 'Headquarters';

-- 2. Get the latest event status of each device.
SELECT
    E.Device_ID,
    D.Name AS DeviceName,
    E.Type AS LatestEventType,
    E.Value AS LatestEventValue,
    E.Timestamp AS LatestEventTimestamp
FROM
    Events E
JOIN
    Devices D ON E.Device_ID = D.Device_ID
WHERE
    (E.Device_ID, E.Timestamp) IN (
        SELECT
            Device_ID,
            MAX(Timestamp)
        FROM
            Events
        GROUP BY
            Device_ID
    );

-- 3. Count how many times each device triggered a suppression in the last month.
-- Assuming 'last month' refers to the month prior to the current date (July 2025)
SELECT
    D.Name AS DeviceName,
    COUNT(E.Event_ID) AS SuppressionCount
FROM
    Events E
JOIN
    Devices D ON E.Device_ID = D.Device_ID
WHERE
    E.Type = 'Suppression Activated' AND E.Timestamp >= '2025-06-01 00:00:00' AND E.Timestamp < '2025-07-01 00:00:00'
GROUP BY
    D.Name;

-- 4. List buildings with no devices installed.
SELECT
    B.Name AS BuildingName
FROM
    Buildings B
LEFT JOIN
    Devices D ON B.Building_ID = D.Building_ID
WHERE
    D.Device_ID IS NULL;

-- 5. Retrieve admin usernames and roles who have access to the system.
SELECT
    Username,
    Role
FROM
    Admins;

