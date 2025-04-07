-- ===============================================
-- Creating the calc_attendance_percentage function
-- ===============================================

CREATE FUNCTION calc_attendance_percentage(student_id INT) 
RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
    DECLARE total_classes INT;
    DECLARE attended_classes INT;
    DECLARE attendance_percentage DECIMAL(5, 2);
    
    -- Get the total number of classes for the student (assuming 'attendance' table contains class sessions)
    SELECT COUNT(DISTINCT a.class_id) INTO total_classes
    FROM attendance a
    WHERE a.student_id = student_id;

    -- Get the number of classes attended by the student
    SELECT COUNT(DISTINCT a.class_id) INTO attended_classes
    FROM attendance a
    WHERE a.student_id = student_id AND a.status = 'Present';

    -- If total_classes is 0, prevent division by zero and return 0
    IF total_classes = 0 THEN
        SET attendance_percentage = 0;
    ELSE
        -- Calculate the attendance percentage
        SET attendance_percentage = (attended_classes / total_classes) * 100;
    END IF;
    
    RETURN attendance_percentage;
END;

-- ===============================================
-- Explanation:
-- ===============================================
-- The function `calc_attendance_percentage` calculates the attendance percentage for a given student.
-- It works as follows:
-- 1. The `total_classes` variable counts the total number of distinct classes the student is enrolled in by looking at the `attendance` table.
-- 2. The `attended_classes` variable counts the number of classes the student attended (where the `status` is marked as 'Present').
-- 3. The function calculates the percentage by dividing the attended classes by the total classes and multiplying by 100.
-- 4. If no classes are found for the student (i.e., `total_classes` is 0), the function returns 0% attendance to avoid division by zero errors.
-- ===============================================
