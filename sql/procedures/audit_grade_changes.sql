DELIMITER $$

CREATE PROCEDURE audit_grade_changes(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_old_grade DECIMAL(5, 2),
    IN p_new_grade DECIMAL(5, 2),
    IN p_updated_by INT
)
BEGIN
    -- Insert into the audit log for grade changes
    INSERT INTO grade_change_log (student_id, course_id, old_grade, new_grade, change_timestamp, updated_by)
    VALUES (p_student_id, p_course_id, p_old_grade, p_new_grade, NOW(), p_updated_by);

END $$

DELIMITER ;
