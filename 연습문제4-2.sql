--[연습문제 4-2]
-- 1. 사원 테이블에서 커미션을 받는 사원이 모두 몇명인지 그 수를 조회하시오
-- COUNT() : NULL 제외
-- commission_pct : 커미션 비율(=수수료 비율) , NULL이 일부 있음
SELECT  COUNT(commission_pct) "커미션을 받는 사원수"
FROM    employees; -- 35 rows;

SELECT COUNT(*)
FROM    employees
WHERE   commission_pct IS NOT NULL;

SELECT *
FROM    employees
WHERE   commission_pct IS NOT NULL;




-- 2. 가장 최근에 뽑은 직원을 입사시킨 날짜가 언제인지 , 최근 입사일자를 조회하는 쿼리문을 작성하시오
-- MAX() : 가장 최근 (hire_date가 가장 큰 값)
SELECT  MAX(hire_date)
FROM    employees;



-- 3. 90번 부서의 평균 급여액을 조회하는 쿼리문을 작성하시오
-- AVG(), ROUND() / TRUNC()
-- TRUNCATE : 자르다 --> TRUNC()
-- 평균 급여액은 소숫점 둘째 자리까지 표기되도록 한다 : ROUND(n [,i]) 

SELECT  TO_CHAR(ROUND(AVG(salary), 2), '$99,999') avg_sal
FROM    employees
WHERE   department_id = :dept_id;
