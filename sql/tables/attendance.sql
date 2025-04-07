-- ===============================================
-- Create Attendance Table
-- ===============================================
CREATE TABLE attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,             -- Unique identifier for each attendance record
    student_id INT NOT NULL,                       -- Foreign key referencing the students table
    course_id INT NOT NULL,                        -- Foreign key referencing the courses table
    attendance_date DATE NOT NULL,                 -- The date the student attended the class
    status ENUM('Present', 'Absent', 'Late') NOT NULL, -- Attendance status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Automatically set the creation time
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Automatically update time when modified
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE, -- Foreign key constraint with cascading delete
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE  -- Foreign key constraint with cascading delete
);

-- ===============================================
-- Add Indexes to the Attendance Table for Faster Search
-- ===============================================
CREATE INDEX idx_attendance_student_id ON attendance (student_id);
CREATE INDEX idx_attendance_course_id ON attendance (course_id);
CREATE INDEX idx_attendance_date ON attendance (attendance_date);
CREATE INDEX idx_attendance_status ON attendance (status);

-- ===============================================
-- Insert Sample Data into the Attendance Table
-- ===============================================
INSERT INTO attendance (student_id, course_id, attendance_date, status)
VALUES 
    (1, 1, '2025-03-01', 'Present'),
    (2, 1, '2025-03-01', 'Absent'),
    (3, 2, '2025-03-01', 'Present'),
    (4, 3, '2025-03-01', 'Late'),
    (1, 3, '2025-03-02', 'Absent');

-- ===============================================
-- Update Attendance Record
-- ===============================================
-- Example: Update the attendance status for a specific student in a course
UPDATE attendance
SET status = 'Present', updated_at = CURRENT_TIMESTAMP
WHERE student_id = 4 AND course_id = 3 AND attendance_date = '2025-03-01';

-- ===============================================
-- Delete Attendance Record
-- ===============================================
-- Example: Remove an attendance record for a student in a specific course
DELETE FROM attendance
WHERE student_id = 1 AND course_id = 1 AND attendance_date = '2025-03-01';

-- ===============================================
-- Query to Retrieve All Attendance Records for a Specific Student
-- ===============================================
SELECT 
    a.id, 
    s.student_name, 
    c.course_code, 
    c.course_name, 
    a.attendance_date, 
    a.status
FROM 
    attendance a
JOIN 
    students s ON a.student_id = s.id
JOIN 
    courses c ON a.course_id = c.id
WHERE 
    a.student_id = 1
ORDER BY 
    a.attendance_date DESC;

-- ===============================================
-- Query to Retrieve All Attendance Records for a Specific Course
-- ===============================================
SELECT 
    a.id, 
    s.student_name, 
    a.attendance_date, 
    a.status
FROM 
    attendance a
JOIN 
    students s ON a.student_id = s.id
WHERE 
    a.course_id = 1
ORDER BY 
    a.attendance_date DESC;

-- ===============================================
-- Query to Retrieve Attendance Summary by Status
-- ===============================================
SELECT 
    c.course_code, 
    c.course_name, 
    a.status, 
    COUNT(a.id) AS attendance_count
FROM 
    attendance a
JOIN 
    courses c ON a.course_id = c.id
GROUP BY 
    c.id, a.status
ORDER BY 
    c.course_code, a.status;

-- ===============================================
-- Query to Retrieve the Number of Students Absent
-- ===============================================
SELECT 
    c.course_code, 
    c.course_name, 
    COUNT(a.id) AS absent_count
FROM 
    attendance a
JOIN 
    courses c ON a.course_id = c.id
WHERE 
    a.status = 'Absent'
GROUP BY 
    c.id
ORDER BY 
    absent_count DESC;

-- ===============================================
-- Query to Retrieve Students Who Are Late
-- ===============================================
SELECT 
    s.student_name, 
    c.course_code, 
    a.attendance_date, 
    a.status
FROM 
    attendance a
JOIN 
    students s ON a.student_id = s.id
JOIN 
    courses c ON a.course_id = c.id
WHERE 
    a.status = 'Late'
ORDER BY 
    a.attendance_date ASC;

-- ===============================================
-- Query to Retrieve Attendance Summary for a Specific Date
-- ===============================================
SELECT 
    s.student_name, 
    c.course_code, 
    a.status
FROM 
    attendance a
JOIN 
    students s ON a.student_id = s.id
JOIN 
    courses c ON a.course_id = c.id
WHERE 
    a.attendance_date = '2025-03-01'
ORDER BY 
    s.student_name;

-- ===============================================
-- Query to Retrieve Students Who Have Perfect Attendance
-- ===============================================
SELECT 
    s.student_name, 
    COUNT(a.id) AS perfect_attendance_count
FROM 
    attendance a
JOIN 
    students s ON a.student_id = s.id
WHERE 
    a.status = 'Present'
GROUP BY 
    a.student_id
HAVING 
    COUNT(a.id) = (SELECT COUNT(*) FROM courses)
ORDER BY 
    s.student_name;

-- ===============================================
-- Trigger to Automatically Update the 'updated_at' Field
-- ===============================================
DELIMITER //
CREATE TRIGGER before_attendance_update
BEFORE UPDATE ON attendance
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END;
//
DELIMITER ;

-- ===============================================
-- Foreign Key Constraints
-- ===============================================
-- The `attendance` table contains two foreign keys:
-- 1. `student_id` references the `students` table.
-- 2. `course_id` references the `courses` table.
-- Both have `ON DELETE CASCADE`, meaning that if a student or course is deleted, their corresponding attendance records are also removed.
-- ===============================================
