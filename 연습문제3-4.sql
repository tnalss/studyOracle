-- [연습문제3-4]

-- 1. 사원의 사번, 이름, 업무(JOB_ID), 업무등급(새로운 컬럼!)을 조회하는 쿼리문을 작성하시오
-- 단, 업무등급은 아래와 같음
-- DECODE() 또는 CASE 1번으로 해결
/*
업무(=JOB_ID)       등급
--------------------------
AD_PRES             A
ST_MAN              B
....
기타                 X
*/
-- 1. DECODE()를 이용한 동등비교 연산 (업무코드와 특정 등급)
SELECT  employee_id emp_id,
        last_name,
        job_id,
        DECODE(job_id, 'AD_PRES', 'A',
                       'ST_MAN', 'B',
                       'IT_PROG', 'C',
                       'SA_REP', 'D',
                       'ST_CLERK', 'E',        
                       'X'
        ) "등급"
FROM    employees
ORDER BY "등급";


-- 2. CASE로 동등비교 : 항목을 ,로 구분하지 않음!
SELECT  employee_id emp_id,
        last_name,
        job_id,
        CASE job_id WHEN 'AD_PRES' THEN 'A'
                    WHEN 'ST_MAN' THEN 'B'
                    WHEN 'IT_PROG' THEN 'C'
                    WHEN 'SA_REP' THEN 'D'
                    WHEN 'ST_CLERK' THEN 'E'
                    ELSE 'X'
        END "등급"
FROM    employees
ORDER BY "등급";



-- 2. 사원의 사번, 이름, 입사일, 근무년수(새로 만들 컬럼), 근속상태(새로 만들 컬럼)를 조회하시오
-- hire_date가 빠르면 01년도, 03년도 입사자등의 정보, 현재 쿼리를 실행하는 시점과의 차이를 고려해
-- 비교조건을 조금 넓게 잡고 계산해야 함!

SELECT  employee_id emp_id,
        last_name,
        TO_CHAR(hire_date, 'YY')
FROM    employees
ORDER BY hire_date; -- 최초 입사자가 01년도, 현재기준~ 20년!! 근속등..

-- ex> 최소 13년 이상으로 조회가 될수 있는데 10년을 기준으로만 하기보다~ 10, 50, 20 구간

-- CASE 2로 문제를 해결 : DECODE()는 동등비교, CASE는 동등비교와 값의 비교연산 가능 표현식
SELECT  employee_id,
        first_name,
        --TO_CHAR(hire_date,'YY') 입사년도,
        hire_date 입사일,
        TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) 근속개월,
        TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)/12) 근속년수1,
        TO_CHAR(SYSDATE, 'YY') - TO_CHAR(hire_date, 'YY') 근무년수2,
        CASE WHEN TO_CHAR(SYSDATE, 'YY') - TO_CHAR(hire_date, 'YY') < 10 THEN '10년 미만 근속'
             WHEN TO_CHAR(SYSDATE, 'YY') - TO_CHAR(hire_date, 'YY') < 15 THEN '10년 이상, 15년 미만 근속'
             WHEN TO_CHAR(SYSDATE, 'YY') - TO_CHAR(hire_date, 'YY') < 20 THEN '16년 이상, 20년 미만 근속'
             ELSE '20년 이상 근속'
        END 근속상태
FROM    employees;        
        
        

