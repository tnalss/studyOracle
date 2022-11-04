--[연습문제 5-2]

-- 1. 사번이 110, 130, 150에 해당하는 사원의 사번, 이름, 부서명을 조회하는 쿼리를
-- ANSI JOIN 형식으로 조인으로 작성하시오

SELECT  e.employee_id, e.first_name, 
        d.department_name
FROM    employees e INNER JOIN departments d
ON      e.department_id = d.department_id
WHERE     e.employee_id IN (110, 130, 150)
ORDER BY 1;

[ANSI JOIN의 ON을 USING으로 변경]
SELECT  e.employee_id, e.first_name, 
        d.department_name
FROM    employees e INNER JOIN departments d
USING   (department_id)
WHERE     e.employee_id IN (110, 130, 150)
ORDER BY 1;

--ORA-00933: SQL 명령어가 올바르게 종료되지 않았습니다
--00933. 00000 -  "SQL command not properly ended"
-- ON, USING 사용시 일반조건은 WHERE절로~ 작성

[ANSI JOIN의 오라클 JOIN으로 변경]
SELECT  e.employee_id, e.first_name, 
        d.department_name
FROM    employees e, departments d
WHERE   e.department_id = d.department_id
AND     e.employee_id IN (110, 130, 150)
ORDER BY 1;
-- 모든 ==> 외부조인(오라클 JOIN) / OUTER JOIN(ANSI JOIN)
-- 모든 사원의 사번, 이름, 부서명, 업무코드, 업무제목을 조회하여 사번 순으로 정렬하시오
-- 오라클 조인, ANSI JOIN 둘다 작성해보자!

-- 사번, 이름, 업무코드 : employees
-- 부서명 : departments
-- 업무제목 : jobs

SELECT  e.employee_id, e.first_name,
        d.department_name,
        j.job_id,
        j.job_title
FROM    employees e LEFT OUTER JOIN departments d
ON      e.department_id = d.department_id
LEFT OUTER JOIN jobs j
ON      e.job_id = j.job_id
ORDER BY 1;

[USING으로 바꿔보자]
SELECT  e.employee_id, e.first_name,
        d.department_name,
        job_id,
        j.job_title
FROM    employees e LEFT OUTER JOIN departments d
USING      (department_id)
LEFT OUTER JOIN jobs j
USING      (job_id)
ORDER BY 1;

[오라클 조인으로 바꿔보자]
SELECT  e.employee_id, e.first_name,
        d.department_name,
        j.job_id,
        j.job_title
FROM    employees e , departments d, jobs j
WHERE   e.department_id = d.department_id(+)
AND     e.job_id = j.job_id(+)
ORDER BY 1;

-- 3. 모든 사원의 사번, 이름, 부서명, 부서가 있는 도시명을 조회하여 사번 순으로 
-- 정렬하시오 -- 오라클 조인, ANSI JOIN 둘다 작성해보자!
-- locations : city (=도시명) 
--[3-1] 오라클 조인
SELECT  e.employee_id, e.first_name,
        d.department_name,
        l.city
FROM    employees e , departments d, locations l
WHERE   e.department_id = d.department_id(+)
AND     d.location_id = l.location_id(+)
ORDER BY 1;


--[3-2] ANSI 조인
SELECT  e.employee_id, e.first_name,
        d.department_name,
        l.city
FROM    employees e LEFT OUTER JOIN departments d
ON   e.department_id = d.department_id
LEFT OUTER JOIN locations l
ON     d.location_id = l.location_id
ORDER BY 1;




