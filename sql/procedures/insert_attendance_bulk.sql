DELIMITER $$

CREATE PROCEDURE insert_attendance_bulk(
    IN p_course_id INT,
    IN p_attendance_data JSON,  -- The data will be passed in JSON format (e.g., [{"student_id": 1, "status": "present"}, ...])
    IN p_updated_by INT
)
BEGIN
    DECLARE student_id INT;
    DECLARE status VARCHAR(10);
    DECLARE i INT DEFAULT 0;
    DECLARE total_students INT;

    -- Get the total number of students in the attendance data
    SET total_students = JSON_LENGTH(p_attendance_data);

    -- Loop through each record in the JSON data
    WHILE i < total_students DO
        SET student_id = JSON_UNQUOTE(JSON_EXTRACT(p_attendance_data, CONCAT('$[', i, '].student_id')));
        SET status = JSON_UNQUOTE(JSON_EXTRACT(p_attendance_data, CONCAT('$[', i, '].status')));

        -- Insert each attendance record into the attendance table
        INSERT INTO attendance (student_id, course_id, status, created_at, updated_by)
        VALUES (student_id, p_course_id, status, NOW(), p_updated_by);

        SET i = i + 1;
    END WHILE;

END $$

DELIMITER ;
