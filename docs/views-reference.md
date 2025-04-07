# Views Reference Documentation

This document provides an overview of the views used in the **student-progress-dashboard** project. Each view aggregates data to offer insights into student performance, attendance, and teacher feedback.

---

## 1. **student_performance_advanced_view**
   - **Purpose**: Aggregates student data, including GPA, total credits, attendance percentage, and ranks performance.
   - **Columns**:
     - `StudentID`: Unique student identifier.
     - `FirstName`, `LastName`: Student’s name.
     - `GPA`: Grade Point Average.
     - `TotalCredits`: Total credits earned.
     - `AttendancePercentage`: Percentage of attended classes.
     - `PerformanceRank`: Rank based on GPA and attendance.
     - `Semester`, `Year`: Semester and year of the record.
   - **SQL**:
     ```sql
     CREATE VIEW student_performance_advanced_view AS
     WITH performance_data AS (
         SELECT s.StudentID, s.FirstName, s.LastName, sp.GPA, sp.TotalCredits, sp.Attendance,
                (SUM(CASE WHEN a.Status = 'Present' THEN 1 ELSE 0 END) / COUNT(a.Date)) * 100 AS AttendancePercentage
         FROM students s
         LEFT JOIN studentperformance sp ON s.StudentID = sp.StudentID
         LEFT JOIN attendance a ON s.StudentID = a.StudentID
         GROUP BY s.StudentID
     )
     SELECT StudentID, FirstName, LastName, GPA, TotalCredits, AttendancePercentage, 
            RANK() OVER (PARTITION BY Semester, Year ORDER BY GPA DESC, AttendancePercentage DESC) AS PerformanceRank
     FROM performance_data;
     ```

---

## 2. **at_risk_students_advanced_view**
   - **Purpose**: Flags students at risk based on low GPA and poor attendance.
   - **Columns**:
     - `StudentID`, `FirstName`, `LastName`: Student details.
     - `GPA`: Grade Point Average.
     - `AttendancePercentage`: Attendance percentage.
     - `RiskLevel`: Categorized as "High Risk", "Moderate Risk", or "Low Risk".
     - `RiskScore`: Composite score based on GPA and attendance.
   - **SQL**:
     ```sql
     CREATE VIEW at_risk_students_advanced_view AS
     SELECT s.StudentID, s.FirstName, s.LastName, sp.GPA, 
            (SUM(CASE WHEN a.Status = 'Present' THEN 1 ELSE 0 END) / COUNT(a.Date)) * 100 AS AttendancePercentage,
            CASE 
                WHEN sp.GPA < 2.0 AND AttendancePercentage < 75 THEN 'High Risk'
                WHEN sp.GPA < 2.5 AND AttendancePercentage < 80 THEN 'Moderate Risk'
                ELSE 'Low Risk'
            END AS RiskLevel,
            (sp.GPA * 0.6) + (AttendancePercentage * 0.4) AS RiskScore
     FROM students s
     LEFT JOIN studentperformance sp ON s.StudentID = sp.StudentID
     LEFT JOIN attendance a ON s.StudentID = a.StudentID
     GROUP BY s.StudentID;
     ```

---

## 3. **teacher_feedback_performance_view**
   - **Purpose**: Aggregates teacher feedback ratings and ranks teachers based on average feedback.
   - **Columns**:
     - `TeacherID`: Teacher identifier.
     - `FirstName`, `LastName`: Teacher's name.
     - `AverageRating`: Average feedback rating.
     - `TotalFeedbacks`: Number of feedback submissions.
     - `FeedbackRank`: Ranking based on average rating.
   - **SQL**:
     ```sql
     CREATE VIEW teacher_feedback_performance_view AS
     SELECT t.TeacherID, t.FirstName, t.LastName,
            AVG(f.Rating) AS AverageRating, COUNT(f.FeedbackID) AS TotalFeedbacks,
            RANK() OVER (ORDER BY AVG(f.Rating) DESC) AS FeedbackRank
     FROM teachers t
     LEFT JOIN feedback f ON t.TeacherID = f.TeacherID
     GROUP BY t.TeacherID;
     ```

---

## 4. **top_performing_courses_view**
   - **Purpose**: Ranks courses based on the average grade of enrolled students.
   - **Columns**:
     - `CourseID`: Unique course identifier.
     - `CourseName`: Name of the course.
     - `AverageGrade`: Average grade for the course.
     - `TotalStudents`: Number of students enrolled in the course.
     - `CourseRank`: Rank based on average grade.
   - **SQL**:
     ```sql
     CREATE VIEW top_performing_courses_view AS
     SELECT c.CourseID, c.CourseName, AVG(g.Grade) AS AverageGrade, COUNT(g.EnrollmentID) AS TotalStudents,
            RANK() OVER (ORDER BY AVG(g.Grade) DESC) AS CourseRank
     FROM courses c
     LEFT JOIN enrollments e ON c.CourseID = e.CourseID
     LEFT JOIN grades g ON e.EnrollmentID = g.EnrollmentID
     GROUP BY c.CourseID;
     ```

---

## 5. **student_attendance_trend_view**
   - **Purpose**: Tracks student attendance over multiple semesters.
   - **Columns**:
     - `StudentID`, `FirstName`, `LastName`: Student details.
     - `Semester`, `Year`: Semester and year of attendance data.
     - `AttendancePercentage`: Percentage of attended classes.
     - `AverageAttendance`: Student's average attendance across all semesters.
   - **SQL**:
     ```sql
     CREATE VIEW student_attendance_trend_view AS
     SELECT s.StudentID, s.FirstName, s.LastName, a.Semester, a.Year,
            (SUM(CASE WHEN a.Status = 'Present' THEN 1 ELSE 0 END) / COUNT(a.Date)) * 100 AS AttendancePercentage,
            AVG((SUM(CASE WHEN a.Status = 'Present' THEN 1 ELSE 0 END) / COUNT(a.Date)) * 100) 
            OVER (PARTITION BY s.StudentID) AS AverageAttendance
     FROM students s
     LEFT JOIN attendance a ON s.StudentID = a.StudentID
     GROUP BY s.StudentID, a.Semester, a.Year;
     ```

---

Each view aggregates and ranks student-related data for performance monitoring, attendance tracking, and feedback analysis. They allow for easy identification of students' academic progress, teacher effectiveness, and course performance.
