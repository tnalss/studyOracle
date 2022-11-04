--[연습문제3-3]

--1. 사원 테이블에서 30번 부서원의 사번, 성명, 급여, 근무 개월수를 조회하는 쿼리문을 작성하시오
--(단, 근무개월수는 오늘 날짜를 기준으로 날짜 함수를 사용하여 계산한다)
-- MONTHS_BETWEEN(이후날짜, 이전날짜) : 이후 날짜 - 이전 날짜 (개월 수 반환)
-- ROUND(n [,i]) : 반올림 함수, 소수(i)/정수(-i) 번째 자리로 반올림
-- TRUNC(n) 
-- CEIL(n)
-- FLOOR(n)
SELECT  employee_id,
        last_name,
        salary,
        ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) "근무 개월수",
        department_id
FROM    employees
WHERE   department_id = 30;



--2. 급여가 12000 달러 이상인 사원의 사번, 성명, 급여를 조회하여 급여 순으로 결과를 정렬하시오
--(단, 급여는 천단위 구분 기호를 사용하여야 한다)

SELECT  employee_id,
        last_name,
        TO_CHAR(salary, '$99,999') salary
FROM    employees
WHERE   salary >= 12000
ORDER BY salary;


--3. 2005년 이전에 입사한 사원들의 사번, 성명, 입사일, 업무 시작 요일을 조회하는 쿼리문을 작성하시오
--(단, 업무시작 요일이란 입사일에 해당하는 요일을 지칭한다)
-- 2005-01-01
-- 2004-12-31까지 포함!
-- LAST_DAY(date) : 마지막 날짜를 반환
-- NEXT_DAY(date, char) : 이후 날짜중 char에 명시된 첫번째 일자
-- char / MONDAY, MON, 1:일요일 ~ 7:토요일
SELECT TO_CHAR(SYSDATE, 'YYYY')
FROM dual;

-- NLS 설정 (National : 다국 / 여러나라 , 즉, 각 나라별 언어에 맞게~)
SELECT *
FROM v$nls_parameters;

-- 한글로 요일 출력
ALTER SESSION SET NLS_DATE_LANGUAGE='KOREAN'; -- 또는 KOREAN

SELECT  employee_id,
        last_name,
        hire_date,
        TO_CHAR(hire_date, 'DAY') "업무 시작 요일1",
        TO_CHAR(hire_date, 'DY') "업무 시작 요일2"
--        NEXT_DAY(hire_date, ) "업무 시작 요일"
FROM    employees
WHERE   TO_CHAR(hire_date, 'YYYY') < '2005'; -- 24rows