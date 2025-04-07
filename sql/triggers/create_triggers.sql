-- Change the delimiter for multi-line trigger definitions
DELIMITER $$

-- Trigger 1: Audit Grade Changes
CREATE TRIGGER audit_grade_changes
AFTER UPDATE ON grades
FOR EACH ROW
BEGIN
    DECLARE old_grade DECIMAL(5, 2);
    DECLARE new_grade DECIMAL(5, 2);
    DECLARE change_time TIMESTAMP;
    DECLARE updated_by INT;

    SET old_grade = OLD.grade;
    SET new_grade = NEW.grade;
    SET change_time = NOW();
    SET updated_by = CURRENT_USER();

    IF old_grade <> new_grade THEN
        INSERT INTO grade_change_audit (
            student_id,
            course_id,
            old_grade,
            new_grade,
            change_time,
            updated_by
        )
        VALUES (
            OLD.student_id,
            OLD.course_id,
            old_grade,
            new_grade,
            change_time,
            updated_by
        );
    END IF;
END $$

-- Trigger 2: Enforce Attendance Limit
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

-- Trigger 3: Auto-Calculate GPA
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

-- Trigger 4: Track Attendance Changes
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

-- Trigger 5: Prevent Duplicate Enrollments
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

-- Trigger 6: Audit Feedback Changes
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

-- Trigger 7: Prevent Grade Changes After Finalization
CREATE TRIGGER prevent_grade_changes_after_finalization
BEFORE UPDATE ON grades
FOR EACH ROW
BEGIN
    DECLARE is_finalized BOOLEAN;

    -- Check if the course grades have been finalized
    SELECT finalized INTO is_finalized
    FROM courses
    WHERE id = NEW.course_id;

    IF is_finalized THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Grade changes are not allowed after course grades have been finalized';
    END IF;
END $$

-- Reset the delimiter to default
DELIMITER ;
