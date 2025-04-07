# Database Schema: Student Progress Dashboard

This document provides a detailed description of the database schema for the Student Progress Dashboard, designed to track student information, enrollment, grades, attendance, assignments, feedback, and other performance-related data.

## Tables

### 1. **Students**

**Description:** Contains details about students enrolled in the system.

| Field           | Type         | Description                                      |
|-----------------|--------------|--------------------------------------------------|
| `StudentID`     | `INT` [PK]   | Unique identifier for each student.              |
| `FirstName`     | `VARCHAR(50)`| Student's first name.                            |
| `LastName`      | `VARCHAR(50)`| Student's last name.                             |
| `DateOfBirth`   | `DATE`       | Student's date of birth.                         |
| `Gender`        | `ENUM`       | Gender of the student ('Male', 'Female', 'Other'). |
| `GradeLevel`    | `INT`        | The grade level of the student.                  |
| `EnrollmentDate`| `DATE`       | Date the student enrolled.                       |
| `Email`         | `VARCHAR(100)`| Student's email address.                        |
| `Phone`         | `VARCHAR(20)`| Student's phone number.                          |
| `Address`       | `VARCHAR(255)`| Student's address.                              |
| `EmergencyContact`| `VARCHAR(50)`| Emergency contact name.                         |
| `NationalID`    | `VARCHAR(50)`| National identification number.                  |
| `Status`        | `ENUM`       | Current student status ('Active', 'Graduated', 'Dropped'). |

### 2. **Teachers**

**Description:** Stores information about teachers in the system.

| Field         | Type         | Description                                     |
|---------------|--------------|-------------------------------------------------|
| `TeacherID`   | `INT` [PK]   | Unique identifier for each teacher.             |
| `FirstName`   | `VARCHAR(50)`| Teacher's first name.                           |
| `LastName`    | `VARCHAR(50)`| Teacher's last name.                            |
| `Department`  | `VARCHAR(50)`| Department the teacher belongs to.              |
| `Email`       | `VARCHAR(100)`| Teacher's email address.                        |
| `Phone`       | `VARCHAR(20)`| Teacher's phone number.                         |
| `Office`      | `VARCHAR(50)`| Teacher's office location.                      |
| `HireDate`    | `DATE`       | Date the teacher was hired.                     |
| `Status`      | `ENUM`       | Teacher's current status ('Active', 'Retired', 'On Leave'). |

### 3. **Courses**

**Description:** Stores details of courses offered by the institution.

| Field         | Type         | Description                                      |
|---------------|--------------|--------------------------------------------------|
| `CourseID`    | `INT` [PK]   | Unique identifier for the course.                |
| `CourseName`  | `VARCHAR(100)`| Name of the course.                             |
| `TeacherID`   | `INT` [FK]   | Foreign key referencing the teacher.             |
| `CourseCode`  | `VARCHAR(50)`| Course identifier code.                         |
| `Credits`     | `INT`        | Number of credits awarded for the course.        |
| `Description` | `TEXT`       | Course description.                              |
| `Schedule`    | `VARCHAR(100)`| Course schedule (days and times).                |
| `Prerequisites`| `TEXT`      | Prerequisite courses or requirements.            |

### 4. **Enrollments**

**Description:** Tracks student enrollment in courses.

| Field           | Type         | Description                                      |
|-----------------|--------------|--------------------------------------------------|
| `EnrollmentID`  | `INT` [PK]   | Unique identifier for the enrollment record.     |
| `StudentID`     | `INT` [FK]   | Foreign key referencing the student.             |
| `CourseID`      | `INT` [FK]   | Foreign key referencing the course.              |
| `Semester`      | `VARCHAR(10)`| Semester the student is enrolled in (e.g., Fall, Spring). |
| `Year`          | `INT`        | Year of the enrollment.                          |
| `EnrollmentDate`| `DATE`       | Date of course enrollment.                       |
| `Status`        | `ENUM`       | Enrollment status ('Active', 'Completed', 'Dropped'). |
| `WithdrawalDate`| `DATE`       | Date the student withdrew (if applicable).       |
| `FinalGrade`    | `FLOAT`      | Final grade received by the student in the course. |

### 5. **Grades**

**Description:** Contains records of grades assigned to students for each course.

| Field              | Type         | Description                                      |
|--------------------|--------------|--------------------------------------------------|
| `GradeID`          | `INT` [PK]   | Unique identifier for the grade record.          |
| `EnrollmentID`     | `INT` [FK]   | Foreign key referencing the enrollment record.   |
| `Grade`            | `FLOAT`      | Grade awarded for the course.                    |
| `GradeDate`        | `DATE`       | Date when the grade was awarded.                 |
| `Semester`         | `VARCHAR(10)`| Semester in which the grade was awarded.         |
| `Year`             | `INT`        | Year the grade was awarded.                      |
| `InstructorComments`| `TEXT`      | Comments from the instructor.                    |

### 6. **Attendance**

**Description:** Tracks student attendance in each course.

