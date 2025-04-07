-- ===============================================
-- Function to get a list of flagged students based on GPA and attendance
-- ===============================================
CREATE FUNCTION get_flagged_students()
RETURNS TABLE (
    student_id INT,
    student_name VARCHAR(255),
    gpa DECIMAL(5, 2),
    attendance_percentage DECIMAL(5, 2)
)
DETERMINISTIC
BEGIN
    RETURN
    (
        SELECT 
            s.id AS student_id,
            s.name AS student_name,
            get_student_gpa(s.id) AS gpa,  -- Assuming the GPA function is already created
            get_attendance_percentage(s.id) AS attendance_percentage  -- Assuming attendance function is created
        FROM students s
        WHERE 
            get_student_gpa(s.id) < 2.0  -- Flag students with GPA below 2.0
            OR get_attendance_percentage(s.id) < 75  -- Flag students with attendance below 75%
    );
END;

-- Explanation:
-- This function returns a table of students who are considered "flagged" due to poor academic performance or attendance.
-- It checks if the student's GPA is below 2.0 or if their attendance is below 75%.
-- The `get_student_gpa(s.id)` and `get_attendance_percentage(s.id)` are assumed to be existing functions in the database.
-- The function will return the student's ID, name, GPA, and attendance percentage for those who meet the criteria.
