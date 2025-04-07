-- ===============================================
-- Create Feedback Table
-- ===============================================
CREATE TABLE feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,             -- Unique identifier for each feedback record
    student_id INT NOT NULL,                       -- Foreign key referencing the students table
    teacher_id INT NOT NULL,                       -- Foreign key referencing the teachers table
    course_id INT NOT NULL,                        -- Foreign key referencing the courses table
    feedback_date DATE NOT NULL,                   -- The date the feedback was given
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5), -- Rating given by the student (1 to 5 scale)
    comments TEXT,                                 -- Optional comments or detailed feedback
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Automatically set the creation time
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Automatically update time when modified
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE, -- Foreign key constraint with cascading delete
    FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE, -- Foreign key constraint with cascading delete
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE  -- Foreign key constraint with cascading delete
);

-- ===============================================
-- Add Indexes to the Feedback Table for Faster Search
-- ===============================================
CREATE INDEX idx_feedback_student_id ON feedback (student_id);
CREATE INDEX idx_feedback_teacher_id ON feedback (teacher_id);
CREATE INDEX idx_feedback_course_id ON feedback (course_id);
CREATE INDEX idx_feedback_date ON feedback (feedback_date);
CREATE INDEX idx_feedback_rating ON feedback (rating);

-- ===============================================
-- Insert Sample Data into the Feedback Table
-- ===============================================
INSERT INTO feedback (student_id, teacher_id, course_id, feedback_date, rating, comments)
VALUES 
    (1, 1, 1, '2025-03-01', 4, 'Great class, but could use more practical examples.'),
    (2, 1, 1, '2025-03-02', 3, 'Good lectures, but the pace is too fast for beginners.'),
    (3, 2, 2, '2025-03-02', 5, 'Excellent teaching style, very engaging.'),
    (4, 3, 3, '2025-03-01', 2, 'The course was too difficult to follow, needs better structure.'),
    (1, 2, 2, '2025-03-03', 4, 'Good course, but the assignments were too challenging.');

-- ===============================================
-- Update Feedback Record
-- ===============================================
-- Example: Update the feedback rating and comments for a specific student, teacher, and course
UPDATE feedback
SET rating = 5, comments = 'Fantastic course, very well-structured!'
WHERE student_id = 4 AND teacher_id = 3 AND course_id = 3 AND feedback_date = '2025-03-01';

-- ===============================================
-- Delete Feedback Record
-- ===============================================
-- Example: Remove a feedback record for a specific student, teacher, and course
DELETE FROM feedback
WHERE student_id = 2 AND teacher_id = 1 AND course_id = 1 AND feedback_date = '2025-03-02';

-- ===============================================
-- Query to Retrieve All Feedback Given by a Specific Student
-- ===============================================
SELECT 
    f.id, 
    s.student_name, 
    t.teacher_name, 
    c.course_code, 
    c.course_name, 
    f.feedback_date, 
    f.rating, 
    f.comments
FROM 
    feedback f
JOIN 
    students s ON f.student_id = s.id
JOIN 
    teachers t ON f.teacher_id = t.id
JOIN 
    courses c ON f.course_id = c.id
WHERE 
    f.student_id = 1
ORDER BY 
    f.feedback_date DESC;

-- ===============================================
-- Query to Retrieve All Feedback Given by a Specific Teacher
-- ===============================================
SELECT 
    f.id, 
    s.student_name, 
    c.course_code, 
    c.course_name, 
    f.feedback_date, 
    f.rating, 
    f.comments
FROM 
    feedback f
JOIN 
    students s ON f.student_id = s.id
JOIN 
    courses c ON f.course_id = c.id
WHERE 
    f.teacher_id = 1
ORDER BY 
    f.feedback_date DESC;

-- ===============================================
-- Query to Retrieve Feedback Summary by Rating
-- ===============================================
SELECT 
    t.teacher_name, 
    c.course_code, 
    c.course_name, 
    f.rating, 
    COUNT(f.id) AS feedback_count
FROM 
    feedback f
JOIN 
    teachers t ON f.teacher_id = t.id
JOIN 
    courses c ON f.course_id = c.id
GROUP BY 
    t.id, c.id, f.rating
ORDER BY 
    t.teacher_name, c.course_code, f.rating;

-- ===============================================
-- Query to Retrieve Average Rating for a Specific Teacher and Course
-- ===============================================
SELECT 
    t.teacher_name, 
    c.course_code, 
    c.course_name, 
    AVG(f.rating) AS average_rating
FROM 
    feedback f
JOIN 
    teachers t ON f.teacher_id = t.id
JOIN 
    courses c ON f.course_id = c.id
WHERE 
    f.teacher_id = 1 AND f.course_id = 1
GROUP BY 
    t.id, c.id
ORDER BY 
    average_rating DESC;

-- ===============================================
-- Query to Retrieve Teachers with the Highest Average Rating
-- ===============================================
SELECT 
    t.teacher_name, 
    AVG(f.rating) AS average_rating
FROM 
    feedback f
JOIN 
    teachers t ON f.teacher_id = t.id
GROUP BY 
    t.id
ORDER BY 
    average_rating DESC
LIMIT 5;

-- ===============================================
-- Query to Retrieve Students Who Gave Feedback
-- ===============================================
SELECT 
    s.student_name, 
    t.teacher_name, 
    c.course_code, 
    f.rating, 
    f.comments
FROM 
    feedback f
JOIN 
    students s ON f.student_id = s.id
JOIN 
    teachers t ON f.teacher_id = t.id
JOIN 
    courses c ON f.course_id = c.id
WHERE 
    f.rating = 5
ORDER BY 
    s.student_name;

-- ===============================================
-- Trigger to Automatically Update the 'updated_at' Field
-- ===============================================
DELIMITER //
CREATE TRIGGER before_feedback_update
BEFORE UPDATE ON feedback
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END;
//
DELIMITER ;

-- ===============================================
-- Foreign Key Constraints
-- ===============================================
-- The `feedback` table contains three foreign keys:
-- 1. `student_id` references the `students` table.
-- 2. `teacher_id` references the `teachers` table.
-- 3. `course_id` references the `courses` table.
-- All three foreign keys have `ON DELETE CASCADE`, meaning that if a student, teacher, or course is deleted, their corresponding feedback records are also removed.
-- ===============================================
