-- ===============================================
-- Create Students Table
-- ===============================================
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,          -- Unique identifier for each student
    first_name VARCHAR(100) NOT NULL,           -- First name of the student
    last_name VARCHAR(100) NOT NULL,            -- Last name of the student
    date_of_birth DATE NOT NULL,                -- Birthdate of the student
    gender ENUM('Male', 'Female', 'Other') NOT NULL, -- Gender of the student
    email VARCHAR(255) UNIQUE NOT NULL,         -- Email, unique for each student
    phone_number VARCHAR(15),                   -- Optional phone number
    enrollment_date DATE NOT NULL,              -- The date the student enrolled
    address TEXT,                               -- Optional address
    status ENUM('Active', 'Inactive', 'Graduated', 'Dropped') DEFAULT 'Active', -- Student status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Automatically set the creation time
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Automatically update time when modified
);

-- ===============================================
-- Add Indexes to the students table for faster search
-- ===============================================
CREATE INDEX idx_students_email ON students (email);
CREATE INDEX idx_students_status ON students (status);

-- ===============================================
-- Insert Sample Data into the Students Table
-- ===============================================
INSERT INTO students (first_name, last_name, date_of_birth, gender, email, phone_number, enrollment_date)
VALUES 
    ('John', 'Doe', '2000-05-15', 'Male', 'john.doe@example.com', '123-456-7890', '2018-09-01'),
    ('Jane', 'Smith', '1999-10-20', 'Female', 'jane.smith@example.com', '987-654-3210', '2017-08-25'),
    ('Michael', 'Johnson', '2001-02-12', 'Male', 'michael.johnson@example.com', '555-123-4567', '2019-01-10'),
    ('Emily', 'Davis', '2000-07-30', 'Female', 'emily.davis@example.com', '555-765-4321', '2018-06-14');

-- ===============================================
-- Update Student Information
-- ===============================================
-- Example: Update phone number for a specific student
UPDATE students
SET phone_number = '111-222-3333'
WHERE email = 'john.doe@example.com';

-- ===============================================
-- Delete a Student Record
-- ===============================================
-- Example: Remove a student from the system
DELETE FROM students
WHERE id = 4;

-- ===============================================
-- Query to Retrieve All Active Students
-- ===============================================
SELECT 
    id, 
    first_name, 
    last_name, 
    email, 
    enrollment_date, 
    status
FROM 
    students
WHERE 
    status = 'Active'
ORDER BY 
    enrollment_date DESC;

-- ===============================================
-- Query to Retrieve Student by Email
-- ===============================================
SELECT 
    id, 
    first_name, 
    last_name, 
    date_of_birth, 
    gender, 
    email, 
    phone_number, 
    status
FROM 
    students
WHERE 
    email = 'john.doe@example.com';

-- ===============================================
-- Query to Count Students by Status
-- ===============================================
SELECT 
    status, 
    COUNT(*) AS total_students
FROM 
    students
GROUP BY 
    status;

-- ===============================================
-- Query to List Students with Their Age
-- ===============================================
SELECT 
    id, 
    first_name, 
    last_name, 
    email,
    TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM 
    students
ORDER BY 
    age DESC;

-- ===============================================
-- Trigger to Automatically Update the 'updated_at' Field
-- ===============================================
DELIMITER //
CREATE TRIGGER before_student_update
BEFORE UPDATE ON students
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END;
//
DELIMITER ;

-- ===============================================
-- Foreign Key Constraints (if applicable)
-- ===============================================
-- Example: If the `students` table has a foreign key relationship with a `courses` table
-- ALTER TABLE students
-- ADD CONSTRAINT fk_course_id
-- FOREIGN KEY (course_id) REFERENCES courses(id);

-- ===============================================
-- Notes:
-- The `students` table holds basic student information.
-- The table supports basic CRUD operations, such as insert, update, delete, and select.
-- Indexes are added to the `email` and `status` fields for faster querying.
-- A trigger automatically updates the `updated_at` field when a record is modified.
-- The age of each student is calculated dynamically using `TIMESTAMPDIFF`.
-- ===============================================

