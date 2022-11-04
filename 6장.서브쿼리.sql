6장. 서브쿼리 (p.51)
SQL 문장 안에 있는 또 다른 SQL 문장을 서브쿼리라 한다.
서브쿼리는 괄호를 묶어 사용하고, 서브쿼리가 포함된 쿼리문을 메인쿼리라 한다.

-- 쿼리(Query) 구분
-- 메인쿼리 vs 서브쿼리 : 서브쿼리 없이 메인쿼리만으로도 조회는 가능! (효율 > 속도)
--(일반쿼리)

[예제6-1] 평균 급여보다 더 적은 급여를 받는 사원의 사번, 이름, 성 정보를 조회하시오
-- 평균 급여를 조회
SELECT ROUND(AVG(salary)) avg_sal
FROM    employees; -- average salary : 6462$

SELECT employee_id, first_name, last_name
FROM    employees
WHERE   salary < 6462; --56 rows

--서브쿼리로 작성해보자
SELECT employee_id, first_name, last_name
FROM    employees
WHERE   salary < ( SELECT ROUND(AVG(salary)) avg_sal
                   FROM    employees ); -- 56 rows
                   
-- 일반 쿼리 여러개 vs 서브쿼리 : 효율성 ↑ 속도(=실행순서) 

* 서브쿼리의 유형 : 
-- I.서브쿼리 실행결과로 유형을 구분 : 단일행, 다중행, 다중컬럼 서브쿼리
-- II.연관성을 따져서 : 상호 연관 없는 서브쿼리 vs 상호 연관 서브쿼리
-- III.사용위치로 구분 : SELECT절(=스칼라), FROM절(=인라인 뷰)
-- ※ 일반적으로 서브쿼리는 WHERE절 에 사용!
1) 단일 행 (단일 컬럼) 서브쿼리 : 하나의 결과 행 ==> 그룹함수(COUNT, MAX, MIN, SUM, AVG) 사용시
SELECT ROUND(AVG(salary)) avg_sal
FROM    employees;

2) 다중 행 (단일 컬럼) 서브쿼리 : 둘 이상의 결과 행을 반환하는 서브쿼리 
SELECT salary
FROM    employees
WHERE department_id = 80;

3) (다중 행) 다중 컬럼 서브쿼리 :둘 이상의 컬럼, 둘 이상의 결과 행을 반환하는 서브쿼리 (일반 쿼리형태)
SELECT employee_id, last_name, salary
FROM    employees
WHERE department_id = 80;

4) 상호연관 서브쿼리 :  메인쿼리의 컬럼이 서브쿼리의 조건으로 사용되는 서브쿼리

5) 스칼라 서브쿼리 : SELECT 절에 사용되는 서브쿼리 (=컬럼)

6) 인라인 뷰 서브쿼리 : FROM 절에 사용되는 서브쿼리 (=테이블)


6-1. 단일 행 (단일 컬럼) 서브쿼리
-- 단일 행 서브쿼리는 단일 행 연산자 (=, >, >=, <, <=, <>, !=) 와 함께 사용한다.
-- 서브쿼리의 결과 행이 한 행(=단일 해) 이므로 그룹 함수를 사용하는 경우가 많다.
[예제6-2] 월 급여가 가장 많은(=최대) 사원의 사번, 이름, 성 정보를 조회하시오
SELECT MAX(salary)
FROM    employees; -- 24000$ (Steven King은 사장님!)

SELECT employee_id, first_name, last_name
FROM    employees
WHERE   salary = 24000; -- 일반쿼리로 최대급여 24000 을 비교

SELECT employee_id, first_name, last_name
FROM    employees
WHERE   salary = ( SELECT MAX(salary)
                   FROM    employees );

[예제 6-23] 사번 108번인 사원의 급여보다 더 많은 급여를 받는 사원의 사번, 이름, 급여를
조회하시오
-- 1. 108번 사원의 급여를 조회한다.
SELECT  salary
FROM    employees
WHERE   employee_id = 108; -- 12008$
-- 2. 108번 사원의 급여를 비교 (>=)해서 더 많은 급여를 받는 사원을 조회한다.
SELECT employee_id, last_name, salary
FROM    employees
WHERE   salary >= 12008; -- 8rows

-- 3. 서브쿼리로 작성하면
SELECT employee_id, last_name, salary
FROM    employees
WHERE   salary >= ( SELECT  salary
                    FROM    employees
                    WHERE   employee_id = 108 ); -- 8rows
