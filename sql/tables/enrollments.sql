-- ===============================================
-- Create Enrollments Table
-- ===============================================
CREATE TABLE enrollments (
    id INT PRIMARY KEY AUTO_INCREMENT,             -- Unique identifier for each enrollment record
    student_id INT NOT NULL,                       -- Foreign key referencing the students table
    course_id INT NOT NULL,                        -- Foreign key referencing the courses table
    enrollment_date DATE NOT NULL,                 -- Date when the student enrolled in the course
    status ENUM('Enrolled', 'Completed', 'Dropped', 'Withdrawn') DEFAULT 'Enrolled',  -- Enrollment status
    grade DECIMAL(5,2),                            -- Final grade for the student (if available)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Automatically set the creation time
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Automatically update time when modified
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,  -- Foreign key constraint with cascading delete
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE   -- Foreign key constraint with cascading delete
);

-- ===============================================
-- Add Indexes to the enrollments table for faster search
-- ===============================================
CREATE INDEX idx_enrollments_student_id ON enrollments (student_id);
CREATE INDEX idx_enrollments_course_id ON enrollments (course_id);
CREATE INDEX idx_enrollments_status ON enrollments (status);
CREATE INDEX idx_enrollments_enrollment_date ON enrollments (enrollment_date);

-- ===============================================
-- Insert Sample Data into the Enrollments Table
-- ===============================================
INSERT INTO enrollments (student_id, course_id, enrollment_date, status, grade)
VALUES 
    (1, 1, '2025-01-10', 'Enrolled', NULL),
    (2, 2, '2025-02-01', 'Enrolled', NULL),
    (3, 3, '2025-03-01', 'Completed', 85.5),
    (4, 4, '2025-04-01', 'Dropped', NULL),
    (1, 2, '2025-01-15', 'Completed', 92.0);

-- ===============================================
-- Update Enrollment Information
-- ===============================================
-- Example: Update the grade for a specific student in a course
UPDATE enrollments
SET grade = 90.0
WHERE student_id = 3 AND course_id = 3;

-- ===============================================
-- Delete an Enrollment Record
-- ===============================================
-- Example: Remove an enrollment record for a student in a course
DELETE FROM enrollments
WHERE student_id = 4 AND course_id = 4;

-- ===============================================
-- Query to Retrieve All Enrollments for a Specific Student
-- ===============================================
SELECT 
    e.id, 
    s.student_name, 
    c.course_code, 
    c.course_name, 
    e.enrollment_date, 
    e.status, 
    e.grade
FROM 
    enrollments e
JOIN 
    students s ON e.student_id = s.id
JOIN 
    courses c ON e.course_id = c.id
WHERE 
    e.student_id = 1
ORDER BY 
    e.enrollment_date DESC;

-- ===============================================
-- Query to Retrieve All Enrollments for a Specific Course
-- ===============================================
SELECT 
    e.id, 
    s.student_name, 
    e.enrollment_date, 
    e.status, 
    e.grade
FROM 
    enrollments e
JOIN 
    students s ON e.student_id = s.id
WHERE 
    e.course_id = 2
ORDER BY 
    e.enrollment_date ASC;

-- ===============================================
-- Query to Retrieve All Completed Enrollments
-- ===============================================
SELECT 
    e.id, 
    s.student_name, 
    c.course_code, 
    c.course_name, 
    e.enrollment_date, 
    e.grade
FROM 
    enrollments e
JOIN 
    students s ON e.student_id = s.id
JOIN 
    courses c ON e.course_id = c.id
WHERE 
    e.status = 'Completed'
ORDER BY 
    e.enrollment_date DESC;

-- ===============================================
-- Query to Retrieve the Count of Enrollments by Course
-- ===============================================
SELECT 
    c.course_code, 
    c.course_name, 
    COUNT(e.id) AS total_enrollments
FROM 
    enrollments e
JOIN 
    courses c ON e.course_id = c.id
GROUP BY 
    c.id
ORDER BY 
    total_enrollments DESC;

-- ===============================================
-- Query to Retrieve the Average Grade per Course
-- ===============================================
SELECT 
    c.course_code, 
    c.course_name, 
    AVG(e.grade) AS average_grade
FROM 
    enrollments e
JOIN 
    courses c ON e.course_id = c.id
WHERE 
    e.status = 'Completed'
GROUP BY 
    c.id
ORDER BY 
    average_grade DESC;

-- ===============================================
-- Trigger to Automatically Update the 'updated_at' Field
-- ===============================================
DELIMITER //
CREATE TRIGGER before_enrollment_update
BEFORE UPDATE ON enrollments
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END;
//
DELIMITER ;

-- ===============================================
-- Foreign Key Constraints
-- ===============================================
-- The `enrollments` table contains two foreign keys:
-- 1. `student_id` references the `students` table.
-- 2. `course_id` references the `courses` table.
-- Both have `ON DELETE CASCADE`, meaning that if a student or course is deleted, their corresponding enrollment records are also removed.
-- ===============================================
