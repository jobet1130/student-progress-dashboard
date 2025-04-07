DELIMITER $$

CREATE TRIGGER prevent_grade_changes_after_finalization
BEFORE UPDATE ON grades
FOR EACH ROW
BEGIN
    DECLARE is_finalized BOOLEAN;

    -- Check if the course grades have been finalized
    SELECT finalized INTO is_finalized
    FROM courses
    WHERE id = NEW.course_id;

    IF is_finalized THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Grade changes are not allowed after course grades have been finalized';
    END IF;
END $$

DELIMITER ;
