-- ===============================================
-- Query to compare student progress across terms/semesters
-- ===============================================
SELECT s.id AS student_id,
       s.name AS student_name,
       AVG(g.grade) AS average_gpa,
       AVG(a.attendance_percentage) AS average_attendance
FROM students s
JOIN grades g ON s.id = g.student_id
JOIN attendance a ON s.id = a.student_id
GROUP BY s.id
HAVING COUNT(DISTINCT g.semester) > 1  -- Ensuring that the comparison is made across multiple semesters
ORDER BY average_gpa DESC, average_attendance DESC;

-- Explanation:
-- This query compares the progress of students across multiple semesters. It calculates the average GPA and attendance for each student.
-- The `HAVING` clause ensures that the comparison is done only for students who have data across multiple semesters.
-- The result is ordered by GPA and attendance in descending order to show the top-performing students.