[예제6-4] 월급여가 가장 많은 사원의 사번, 이름, 업무제목 정보를 조회하시오
-- 6-4-1. 최대 급여를 조회
SELECT MAX(salary)
FROM employees; -- 24000$, 1rows (단일 행, 단일 컬럼)

-- 6-4-2. 사번, 이름, 업무제목을 조회
SELECT  e.employee_id, e.last_name,
        j.job_title
FROM    employees e, jobs j
WHERE   e.job_id = j.job_id
ORDER BY 1;

-- 6-4-2. 사번, 이름, 업무제목을 조회하되 salary를 24000으로 필터링
SELECT  e.employee_id, e.last_name,
        j.job_title
FROM    employees e, jobs j
WHERE   e.job_id = j.job_id
AND     e.salary = 24000
ORDER BY 1;


-- 6-4-3. 그러면, 서브쿼리로 표현!
SELECT  e.employee_id, e.last_name,
        j.job_title
FROM    employees e, jobs j
WHERE   e.job_id = j.job_id
AND     e.salary = ( SELECT MAX(salary)
                     FROM employees )
ORDER BY 1;


6-2. 단일 행 (단일 컬럼) 서브쿼리
-- 다중 행 서브쿼리는 다중 행 연산자(IN, NOT IN, ANY, ALL, EXISTS) 와 함께 사용하는
-- 서브쿼리

6-2-1.IN 연산자
[예제6-5] 근무지(위치코드, 부서가 어느 나라에 있는지)가 영국인 부서코드, 위치코드,
부서명 정보를 조회하시오
SELECT  department_id, location_id, department_name
FROM    departments
WHERE   location_id IN ( SELECT location_id
                         FROM   locations
                         WHERE  country_id='UK' ); -- 2400, 2500, 2600

--ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다.
--01427. 00000 -  "single-row subquery returns more than one row"
--조건절에서 =과 서브쿼리결과를 비교할 수 없음(서브쿼리는 다중 행 결과를 반환하기 때문)

6-2-2. ANY 연산자
서브쿼리의 결과 값 중 어느 하나의 값만 만족되면 행을 반환한다.
[예제6-6] 70번 부서원의 급여보다 높은 급여를 받는 사원의 사번, 이름, 부서번호, 급여를
급여 순으로 조회 하시오
-- 부서별로 사원수를 조회
SELECT department_id, COUNT(*)
FROM    employees
GROUP BY department_id -- 10,40,70번 부서 : 1명, (null) : 1명
ORDER BY 1;


SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary > ANY ( SELECT salary 
                   FROM employees
                   WHERE department_id = 70 ) -- 10000$ 초과
ORDER BY 1; -- 15rows

* > ANY 는 > MIN()과 동일한 기능을 한다.

SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary > ANY( SELECT salary
                   FROM employees
                   WHERE department_id = 70 ) -- 10000$ 초과
ORDER BY 1; -- 15rows


[예제6-8] 10번 부서원의 급여보다 적은 급여를 받는 사원의 사번, 이름, 부서번호, 급여를
급여 순으로 조회하시오
SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary < (  SELECT MAX(salary)
                    FROM    employees
                    WHERE   department_id=20 )
ORDER BY salary DESC;               

* < ANY 는 < MAX()와 동일한 기능을 한다.


6-2-2. ALL 연산자
ALL 연산자는 서브쿼리의 결과 값 모두에 만족되면 행을 반환

[예제6-10] 100번 부서원 모두의 급여보다 높은 급여를 받는 사원의 사번, 이름, 부서번호,
급여를 급여 오름차순으로 정렬하여 조회하시오
-- ASC : 기본 조회 방법(오름차순)
-- DESC : 내림차순 정렬

SELECT salary
FROM    employees
WHERE   department_id = 30;


SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary > ALL (  SELECT salary
                    FROM    employees
                    WHERE   department_id = 100 ) -- 최대:12008, 최소:6900
ORDER BY salary;                    

* > ANY : MIN()과 같은 기능이고,
  > ALL : MAX()와 같은 기능이다.

SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary > (  SELECT  MAX(salary) -- 최대 : 12008$
                    FROM    employees
                    WHERE   department_id = 100 ) 
ORDER BY salary;                    


