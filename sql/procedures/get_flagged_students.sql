DELIMITER $$

CREATE PROCEDURE get_flagged_students(
    OUT p_flagged_students JSON
)
BEGIN
    DECLARE student_id INT;
    DECLARE avg_gpa DECIMAL(5, 2);
    DECLARE avg_attendance DECIMAL(5, 2);
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT student_id, AVG(gpa) AS avg_gpa, AVG(attendance_percentage) AS avg_attendance
        FROM student_performance_view
        GROUP BY student_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    SET p_flagged_students = JSON_ARRAY();

    -- Loop through all students and flag those who are underperforming
    read_loop: LOOP
        FETCH cur INTO student_id, avg_gpa, avg_attendance;
        IF done THEN
            LEAVE read_loop;
        END IF;

        IF avg_gpa < 2.0 OR avg_attendance < 75.0 THEN
            SET p_flagged_students = JSON_ARRAY_APPEND(p_flagged_students, '$', JSON_OBJECT('student_id', student_id, 'avg_gpa', avg_gpa, 'avg_attendance', avg_attendance));
        END IF;
    END LOOP;

    CLOSE cur;

END $$

DELIMITER ;
