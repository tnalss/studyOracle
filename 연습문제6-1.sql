--[연습문제 6-1]
-- 단일 행 (단일 컬럼) 서브쿼리 : 그룹함수와 함께 사용, 값을 비교하는 쿼리문
--                             WHERE 조건절에 작성 (비교 연산자)

-- 1. 급여가 가장 적은 사원의 사번, 이름, 부서(명/코드?), 급여를 조회하시오
SELECT  employee_id, first_name, last_name, department_id, 
        TO_CHAR(salary, '$99,999') salary
FROM    employees
WHERE   salary = ( SELECT MIN(salary)
                   FROM employees );
        


-- 2. 부서명이 Marketing인 부서에 속한 모든 사원의 사번, 이름, 부서코드, 업무코드를
--조회하시오
SELECT  employee_id, first_name, department_id, job_id
FROM    employees
WHERE   department_id = ( SELECT department_id
                          FROM departments
                          WHERE department_name LIKE 'Marketing' ) ;



-- 3. 회사의 사장보다 더 먼저 입사한 사원들의 사번, 이름, 입사일을 조회하시오
--(단, 사장은 그를 관리하는 매니저가 없는 사원이다)
-- 그룹함수 MAX(), MIN()을 hire_date(=입사일)에 사용했을때?
-- MAX(hire_date) : 가장 늦게 / 가장 최근 입사자
-- MIN(hire_date) : 가장 일찍 / 가장 먼저 입사자
SELECT  employee_id, first_name, hire_date
FROM    employees
WHERE   hire_date < ( SELECT MAX(hire_date)
                      FROM employees
                      WHERE manager_id IS NULL ); -- 10 rows