[예제6-11] 30번 부서원의 모두의 급여보다 적은 급여를 받는 사원의 사번, 이름, 부서번호,
급여를 급여 순으로 조회하시오
-- 30번 부서원의 급여 최대 : 11000$, 최저급여 : 2500$
SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary < ALL ( SELECT salary
                    FROM employees
                    WHERE department_id = 30 )
ORDER BY salary;                    


* < ANY : MAX()과 같은 기능이고,
  < ALL : MIN()와 같은 기능이다.

[예제 6-13]  
SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary < ( SELECT MIN(salary) -- 최소 : 2500$
                   FROM employees
                   WHERE department_id = 30 )
ORDER BY salary;     


* = ANY 연산자는 IN 연산자와 동일한 기능을 한다.
[예제6-14] 20번 부서원 급여와 같은 급여를 받는 사원의 사번, 이름, 부서번호, 급여를
부서코드 순, 급여 순으로 조회하시오
SELECT salary
FROM    employees
WHERE   department_id=20; -- 2명의 부서원이 있는 20번 부서, 각각 13000$, 6000$


SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary = ANY ( SELECT salary
                   FROM    employees
                   WHERE   department_id=20 )
ORDER BY department_id, salary;


[예제 6-15] =ANY를 IN으로 바꿔보시오
SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary IN ( SELECT salary
                   FROM    employees
                   WHERE   department_id=20 )
ORDER BY department_id, salary;

* NOT IN 연산자는 <> ALL 연산자와 동일한 기능을 한다.

[예제6-16] 부서 테이블에서 부서코드가 10,20,30,40에 해당하지 않는 부서코드를 조회하는
쿼리를 작성하시오
SELECT  department_id
FROM    departments
--WHERE   department_id = ANY (10,20,30,40); -- IN 과 같음
--WHERE   department_id != ANY (10,20,30,40); 
--WHERE   department_id <> ALL (10,20,30,40); 
WHERE   department_id != ANY (10,20,30,40); 

---- * 다중행 단일컬럼 서브쿼리 
----------------------------------------------
IN               [포함된 것]
NOT IN  : <> ALL [포함되지 않는것]
ANY    > ANY : MIN()     |     < ANY : MAX()
       = ANY : IN 
ALL    > ALL : MAX()     |     < ALL : MIN()
----------------------------------------------


6-2-3. (단일 행) 다중 컬럼 서브쿼리
서브쿼리의 실행결과가 메인쿼리처럼 여러개의 컬럼을 사용하는 것

[예제6-18] 매니저가 없는 사원이 매니저로 일하고 있는 부서코드, 부서명을 조회하시오
SELECT department_id, COUNT(*)
FROM    employees
WHERE   department_id = 90
GROUP BY department_id
ORDER BY 1;

SELECT employee_id, department_id, first_name, last_name
FROM    employees
WHERE   manager_id IS NULL;

SELECT department_id, department_name
FROM    departments
WHERE   department_id = 90; -- executive : 경영부서

-- (단일 행) 다중 컬럼 서브쿼리 vs (다중행) 다중컬럼 서브쿼리 : INSERT, *UPDATE, DELETE
-- 8장. DML에서 다시 (다중 행) 다중컬럼 서브쿼리 확인

SELECT department_id, department_name
FROM    departments
WHERE   (department_id, manager_id) IN ( SELECT first_name, employee_id
                                         FROM   employees
                                         WHERE  manager_id IS NULL );


6-2-4. 상호 연관 서브쿼리 : 메인 테이블,서브 테이블간의 JOIN 연산
상호 연관 서브쿼리는 메인 쿼리의 컬럼이 서브쿼리의 조건절에 사용되어 메인쿼리에
독립적이지 않는(=종속적인) 형식의 서브쿼리이다.

[예제6-19] 매니저가 있는 부서코드에 소속된 사원들의 수를 조회 하시오
SELECT  department_id
FROM    employees
WHERE   manager_id IS NOT NULL
ORDER BY 1;

SELECT  e.department_id, COUNT(*)
FROM    employees e
WHERE   department_id IN ( SELECT department_id
                           FROM departments d
                           WHERE manager_id IS NOT NULL
                           AND  e.department_id = d.department_id )
GROUP BY ROLLUP(e.department_id);

* IN 연산자를 EXISTS 연산자로 바꿔 사용할 수 있다.

SELECT  e.department_id, COUNT(*)
FROM    employees e
WHERE   EXISTS ( SELECT manager_id
                           FROM departments d
                           WHERE manager_id IS NOT NULL
                           AND  e.department_id = d.department_id )
