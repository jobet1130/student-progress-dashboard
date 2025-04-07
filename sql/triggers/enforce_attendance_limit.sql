DELIMITER $$

CREATE TRIGGER enforce_attendance_limit
BEFORE INSERT ON attendance
FOR EACH ROW
BEGIN
    DECLARE total_absences INT;

    -- Count the number of absences for this student and course
    SELECT COUNT(*) INTO total_absences
    FROM attendance
    WHERE student_id = NEW.student_id
      AND course_id = NEW.course_id
      AND status = 'absent';

    -- If absences exceed 3, prevent the new absence entry
    IF total_absences >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student has exceeded maximum allowable absences for this course';
    END IF;
END $$

DELIMITER ;
