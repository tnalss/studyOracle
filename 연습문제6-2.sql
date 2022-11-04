-- [연습문제6-2]

--1. 부서 위치코드가 1700에 해당하는 모든 사원의 사번, 이름, 부서코드, 업무코드를
--조회하는 쿼리를 작성하시오
SELECT  department_id --(10,30,90,100~270 : 21rows)
FROM    departments
WHERE   location_id=1700; --US 

SELECT  employee_id, last_name, department_id, job_id
FROM    employees
WHERE   department_id IN ( SELECT  department_id
                           FROM    departments
                           WHERE   location_id=1700 );  --18 rows



--2. 부서별로 가장 급여를 많이 받는 사원의 사번, 이름, 부서번호, 급여, 업무코드를
-- 조회하는 쿼리문을 다중 컬럼 서브쿼리를 사용해서 작성하시오

SELECT department_id, MAX(salary) max_sal
FROM    employees
GROUP BY department_id -- null 포함
ORDER BY department_id;

SELECT employee_id, last_name, department_id, salary, job_id
FROM    employees
WHERE  (department_id, salary) IN ( SELECT department_id, MAX(salary) max_sal
                                    FROM    employees
                                    GROUP BY department_id )
ORDER BY 3;         