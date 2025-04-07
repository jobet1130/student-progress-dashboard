DELIMITER $$

CREATE PROCEDURE get_student_gpa(
    IN p_student_id INT,
    OUT p_gpa DECIMAL(5, 2)
)
BEGIN
    DECLARE total_points DECIMAL(10, 2) DEFAULT 0;
    DECLARE total_courses INT DEFAULT 0;
    DECLARE grade DECIMAL(5, 2);
    DECLARE credit_hours INT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR 
        SELECT grade, credit_hours FROM grades 
        JOIN courses ON grades.course_id = courses.id 
        WHERE student_id = p_student_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    -- Calculate GPA
    read_loop: LOOP
        FETCH cur INTO grade, credit_hours;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET total_points = total_points + (grade * credit_hours);
        SET total_courses = total_courses + credit_hours;
    END LOOP;

    CLOSE cur;

    -- Calculate the GPA
    IF total_courses > 0 THEN
        SET p_gpa = total_points / total_courses;
    ELSE
        SET p_gpa = 0;
    END IF;

END $$

DELIMITER ;
