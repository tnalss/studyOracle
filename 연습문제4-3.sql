--[연습문제 4-3]
-- 1. 사원테이블에서 똑같은 이름(first_name)이 둘 이상 있는 이름과 그 이름이 모두 몇명인지를
--조회하는 쿼리문을 작성하시오

SELECT  first_name,
        COUNT(*)
FROM    employees
--WHERE
GROUP BY    first_name
HAVING  COUNT(*) >= 2
ORDER BY 1;

-- 2. 부서번호, 각 부서별 급여총액과 평균급여를 조회하시오
--(단, 부서 평균 급여가 8000 이상인 부서만 조회되도록 한다)

SELECT  department_id,
        SUM(salary) total_sal,
        ROUND(AVG(salary)) avg_sal
FROM    employees
HAVING  ROUND(AVG(salary)) >= 8000
GROUP BY department_id
ORDER BY 1;


-- 3. 년도, 년도별 입사한 사원수를 조회하는 쿼리문을 작성하시오
--(단, 년도는 2014의 형태로 표기되도록 한다)

SELECT  TO_CHAR(hire_date, 'YYYY') year,
        COUNT(*)
FROM    employees
GROUP BY hire_date
ORDER BY 1;