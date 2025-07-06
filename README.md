BRA_Fire_Suppression Platform

Project Description
A database system for managing fire detection IoT devices, events, buildings, and admin users.
Schema Explanation
• Building: Stores info about buildings with devices.
• Device: Each installed device (e.g. sensor, alarm).
• Event: Events like alarms, temperature readings, and suppression activations.
• Admin: System managers with defined roles.
Security
• Passwords are stored as hashed values.
• Role-based access control (e.g., Super Admin, Technician).
• Recommend TLS/SSL for secure data transmission.
• Apply MySQL/MariaDB GRANTs for controlled access.
Optimization
Indexing on:
• device_id, timestamp (for faster event lookups)
• building_id in Devices
• Foreign key constraints maintain referential integrity.
Scalability
• Archive old events periodically to manage table size.
• Partition events table by time (e.g., monthly) or by device type.
• Consider using NoSQL (e.g., MongoDB) for high-speed real-time data ingestion from sensors.
