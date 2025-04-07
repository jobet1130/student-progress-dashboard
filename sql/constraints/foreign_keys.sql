-- ===============================================
-- Add Foreign Key Constraints to Ensure Referential Integrity
-- ===============================================

-- Ensure that the `students` table has a valid foreign key reference from `enrollments`
ALTER TABLE enrollments
    ADD CONSTRAINT fk_enrollments_student_id
    FOREIGN KEY (student_id) 
    REFERENCES students(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Ensure that the `courses` table has a valid foreign key reference from `enrollments`
ALTER TABLE enrollments
    ADD CONSTRAINT fk_enrollments_course_id
    FOREIGN KEY (course_id) 
    REFERENCES courses(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Ensure that the `teachers` table has a valid foreign key reference from `courses`
ALTER TABLE courses
    ADD CONSTRAINT fk_courses_teacher_id
    FOREIGN KEY (teacher_id)
    REFERENCES teachers(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- Ensure that the `feedback` table has a valid foreign key reference from `students`
ALTER TABLE feedback
    ADD CONSTRAINT fk_feedback_student_id
    FOREIGN KEY (student_id)
    REFERENCES students(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Ensure that the `feedback` table has a valid foreign key reference from `teachers`
ALTER TABLE feedback
    ADD CONSTRAINT fk_feedback_teacher_id
    FOREIGN KEY (teacher_id)
    REFERENCES teachers(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Ensure that the `feedback` table has a valid foreign key reference from `courses`
ALTER TABLE feedback
    ADD CONSTRAINT fk_feedback_course_id
    FOREIGN KEY (course_id)
    REFERENCES courses(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Ensure that the `grades` table has a valid foreign key reference from `students`
ALTER TABLE grades
    ADD CONSTRAINT fk_grades_student_id
    FOREIGN KEY (student_id)
    REFERENCES students(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Ensure that the `grades` table has a valid foreign key reference from `courses`
ALTER TABLE grades
    ADD CONSTRAINT fk_grades_course_id
    FOREIGN KEY (course_id)
    REFERENCES courses(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Ensure that the `attendance` table has a valid foreign key reference from `students`
ALTER TABLE attendance
    ADD CONSTRAINT fk_attendance_student_id
    FOREIGN KEY (student_id)
    REFERENCES students(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Ensure that the `attendance` table has a valid foreign key reference from `courses`
ALTER TABLE attendance
    ADD CONSTRAINT fk_attendance_course_id
    FOREIGN KEY (course_id)
    REFERENCES courses(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Ensure that the `attendance` table has a valid foreign key reference from `teachers`
ALTER TABLE attendance
    ADD CONSTRAINT fk_attendance_teacher_id
    FOREIGN KEY (teacher_id)
    REFERENCES teachers(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- ===============================================
-- Foreign Key Constraint Summary
-- ===============================================
-- 1. `enrollments` references `students` and `courses`.
-- 2. `courses` references `teachers`.
-- 3. `feedback` references `students`, `teachers`, and `courses`.
-- 4. `grades` references `students` and `courses`.
-- 5. `attendance` references `students`, `courses`, and `teachers`.
-- 
-- Each foreign key ensures referential integrity across related tables.
-- `ON DELETE CASCADE` ensures that if a record in the referenced table is deleted, the corresponding records in the dependent table are also deleted.
-- `ON UPDATE CASCADE` ensures that any update to the referenced primary key will automatically update the corresponding foreign key in dependent tables.
-- `ON DELETE SET NULL` in the `courses` table for the `teacher_id` means that if a teacher is deleted, the teacher reference in the course will be set to NULL instead of deleting the course.
