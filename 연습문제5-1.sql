[연습문제5-1]
--1. 이름에 소문자 v가 포함된 모든 사원의 사번, 이름, 부서명을 조회하는 쿼리문을 작성하시오
SELECT  e.employee_id, e.first_name,
        d.department_name
FROM    employees e, departments d        
WHERE   e.department_id = d.department_id
AND     e.first_name LIKE '%v%'
ORDER BY 1; --8 rows


--2. 커미션을 받는 사원의 사번, 이름, 급여, 커미션 금액, 부서명을 조회하는 쿼리문을 조회하시오
--(단, 커미션 금액은 월급여에 대한 커미션 금액을 나타낸다)
-- commission_pct : 커미션율 (수수료 율)
-- 커미션 금액 : 월 급여에 대한 커미션 금액 ==> salary * commission_pct
-- 총 급여 : 급여 + 커미션 금액 ==> salary + (salary * commission_pct)

SELECT  e.employee_id, 
        e.first_name, 
        e.salary * e.commission_pct "comm_sal"
FROM    employees e
WHERE   e.commission_pct IS NOT NULL; --35 rows


SELECT  e.employee_id, 
        e.first_name, 
        e.salary, 
        e.salary * e.commission_pct "comm_sal",
        d.department_name
FROM    employees e, departments d        
WHERE   e.department_id = d.department_id(+)
AND     e.commission_pct IS NOT NULL
ORDER BY 1; --35rows

        




--3. 각 부서의 부서코드, 부서명, 위치코드, 도시명, 국가코드, 국가명을 조회하시오

SELECT *
FROM    departments; --27 rows

-- 부서코드, 부서명, 위치코드 : departments
-- 도시명, 국가코드 : locations
-- 국가명 : countries

SELECT  d.department_id, d.department_name, d.location_id,
        l.city, l.country_id,
        c.country_name
FROM    departments d, locations l, countries c
WHERE   d.location_id = l.location_id
AND     l.country_id = c.country_id
--GROUP BY
--HAVING
ORDER BY 1;



--4. 사원의 사번, 이름, 업무코드, 매니저의 사번, 매니저의 이름, 매니저의 업무코드를
--조회하여 사원의 사번 순서로 정렬하시오
-- 매니저도 사원이다 : SELF JOIN <---> 사원의 매니저 코드 = 매니저의 사번코드
-- 사번, 이름, 업무코드 : employees e
-- 매니저의 사번, 이름, 업무코드 : employees m

SELECT  e.employee_id, e.first_name, e.job_id,
        m.employee_id manager_id, 
        m.first_name manager_name, 
        m.job_id manger_job_id
FROM    employees e, employees m
WHERE   e.manager_id = m.employee_id
ORDER BY 1;






--5. 모든 사원의 사번, 이름, 부서명, 도시이름, 주소 정보를 조회하여 사번 순으로 정렬하시오
-- 107 rows

SELECT  employee_id, first_name,
        department_name,
        city, street_address
FROM    employees e, departments d, locations l
WHERE   e.department_id = d.department_id(+)
AND     d.location_id = l.location_id(+)
ORDER BY 1;
