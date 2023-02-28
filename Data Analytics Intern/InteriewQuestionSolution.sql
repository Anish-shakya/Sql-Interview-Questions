----- Given Tables 

SELECT * FROM student_list
SELECT * FROM student_response
SELECT * FROM question_paper_code
SELECT * FROM correct_answer



------ Actual Solution to the Given Problem--------------
WITH CTE AS (
	SELECT sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name,
		SUM(CASE
			WHEN pc.subject='Math' AND  sr.option_marked = ca.correct_option 
				 THEN 1 ELSE 0
		END ) AS Math_Correct ,

		SUM(CASE 
			WHEN pc.subject='Math' AND sr.option_marked <> ca.correct_option AND sr.option_marked <> 'e' 
				THEN 1 ELSE 0
		END ) AS Math_Wrong	,

		SUM(CASE 
			WHEN pc.subject='Math' AND  sr.option_marked = 'e' 
				THEN 1 ELSE 0
		END ) AS Math_Yet_To_Learn ,
		SUM(CASE
				WHEN pc.subject ='Math'
				THEN 1 ELSE 0	
		END) AS Total_Math_Questions ,

		SUM(CASE
			WHEN pc.subject='Science' AND  sr.option_marked = ca.correct_option 
				 THEN 1 ELSE 0
		END ) AS Science_Correct ,

		SUM(CASE 
			WHEN pc.subject='Science' AND sr.option_marked <> ca.correct_option AND sr.option_marked <> 'e' 
				THEN 1 ELSE 0
		END ) AS Science_Wrong	,

		SUM(CASE 
			WHEN pc.subject='Science' AND  sr.option_marked = 'e' 
				THEN 1 ELSE 0
		END ) AS Science_Yet_To_Learn ,

		SUM(CASE
				WHEN pc.subject ='Science'
				THEN 1 ELSE 0	
		END) AS Total_Science_Questions

	FROM student_list sl
	JOIN student_response sr ON sl.roll_number = sr.roll_number
	JOIN question_paper_code pc ON pc.paper_code = sr.question_paper_code  
	JOIN correct_answer ca  ON ca.question_paper_code = sr.question_paper_code AND ca.question_number = sr.question_number /* And condition to remove duplicate records*/
	GROUP BY sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name
	Order BY 1
)
SELECT roll_number,student_name,class,section,school_name,math_correct,math_wrong,math_yet_to_learn, math_correct AS math_score,
		ROUND((math_correct::decimal/Total_Math_Questions::decimal) * 100,2) AS math_percentage ,
		science_correct,science_wrong,science_yet_to_learn ,science_correct AS science_score,
		ROUND((science_correct::decimal/Total_science_Questions::decimal) * 100,2) AS math_percentage
FROM CTE






--------Solution Break Down  For given Problem---------


--------Joining all four tables-------------------------
SELECT * 
FROM student_list sl
JOIN student_response sr ON sl.roll_number = sr.roll_number
JOIN question_paper_code pc ON pc.paper_code = sr.question_paper_code  
JOIN correct_answer ca  ON ca.question_paper_code = sr.question_paper_code AND ca.question_number = sr.question_number /* And condition to remove duplicate records*/


------ Calculation Of Math_Correct----------------
SELECT sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name,
	SUM(CASE
		WHEN sr.option_marked = ca.correct_option 
			 THEN 1 ELSE 0
	END ) AS Math_Correct
	FROM student_list sl
	JOIN student_response sr ON sl.roll_number = sr.roll_number
	JOIN question_paper_code pc ON pc.paper_code = sr.question_paper_code  
	JOIN correct_answer ca  ON ca.question_paper_code = sr.question_paper_code AND ca.question_number = sr.question_number /* And condition to remove duplicate records*/
WHERE subject ='Math' 
GROUP BY sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name
Order BY 1



------ Calculation Of Math_Wrong----------------
SELECT sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name,
	SUM(CASE 
		WHEN sr.option_marked <> ca.correct_option AND sr.option_marked <> 'e'
			THEN 1 ELSE 0
	END ) AS Math_Wrong		

	FROM student_list sl
	JOIN student_response sr ON sl.roll_number = sr.roll_number
	JOIN question_paper_code pc ON pc.paper_code = sr.question_paper_code  
	JOIN correct_answer ca  ON ca.question_paper_code = sr.question_paper_code AND ca.question_number = sr.question_number /* And condition to remove duplicate records*/
WHERE pc.subject = 'Math' 
GROUP BY sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name
Order BY 1


----- Calculation of Math_yet_to_learn--------------

SELECT sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name,
	SUM(CASE 
		WHEN  sr.option_marked = 'e'
			THEN 1 ELSE 0
	END ) AS Math_Yet_To_Learn		

	FROM student_list sl
	JOIN student_response sr ON sl.roll_number = sr.roll_number
	JOIN question_paper_code pc ON pc.paper_code = sr.question_paper_code  
	JOIN correct_answer ca  ON ca.question_paper_code = sr.question_paper_code AND ca.question_number = sr.question_number /* And condition to remove duplicate records*/
WHERE pc.subject = 'Math' 
GROUP BY sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name
Order BY 1