| Field           | Type         | Description                                      |
|-----------------|--------------|--------------------------------------------------|
| `AttendanceID`  | `INT` [PK]   | Unique identifier for the attendance record.     |
| `StudentID`     | `INT` [FK]   | Foreign key referencing the student.             |
| `CourseID`      | `INT` [FK]   | Foreign key referencing the course.              |
| `Date`          | `DATE`       | Date of the attendance record.                   |
| `Status`        | `ENUM`       | Attendance status ('Present', 'Absent', 'Late').  |
| `Reason`        | `TEXT`       | Reason for absence (if applicable).              |

### 7. **Feedback**

**Description:** Stores feedback provided by students about their teachers.

| Field          | Type         | Description                                      |
|----------------|--------------|--------------------------------------------------|
| `FeedbackID`   | `INT` [PK]   | Unique identifier for the feedback record.       |
| `StudentID`    | `INT` [FK]   | Foreign key referencing the student.             |
| `TeacherID`    | `INT` [FK]   | Foreign key referencing the teacher.             |
| `Comment`      | `TEXT`       | Feedback comment provided by the student.        |
| `Rating`       | `INT`        | Rating provided by the student (e.g., 1-5).       |
| `DateSubmitted`| `DATE`       | Date when the feedback was submitted.            |
| `Anonymous`    | `BOOLEAN`    | Whether the feedback is anonymous.               |

### 8. **Assignments**

**Description:** Information about assignments for courses.

| Field           | Type         | Description                                      |
|-----------------|--------------|--------------------------------------------------|
| `AssignmentID`  | `INT` [PK]   | Unique identifier for the assignment.            |
| `CourseID`      | `INT` [FK]   | Foreign key referencing the course.              |
| `Title`         | `VARCHAR(100)`| Title of the assignment.                        |
| `Description`   | `TEXT`       | Description of the assignment.                   |
| `DueDate`       | `DATE`       | Due date of the assignment.                      |
| `MaxGrade`      | `FLOAT`      | Maximum grade achievable on the assignment.      |
| `TotalPoints`   | `INT`        | Total points for the assignment.                 |
| `AssignedDate`  | `DATE`       | Date when the assignment was given.              |

### 9. **Assignmentsubmissions**

**Description:** Tracks student submissions for assignments.

| Field              | Type         | Description                                      |
|--------------------|--------------|--------------------------------------------------|
| `SubmissionID`     | `INT` [PK]   | Unique identifier for the submission.            |
| `AssignmentID`     | `INT` [FK]   | Foreign key referencing the assignment.          |
| `StudentID`        | `INT` [FK]   | Foreign key referencing the student.             |
| `SubmissionDate`   | `DATE`       | Date the assignment was submitted.               |
| `Grade`            | `FLOAT`      | Grade for the assignment submission.             |
| `Feedback`         | `TEXT`       | Feedback provided for the submission.            |
| `LatePenalty`      | `FLOAT`      | Late penalty applied (if any).                   |
| `SubmittedFiles`   | `TEXT`       | Files submitted as part of the assignment.       |

### 10. **Notifications**

**Description:** Stores notifications sent to students.

| Field              | Type         | Description                                      |
|--------------------|--------------|--------------------------------------------------|
| `NotificationID`   | `INT` [PK]   | Unique identifier for the notification.          |
| `StudentID`        | `INT` [FK]   | Foreign key referencing the student.             |
| `Message`          | `TEXT`       | Content of the notification message.             |
| `SentDate`         | `TIMESTAMP`  | Date and time when the notification was sent.    |
| `Status`           | `ENUM`       | Status of the notification ('Sent', 'Pending', 'Failed'). |
| `IsRead`           | `BOOLEAN`    | Whether the notification has been read.          |

## Relationships

- **Students** ↔ **Enrollments**: One-to-many relationship (A student can have many enrollments).
- **Courses** ↔ **Enrollments**: One-to-many relationship (A course can have many enrollments).
- **Teachers** ↔ **Courses**: One-to-many relationship (A teacher can teach multiple courses).
- **Courses** ↔ **Assignments**: One-to-many relationship (A course can have many assignments).
- **Assignments** ↔ **Assignmentsubmissions**: One-to-many relationship (An assignment can have many submissions).
- **Students** ↔ **Assignmentsubmissions**: One-to-many relationship (A student can submit multiple assignments).
- **Students** ↔ **Feedback**: One-to-many relationship (A student can provide feedback to multiple teachers).
- **Teachers** ↔ **Feedback**: One-to-many relationship (A teacher can receive feedback from multiple students).
- **Students** ↔ **Attendance**: One-to-many relationship (A student can have multiple attendance records).
- **Courses** ↔ **Attendance**: One-to-many relationship (A course can have multiple attendance records).
- **Students** ↔ **Notifications**: One-to-many relationship (A student can have multiple notifications).

## Conclusion

This schema is designed to manage the academic and administrative records of students, courses, teachers, assignments, grades, attendance, feedback, and notifications. The relational design ensures smooth tracking of student progress across different metrics such as academic performance, attendance, and engagement with instructors.
