-- ===============================================
-- Query to identify at-risk students
-- ===============================================
SELECT s.id AS student_id, 
       s.name AS student_name,
       calc_cumulative_gpa(s.id) AS cumulative_gpa,
       calc_attendance_percentage(s.id) AS attendance_percentage
FROM students s
WHERE calc_cumulative_gpa(s.id) < 2.0  -- GPA below 2.0 is considered at risk
   OR calc_attendance_percentage(s.id) < 75  -- Attendance below 75% is considered at risk
ORDER BY cumulative_gpa, attendance_percentage;

-- Explanation:
-- This query selects students who have a cumulative GPA lower than 2.0 or an attendance percentage lower than 75%.
-- It utilizes the previously defined functions `calc_cumulative_gpa` and `calc_attendance_percentage`.
-- The result is ordered by GPA and attendance percentage to highlight the most at-risk students.
