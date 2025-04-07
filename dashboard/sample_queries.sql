-- ========================================================
-- 01. Aggregate Student GPA by Semester and Year
-- This query calculates the average GPA for each student 
-- based on the semester and year.
-- ========================================================
SELECT 
    sp.student_id, 
    sp.semester, 
    sp.year, 
    AVG(sp.gpa) AS average_gpa
FROM student_performance sp
GROUP BY sp.student_id, sp.semester, sp.year
ORDER BY sp.year DESC, sp.semester DESC;

-- ========================================================
-- 02. Top Performing Students (GPA >= 3.5)
-- This query selects the top-performing students with a GPA
-- greater than or equal to 3.5 in a particular semester and year.
-- ========================================================
SELECT 
    sp.student_id, 
    s.first_name, 
    s.last_name, 
    sp.gpa, 
    sp.attendance_percentage,
    sp.performance_rank
FROM student_performance sp
JOIN students s ON sp.student_id = s.student_id
WHERE sp.gpa >= 3.5 AND sp.semester = 'Spring 2025' AND sp.year = 2025
ORDER BY sp.gpa DESC;

-- ========================================================
-- 03. Students at Risk (GPA < 2.0 or Attendance < 75%)
-- This query identifies students at risk based on their GPA 
-- and attendance. A student is considered at risk if their
-- GPA is below 2.0 or their attendance percentage is below 75%.
-- ========================================================
SELECT 
    sp.student_id, 
    s.first_name, 
    s.last_name, 
    sp.gpa, 
    sp.attendance_percentage
FROM student_performance sp
JOIN students s ON sp.student_id = s.student_id
WHERE (sp.gpa < 2.0 OR sp.attendance_percentage < 75) 
    AND sp.semester = 'Spring 2025' AND sp.year = 2025
ORDER BY sp.attendance_percentage ASC, sp.gpa ASC;

-- ========================================================
-- 04. Attendance Summary by Student
-- This query calculates the total number of classes attended, 
-- absent, and late for each student in a given semester.
-- ========================================================
SELECT 
    a.student_id,
    s.first_name,
    s.last_name,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) AS attended,
    COUNT(CASE WHEN a.status = 'Absent' THEN 1 END) AS absent,
    COUNT(CASE WHEN a.status = 'Late' THEN 1 END) AS late
FROM attendance a
JOIN students s ON a.student_id = s.student_id
WHERE a.date BETWEEN '2025-01-01' AND '2025-06-30'
GROUP BY a.student_id, s.first_name, s.last_name
ORDER BY attended DESC;

-- ========================================================
-- 05. Teacher Feedback by Rating
-- This query aggregates teacher feedback by rating level 
-- (1 to 5) for each teacher.
-- ========================================================
SELECT 
    tf.teacher_id, 
    t.first_name, 
    t.last_name, 
    tf.feedback_rank, 
    COUNT(*) AS feedback_count
FROM teacher_feedback tf
JOIN teachers t ON tf.teacher_id = t.teacher_id
GROUP BY tf.teacher_id, t.first_name, t.last_name, tf.feedback_rank
ORDER BY tf.feedback_rank DESC;

-- ========================================================
-- 06. Average Teacher Rating by Subject
-- This query calculates the average rating for teachers 
-- within each department.
-- ========================================================
SELECT 
    t.department, 
    AVG(tf.rating) AS average_rating
FROM teacher_feedback tf
JOIN teachers t ON tf.teacher_id = t.teacher_id
GROUP BY t.department
ORDER BY average_rating DESC;

-- ========================================================
-- 07. Number of Feedbacks Per Teacher
-- This query calculates the total number of feedbacks each teacher
-- has received in a given semester and year.
-- ========================================================
SELECT 
    tf.teacher_id, 
    t.first_name, 
    t.last_name, 
    COUNT(*) AS total_feedbacks
FROM teacher_feedback tf
JOIN teachers t ON tf.teacher_id = t.teacher_id
WHERE tf.semester = 'Spring 2025' AND tf.year = 2025
GROUP BY tf.teacher_id, t.first_name, t.last_name
ORDER BY total_feedbacks DESC;

-- ========================================================
-- 08. Flagged Students for Low Attendance
-- This query flags students who have attended less than 75% 
-- of their classes in the current semester.
-- ========================================================
SELECT 
    sp.student_id,
    s.first_name, 
    s.last_name, 
    sp.attendance_percentage
FROM student_performance sp
JOIN students s ON sp.student_id = s.student_id
WHERE sp.attendance_percentage < 75 
    AND sp.semester = 'Spring 2025' AND sp.year = 2025
ORDER BY sp.attendance_percentage ASC;

-- ========================================================
-- 09. List of Students Enrolled in a Specific Course
-- This query retrieves the list of students enrolled in a 
-- specific course, based on the course ID.
-- ========================================================
SELECT 
    e.student_id, 
    s.first_name, 
    s.last_name, 
    c.course_name
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_id = 101 -- Example CourseID
ORDER BY s.last_name, s.first_name;

-- ========================================================
-- 10. Student Grades by Course and Semester
-- This query retrieves the grades for all students in a 
-- specific course and semester.
-- ========================================================
SELECT 
    e.student_id, 
    s.first_name, 
    s.last_name, 
    g.grade, 
    c.course_name, 
    e.semester, 
    e.year
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_id = 102 -- Example CourseID
    AND e.semester = 'Spring 2025' AND e.year = 2025
ORDER BY g.grade DESC;

-- ========================================================
-- 11. Summary of Teacher Attendance (Classroom)
-- This query aggregates the number of classes taught by each teacher
-- and the attendance for those classes in a specific classroom.
-- ========================================================
SELECT 
    c.teacher_id, 
    t.first_name, 
    t.last_name, 
    COUNT(a.attendance_id) AS total_attendance,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) AS attended,
    COUNT(CASE WHEN a.status = 'Absent' THEN 1 END) AS absent,
    COUNT(CASE WHEN a.status = 'Late' THEN 1 END) AS late
FROM attendance a
JOIN classrooms c ON a.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE a.date BETWEEN '2025-01-01' AND '2025-06-30'
GROUP BY c.teacher_id, t.first_name, t.last_name
ORDER BY total_attendance DESC;
