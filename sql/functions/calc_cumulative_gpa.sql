-- ===============================================
-- Cumulative GPA calculation function
-- ===============================================
CREATE FUNCTION calc_cumulative_gpa(student_id INT) 
RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
    DECLARE total_credits INT;
    DECLARE total_weighted_score DECIMAL(10, 2);
    DECLARE cumulative_gpa DECIMAL(5, 2);
    
    -- Calculate total credits and total weighted score for the student
    SELECT SUM(c.credits), SUM(g.grade * c.credits) 
    INTO total_credits, total_weighted_score
    FROM grades g
    JOIN courses c ON g.course_id = c.id
    WHERE g.student_id = student_id;
    
    -- If the student has no grades, return GPA as 0
    IF total_credits = 0 THEN
        SET cumulative_gpa = 0;
    ELSE
        -- Calculate cumulative GPA
        SET cumulative_gpa = total_weighted_score / total_credits;
    END IF;
    
    RETURN cumulative_gpa;
END;

-- Explanation:
-- This function calculates the cumulative GPA by summing the weighted scores (grade * credits) and dividing by the total credits.
-- It assumes a grade scale where numeric values are assigned to each grade in the 'grades' table.
-- If the student has no grades recorded, it returns 0.
