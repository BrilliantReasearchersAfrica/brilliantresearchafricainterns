# Fire Suppression IoT Monitoring Platform Database

## Project Description

This project provides a database design and implementation for a Fire Suppression IoT Monitoring Platform. The system is designed to manage devices, buildings, events, and administrators, facilitating efficient monitoring and management of fire suppression activities. The database is built using PostgreSQL (or MySQL, as the SQL syntax is largely compatible) and includes an Entity-Relationship Diagram (ERD), SQL scripts for database creation, table definitions, sample data insertion, and advanced querying capabilities. Additionally, it addresses data security, optimization, scalability, and explores the use of NoSQL for real-time sensor data.




## Schema Explanation

The database schema is designed to represent the core entities and their relationships within the Fire Suppression IoT Monitoring Platform. The Entity-Relationship Diagram (ERD) visually depicts these components:

ERD for Fire Suppression IoT Monitoring Platform can be found in the project folder.

### Entities and Their Attributes:

*   **Buildings:** Represents physical locations where devices are installed.
    *   `Building_ID` (Primary Key): Unique identifier for each building.
    *   `Name`: Name of the building (e.g., 'Headquarters').
    *   `Location`: Physical address or description of the building's location.

*   **Devices:** Represents the fire detection and suppression devices.
    *   `Device_ID` (Primary Key): Unique identifier for each device.
    *   `Name`: Name of the device (e.g., 'Smoke Detector 001').
    *   `Type`: Type of device (e.g., 'Smoke', 'Heat', 'Sprinkler').
    *   `Status`: Current operational status of the device (e.g., 'Active', 'Inactive').
    *   `Building_ID` (Foreign Key): Links the device to the building it is installed in.

*   **Events:** Records data reported by devices, such as temperature readings, alarms, or suppression activations.
    *   `Event_ID` (Primary Key): Unique identifier for each event.
    *   `Device_ID` (Foreign Key): Links the event to the device that reported it.
    *   `Timestamp`: Date and time when the event occurred.
    *   `Type`: Type of event (e.g., 'Temperature Reading', 'Alarm', 'Suppression Activated').
    *   `Value`: The value associated with the event (e.g., temperature reading, boolean for alarm/suppression).

*   **Admins:** Stores information about the BRA team members managing the system.
    *   `Admin_ID` (Primary Key): Unique identifier for each administrator.
    *   `Username`: Unique username for login.
    *   `Password`: Hashed password for security.
    *   `Role`: Role of the administrator (e.g., 'Super Admin', 'Technician'), used for access control.

### Relationships:

*   **One-to-Many (1:M) between Buildings and Devices:** A single building can have multiple devices installed, but each device belongs to only one building. This is enforced by the `Building_ID` foreign key in the `Devices` table.

*   **One-to-Many (1:M) between Devices and Events:** A single device can report multiple events over time, but each event is reported by only one device. This is enforced by the `Device_ID` foreign key in the `Events` table.




## Example Queries Explanation

The `advanced_queries.sql` file contains several SQL queries demonstrating how to retrieve specific information from the database:

1.  **Retrieve all events from devices installed in a specific building:** This query joins the `Events`, `Devices`, and `Buildings` tables to filter events based on the building name. This is useful for monitoring activities in a particular location.

2.  **Get the latest event status of each device:** This query uses a subquery to find the maximum timestamp for each device, then retrieves the corresponding event details. This allows for quick access to the most recent data from every device.

3.  **Count how many times each device triggered a suppression in the last month:** This query filters events by type (
    `'Suppression Activated'`
) and a specified time range (last month), then groups the results by device to count suppression events. This provides insights into device performance and potential issues.

4.  **List buildings with no devices installed:** This query uses a `LEFT JOIN` between `Buildings` and `Devices` and filters for `NULL` device IDs to identify buildings that are not yet equipped with any devices. This helps in identifying locations that need device deployment.

5.  **Retrieve admin usernames and roles who have access to the system:** A simple query to fetch the usernames and roles from the `Admins` table, useful for auditing user access and permissions.




## Data Security & Optimization Notes

### Data Security

Ensuring the security of the Fire Suppression IoT Monitoring Platform database is paramount. Several approaches can be implemented:

*   **User Authentication:** All access to the database should be authenticated.

*   **Role-Based Access Control (RBAC):** Implement RBAC to restrict access to data and functionalities based on the user's role. 

*   **Data Encryption at Rest:** Encrypt sensitive data stored in the database (e.g., passwords, potentially location data) to protect it from unauthorized access even if the underlying storage is compromised. 

*   **Data Encryption in Transit:** Secure communication between the IoT devices, the application, and the database using protocols like SSL/TLS. This prevents eavesdropping and tampering of data as it travels across networks.

*   **Regular Security Audits and Monitoring:** Continuously monitor database activity for suspicious patterns and conduct regular security audits to identify and address vulnerabilities.

### Indexing Strategies

Indexing is crucial for improving query performance, especially as the database grows. Here are some recommended strategies:

*   **Primary and Foreign Key Indexes:** Database systems automatically create indexes on primary keys. It's also highly recommended to create indexes on foreign keys (`Building_ID` in `Devices`, `Device_ID` in `Events`) as these columns are frequently used in `JOIN` operations.

*   **Indexes on Frequently Queried Columns:** Columns used in `WHERE` clauses, `ORDER BY` clauses, or `GROUP BY` clauses should be considered for indexing. For example, `Events.Timestamp` would benefit from an index for time-based queries (e.g., "events in the last month"). `Devices.Type` and `Devices.Status` could also be indexed if filtering by these attributes is common.

