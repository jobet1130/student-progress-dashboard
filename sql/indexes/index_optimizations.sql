-- Change delimiter for multi-line statements
DELIMITER $$

-- 1. Create Index on Grades for Faster Queries on Student and Course
CREATE INDEX idx_grades_student_id_course_id
ON grades (student_id, course_id);

-- 2. Create Index on Attendance for Efficient Status Lookup by Student and Course
CREATE INDEX idx_attendance_student_id_course_id
ON attendance (student_id, course_id);

-- 3. Create Index on Enrollments for Efficient Term and Course Lookups
CREATE INDEX idx_enrollments_student_id_course_id_term
ON enrollments (student_id, course_id, term);

-- 4. Create Index on Students for Quick Search by ID (especially for GPA calculation)
CREATE INDEX idx_students_id
ON students (id);

-- 5. Create Index on Feedback for Quick Lookup by Student and Course
CREATE INDEX idx_feedback_student_id_course_id
ON feedback (student_id, course_id);

-- 6. Create Index on Course for Efficient Search and Finalization Status Check
CREATE INDEX idx_courses_id_finalized
ON courses (id, finalized);

-- 7. Create Index on Attendance Change Audit Table (for auditing purposes)
CREATE INDEX idx_attendance_change_audit_student_id_course_id
ON attendance_change_audit (student_id, course_id);

-- 8. Create Index on Grade Change Audit Table (for auditing purposes)
CREATE INDEX idx_grade_change_audit_student_id_course_id
ON grade_change_audit (student_id, course_id);

-- 9. Create Index on Grade Points for Performance Optimizations during GPA Calculation
CREATE INDEX idx_grades_grade_points
ON grades (grade_points);

-- 10. Create Composite Index on Students for Enrollments and Attendance Tracking
CREATE INDEX idx_students_enrollments_attendance
ON students (id, gpa);

-- 11. Create Index on Enrollment to Track Duplicate Enrollments Fast
CREATE INDEX idx_enrollments_student_course_term
ON enrollments (student_id, course_id, term);

-- Reset the delimiter to default
DELIMITER ;
