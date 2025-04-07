-- ===============================================
-- Query to analyze attendance progress over time for a student
-- ===============================================
SELECT a.term, 
       AVG(a.attendance_percentage) AS average_attendance
FROM attendance a
WHERE a.student_id = 123 -- Replace with the desired student ID
GROUP BY a.term
ORDER BY a.term;

-- Explanation:
-- This query calculates the average attendance for a student over different terms. 
-- It provides insights into how the student's attendance has improved or declined over time.
-- The result is ordered by term to show the trend.
