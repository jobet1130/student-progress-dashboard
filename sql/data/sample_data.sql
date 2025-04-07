-- ===============================================
-- Insert Sample Data into Tables
-- ===============================================

-- Sample data for students
INSERT INTO students (id, first_name, last_name, date_of_birth, enrollment_date, email)
VALUES
    (1, 'John', 'Doe', '2000-05-10', '2018-08-15', 'john.doe@email.com'),
    (2, 'Jane', 'Smith', '1999-11-23', '2017-09-10', 'jane.smith@email.com'),
    (3, 'Alice', 'Johnson', '2001-03-12', '2019-01-22', 'alice.johnson@email.com'),
    (4, 'Bob', 'Brown', '2000-07-02', '2018-09-05', 'bob.brown@email.com');

-- Sample data for teachers
INSERT INTO teachers (id, first_name, last_name, department, email)
VALUES
    (1, 'Dr. William', 'Taylor', 'Computer Science', 'william.taylor@school.edu'),
    (2, 'Prof. Emily', 'Davis', 'Mathematics', 'emily.davis@school.edu'),
    (3, 'Dr. Sarah', 'Wilson', 'Physics', 'sarah.wilson@school.edu');

-- Sample data for courses
INSERT INTO courses (id, course_name, teacher_id, credits)
VALUES
    (1, 'Introduction to Programming', 1, 4),
    (2, 'Data Structures and Algorithms', 1, 3),
    (3, 'Calculus I', 2, 4),
    (4, 'Physics 101', 3, 3);

-- Sample data for enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES
    (1, 1, '2018-08-15'),
    (1, 2, '2018-08-15'),
    (2, 3, '2017-09-10'),
    (3, 4, '2019-01-22'),
    (4, 1, '2018-09-05'),
    (4, 3, '2018-09-05');

-- Sample data for grades
INSERT INTO grades (student_id, course_id, grade)
VALUES
    (1, 1, 'A'),
    (1, 2, 'B'),
    (2, 3, 'A'),
    (3, 4, 'B'),
    (4, 1, 'C'),
    (4, 3, 'A');

-- Sample data for attendance
INSERT INTO attendance (student_id, course_id, teacher_id, date, status)
VALUES
    (1, 1, 1, '2023-09-01', 'Present'),
    (1, 2, 1, '2023-09-01', 'Absent'),
    (2, 3, 2, '2023-09-01', 'Present'),
    (3, 4, 3, '2023-09-01', 'Present'),
    (4, 1, 1, '2023-09-01', 'Present'),
    (4, 3, 2, '2023-09-01', 'Absent');

-- Sample data for feedback
INSERT INTO feedback (student_id, teacher_id, course_id, rating, comment)
VALUES
    (1, 1, 1, 4, 'Great course! Very engaging.'),
    (2, 2, 3, 5, 'Best mathematics course I have taken!'),
    (3, 3, 4, 3, 'Good course but needs better examples.'),
    (4, 1, 1, 2, 'Course material was too difficult.');

-- ===============================================
-- Verifying Sample Data Insertion
-- ===============================================

-- Check students data
SELECT * FROM students;

-- Check teachers data
SELECT * FROM teachers;

-- Check courses data
SELECT * FROM courses;

-- Check enrollments data
SELECT * FROM enrollments;

-- Check grades data
SELECT * FROM grades;

-- Check attendance data
SELECT * FROM attendance;

-- Check feedback data
SELECT * FROM feedback;
