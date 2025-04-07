-- ===============================================
-- Creating the top_teachers_view
-- ===============================================

CREATE VIEW top_teachers_view AS
SELECT
    t.id AS teacher_id,
    t.first_name,
    t.last_name,
    t.department,
    t.email,
    
    -- Average feedback score calculation (Assuming ratings range from 1 to 5)
    ROUND(AVG(f.rating), 2) AS average_feedback_score,
    
    -- Number of feedbacks received by the teacher
    COUNT(f.id) AS total_feedbacks,
    
    -- Rank teachers based on their average feedback score
    CASE
        WHEN AVG(f.rating) >= 4.5 THEN 'Excellent'
        WHEN AVG(f.rating) BETWEEN 3.5 AND 4.4 THEN 'Good'
        WHEN AVG(f.rating) BETWEEN 2.5 AND 3.4 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS performance_category
    
FROM
    teachers t
LEFT JOIN feedback f ON t.id = f.teacher_id

GROUP BY
    t.id, t.first_name, t.last_name, t.department, t.email
ORDER BY
    average_feedback_score DESC;

-- ===============================================
-- Explanation:
-- ===============================================
-- This view displays top-performing teachers based on student feedback.
-- The following metrics are included:
-- 1. **Average Feedback Score**: The average rating given to the teacher by students (rating scale: 1 to 5).
-- 2. **Total Feedbacks**: The total number of feedback submissions for the teacher.
-- 3. **Performance Category**: Categorizes teachers based on their average feedback score:
--    - 'Excellent' for scores >= 4.5
--    - 'Good' for scores between 3.5 and 4.4
--    - 'Average' for scores between 2.5 and 3.4
--    - 'Needs Improvement' for scores below 2.5
--
-- The view uses data from the `teachers` table and joins it with the `feedback` table to calculate the average rating for each teacher. It also categorizes teachers based on their performance.
-- ===============================================
