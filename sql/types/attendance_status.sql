-- ===============================================
-- View to Track Detailed Attendance Status
-- ===============================================

CREATE OR REPLACE VIEW attendance_status_view AS
WITH attendance_summary AS (
    -- CTE: Summarize attendance for each student per course, including total sessions attended and the status per session
    SELECT 
        a.student_id,
        s.student_name,
        c.course_id,
        c.course_name,
        at.attendance_date,
        at.status AS attendance_status,
        -- Classify as 'Present' if status is 'P', 'Absent' if 'A', 'Late' if 'L', and 'Excused' if 'E'
        CASE
            WHEN at.status = 'P' THEN 'Present'
            WHEN at.status = 'A' THEN 'Absent'
            WHEN at.status = 'L' THEN 'Late'
            WHEN at.status = 'E' THEN 'Excused'
            ELSE 'Unknown'
        END AS classified_status
    FROM 
        attendance at
    JOIN 
        students s ON at.student_id = s.id
    JOIN 
        courses c ON at.course_id = c.id
    -- Filter for attendance status, ensuring we include all possible statuses (e.g., Late, Excused)
    WHERE at.status IN ('P', 'A', 'L', 'E')
),
attendance_percentage AS (
    -- CTE: Calculate attendance percentage for each student in each course
    SELECT
        student_id,
        course_id,
        -- Calculate the percentage of attendance (number of presents divided by total number of sessions attended)
        ROUND(
            (SUM(CASE WHEN classified_status = 'Present' THEN 1 ELSE 0 END) / COUNT(attendance_date)) * 100, 2
        ) AS attendance_percentage
    FROM 
        attendance_summary
    GROUP BY 
        student_id, course_id
),
late_percentage AS (
    -- CTE: Calculate late attendance percentage for each student in each course
    SELECT
        student_id,
        course_id,
        ROUND(
            (SUM(CASE WHEN classified_status = 'Late' THEN 1 ELSE 0 END) / COUNT(attendance_date)) * 100, 2
        ) AS late_percentage
    FROM
        attendance_summary
    GROUP BY
        student_id, course_id
)
-- Final SELECT to combine all the details into the main view
SELECT
    a.student_id,
    a.student_name,
    a.course_id,
    a.course_name,
    a.attendance_date,
    a.classified_status,
    -- Join the calculated percentages from CTEs
    ap.attendance_percentage,
    lp.late_percentage
FROM
    attendance_summary a
JOIN
    attendance_percentage ap ON a.student_id = ap.student_id AND a.course_id = ap.course_id
JOIN
    late_percentage lp ON a.student_id = lp.student_id AND a.course_id = lp.course_id
ORDER BY
    a.student_name,
    a.course_name,
    a.attendance_date;

-- ===============================================
-- Notes:
-- This view calculates attendance percentages for students for each course across all sessions.
-- It considers various attendance statuses: 'Present', 'Absent', 'Late', and 'Excused'.
-- It uses Common Table Expressions (CTEs) to structure and calculate the attendance data step-by-step.
-- ===============================================