------ Calculation of Math_Total_Question -----------
SELECT sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name,
	SUM(CASE 
		WHEN  pc.subject ='Math'
			THEN 1 ELSE 0
	END ) AS Math_Total_Question	

	FROM student_list sl
	JOIN student_response sr ON sl.roll_number = sr.roll_number
	JOIN question_paper_code pc ON pc.paper_code = sr.question_paper_code  
	JOIN correct_answer ca  ON ca.question_paper_code = sr.question_paper_code AND ca.question_number = sr.question_number /* And condition to remove duplicate records*/
WHERE pc.subject = 'Math' 
GROUP BY sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name
Order BY 1


----Calulation of Math score And Percentage
WITH CTE AS(
	SELECT sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name,
		SUM(CASE
			WHEN sr.option_marked = ca.correct_option 
				 THEN 1 ELSE 0
		END ) AS Math_Correct,

		SUM(CASE 
			WHEN  pc.subject ='Math'
				THEN 1 ELSE 0
		END ) AS Math_Total_Question	

	FROM student_list sl
	JOIN student_response sr ON sl.roll_number = sr.roll_number
	JOIN question_paper_code pc ON pc.paper_code = sr.question_paper_code  
	JOIN correct_answer ca  ON ca.question_paper_code = sr.question_paper_code AND ca.question_number = sr.question_number /* And condition to remove duplicate records*/
	WHERE subject ='Math' 
	GROUP BY sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name
	Order BY 1
)
SELECT roll_number,student_name,class,section,school_name,
		Math_Correct AS Math_Score,ROUND((math_correct::decimal/math_total_question::decimal)*100,2) AS Math_Percentage
FROM CTE


------ Calculation Of science_Correct----------------
SELECT sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name,
	SUM(CASE
		WHEN sr.option_marked = ca.correct_option 
			 THEN 1 ELSE 0
	END ) AS Science_Correct
	FROM student_list sl
	JOIN student_response sr ON sl.roll_number = sr.roll_number
	JOIN question_paper_code pc ON pc.paper_code = sr.question_paper_code  
	JOIN correct_answer ca  ON ca.question_paper_code = sr.question_paper_code AND ca.question_number = sr.question_number /* And condition to remove duplicate records*/
WHERE subject ='Science' 
GROUP BY sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name
Order BY 1



------ Calculation Of Science_Wrong----------------
SELECT sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name,
	SUM(CASE 
		WHEN sr.option_marked <> ca.correct_option AND sr.option_marked <> 'e'
			THEN 1 ELSE 0
	END ) AS science_Wrong		

	FROM student_list sl
	JOIN student_response sr ON sl.roll_number = sr.roll_number
	JOIN question_paper_code pc ON pc.paper_code = sr.question_paper_code  
	JOIN correct_answer ca  ON ca.question_paper_code = sr.question_paper_code AND ca.question_number = sr.question_number /* And condition to remove duplicate records*/
WHERE pc.subject = 'Science' 
GROUP BY sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name
Order BY 1


----- Calculation of Science_yet_to_learn--------------

SELECT sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name,
	SUM(CASE 
		WHEN  sr.option_marked = 'e'
			THEN 1 ELSE 0
	END ) AS Science_Yet_To_Learn		

	FROM student_list sl
	JOIN student_response sr ON sl.roll_number = sr.roll_number
	JOIN question_paper_code pc ON pc.paper_code = sr.question_paper_code  
	JOIN correct_answer ca  ON ca.question_paper_code = sr.question_paper_code AND ca.question_number = sr.question_number /* And condition to remove duplicate records*/
WHERE pc.subject = 'Science' 
GROUP BY sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name
Order BY 1

------ Calculation of Science_Total_Question -----------
SELECT sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name,
	SUM(CASE 
		WHEN  pc.subject ='Science'
			THEN 1 ELSE 0
	END ) AS Science_Total_Question	

	FROM student_list sl
	JOIN student_response sr ON sl.roll_number = sr.roll_number
	JOIN question_paper_code pc ON pc.paper_code = sr.question_paper_code  
	JOIN correct_answer ca  ON ca.question_paper_code = sr.question_paper_code AND ca.question_number = sr.question_number /* And condition to remove duplicate records*/
WHERE pc.subject = 'Science' 
GROUP BY sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name
Order BY 1

----Calulation of Sciecnce score And Percentage
WITH CTE AS(
	SELECT sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name,
		SUM(CASE
			WHEN sr.option_marked = ca.correct_option 
				 THEN 1 ELSE 0
		END ) AS Science_Correct,

		SUM(CASE 
			WHEN  pc.subject ='Science'
				THEN 1 ELSE 0
		END ) AS Science_Total_Question	

	FROM student_list sl
	JOIN student_response sr ON sl.roll_number = sr.roll_number
	JOIN question_paper_code pc ON pc.paper_code = sr.question_paper_code  
	JOIN correct_answer ca  ON ca.question_paper_code = sr.question_paper_code AND ca.question_number = sr.question_number /* And condition to remove duplicate records*/
	WHERE subject ='Science' 
	GROUP BY sl.roll_number,sl.student_name,sl.class,sl.section,sl.school_name
	Order BY 1
)
SELECT roll_number,student_name,class,section,school_name,
		Science_Correct AS science_Score,ROUND((science_correct::decimal/science_total_question::decimal)*100,2) AS Science_Percentage
FROM CTE



-------The End--------------------------------