GROUP BY ROLLUP(e.department_id);

* EXISTS 연산자는 서브쿼리 결과행의 존재 여부만 판단한다.
* EXISTS 연산자를 사용하는 상호 연관 서브쿼리의 경우, 서브쿼리의 SELECT 목록과는 
무관하고 메인 쿼리 컬럼과의 JOIN 조건이 핵심이다.


6-2-5. 스칼라 서브쿼리 : SELECT 절에 위치
*SELECT 절에 사용하는 서브쿼리  ==> 컬럼처럼 동작 ==> Alias(별칭) 사용
코드성 테이블(=부서코드, 업무코드..)에서 코드명을 조회하거나 그룹함수의 결과값을 조회할때
사용하는 서브쿼리

[예제6-22] 사원의 이름, 급여, 부서코드, 부서명을 조회하시오
SELECT  e.first_name, e.salary, e.department_id, 
        ( SELECT d.department_name
          FROM   departments d
          WHERE  d.department_id = e.department_id
          ) dept_name
FROM    employees e
WHERE   manager_id IS NOT NULL;


[예제6-23] 사원의 이름, 급여, 부서코드, 부서 평균급여를 조회하시오
SELECT  first_name, salary, department_id,
        ( SELECT ROUND(AVG(salary))
          FROM  employees s
          WHERE s.department_id = e.department_id
          GROUP BY department_id
          ) avg_sal
FROM    employees e
WHERE   manager_id IS NOT NULL;

[연습문제6-3] 각 부서에 대해 부서코드, 부서명, 부서가 위치한 도시이름을 조회하는 
쿼리문을 작성하시오
SELECT  d.department_id, d.department_name,
        ( SELECT l.city
          FROM locations l
          WHERE l.location_id = d.location_id) city -- 원래 있던 컬럼처럼, 다른 테이블의 컬럼 데이터를 가져오는것
FROM    departments d;

--[ JOIN으로 처리해보세요 ]
SELECT  d.department_id, d.department_name,
        l.city
FROM    departments d, locations l
WHERE   d.location_id = l.location_id
ORDER BY 1;

6-2-6.인라인 뷰(Inline View)
인라인 뷰는 FROM 절에 사용되는 서브쿼리 형식 ==> 테이블 처럼 ==> 원래 없는 테이블인데,
마치 있는 테이블처럼
* 쿼리가 실행될때 생성되었다가, 사라지는 임시성 뷰라 할수 있다. (쿼리실행,처리는 메모리에서 실행되고 COMMIT 하면, 실제로 반영)
* 메인 쿼리에 독립적이고, WHERE 절에 메인쿼리의 테이블과 JOIN을 통해 관계를 맺는다.
-- 메인쿼리에 종속적인 : 상호 연관 서브쿼리(메인쿼리 컬럼이 서브쿼리 JOIN 조건절에 다시 사용)

SELECT *
FROM v$nls_parameters; -- v : view를 의미 [SYS/SYSTEM 계정으로 확인]

[예제6-24] 급여가 회사 평균급여 이상이고, 최대급여 이하인 사원의 사번, 이름, 급여, 
회사 평균급여, 회사 최대급여를 조회하시오
-- BETWEEN 시작값 AND 마지막값 : 시작값, 마지막값 포함되는 값의 범위
-- [salary_summary : 평균급여, 최대급여 테이블]
SELECT  employee_id, last_name, salary,
        avg_sal, max_sal
FROM    employees, ( SELECT ROUND(AVG(salary)) avg_sal, MAX(salary) max_sal
                     FROM employees ) --6463$ 이상, 24000$ 이하
WHERE   salary BETWEEN avg_sal AND max_sal;


[예제6-25] 사원테이블에서 월별 입사자 현황을 조회하시오
-- 변환함수 : 한번에 못바꿈..숫자->문자, 문자->날짜(o) vs 숫자 -> 날짜 (x)
--      TO_CHAR(number, fmt)         TO_DATE(char, fmt)
--  숫자  <----------------->   문자   <--------------->  날짜
--      TO_NUMBER()                  TO_CHAR(date,fmt])
SELECT hire_date
FROM    employees;

-- DECODE     vs    CASE I, CASE II
-- IF~ELSE IF       동등비교,범위연산 (표현식)

SELECT parameter
FROM v$nls_parameters; -- 기본값 RR/MM/DD vs MM or RR or DD

