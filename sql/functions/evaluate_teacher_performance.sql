-- ===============================================
-- Query to evaluate teacher performance based on student feedback
-- ===============================================
SELECT t.id AS teacher_id, 
       t.name AS teacher_name,
       AVG(f.rating) AS average_feedback_score
FROM teachers t
JOIN feedback f ON t.id = f.teacher_id
GROUP BY t.id
HAVING AVG(f.rating) >= 4.0  -- Teachers with an average rating of 4.0 or higher are considered top performers
ORDER BY average_feedback_score DESC;

-- Explanation:
-- This query joins the `teachers` and `feedback` tables and calculates the average feedback score for each teacher.
-- It filters out teachers with an average rating below 4.0, considering only those with high performance.
-- The result is ordered in descending order of the feedback score to highlight the top-performing teachers.
