DELIMITER $$

CREATE TRIGGER audit_grade_changes
AFTER UPDATE ON grades
FOR EACH ROW
BEGIN
    -- Declare variables to hold the old and new grade values, the time of change, and the user who updated the grade
    DECLARE old_grade DECIMAL(5, 2);
    DECLARE new_grade DECIMAL(5, 2);
    DECLARE change_time TIMESTAMP;
    DECLARE updated_by INT;

    -- Capture the old and new grade values
    SET old_grade = OLD.grade;
    SET new_grade = NEW.grade;

    -- Get the current timestamp of the change
    SET change_time = NOW();

    -- Capture the user who updated the grade. Assuming there's a system to track the user ID who made the update
    SET updated_by = CURRENT_USER();  -- This would be replaced with an actual user ID if needed

    -- Only log changes if the grade has actually been modified
    IF old_grade <> new_grade THEN
        -- Insert the audit record into the grade_change_audit table
        INSERT INTO grade_change_audit (
            student_id,
            course_id,
            old_grade,
            new_grade,
            change_time,
            updated_by
        )
        VALUES (
            OLD.student_id,
            OLD.course_id,
            old_grade,
            new_grade,
            change_time,
            updated_by
        );
    END IF;

END $$

DELIMITER ;
