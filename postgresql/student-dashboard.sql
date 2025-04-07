CREATE TABLE "students" (
  "StudentID" INT PRIMARY KEY,
  "FirstName" VARCHAR(50),
  "LastName" VARCHAR(50),
  "DateOfBirth" DATE,
  "Gender" VARCHAR(10),
  "GradeLevel" INT,
  "EnrollmentDate" DATE,
  "Email" VARCHAR(100),
  "Phone" VARCHAR(20),
  "Address" VARCHAR(255),
  "EmergencyContact" VARCHAR(50),
  "NationalID" VARCHAR(50),
  "Status" VARCHAR(10)
);

CREATE TABLE "teachers" (
  "TeacherID" INT PRIMARY KEY,
  "FirstName" VARCHAR(50),
  "LastName" VARCHAR(50),
  "Department" VARCHAR(50),
  "Email" VARCHAR(100),
  "Phone" VARCHAR(20),
  "Office" VARCHAR(50),
  "HireDate" DATE,
  "Status" VARCHAR(10)
);

CREATE TABLE "courses" (
  "CourseID" INT PRIMARY KEY,
  "CourseName" VARCHAR(100),
  "TeacherID" INT,
  "CourseCode" VARCHAR(50),
  "Credits" INT,
  "Description" TEXT,
  "Schedule" VARCHAR(100),
  "Prerequisites" TEXT
);

CREATE TABLE "enrollments" (
  "EnrollmentID" INT PRIMARY KEY,
  "StudentID" INT,
  "CourseID" INT,
  "Semester" VARCHAR(10),
  "Year" INT,
  "EnrollmentDate" DATE,
  "Status" VARCHAR(10),
  "WithdrawalDate" DATE,
  "FinalGrade" FLOAT
);

CREATE TABLE "grades" (
  "GradeID" INT PRIMARY KEY,
  "EnrollmentID" INT,
  "Grade" FLOAT,
  "GradeDate" DATE,
  "Semester" VARCHAR(10),
  "Year" INT,
  "InstructorComments" TEXT
);

CREATE TABLE "attendance" (
  "AttendanceID" INT PRIMARY KEY,
  "StudentID" INT,
  "CourseID" INT,
  "Date" DATE,
  "Status" VARCHAR(10),
  "Reason" TEXT
);

CREATE TABLE "feedback" (
  "FeedbackID" INT PRIMARY KEY,
  "StudentID" INT,
  "TeacherID" INT,
  "Comment" TEXT,
  "Rating" INT,
  "DateSubmitted" DATE,
  "Anonymous" BOOLEAN
);

CREATE TABLE "gradeaudit" (
  "AuditID" INT PRIMARY KEY,
  "EnrollmentID" INT,
  "OldGrade" FLOAT,
  "NewGrade" FLOAT,
  "ChangedOn" TIMESTAMP,
  "ChangedBy" INT,
  "ReasonForChange" TEXT
);

CREATE TABLE "attendancelog" (
  "LogID" INT PRIMARY KEY,
  "AttendanceID" INT,
  "PreviousStatus" VARCHAR(10),
  "NewStatus" VARCHAR(10),
  "ChangedOn" TIMESTAMP,
  "ChangedBy" INT
);

CREATE TABLE "assignments" (
  "AssignmentID" INT PRIMARY KEY,
  "CourseID" INT,
  "Title" VARCHAR(100),
  "Description" TEXT,
  "DueDate" DATE,
  "MaxGrade" FLOAT,
  "TotalPoints" INT,
  "AssignedDate" DATE
);

CREATE TABLE "assignmentsubmissions" (
  "SubmissionID" INT PRIMARY KEY,
  "AssignmentID" INT,
  "StudentID" INT,
  "SubmissionDate" DATE,
  "Grade" FLOAT,
  "Feedback" TEXT,
  "LatePenalty" FLOAT,
  "SubmittedFiles" TEXT
);

CREATE TABLE "classroom" (
  "ClassroomID" INT PRIMARY KEY,
  "CourseID" INT,
  "RoomNumber" VARCHAR(50),
  "Building" VARCHAR(50),
  "Schedule" VARCHAR(100),
  "Capacity" INT
);

CREATE TABLE "studentperformance" (
  "MetricID" INT PRIMARY KEY,
  "StudentID" INT,
  "GPA" FLOAT,
  "TotalCredits" INT,
  "Attendance" FLOAT,
  "Semester" VARCHAR(10),
  "Year" INT,
  "Rank" VARCHAR(50)
);

CREATE TABLE "notifications" (
  "NotificationID" INT PRIMARY KEY,
  "StudentID" INT,
  "Message" TEXT,
  "SentDate" TIMESTAMP,
  "Status" VARCHAR(10),
  "IsRead" BOOLEAN
);

ALTER TABLE "courses" ADD FOREIGN KEY ("TeacherID") REFERENCES "teachers" ("TeacherID");

ALTER TABLE "students" ADD FOREIGN KEY ("StudentID") REFERENCES "enrollments" ("StudentID");

ALTER TABLE "courses" ADD FOREIGN KEY ("CourseID") REFERENCES "enrollments" ("CourseID");

ALTER TABLE "enrollments" ADD FOREIGN KEY ("EnrollmentID") REFERENCES "grades" ("EnrollmentID");

ALTER TABLE "students" ADD FOREIGN KEY ("StudentID") REFERENCES "attendance" ("StudentID");

ALTER TABLE "courses" ADD FOREIGN KEY ("CourseID") REFERENCES "attendance" ("CourseID");

ALTER TABLE "students" ADD FOREIGN KEY ("StudentID") REFERENCES "feedback" ("StudentID");

ALTER TABLE "teachers" ADD FOREIGN KEY ("TeacherID") REFERENCES "feedback" ("TeacherID");

ALTER TABLE "grades" ADD FOREIGN KEY ("EnrollmentID") REFERENCES "gradeaudit" ("EnrollmentID");

ALTER TABLE "enrollments" ADD FOREIGN KEY ("EnrollmentID") REFERENCES "gradeaudit" ("EnrollmentID");

ALTER TABLE "attendance" ADD FOREIGN KEY ("AttendanceID") REFERENCES "attendancelog" ("AttendanceID");

ALTER TABLE "teachers" ADD FOREIGN KEY ("TeacherID") REFERENCES "attendancelog" ("ChangedBy");

ALTER TABLE "courses" ADD FOREIGN KEY ("CourseID") REFERENCES "assignments" ("CourseID");

ALTER TABLE "assignments" ADD FOREIGN KEY ("AssignmentID") REFERENCES "assignmentsubmissions" ("AssignmentID");

ALTER TABLE "students" ADD FOREIGN KEY ("StudentID") REFERENCES "assignmentsubmissions" ("StudentID");

ALTER TABLE "courses" ADD FOREIGN KEY ("CourseID") REFERENCES "classroom" ("CourseID");

ALTER TABLE "teachers" ADD FOREIGN KEY ("TeacherID") REFERENCES "classroom" ("ClassroomID");

ALTER TABLE "students" ADD FOREIGN KEY ("StudentID") REFERENCES "studentperformance" ("StudentID");

ALTER TABLE "students" ADD FOREIGN KEY ("StudentID") REFERENCES "notifications" ("StudentID");
