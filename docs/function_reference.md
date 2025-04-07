# Function Reference: Student Progress Dashboard

This document provides a reference for the various functions used in the Student Progress Dashboard system. Each function's purpose, parameters, and return values are outlined to help developers understand the system's functionality.

## Functions

### 1. **addStudent()**

**Purpose:** Adds a new student record to the `students` table.

#### Parameters:
- `firstName` (`String`): The first name of the student.
- `lastName` (`String`): The last name of the student.
- `dateOfBirth` (`Date`): The student's date of birth.
- `gender` (`String`): The student's gender (one of 'Male', 'Female', 'Other').
- `gradeLevel` (`Integer`): The student's grade level.
- `enrollmentDate` (`Date`): The date the student enrolled.
- `email` (`String`): The student's email address.
- `phone` (`String`): The student's phone number.
- `address` (`String`): The student's address.
- `emergencyContact` (`String`): The student's emergency contact name.
- `nationalID` (`String`): The student's national ID.
- `status` (`String`): The student's status (one of 'Active', 'Graduated', 'Dropped').

#### Return Value:
- `Boolean`: `true` if the student was added successfully, `false` otherwise.

---

### 2. **getStudentByID()**

**Purpose:** Retrieves a student record based on their `StudentID`.

#### Parameters:
- `studentID` (`Integer`): The unique identifier for the student.

#### Return Value:
- `Student Object`: A student object containing details like `FirstName`, `LastName`, `GradeLevel`, `Email`, etc., or `null` if no student is found.

---

### 3. **updateStudentStatus()**

**Purpose:** Updates the status of a student (e.g., from 'Active' to 'Graduated').

#### Parameters:
- `studentID` (`Integer`): The unique identifier for the student.
- `newStatus` (`String`): The new status of the student (one of 'Active', 'Graduated', 'Dropped').

#### Return Value:
- `Boolean`: `true` if the status was updated successfully, `false` otherwise.

---

### 4. **getCoursesByTeacher()**

**Purpose:** Retrieves all courses taught by a specific teacher.

#### Parameters:
- `teacherID` (`Integer`): The unique identifier for the teacher.

#### Return Value:
- `Array of Course Objects`: A list of courses taught by the specified teacher.

---

### 5. **addCourse()**

**Purpose:** Adds a new course to the `courses` table.

#### Parameters:
- `courseName` (`String`): The name of the course.
- `teacherID` (`Integer`): The ID of the teacher responsible for the course.
- `courseCode` (`String`): The course's unique code.
- `credits` (`Integer`): The number of credits the course offers.
- `description` (`String`): A brief description of the course.
- `schedule` (`String`): The course schedule (days and times).
- `prerequisites` (`String`): Prerequisite courses or requirements.

#### Return Value:
- `Boolean`: `true` if the course was added successfully, `false` otherwise.

---

### 6. **enrollStudentInCourse()**

**Purpose:** Enrolls a student in a specific course.

#### Parameters:
- `studentID` (`Integer`): The unique identifier for the student.
- `courseID` (`Integer`): The unique identifier for the course.
- `semester` (`String`): The semester the student is enrolling in.
- `year` (`Integer`): The year the student is enrolling in.

#### Return Value:
- `Boolean`: `true` if the student was enrolled successfully, `false` otherwise.

---

### 7. **getStudentGrades()**

**Purpose:** Retrieves the grades of a student for all courses they are enrolled in.

#### Parameters:
- `studentID` (`Integer`): The unique identifier for the student.

#### Return Value:
- `Array of Grade Objects`: A list of grades for each course, containing details such as `CourseID`, `Grade`, `Semester`, `Year`, etc.

---

### 8. **updateGrade()**

**Purpose:** Updates the grade for a student's course.

#### Parameters:
- `enrollmentID` (`Integer`): The unique identifier for the student's enrollment in a course.
- `newGrade` (`Float`): The new grade to be assigned.
- `comments` (`String`): Optional comments from the instructor.

#### Return Value:
- `Boolean`: `true` if the grade was updated successfully, `false` otherwise.

---

### 9. **logAttendance()**

**Purpose:** Records a student's attendance for a specific course.

#### Parameters:
- `studentID` (`Integer`): The unique identifier for the student.
- `courseID` (`Integer`): The unique identifier for the course.
- `attendanceStatus` (`String`): The status of the student's attendance (one of 'Present', 'Absent', 'Late').
- `date` (`Date`): The date of attendance.
- `reason` (`String`): Reason for absence (if applicable).

#### Return Value:
- `Boolean`: `true` if the attendance was logged successfully, `false` otherwise.

---

### 10. **getStudentFeedback()**

**Purpose:** Retrieves all feedback provided by a student to teachers.

#### Parameters:
- `studentID` (`Integer`): The unique identifier for the student.

#### Return Value:
- `Array of Feedback Objects`: A list of feedback entries provided by the student, including `TeacherID`, `Comment`, `Rating`, etc.

---

### 11. **sendNotification()**

**Purpose:** Sends a notification to a student.

#### Parameters:
- `studentID` (`Integer`): The unique identifier for the student.
- `message` (`String`): The message to be sent.
- `status` (`String`): The status of the notification ('Sent', 'Pending', 'Failed').

#### Return Value:
- `Boolean`: `true` if the notification was sent successfully, `false` otherwise.

---

### 12. **getCourseAttendance()**

**Purpose:** Retrieves the attendance records for a specific course.

#### Parameters:
- `courseID` (`Integer`): The unique identifier for the course.

#### Return Value:
- `Array of Attendance Objects`: A list of attendance records for the course, containing `StudentID`, `Status`, `Date`, etc.

---

### 13. **updateAttendance()**

**Purpose:** Updates the attendance status of a student in a specific course.

#### Parameters:
- `attendanceID` (`Integer`): The unique identifier for the attendance record.
- `newStatus` (`String`): The new attendance status ('Present', 'Absent', 'Late').
- `reason` (`String`): Optional reason for the status change (if applicable).

#### Return Value:
- `Boolean`: `true` if the attendance was updated successfully, `false` otherwise.

---

### 14. **auditGradeChange()**

**Purpose:** Logs a grade change event in the `gradeaudit` table.

#### Parameters:
- `enrollmentID` (`Integer`): The unique identifier for the enrollment.
- `oldGrade` (`Float`): The previous grade before the change.
- `newGrade` (`Float`): The new grade after the change.
- `changedBy` (`Integer`): The ID of the user making the change.
- `reasonForChange` (`String`): Reason for the grade change.

#### Return Value:
- `Boolean`: `true` if the grade change was logged successfully, `false` otherwise.

---

## Conclusion

This function reference document serves as a comprehensive guide to the core functions implemented in the Student Progress Dashboard. Developers can refer to this document to understand the functionality of each method, its parameters, and expected return values to effectively utilize the system and perform necessary operations.
