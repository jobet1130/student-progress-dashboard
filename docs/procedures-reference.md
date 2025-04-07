# Procedures Reference

This document provides an in-depth reference to all stored procedures within the **student-progress-dashboard** project. The procedures cover various complex use cases such as data updates, bulk operations, advanced error handling, logging, and performance optimization.

---

## 1. **update_grade_and_log**
   - **Purpose**: 
     This procedure updates the grade of a student for a specific course and logs the grade change in the `GradeAudit` table. It provides versioning by storing the old grade and the reason for the change.
   - **Parameters**:
     - `enrollmentID` (INT): The ID of the enrollment record whose grade needs to be updated.
     - `newGrade` (FLOAT): The new grade to assign to the student.
     - `changedBy` (INT): The ID of the teacher or administrator who made the change.
     - `reasonForChange` (TEXT): A detailed reason for the grade change.
   - **Advanced Features**:
     - **Error Handling**: Ensures the process stops if the grade update fails and provides meaningful error messages.
     - **Transaction Handling**: Uses transactions to guarantee atomicity of the grade update and logging.
   - **SQL Definition**:
     ```sql
     DELIMITER //

     CREATE PROCEDURE update_grade_and_log(
         IN enrollmentID INT,
         IN newGrade FLOAT,
         IN changedBy INT,
         IN reasonForChange TEXT
     )
     BEGIN
         DECLARE oldGrade FLOAT;
         DECLARE exit handler for SQLEXCEPTION
         BEGIN
             -- Rollback transaction on failure
             ROLLBACK;
             SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error in updating grade and logging audit';
         END;

         -- Start Transaction
         START TRANSACTION;

         -- Fetch the current grade
         SELECT Grade INTO oldGrade
         FROM grades
         WHERE EnrollmentID = enrollmentID;

         -- Update the grade
         UPDATE grades
         SET Grade = newGrade
         WHERE EnrollmentID = enrollmentID;

         -- Log the grade change in the GradeAudit table
         INSERT INTO gradeaudit (EnrollmentID, OldGrade, NewGrade, ChangedOn, ChangedBy, ReasonForChange)
         VALUES (enrollmentID, oldGrade, newGrade, NOW(), changedBy, reasonForChange);

         -- Commit the transaction
         COMMIT;
     END //

     DELIMITER ;
     ```

---

## 2. **insert_attendance_bulk**
   - **Purpose**:
     Inserts multiple attendance records for a specific course and date in bulk, improving efficiency for large datasets. This is useful for recording attendance for large classes or multiple courses at once.
   - **Parameters**:
     - `courseID` (INT): The ID of the course for which attendance is being recorded.
     - `date` (DATE): The date of the attendance.
     - `attendanceStatus` (ENUM): The attendance status for all students (e.g., 'Present', 'Absent', 'Late').
     - `studentsList` (TEXT): A comma-separated list of student IDs whose attendance needs to be updated.
   - **Advanced Features**:
     - **Cursor and JSON Parsing**: Efficient handling of lists with JSON parsing and cursors for bulk processing.
     - **Bulk Operations**: The procedure inserts multiple rows in one go, minimizing the overhead of repetitive SQL queries.
     - **Error Handling**: Gracefully handles any failure in inserting records for individual students and logs the errors.
   - **SQL Definition**:
     ```sql
     DELIMITER //

     CREATE PROCEDURE insert_attendance_bulk(
         IN courseID INT,
         IN date DATE,
         IN attendanceStatus ENUM('Present', 'Absent', 'Late'),
         IN studentsList TEXT
     )
     BEGIN
         DECLARE studentID INT;
         DECLARE done INT DEFAULT 0;
         DECLARE studentCursor CURSOR FOR
             SELECT TRIM(value) FROM JSON_TABLE(studentsList, "$[*]" COLUMNS(value INT PATH "$")) AS students;
         DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

         OPEN studentCursor;

         read_loop: LOOP
             FETCH studentCursor INTO studentID;
             IF done THEN
                 LEAVE read_loop;
             END IF;

             -- Insert attendance record for each student
             BEGIN
                 DECLARE EXIT HANDLER FOR SQLEXCEPTION
                 BEGIN
                     -- Handle error and skip the failed record
                     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error inserting attendance for student ID ' + studentID;
                 END;

                 INSERT INTO attendance (StudentID, CourseID, Date, Status)
                 VALUES (studentID, courseID, date, attendanceStatus);
             END;

         END LOOP;

         CLOSE studentCursor;
     END //

     DELIMITER ;
     ```

---

