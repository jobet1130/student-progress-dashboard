DELIMITER $$

CREATE TRIGGER auto_calculate_gpa
AFTER INSERT OR UPDATE ON grades
FOR EACH ROW
BEGIN
    DECLARE total_points DECIMAL(10, 2);
    DECLARE total_courses INT;
    DECLARE new_gpa DECIMAL(3, 2);

    -- Calculate total grade points
    SELECT SUM(grade_points) INTO total_points
    FROM grades
    WHERE student_id = NEW.student_id;

    -- Count the total number of courses taken by the student
    SELECT COUNT(*) INTO total_courses
    FROM grades
    WHERE student_id = NEW.student_id;

    -- Calculate GPA
    SET new_gpa = total_points / total_courses;

    -- Update the GPA in the students table
    UPDATE students
    SET gpa = new_gpa
    WHERE id = NEW.student_id;
END $$

DELIMITER ;
