-- ===============================================
-- Create Courses Table
-- ===============================================
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,           -- Unique identifier for each course
    course_code VARCHAR(20) UNIQUE NOT NULL,     -- Unique course code (e.g., CS101)
    course_name VARCHAR(255) NOT NULL,           -- Name of the course (e.g., Introduction to Computer Science)
    department VARCHAR(100) NOT NULL,            -- Department offering the course (e.g., Computer Science)
    credits INT NOT NULL,                       -- Number of credits for the course
    course_description TEXT,                    -- Optional description of the course
    start_date DATE NOT NULL,                   -- Start date of the course
    end_date DATE NOT NULL,                     -- End date of the course
    status ENUM('Active', 'Inactive', 'Completed') DEFAULT 'Active', -- Course status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Automatically set the creation time
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Automatically update time when modified
);

-- ===============================================
-- Add Indexes to the courses table for faster search
-- ===============================================
CREATE INDEX idx_courses_department ON courses (department);
CREATE INDEX idx_courses_status ON courses (status);
CREATE INDEX idx_courses_course_code ON courses (course_code);

-- ===============================================
-- Insert Sample Data into the Courses Table
-- ===============================================
INSERT INTO courses (course_code, course_name, department, credits, course_description, start_date, end_date)
VALUES 
    ('CS101', 'Introduction to Computer Science', 'Computer Science', 3, 'An introductory course to computer science principles.', '2025-01-15', '2025-05-15'),
    ('MATH201', 'Calculus I', 'Mathematics', 4, 'A course covering the basics of calculus including differentiation and integration.', '2025-02-01', '2025-06-01'),
    ('CHEM101', 'General Chemistry I', 'Chemistry', 4, 'An introductory course to general chemistry including atomic structure and bonding.', '2025-03-01', '2025-07-01'),
    ('BIO102', 'General Biology', 'Biology', 3, 'A course on basic biological principles including cell biology and genetics.', '2025-04-01', '2025-08-01');

-- ===============================================
-- Update Course Information
-- ===============================================
-- Example: Update the course description for a specific course
UPDATE courses
SET course_description = 'An advanced course in computer science principles.'
WHERE course_code = 'CS101';

-- ===============================================
-- Delete a Course Record
-- ===============================================
-- Example: Remove a course from the system
DELETE FROM courses
WHERE course_code = 'BIO102';

-- ===============================================
-- Query to Retrieve All Active Courses
-- ===============================================
SELECT 
    id, 
    course_code, 
    course_name, 
    department, 
    credits, 
    start_date, 
    end_date, 
    status
FROM 
    courses
WHERE 
    status = 'Active'
ORDER BY 
    start_date ASC;

-- ===============================================
-- Query to Retrieve Course by Course Code
-- ===============================================
SELECT 
    id, 
    course_code, 
    course_name, 
    department, 
    credits, 
    course_description, 
    start_date, 
    end_date, 
    status
FROM 
    courses
WHERE 
    course_code = 'CS101';

-- ===============================================
-- Query to Count Courses by Department
-- ===============================================
SELECT 
    department, 
    COUNT(*) AS total_courses
FROM 
    courses
GROUP BY 
    department;

-- ===============================================
-- Query to List Courses by Status
-- ===============================================
SELECT 
    id, 
    course_code, 
    course_name, 
    department, 
    credits, 
    start_date, 
    end_date, 
    status
FROM 
    courses
WHERE 
    status = 'Completed'
ORDER BY 
    end_date DESC;

-- ===============================================
-- Query to Get Courses that Start in the Future
-- ===============================================
SELECT 
    id, 
    course_code, 
    course_name, 
    department, 
    credits, 
    start_date, 
    end_date, 
    status
FROM 
    courses
WHERE 
    start_date > CURDATE()
ORDER BY 
    start_date ASC;

-- ===============================================
-- Trigger to Automatically Update the 'updated_at' Field
-- ===============================================
DELIMITER //
CREATE TRIGGER before_course_update
BEFORE UPDATE ON courses
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END;
//
DELIMITER ;

-- ===============================================
-- Foreign Key Constraints (if applicable)
-- ===============================================
-- Example: If the `courses` table has a foreign key relationship with an `enrollments` table
-- ALTER TABLE courses
-- ADD CONSTRAINT fk_teacher_id
-- FOREIGN KEY (teacher_id) REFERENCES teachers(id);

-- ===============================================
-- Notes:
-- The `courses` table holds basic course information.
-- The table supports basic CRUD operations, such as insert, update, delete, and select.
-- Indexes are added to the `department`, `status`, and `course_code` fields for faster querying.
-- A trigger automatically updates the `updated_at` field when a record is modified.
-- ===============================================
