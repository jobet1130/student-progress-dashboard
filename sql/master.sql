-- master.sql
-- This script will execute all components in the correct order

-- Step 1: Create Types (ENUMs)
-- These are basic data types used for enforcing specific values (e.g., attendance status).
-- Ensure types are created first before creating tables or inserting data.
source ./sql/types/types.sql;

-- Step 2: Create Tables
-- Create the main database tables that will hold student, teacher, course, grade, etc.
source ./sql/tables/students.sql;
source ./sql/tables/teachers.sql;
source ./sql/tables/courses.sql;
source ./sql/tables/enrollments.sql;
source ./sql/tables/grades.sql;
source ./sql/tables/attendance.sql;
source ./sql/tables/feedback.sql;

-- Step 3: Apply Constraints
-- This will include foreign keys and other constraints to maintain referential integrity.
source ./sql/constraints/foreign_keys.sql;

-- Step 4: Insert Sample Data
-- Insert sample data into the database so we have meaningful records for queries.
source ./sql/data/sample_data.sql;

-- Step 5: Create Views
-- Define views for common aggregations and performance metrics like student performance and at-risk students.
source ./sql/views/student_performance_view.sql;
source ./sql/views/at_risk_students_view.sql;
source ./sql/views/top_teachers_view.sql;

-- Step 6: Create Functions
-- Define functions for calculations such as GPA and attendance percentages.
source ./sql/functions/calc_attendance_percentage.sql;
source ./sql/functions/get_student_gpa.sql;
source ./sql/functions/get_flagged_students.sql;

-- Step 7: Create Procedures
-- Procedures for common operations like grade updates and bulk attendance inserts.
source ./sql/procedures/update_grade_and_log.sql;
source ./sql/procedures/insert_attendance_bulk.sql;

-- Step 8: Create Triggers
-- Define triggers for auditing changes in grades and attendance.
source ./sql/triggers/audit_grade_changes.sql;
source ./sql/triggers/audit_attendance_changes.sql;

-- Step 9: Create Indexes
-- Create necessary indexes to optimize query performance for frequently accessed columns.
source ./sql/indexes/index_optimizations.sql;

-- Step 10: Final Clean-Up & Additional Setup
-- Any additional setup required for views, indexes, or stored procedures can be included here.

-- Ensure the database setup is complete
SELECT 'Database setup complete!' AS message;
