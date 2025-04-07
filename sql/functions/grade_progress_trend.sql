-- ===============================================
-- Query to analyze grade progress over time for a student
-- ===============================================
SELECT g.semester, 
       AVG(g.grade) AS average_grade
FROM grades g
WHERE g.student_id = 123 -- Replace with the desired student ID
GROUP BY g.semester
ORDER BY g.semester;

-- Explanation:
-- This query calculates the average grade for a student across different semesters. 
-- It allows for a trend analysis of the student's performance over time.
-- The result is ordered by semester, showing how the student's grades have progressed or declined.
