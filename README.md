# Airbnb-Database-Management-System
# Airbnb Database Management System

## Overview
This project provides a complete Airbnb database setup using MySQL. The database can be initialized using a single SQL script.

---

## 1. Prerequisites
To run this database, you need:

- A local or remote **MySQL Server**
- A database client such as **MySQL Workbench**

---

## 2. Setup Instructions

### Step 1: Extract the Files
1. Download the provided final `.zip` submission folder  
2. Extract the contents to a known location on your computer  
3. Locate the master SQL script file:


---

### Step 2: Open the Database Client
1. Launch **MySQL Workbench**  
2. Connect to your MySQL Server using root/admin credentials  

---

### Step 3: Load the SQL Script
1. In the top menu, click:  
**File > Open SQL Script...**  
2. Navigate to the extracted folder  
3. Select the file:
```bash
master.sql
```
4. The script will open in a new query tab

### Step 4: Execute the Script
1. The script is self-contained and includes:
```bash
DROP DATABASE IF EXISTS airbnb;
CREATE DATABASE airbnb;
USE airbnb;
```
2. Click the ⚡ Execute (Lightning Bolt) button
3. Check the Action Output panel to confirm:
_ All 23 tables created
_ No errors

### Step 5: Verify the Installation

1. In the Schemas panel (left side), click refresh
2. Expand the newly created: airbnb
3. Open the Tables folder to confirm all tables exist
4. To verify data, run the following query:
```bash
SELECT * FROM booking;
```
This will display booking records and confirm successful data insertion.

### Notes
_ The script automatically resets the database before installation
_ Make sure you have proper permissions to create databases
