-- ===============================================
-- Creating the student_performance_view
-- ===============================================

CREATE VIEW student_performance_view AS
SELECT
    s.id AS student_id,
    s.first_name,
    s.last_name,
    s.email,
    s.enrollment_date,
    
    -- GPA Calculation based on Grades
    ROUND(
        (SUM(CASE 
                WHEN g.grade = 'A' THEN 4
                WHEN g.grade = 'B' THEN 3
                WHEN g.grade = 'C' THEN 2
                WHEN g.grade = 'D' THEN 1
                ELSE 0
            END) / COUNT(g.course_id)), 2) AS gpa,
    
    -- Attendance Percentage (Number of classes attended / Total number of classes)
    ROUND(
        (SUM(CASE 
                WHEN a.status = 'Present' THEN 1 
                ELSE 0
            END) / COUNT(a.course_id)) * 100, 2) AS attendance_percentage,
    
    -- Feedback Rating (Average of student feedback ratings for all courses)
    ROUND(
        (AVG(f.rating)), 2) AS average_feedback_rating,
    
    -- Total Number of Enrollments
    COUNT(e.course_id) AS total_enrollments,
    
    -- Total Number of Absent Days
    SUM(CASE 
            WHEN a.status = 'Absent' THEN 1 
            ELSE 0
        END) AS total_absent_days
    
FROM
    students s
LEFT JOIN enrollments e ON s.id = e.student_id
LEFT JOIN grades g ON s.id = g.student_id
LEFT JOIN attendance a ON s.id = a.student_id AND e.course_id = a.course_id
LEFT JOIN feedback f ON s.id = f.student_id AND e.course_id = f.course_id

GROUP BY
    s.id, s.first_name, s.last_name, s.email, s.enrollment_date;

-- ===============================================
-- Explanation:
-- ===============================================
-- The student_performance_view provides a consolidated view of the following:
-- 1. **GPA**: Calculated based on the grade letter scale (A=4, B=3, etc.)
-- 2. **Attendance Percentage**: Percentage of classes a student attended.
-- 3. **Average Feedback Rating**: The average rating a student has given for their courses.
-- 4. **Total Enrollments**: Total number of courses the student is enrolled in.
-- 5. **Total Absent Days**: Total number of days a student was absent.

-- This view combines data from the following tables:
-- - `students`: Student details.
-- - `enrollments`: Courses a student is enrolled in.
-- - `grades`: Academic performance data.
-- - `attendance`: Attendance data for each class session.
-- - `feedback`: Feedback provided by the student for each course.

-- This view helps track the overall performance of a student across different dimensions.
-- ===============================================
