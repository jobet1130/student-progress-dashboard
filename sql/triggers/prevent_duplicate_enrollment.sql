DELIMITER $$

CREATE TRIGGER prevent_duplicate_enrollment
BEFORE INSERT ON enrollments
FOR EACH ROW
BEGIN
    DECLARE existing_enrollment INT;

    -- Check if the student is already enrolled in the course for this term
    SELECT COUNT(*) INTO existing_enrollment
    FROM enrollments
    WHERE student_id = NEW.student_id
      AND course_id = NEW.course_id
      AND term = NEW.term;

    -- If already enrolled, prevent the insertion
    IF existing_enrollment > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student is already enrolled in this course for the specified term';
    END IF;
END $$

DELIMITER ;
