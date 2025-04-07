-- ===============================================
-- Create Teachers Table
-- ===============================================
CREATE TABLE teachers (
    id INT PRIMARY KEY AUTO_INCREMENT,          -- Unique identifier for each teacher
    first_name VARCHAR(100) NOT NULL,           -- First name of the teacher
    last_name VARCHAR(100) NOT NULL,            -- Last name of the teacher
    date_of_birth DATE NOT NULL,                -- Birthdate of the teacher
    gender ENUM('Male', 'Female', 'Other') NOT NULL, -- Gender of the teacher
    email VARCHAR(255) UNIQUE NOT NULL,         -- Email, unique for each teacher
    phone_number VARCHAR(15),                   -- Optional phone number
    hire_date DATE NOT NULL,                    -- The date the teacher was hired
    department VARCHAR(100),                    -- Department where the teacher belongs
    status ENUM('Active', 'Inactive', 'Retired', 'On Leave') DEFAULT 'Active', -- Teacher's employment status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Automatically set the creation time
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Automatically update time when modified
);

-- ===============================================
-- Add Indexes to the teachers table for faster search
-- ===============================================
CREATE INDEX idx_teachers_email ON teachers (email);
CREATE INDEX idx_teachers_department ON teachers (department);
CREATE INDEX idx_teachers_status ON teachers (status);

-- ===============================================
-- Insert Sample Data into the Teachers Table
-- ===============================================
INSERT INTO teachers (first_name, last_name, date_of_birth, gender, email, phone_number, hire_date, department)
VALUES 
    ('Alice', 'Williams', '1980-05-15', 'Female', 'alice.williams@example.com', '123-456-7890', '2010-09-01', 'Mathematics'),
    ('David', 'Brown', '1975-03-25', 'Male', 'david.brown@example.com', '987-654-3210', '2005-08-20', 'Physics'),
    ('Sophia', 'Johnson', '1990-07-12', 'Female', 'sophia.johnson@example.com', '555-123-4567', '2015-05-10', 'Chemistry'),
    ('James', 'Davis', '1985-11-20', 'Male', 'james.davis@example.com', '555-765-4321', '2012-01-15', 'Computer Science');

-- ===============================================
-- Update Teacher Information
-- ===============================================
-- Example: Update phone number for a specific teacher
UPDATE teachers
SET phone_number = '111-222-3333'
WHERE email = 'alice.williams@example.com';

-- ===============================================
-- Delete a Teacher Record
-- ===============================================
-- Example: Remove a teacher from the system
DELETE FROM teachers
WHERE id = 4;

-- ===============================================
-- Query to Retrieve All Active Teachers
-- ===============================================
SELECT 
    id, 
    first_name, 
    last_name, 
    email, 
    hire_date, 
    department, 
    status
FROM 
    teachers
WHERE 
    status = 'Active'
ORDER BY 
    hire_date DESC;

-- ===============================================
-- Query to Retrieve Teacher by Email
-- ===============================================
SELECT 
    id, 
    first_name, 
    last_name, 
    date_of_birth, 
    gender, 
    email, 
    phone_number, 
    department, 
    status
FROM 
    teachers
WHERE 
    email = 'alice.williams@example.com';

-- ===============================================
-- Query to Count Teachers by Department
-- ===============================================
SELECT 
    department, 
    COUNT(*) AS total_teachers
FROM 
    teachers
GROUP BY 
    department;

-- ===============================================
-- Query to List Teachers with Their Age
-- ===============================================
SELECT 
    id, 
    first_name, 
    last_name, 
    email,
    TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM 
    teachers
ORDER BY 
    age DESC;

-- ===============================================
-- Query to Get Teachers on Leave
-- ===============================================
SELECT 
    id, 
    first_name, 
    last_name, 
    email, 
    hire_date, 
    department, 
    status
FROM 
    teachers
WHERE 
    status = 'On Leave';

-- ===============================================
-- Trigger to Automatically Update the 'updated_at' Field
-- ===============================================
DELIMITER //
CREATE TRIGGER before_teacher_update
BEFORE UPDATE ON teachers
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END;
//
DELIMITER ;

-- ===============================================
-- Foreign Key Constraints (if applicable)
-- ===============================================
-- Example: If the `teachers` table has a foreign key relationship with a `courses` table
-- ALTER TABLE teachers
-- ADD CONSTRAINT fk_course_id
-- FOREIGN KEY (course_id) REFERENCES courses(id);

-- ===============================================
-- Notes:
-- The `teachers` table holds basic teacher information.
-- The table supports basic CRUD operations, such as insert, update, delete, and select.
-- Indexes are added to the `email`, `department`, and `status` fields for faster querying.
-- A trigger automatically updates the `updated_at` field when a record is modified.
-- The age of each teacher is calculated dynamically using `TIMESTAMPDIFF`.
-- ===============================================

