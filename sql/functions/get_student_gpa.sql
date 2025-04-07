-- ===============================================
-- Function to calculate the GPA for a student
-- ===============================================
CREATE FUNCTION get_student_gpa(student_id INT)
RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
    DECLARE total_credits INT;
    DECLARE total_weighted_score DECIMAL(10, 2);
    DECLARE student_gpa DECIMAL(5, 2);
    
    -- Calculate total credits and total weighted score for the student
    SELECT SUM(c.credits), SUM(g.grade * c.credits) 
    INTO total_credits, total_weighted_score
    FROM grades g
    JOIN courses c ON g.course_id = c.id
    WHERE g.student_id = student_id;
    
    -- If the student has no grades or credits, return GPA as 0
    IF total_credits = 0 THEN
        SET student_gpa = 0;
    ELSE
        -- Calculate GPA: total weighted score divided by total credits
        SET student_gpa = total_weighted_score / total_credits;
    END IF;
    
    RETURN student_gpa;
END;

-- Explanation:
-- This function calculates the GPA for a given student based on the grades and credit hours of the courses they are enrolled in.
-- It multiplies each grade by the corresponding course credit, sums the results, and divides by the total number of credits to determine the weighted average.
-- If no grades or credits exist for the student, the function returns a GPA of 0.
