-- ===============================================
-- Create Grades Table
-- ===============================================
CREATE TABLE grades (
    id INT PRIMARY KEY AUTO_INCREMENT,                 -- Unique identifier for each grade record
    student_id INT NOT NULL,                           -- Foreign key referencing the students table
    course_id INT NOT NULL,                            -- Foreign key referencing the courses table
    grade DECIMAL(5,2) NOT NULL,                       -- Final grade for the student in the course
    grade_date DATE NOT NULL,                          -- Date when the grade was assigned
    grading_status ENUM('Assigned', 'Pending', 'Finalized') DEFAULT 'Assigned',  -- Grading status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     -- Automatically set the creation time
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Automatically update time when modified
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,  -- Foreign key constraint with cascading delete
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE   -- Foreign key constraint with cascading delete
);

-- ===============================================
-- Add Indexes to the Grades Table for Faster Search
-- ===============================================
CREATE INDEX idx_grades_student_id ON grades (student_id);
CREATE INDEX idx_grades_course_id ON grades (course_id);
CREATE INDEX idx_grades_grading_status ON grades (grading_status);
CREATE INDEX idx_grades_grade_date ON grades (grade_date);

-- ===============================================
-- Insert Sample Data into the Grades Table
-- ===============================================
INSERT INTO grades (student_id, course_id, grade, grade_date, grading_status)
VALUES 
    (1, 1, 85.5, '2025-05-10', 'Finalized'),
    (2, 1, 78.0, '2025-05-11', 'Finalized'),
    (3, 2, 92.0, '2025-04-22', 'Assigned'),
    (4, 3, 67.5, '2025-03-15', 'Pending'),
    (1, 3, 88.0, '2025-03-10', 'Finalized');

-- ===============================================
-- Update Grade Information
-- ===============================================
-- Example: Update the grade for a specific student in a course
UPDATE grades
SET grade = 90.0, grading_status = 'Finalized'
WHERE student_id = 3 AND course_id = 2;

-- ===============================================
-- Delete a Grade Record
-- ===============================================
-- Example: Remove a grade record for a student in a course
DELETE FROM grades
WHERE student_id = 4 AND course_id = 3;

-- ===============================================
-- Query to Retrieve All Grades for a Specific Student
-- ===============================================
SELECT 
    g.id, 
    s.student_name, 
    c.course_code, 
    c.course_name, 
    g.grade, 
    g.grade_date, 
    g.grading_status
FROM 
    grades g
JOIN 
    students s ON g.student_id = s.id
JOIN 
    courses c ON g.course_id = c.id
WHERE 
    g.student_id = 1
ORDER BY 
    g.grade_date DESC;

-- ===============================================
-- Query to Retrieve Grades for a Specific Course
-- ===============================================
SELECT 
    g.id, 
    s.student_name, 
    g.grade, 
    g.grade_date, 
    g.grading_status
FROM 
    grades g
JOIN 
    students s ON g.student_id = s.id
WHERE 
    g.course_id = 1
ORDER BY 
    g.grade_date DESC;

-- ===============================================
-- Query to Retrieve All Finalized Grades
-- ===============================================
SELECT 
    g.id, 
    s.student_name, 
    c.course_code, 
    c.course_name, 
    g.grade, 
    g.grade_date
FROM 
    grades g
JOIN 
    students s ON g.student_id = s.id
JOIN 
    courses c ON g.course_id = c.id
WHERE 
    g.grading_status = 'Finalized'
ORDER BY 
    g.grade_date DESC;

-- ===============================================
-- Query to Retrieve the Average Grade per Course
-- ===============================================
SELECT 
    c.course_code, 
    c.course_name, 
    AVG(g.grade) AS average_grade
FROM 
    grades g
JOIN 
    courses c ON g.course_id = c.id
WHERE 
    g.grading_status = 'Finalized'
GROUP BY 
    c.id
ORDER BY 
    average_grade DESC;

-- ===============================================
-- Query to Retrieve the Count of Students with Pending Grades
-- ===============================================
SELECT 
    c.course_code, 
    c.course_name, 
    COUNT(g.id) AS pending_grades_count
FROM 
    grades g
JOIN 
    courses c ON g.course_id = c.id
WHERE 
    g.grading_status = 'Pending'
GROUP BY 
    c.id
ORDER BY 
    pending_grades_count DESC;

-- ===============================================
-- Query to Retrieve Students' Grades with Pending Status
-- ===============================================
SELECT 
    s.student_name, 
    c.course_code, 
    g.grade, 
    g.grade_date, 
    g.grading_status
FROM 
    grades g
JOIN 
    students s ON g.student_id = s.id
JOIN 
    courses c ON g.course_id = c.id
WHERE 
    g.grading_status = 'Pending'
ORDER BY 
    g.grade_date ASC;

-- ===============================================
-- Trigger to Automatically Update the 'updated_at' Field
-- ===============================================
DELIMITER //
CREATE TRIGGER before_grade_update
BEFORE UPDATE ON grades
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END;
//
DELIMITER ;

-- ===============================================
-- Foreign Key Constraints
-- ===============================================
-- The `grades` table contains two foreign keys:
-- 1. `student_id` references the `students` table.
-- 2. `course_id` references the `courses` table.
-- Both have `ON DELETE CASCADE`, meaning that if a student or course is deleted, their corresponding grade records are also removed.
-- ===============================================
