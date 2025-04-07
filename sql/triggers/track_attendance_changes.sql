DELIMITER $$

CREATE TRIGGER track_attendance_changes
AFTER UPDATE ON attendance
FOR EACH ROW
BEGIN
    DECLARE old_status VARCHAR(10);
    DECLARE new_status VARCHAR(10);
    DECLARE change_time TIMESTAMP;
    DECLARE updated_by INT;

    SET old_status = OLD.status;
    SET new_status = NEW.status;
    SET change_time = NOW();
    SET updated_by = CURRENT_USER();

    IF old_status <> new_status THEN
        INSERT INTO attendance_change_audit (
            student_id,
            course_id,
            old_status,
            new_status,
            change_time,
            updated_by
        )
        VALUES (
            OLD.student_id,
            OLD.course_id,
            old_status,
            new_status,
            change_time,
            updated_by
        );
    END IF;
END $$

DELIMITER ;
