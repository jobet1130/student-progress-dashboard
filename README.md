# Student Progress Monitoring Dashboard

## Project Overview

The **Student Progress Monitoring Dashboard** provides an in-depth tool for educational institutions to track and analyze student performance across different dimensions such as **grades**, **attendance**, **feedback**, and more. This project utilizes SQL databases to store, manipulate, and report on student data, helping educators monitor student progress effectively. The dashboard also includes several advanced features such as **custom views**, **user-defined functions**, **triggers**, and **stored procedures** to ensure data integrity and offer meaningful insights.

## Table of Contents

- [Project Overview](#project-overview)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
  - [Prerequisites](#prerequisites)
  - [Steps to Setup](#steps-to-setup)
- [Database Schema](#database-schema)
  - [Tables](#tables)
  - [Constraints](#constraints)
  - [Views](#views)
  - [Functions](#functions)
  - [Procedures](#procedures)
  - [Triggers](#triggers)
- [Queries](#queries)
  - [Sample Queries](#sample-queries)
- [Environment Variables](#environment-variables)
- [License](#license)

---

## Project Structure
student-progress-dashboard/
│
├── 📁 sql/                               # SQL Scripts for setup and database components
│   ├── 📁 01_types/                     # Type definitions (ENUMs)
│   ├── 📁 02_tables/                    # Table creation scripts
│   ├── 📁 03_constraints/               # Foreign key and constraints scripts
│   ├── 📁 04_data/                      # Sample data inserts
│   ├── 📁 05_views/                     # Views for performance metrics
│   ├── 📁 06_functions/                 # SQL functions (e.g., GPA calculation)
│   ├── 📁 07_procedures/                # Stored procedures (e.g., grade update)
│   ├── 📁 08_triggers/                  # Triggers (e.g., audit logs)
│   ├── 📁 09_indexes/                   # Index optimization scripts
│   └── 📄 10_master.sql                 # Master script to execute everything in order
│
├── 📁 docs/                              # Project Documentation
│   ├── 📄 ERD.png                       # Entity Relationship Diagram (ERD)
│   ├── 📄 schema_description.md         # Detailed schema explanation
│   └── 📄 function_reference.md         # Reference for functions and procedures
│
├── 📁 dashboard/                         # Metabase configuration
│   ├── 📄 metabase_config.json          # Sample Metabase configuration
│   └── 📄 sample_queries.sql            # Aggregations & metrics queries
│
├── 📁 tests/                             # Unit tests
│   └── 📄 unit_test_cases.sql           # Test cases for views/functions
│
├── 📄 setup.sh                          # Bash script for DB setup
├── 📄 .env                              # Environment variables for DB setup
├── 📄 README.md                         # Project overview and guide
└── 📄 LICENSE                           # Project license



---

## Setup Instructions

### Prerequisites

Before setting up the project, ensure you have the following:

- A MySQL or PostgreSQL database system installed and running.
- Access credentials to create a new database and tables.
- A shell environment to run the setup script (`setup.sh`).

### Steps to Setup

1. **Clone the Repository**  
   Clone this repository to your local machine:
   ```bash
   git clone https://github.com/jobet1130/student-progress-dashboard.gitstudent-progress-dashboard.git
   cd student-progress-dashboard

2. **Configure Environment Variables**
    Create or update the **.env** file with your database credentials:
    ```bash
    DB_HOST=localhost
    DB_USER=root
    DB_PASSWORD=
    DB_NAME=student-dashboard

3. **Run the Setup Script**
    Run the **setup.sh** script to set up the database and its components. This will create the necessary **tables**, **views**, **functions**, **procedures**, and **insert sample data**:
    ```bash
    bash setup.sh

4. **Verify Database Setup**
    Once the setup is complete, you can verify by running the queries or checking the created tables in the database.

# Database Schema
The schema for the **Student Progress Monitoring Dashboard** includes several tables, views, functions, procedures, and triggers.

#### Tables

The database consists of the following tables, which store information related to students, courses, attendance, grades, and feedback:

- **students:** Stores student details (e.g., name, age, enrollment date).
- **teachers:** Stores teacher details (e.g., name, department).
- **courses:** Defines the courses offered in the institution.

- **enrollments:** Tracks student enrollments in courses.

- **grades:** Stores student grades for each course.

- **attendance:** Stores attendance records for each student.

- **feedback:** Stores feedback provided by students for their teachers.

#### Constraints
Foreign Key constraints are applied across tables to ensure referential integrity. For instance:
- **enrollments.student_id** references **student_id**
- **grades.student_id** references **students.id**
- **attendance.student_id** references **students.id**

These constraints are defined in the **03_constraints/foreign_keys.sql** file

#### Views
Views are predefined queries that aggragate and present data. Key views include:
- **student_performance_view:** Combines grades and attendance to give an overall picture of student performance.
- **at_risk_students_view:** Flags students who are at risk due to low GPA or poor attendance.
- **top_teachers_view:** Displays top-performing teachers based on student feedback.

#### Functions
Functions are used to calculate metrics or retrieve specific data. Notable functions include:
- **calc_attendance_percentage:** Calculates the attendance percentage for a given student.
- **get_student_gpa:** Computes the GPA of a student based on their grades.
- **get_flagged_students:** Returns a list of students flagged for poor performance.

#### Procedures
Procedures automate tasks or updates in the database. Key stored procedures include:
- **update_grade_and_log:** Updates the student's grade and logs the change for auditing purposes.
- **insert_attendance_bulk:** Inserts bulk attendance data, useful for large student cohorts.

#### Triggers
Triggers are used to automate actions when certain conditions are met. Examples:
- **audit_grade_changes:** Tracks changes made to grades and stores the old and new values.
- **create_triggers.sql:** Includes various triggers for auditing and validation.

# Queries
Sample queries that you can run to retrieve data from the database:
1. #### View Student Performance
    This query retrieves overall performance by combining grades and attendance:
    ```bash
    SELECT * FROM student_performance_view;

2. #### Identify At-Risk Students
    Retrieve students who are at risk based on low GPA or poor attendance:
    ```bash
    SELECT * FROM at_risk_students_view;

3. #### Get Top Teachers
    Get Top Teachers
    ```bash
    SELECT * FROM top_teachers_view;
You can modify these queries or use them to generate reports in your dashboard.

# Enviroment Variables
The following environment variables need to be defined in the **.env file** for proper database configuration:
DB_HOST: The host of your database (e.g., localhost or a remote IP address).

- **DB_USER:** The username to connect to the database.
- **DB_PASSWORD:** The password for the database user.
- **DB_NAME:** The name of the database to use for the dashboard.

### License
This project is licensed under the MIT License. See the **LICENSE** file for more details.

## Conclusion
The **Student Progress Monitoring Dashboard** is a comprehensive system for tracking student progress, utilizing SQL for data storage and manipulation. By following the setup instructions, you can easily deploy the database and begin generating insights on student performance. The use of advanced SQL techniques, including functions, stored procedures, and triggers, ensures that the system is both robust and efficient for managing educational data.


### Key Sections:

1. **Project Overview**: Provides a clear description of what the project is about.
2. **Table of Contents**: Easy navigation to different sections of the README.
3. **Project Structure**: Detailed breakdown of the project’s file structure, making it easier for others to understand and navigate.
4. **Setup Instructions**: Step-by-step guide to set up the project, including prerequisites, environment configuration, and script execution.
5. **Database Schema**: Describes the tables, constraints, views, functions, procedures, and triggers in detail, with links to related documentation.
6. **Queries**: Sample queries that users can run to retrieve data from the database.
7. **Environment Variables**: Clearly outlines the necessary configuration for database access.
8. **License**: Mentions the licensing of the project.

This version is entirely in Markdown format and follows best practices for documentation, making it easy to set up, understand, and use the project.
