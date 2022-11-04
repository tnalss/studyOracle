[연습문제2-1] 다음 연습문제를 사원테이블을 이용하여 해결해보세요

1. 사번이 200인 사원의 이름과 부서번호를 조회하는 쿼리문을 작성하시오
SELECT  employee_id, first_name, department_id
FROM    employees
WHERE   employee_Id = 200; -- 1rows

--EMPLOYEE_ID FIRST_NAME           DEPARTMENT_ID
------------- -------------------- -------------
--        200 Jennifer                        10


2. 급여가 3000 에서 15000 사이에 포함되지 않는 사원의 사번, 이름, 급여정보를 
조회하는 쿼리를 작성하시오
(단, 이름은 성과 이름을 공백문자를 두어 합쳐서 조회한다. ex> John + Seon ==> John Seo로)
SELECT  employee_id, first_name||' '||last_name name, salary
FROM    employees
WHERE   NOT salary BETWEEN 3000 AND 15000; --27 rows



3. 부서번호 30과 60에 소속된 사원의 사번, 이름, 부서번호, 급여를 조회하는데 이름을 알파벳
순서로 정렬하여 조회하는 쿼리문을 작성하시오
SELECT  employee_id, first_name, salary, department_id
FROM    employees
--WHERE   department_id = 30
--OR      department_id = 60
WHERE   department_id IN (30, 60)
--ORDER BY first_name;
ORDER BY first_name ASC;



4. 급여가 3000에서 15000 사이면서 부서번호가 30번 또는 60에 소속된 사원의 사번, 이름,
급여를 조회하는 쿼리문을 작성하시오
(단, 조회되는 컬럼명중 이름은 full name으로, 급여는 Monthly Salary로 조회되도록 한다)
SELECT employee_id, first_name, salary, department_id
FROM    employees
WHERE   SALARY BETWEEN 3000 AND 15000
AND      DEPARTMENT_ID IN (30, 60); -- 7rows




5. 소속된 부서번호가 없는 사원의 사번, 이름, 업무코드를 조회하는 쿼리문을 작성하시오
SELECT employee_id, first_name, job_id
FROM    employees
WHERE   department_id IS NULL;




6. 커미션을 받는 사원의 사번, 이름, 급여, 커미션을 조회하는데 커미션이 높은 사원부터
낮은 사원 순서로 정렬하여 조회하시오
SELECT  employee_id, first_name, salary, commission_pct
FROM    employees
WHERE   commission_pct IS NOT NULL
--ORDER BY    4; -- 컬럼명, Alias 대신 컬럼 번호사용
ORDER BY    commission_pct; -- 35rows




7. 이름에 문자 z 가 포함된 사원의 사번과 이름을 조회하시오
-- first_name : 3rows
-- fullname : 7rows
SELECT employee_id, first_name||' '||last_name name
FROM    employees
--WHERE   first_name||' '||last_name LIKE '%z%';
WHERE   first_name LIKE '%z%';