SELECT  DECODE(TO_CHAR(hire_date, 'MM'), '01', COUNT(*), 0) "1월",
        DECODE(TO_CHAR(hire_date, 'MM'), '02', COUNT(*), 0) "2월",
        DECODE(TO_CHAR(hire_date, 'MM'), '03', COUNT(*), 0) "3월",
        DECODE(TO_CHAR(hire_date, 'MM'), '04', COUNT(*), 0) "4월",
        DECODE(TO_CHAR(hire_date, 'MM'), '05', COUNT(*), 0) "5월",
        DECODE(TO_CHAR(hire_date, 'MM'), '06', COUNT(*), 0) "6월",
        DECODE(TO_CHAR(hire_date, 'MM'), '07', COUNT(*), 0) "7월",
        DECODE(TO_CHAR(hire_date, 'MM'), '08', COUNT(*), 0) "8월",
        DECODE(TO_CHAR(hire_date, 'MM'), '09', COUNT(*), 0) "9월",
        DECODE(TO_CHAR(hire_date, 'MM'), '10', COUNT(*), 0) "10월",
        DECODE(TO_CHAR(hire_date, 'MM'), '11', COUNT(*), 0) "11월",
        DECODE(TO_CHAR(hire_date, 'MM'), '12', COUNT(*), 0) "12월"
FROM    employees
GROUP BY TO_CHAR(hire_date, 'MM')
ORDER BY TO_CHAR(hire_date, 'MM');

* 이 결과를 하나의 테이블 데이터로 생각해보자 (= 월별 입사자 현황 테이블은 현재 없음)
* 인라인 뷰 서브쿼리를 이용해 1행의 결과로 만들자!

[예제6-26]
SELECT  SUM(m1) "1월", SUM(m2) "2월", SUM(m3) "3월", SUM(m4) "4월",
        SUM(m5) "5월", SUM(m6) "6월", SUM(m7) "7월", SUM(m8) "8월",
        SUM(m9) "9월", SUM(m10) "10월", SUM(m11) "11월", SUM(m12) "12월"
FROM    (
        SELECT  DECODE(TO_CHAR(hire_date, 'MM'), '01', COUNT(*), 0) m1,
                DECODE(TO_CHAR(hire_date, 'MM'), '02', COUNT(*), 0) m2,
                DECODE(TO_CHAR(hire_date, 'MM'), '03', COUNT(*), 0) m3,
                DECODE(TO_CHAR(hire_date, 'MM'), '04', COUNT(*), 0) m4,
                DECODE(TO_CHAR(hire_date, 'MM'), '05', COUNT(*), 0) m5,
                DECODE(TO_CHAR(hire_date, 'MM'), '06', COUNT(*), 0) m6,
                DECODE(TO_CHAR(hire_date, 'MM'), '07', COUNT(*), 0) m7,
                DECODE(TO_CHAR(hire_date, 'MM'), '08', COUNT(*), 0) m8,
                DECODE(TO_CHAR(hire_date, 'MM'), '09', COUNT(*), 0) m9,
                DECODE(TO_CHAR(hire_date, 'MM'), '10', COUNT(*), 0) m10,
                DECODE(TO_CHAR(hire_date, 'MM'), '11', COUNT(*), 0) m11,
                DECODE(TO_CHAR(hire_date, 'MM'), '12', COUNT(*), 0) m12
        FROM    employees
        GROUP BY TO_CHAR(hire_date, 'MM')
);



-- 인라인 뷰 서브쿼리 : FROM 절에 사용하는 서브쿼리를 뜻함
ROWNUM : 가상의 컬럼(Pseudo-Column, 의사 컬럼)으로 존재하는 쿼리문의 실행 결과의 순서값을
가리킨다.
-- ROW_NUMBER() : 순위(RANKING), 순번을 조회하는 함수

[예제6-27] 사번, 이름을 10건 조회한다.
-- MYSQL : LIMIT 5
SELECT  ROWNUM, employee_id, first_name
FROM    employees
WHERE   ROWNUM <= 10;

[예제6-28]
SELECT  employee_id, first_name, salary
FROM    employees
ORDER BY salary DESC; -- Steven ~ Lisa

SELECT *
FROM    ( SELECT  employee_id, first_name, salary
          FROM    employees
          ORDER BY salary DESC )
WHERE ROWNUM < 11;


* 만능쿼리 , 한방쿼리 : 실무에서 사용하는 쿼리문 (외워서 쓰거나, 저장해두었다가~)
-- 검색해보세요!
