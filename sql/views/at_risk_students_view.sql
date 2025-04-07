-- ===============================================
-- Creating the at_risk_students_view
-- ===============================================

CREATE VIEW at_risk_students_view AS
SELECT
    s.id AS student_id,
    s.first_name,
    s.last_name,
    s.email,
    s.enrollment_date,
    
    -- GPA Calculation (Using the grade scale: A=4, B=3, C=2, D=1, F=0)
    ROUND(
        (SUM(CASE 
                WHEN g.grade = 'A' THEN 4
                WHEN g.grade = 'B' THEN 3
                WHEN g.grade = 'C' THEN 2
                WHEN g.grade = 'D' THEN 1
                ELSE 0
            END) / COUNT(g.course_id)), 2) AS gpa,
    
    -- Attendance Percentage (Classes attended / Total classes)
    ROUND(
        (SUM(CASE 
                WHEN a.status = 'Present' THEN 1
                ELSE 0
            END) / COUNT(a.course_id)) * 100, 2) AS attendance_percentage,
    
    -- Flags students who are at risk
    CASE
        WHEN
            ROUND(
                (SUM(CASE 
                        WHEN g.grade = 'A' THEN 4
                        WHEN g.grade = 'B' THEN 3
                        WHEN g.grade = 'C' THEN 2
                        WHEN g.grade = 'D' THEN 1
                        ELSE 0
                    END) / COUNT(g.course_id)), 2) < 2.0
            OR 
            ROUND(
                (SUM(CASE 
                        WHEN a.status = 'Present' THEN 1
                        ELSE 0
                    END) / COUNT(a.course_id)) * 100, 2) < 70
        THEN 'At Risk'
        ELSE 'Not At Risk'
    END AS risk_status
    
FROM
    students s
LEFT JOIN enrollments e ON s.id = e.student_id
LEFT JOIN grades g ON s.id = g.student_id
LEFT JOIN attendance a ON s.id = a.student_id AND e.course_id = a.course_id

GROUP BY
    s.id, s.first_name, s.last_name, s.email, s.enrollment_date;

-- ===============================================
-- Explanation:
-- ===============================================
-- This view identifies students who are at risk due to low GPA or poor attendance.
-- The following conditions flag students as "At Risk":
-- 1. **GPA**: A GPA below 2.0.
-- 2. **Attendance Percentage**: An attendance percentage below 70%.
--
-- The view includes:
-- - **GPA**: Calculated using a grade scale (A=4, B=3, etc.).
-- - **Attendance Percentage**: Percentage of classes attended by the student.
-- - **Risk Status**: A column that flags students who are considered "At Risk".
--
-- Data is aggregated based on the `students` table, with joins to the `grades` and `attendance` tables.
-- ===============================================