*   **Composite Indexes:** For queries that filter on multiple columns, a composite index (an index on multiple columns) can be more efficient than separate indexes. For example, an index on `(Device_ID, Timestamp)` for the `Events` table could optimize queries that look for specific events from a device within a time range.

*   **Consider Index Type:** Choose appropriate index types (e.g., B-tree, Hash) based on the data type and query patterns. B-tree indexes are generally good for a wide range of queries, including range searches.

*   **Avoid Over-Indexing:** While indexes improve read performance, they add overhead to write operations (INSERT, UPDATE, DELETE) as indexes need to be updated. Over-indexing can also consume significant storage space. A balanced approach is necessary.

### Scalability

Scaling the database system to handle thousands of devices and events per day requires careful planning:

*   **Vertical Scaling (Up):** Upgrade the hardware (CPU, RAM, storage) of the database server. This is often the first step but has limitations.

*   **Horizontal Scaling (Out):** Distribute the database across multiple servers. This can involve:
    *   **Replication:** Create read replicas of the database to distribute read traffic. This is particularly useful for analytical queries that don't require real-time consistency.
    *   **Sharding/Partitioning:** Divide the data into smaller, more manageable chunks (shards) and distribute them across different servers. For this system, data could be sharded by `Building_ID` or `Device_ID`, or even by time for event data. This significantly improves write performance and query performance for sharded queries.

*   **Connection Pooling:** Efficiently manage database connections from the application to reduce overhead and improve responsiveness.

*   **Caching:** Implement caching mechanisms (e.g., Redis, Memcached) for frequently accessed static or slowly changing data to reduce database load.

*   **Asynchronous Processing:** For high-volume event ingestion, consider using message queues (e.g., Kafka, RabbitMQ) to decouple event producers (devices) from the database. Events can be queued and then processed in batches, reducing the direct write load on the database.

*   **Database Optimization:** Regularly review and optimize SQL queries, ensure proper indexing, and maintain database statistics to help the query optimizer make efficient execution plans.

*   **Cloud-Native Database Services:** Utilize managed database services from cloud providers (e.g., AWS RDS, Google Cloud SQL, Azure Database) that offer built-in scalability, high availability, and automated management features.




## NoSQL Database Structure for Real-time Sensor Data (MongoDB Example)

While a relational database is excellent for structured data and complex relationships, NoSQL databases, particularly document-oriented databases like MongoDB, are well-suited for handling real-time sensor data streams due to their flexibility, scalability, and ability to handle high volumes of unstructured or semi-structured data.

### JSON Document Example for a Temperature Reading Event:

```json
{
  "device_id": "DEV001",
  "building_id": "BLD001",
  "timestamp": "2025-07-05T14:30:00.123Z",
  "event_type": "temperature_reading",
  "value": 25.7,
  "unit": "celsius",
  "location": {
    "latitude": 34.0522,
    "longitude": -118.2437
  },
  "sensor_metadata": {
    "manufacturer": "SensorCorp",
    "model": "TempSense-X1",
    "calibration_date": "2025-01-15"
  }
}
```

This JSON document represents a single temperature reading event. Key characteristics include:

*   **Flexibility:** New fields can be added to documents without altering a predefined schema, which is ideal for evolving sensor data.
*   **Nested Structures:** `location` and `sensor_metadata` are embedded documents, allowing for rich, hierarchical data representation.
*   **Timestamp:** Crucial for time-series data, often indexed for efficient querying.

### Explanation Why NoSQL May Be Chosen for This Use-Case Alongside Relational Databases:

NoSQL databases offer several advantages for real-time sensor data streams:

1.  **High Ingestion Rate:** Sensor data often comes in at a very high velocity. NoSQL databases are designed for high write throughput, making them suitable for ingesting massive amounts of data quickly without strict schema validation overhead.

2.  **Flexible Schema:** Sensor data can be diverse and evolve over time. Different devices might report different types of data with varying attributes. NoSQL databases, especially document stores, offer schema flexibility, allowing new data points or sensor types to be added easily without requiring schema migrations, which can be disruptive in relational databases.

3.  **Scalability:** NoSQL databases are inherently designed for horizontal scalability, meaning they can easily distribute data across many servers (sharding) to handle increasing data volumes and traffic. This is critical for IoT platforms that can grow to thousands or millions of devices.

4.  **Handling Unstructured/Semi-structured Data:** Sensor data can sometimes be unstructured or semi-structured. NoSQL databases are adept at storing and querying such data without forcing it into a rigid tabular format.

5.  **Time-Series Data Optimization:** Many NoSQL databases have features or patterns optimized for time-series data, allowing for efficient storage and querying of data based on time ranges.

6.  **Reduced Joins:** For analytical queries on raw sensor data, NoSQL databases often allow for denormalization, where related data is embedded within a single document. This reduces the need for complex joins, which can be performance-intensive in relational databases when dealing with large datasets.

In a hybrid approach, the relational database (PostgreSQL/MySQL) could manage the core, structured data like `Buildings`, `Devices`, and `Admins` (master data), where data integrity and complex transactional queries are critical. The NoSQL database (MongoDB) would then handle the high-volume, real-time `Event` data, leveraging its strengths for rapid ingestion and flexible querying of sensor readings. This allows each database type to be used for its optimal purpose.