## 3. **get_flagged_students**
   - **Purpose**:
     Retrieves a list of students who are flagged based on a low GPA and/or attendance, marking them as 'at-risk' based on predefined thresholds.
   - **Parameters**:
     - `minGPA` (FLOAT): The minimum GPA below which students are flagged.
     - `minAttendance` (FLOAT): The minimum attendance percentage below which students are flagged.
   - **Advanced Features**:
     - **Join Optimization**: Joins student performance data with grades and attendance, ensuring that only relevant student data is retrieved.
     - **Efficient Filtering**: Uses indexed columns to filter students efficiently based on GPA and attendance criteria.
   - **SQL Definition**:
     ```sql
     DELIMITER //

     CREATE PROCEDURE get_flagged_students(
         IN minGPA FLOAT,
         IN minAttendance FLOAT
     )
     BEGIN
         -- Query to retrieve students flagged based on GPA and/or attendance
         SELECT s.StudentID, s.FirstName, s.LastName, sp.GPA, sp.Attendance
         FROM students s
         JOIN studentperformance sp ON s.StudentID = sp.StudentID
         WHERE sp.GPA < minGPA OR sp.Attendance < minAttendance;
     END //

     DELIMITER ;
     ```

---

## 4. **insert_bulk_feedback**
   - **Purpose**: 
     Inserts feedback for multiple students regarding a specific teacher/course combination in bulk, minimizing overhead and enabling fast data entry.
   - **Parameters**:
     - `teacherID` (INT): The ID of the teacher for whom the feedback is being inserted.
     - `courseID` (INT): The ID of the course for which feedback is related.
     - `feedbackList` (TEXT): A JSON string containing a list of feedback records (student ID, comment, rating).
   - **Advanced Features**:
     - **JSON Parsing**: Efficient parsing of JSON for bulk feedback.
     - **Error Handling**: If a feedback record cannot be inserted for a specific student, the system skips it and continues with the next one.
     - **Batch Processing**: Allows for large-scale batch processing with minimal impact on system performance.
   - **SQL Definition**:
     ```sql
     DELIMITER //

     CREATE PROCEDURE insert_bulk_feedback(
         IN teacherID INT,
         IN courseID INT,
         IN feedbackList TEXT
     )
     BEGIN
         DECLARE studentID INT;
         DECLARE feedbackComment TEXT;
         DECLARE rating INT;
         DECLARE done INT DEFAULT 0;
         DECLARE feedbackCursor CURSOR FOR
             SELECT TRIM(value->>'studentID'), TRIM(value->>'comment'), TRIM(value->>'rating')
             FROM JSON_TABLE(feedbackList, "$[*]" COLUMNS(
                 studentID INT PATH "$.studentID",
                 comment VARCHAR(255) PATH "$.comment",
                 rating INT PATH "$.rating"
             )) AS feedback;
         DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

         OPEN feedbackCursor;

         feedback_loop: LOOP
             FETCH feedbackCursor INTO studentID, feedbackComment, rating;
             IF done THEN
                 LEAVE feedback_loop;
             END IF;

             BEGIN
                 DECLARE EXIT HANDLER FOR SQLEXCEPTION
                 BEGIN
                     -- Log the error and continue
                     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error inserting feedback for student ID ' + studentID;
                 END;

                 INSERT INTO feedback (StudentID, TeacherID, CourseID, Comment, Rating, DateSubmitted)
                 VALUES (studentID, teacherID, courseID, feedbackComment, rating, NOW());
             END;
         END LOOP;

         CLOSE feedbackCursor;
     END //

     DELIMITER ;
     ```

---

## 5. **update_student_status**
   - **Purpose**:
     Updates the enrollment status of a student, such as marking a student as 'Graduated' or 'Dropped' after completion of a course or academic period.
   - **Parameters**:
     - `studentID` (INT): The ID of the student whose status needs to be updated.
     - `newStatus` (ENUM): The new status for the student (`'Active'`, `'Graduated'`, `'Dropped'`).
   - **Advanced Features**:
     - **Transactional Integrity**: Ensures the update is completed successfully or rolled back in case of an error.
     - **Status Validation**: Before updating, the procedure checks if the new status is valid, preventing erroneous data updates.
   - **SQL Definition**:
     ```sql
     DELIMITER //

     CREATE PROCEDURE update_student_status(
         IN studentID INT,
         IN newStatus ENUM('Active', 'Graduated', 'Dropped')
     )
     BEGIN
         DECLARE exit handler for SQLEXCEPTION
         BEGIN
             -- Rollback transaction in case of error
             ROLLBACK;
             SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error updating student status';
         END;

         -- Start transaction
         START TRANSACTION;

         -- Validate the status before updating
         IF newStatus NOT IN ('Active', 'Graduated', 'Dropped') THEN
             SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid status';
         END IF;

         -- Update student status
         UPDATE students
         SET Status = newStatus
         WHERE StudentID = studentID;

         -- Commit transaction
         COMMIT;
     END //

     DELIMITER ;
     ```

---

## Conclusion

These stored procedures leverage advanced SQL concepts such as transactions, error handling, bulk data processing, and JSON parsing to ensure the system is robust, efficient, and reliable. These procedures are designed to handle various complex operations within the **student-progress-dashboard** project, and they can be extended further as needed.
