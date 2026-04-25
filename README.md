# Airbnb-Database-Management-System
Airbnb Database Management System

## 1.	Prerequisites	
To run this database, you must have a local or remote MySQL Server installed, along with a client interface such as MySQL Workbench.
Step 1: Extract the Files
### 1.	Download the provided final .zip submission folder.
### 2.	Extract the contents of the ZIP file to a known location on your computer.
### 3.	Locate the master SQL script file named  master.sql
## Step 2: Open the Database Client
### 1.	Launch MySQL Workbench.
### 2.	Connect to your local MySQL Server instance using your root or admin credentials.
## Step 3: Load the SQL Script
### 1.	In the top navigation bar of MySQL Workbench, click on File > Open SQL Script...
### 2.	Navigate to the extracted folder from Step 1 and select the master.sql file.
### 3.	The script will open in a new query tab.
## Step 4: Execute the Script
### 1.	The script is self-contained. It includes the commands DROP DATABASE IF EXISTS airbnb;, CREATE DATABASE airbnb;, and USE airbnb; at the very beginning to ensure a clean installation.
### 2.	Click the Lightning Bolt icon (Execute) in the toolbar to run the entire script.
### 3.	Observe the "Action Output" panel at the bottom of the screen to ensure all 23 tables were created and populated with 0 errors.
## Step 5: Verify the Installation
### 1.	In the "Schemas" panel on the left side of MySQL Workbench, click the refresh icon.
### 2.	Expand the newly created airbnb schema.
### 3.	Expand the "Tables" folder to verify that all 23 tables are present.
### 4.	To verify the data volume, open a new query tab and execute:   
```bash
SELECT * FROM booking;
```
 This will display the core transaction data to confirm the data insertion was successful.

