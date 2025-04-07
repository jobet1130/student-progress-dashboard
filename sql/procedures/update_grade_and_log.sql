-- ===============================================
-- Stored Procedure: update_grade_and_log
-- Purpose: Update a student's grade for a given course and log the change.
-- ===============================================
DELIMITER $$

CREATE PROCEDURE update_grade_and_log(
    IN p_student_id INT,      -- The ID of the student whose grade needs to be updated
    IN p_course_id INT,       -- The ID of the course the grade corresponds to
    IN p_new_grade DECIMAL(5, 2), -- The new grade to be set for the student
    IN p_updated_by INT       -- The ID of the user updating the grade
)
BEGIN
    DECLARE old_grade DECIMAL(5, 2); -- Variable to store the old grade before updating

    -- Step 1: Get the current grade for the student in the given course
    SELECT grade INTO old_grade
    FROM grades
    WHERE student_id = p_student_id
      AND course_id = p_course_id;

    -- Step 2: Update the grade in the grades table
    UPDATE grades
    SET grade = p_new_grade,
        updated_at = NOW(),               -- Record the time of the update
        updated_by = p_updated_by         -- Record the user making the update
    WHERE student_id = p_student_id
      AND course_id = p_course_id;

    -- Step 3: Log the grade change into the audit_log table
    INSERT INTO grade_change_log (
        student_id,
        course_id,
        old_grade,
        new_grade,
        change_timestamp,
        updated_by
    )
    VALUES (
        p_student_id,
        p_course_id,
        old_grade,
        p_new_grade,
        NOW(),                            -- Record the time of the change
        p_updated_by                      -- Record the user who made the change
    );

    -- Step 4: Optionally, add more logic if needed (e.g., notifications or validations)
END $$

DELIMITER ;

-- Explanation:
-- This stored procedure updates a student's grade for a given course and logs the change in an audit table.
-- Parameters:
-- p_student_id: The ID of the student whose grade is being updated.
-- p_course_id: The ID of the course the grade corresponds to.
-- p_new_grade: The new grade to be set for the student.
-- p_updated_by: The ID of the user who is updating the grade.

-- Process Flow:
-- 1. Fetch the current grade for the student and course.
-- 2. Update the grade in the `grades` table.
-- 3. Insert a log of the grade change into the `grade_change_log` table, which tracks changes to student grades for auditing purposes.

-- Example usage:
-- CALL update_grade_and_log(1, 101, 85.5, 1001);
-- This will update the grade of student 1 in course 101 to 85.5, and log the change by user 1001.
