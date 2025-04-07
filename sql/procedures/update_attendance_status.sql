DELIMITER $$

CREATE PROCEDURE update_attendance_status(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_new_status VARCHAR(10),
    IN p_updated_by INT
)
BEGIN
    -- Update the attendance record for the student and course
    UPDATE attendance
    SET status = p_new_status,
        updated_at = NOW(),
        updated_by = p_updated_by
    WHERE student_id = p_student_id
      AND course_id = p_course_id;

END $$

DELIMITER ;
