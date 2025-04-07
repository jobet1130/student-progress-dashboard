DELIMITER $$

CREATE TRIGGER audit_feedback_changes
AFTER UPDATE ON feedback
FOR EACH ROW
BEGIN
    DECLARE old_feedback TEXT;
    DECLARE new_feedback TEXT;
    DECLARE change_time TIMESTAMP;
    DECLARE updated_by INT;

    SET old_feedback = OLD.feedback_content;
    SET new_feedback = NEW.feedback_content;
    SET change_time = NOW();
    SET updated_by = CURRENT_USER();

    IF old_feedback <> new_feedback THEN
        INSERT INTO feedback_change_audit (
            feedback_id,
            student_id,
            course_id,
            old_feedback,
            new_feedback,
            change_time,
            updated_by
        )
        VALUES (
            OLD.id,
            OLD.student_id,
            OLD.course_id,
            old_feedback,
            new_feedback,
            change_time,
            updated_by
        );
    END IF;
END $$

DELIMITER ;
