5장. JOIN 연산

오라클은 관계형 데이터 베이스이다 (RDBMS) -- E.F.CODD 박사 1970년도에 제안 , 현재 대부분!
-- SQL(절차적 질의어) vs NoSQL(SQL을 사용하지 않는, key-value or collection[document])
-- ORACLE, MYSQL ....  MongoDB / Firebase .. 8:2 or 7:3
-- 오라클 테이블 컬럼 255개까지..

JOIN은 여러 테이블을 연결하여 데이터를 조회하는 방법이다.
-- WHY? 하나의 모든 데이터를 담아뒀다가 뭔가 하나의 데이터를 갱신 ==> ??
-- 데이터베이스 특징 : 중복을 피하고 효율적으로 공유하기 위한 시스템 ==> 정보를 분산시켜서
-- 관리 및 필요할때 JOIN 연산을 통해 원하는 데이터를 조회할 수 있도록 만들었기 때문!

5-1. 오라클 JOIN

5-1-1. Cartesian Product (카테시안 곱) : JOIN 조건을 기술하지 않았을 때 잘못된 결과가
발생하는데, 이것을 가리킨다.

-- JOIN 연산을 제대로 하지 않아서 값의 범위를 초과한 결과가 조회된 현상
-- 일부러? 의도적으로? 할 일도 없다.

[예제5-1] 사번, 성, 부서명을 조회하시오
-- 사번, 성 : employees 테이블에 employee_id, last_name
-- 부서명 : departments 테이블에 department_name

-- 1. 부서 테이블의 구조(정의)
DESC departments;

-- 2.사원 테이블의 정보를 조회
SELECT  employee_id, last_name
FROM    employees
ORDER BY 1;

-- 3.부서테이블의 정보를 조회
SELECT  department_name
FROM    departments;

-- 4. 사원테이블 , 부서테이블을 함께 조회
SELECT  employee_id, last_name, department_name
FROM    employees, departments; -- 2889 rows

* WHERE 절에 JOIN 조건을 작성하여 여러 테이블로부터 데이터를 조회한다.


5-1-2. EQUI-JOIN(=동등 조인) : WHERE 절에 동등 연산자(=)을 사용하는 JOIN 형식으로, 
JOIN 조건은 같은 값을 가진 컬럼에 대해 테이블명.컬럼명 = 테이블명.컬럼명 을 사용한다
* 여러 테이블에 있는 공통 컬럼(=조인조건)을 기준으로 작성한다.

[예제5-2] employees, departments 테이블에서 사번, 이름, 부서명을 조회하시오
SELECT  employee_id, first_name,
        department_name
FROM    employees , departments     
WHERE   employees.department_id = departments.department_id;


* 테이블을 Alias(=별칭)를 사용해서 쿼리문을 단순화, 가독성을 높일 수 있다.
[예제5-3] employees, departments 테이블에서 사번, 이름, 부서명을 조회하시오
SELECT  '한울' company, employee_id, first_name,
        department_name
FROM    employees e, departments d
WHERE   e.department_id = d.department_id; -- department_id는 null값 포함!


[예제5-4] employees, jobs 테이블을 사용해서 사번, 이름, 업무코드, 업무제목을 조회
하시오
-- JOBS :
-- JOB_HISTORY :
DESC jobs;
SELECT COUNT(*)
FROM jobs;
--이름         널?       유형           
------------ -------- ------------ 
--JOB_ID     NOT NULL VARCHAR2(10) 
--JOB_TITLE  NOT NULL VARCHAR2(35) 
--MIN_SALARY          NUMBER(6)    
--MAX_SALARY          NUMBER(6)
--         (107 rows)          (19rows)
--SELECT 107 * 19
--FROM dual; --2033 rows : Cartesian Product

SELECT  e.employee_id, e.first_name, e.job_id,
        j.job_title
FROM    employees e, jobs j
WHERE   e.job_id = j.job_id; -- 일반조건절 vs JOIN 조건절


SELECT  e.employee_id, e.first_name, e.department_id, e.job_id
FROM    employees e
WHERE   first_name = 'Kimberely'; --job_id는 null을 포함하고 있지 않다.

SELECT TABLE_NAME
FROM USER_TABLES;

--TABLE_NAME                                                                                                                      
----------------------------------------------------------------------------------------------------------------------------------
--REGIONS : 대륙 정보
--LOCATIONS : 도시 정보
--DEPARTMENTS : 부서 정보
--JOBS : 업무 정보
--EMPLOYEES : 사원 정보
--JOB_HISTORY : 업무이력 정보
--COUNTRIES : 국가 정보

* JOIN 하는 대상 테이블이 추가되면 JOIN 조건을 추가한다.
[예제 5-5] employees, departments, jobs 테이블을 사용하여 사번, 이름, 부서명,
업무제목을 조회하시오
DESC employees;
DESC departments;
DESC jobs;

SELECT  e.employee_id, e.first_name,
        d.department_name,
        j.job_title
FROM    employees e, departments d, jobs j
WHERE   e.department_id = d.department_id
AND     e.job_id = j.job_id
ORDER BY 2;



* WHERE 절에 JOIN 조건과 일반 조건을 함께 사용할 수 있다.
[예제5-6] 사번이 101번인 사원의 사번, 이름, 부서명, 업무제목 정보를 조회하시오
SELECT  e.employee_id, e.first_name,
        d.department_name,        
        j.job_title
FROM    employees e, departments d, jobs j
WHERE   e.department_id = d.department_id
AND     e.job_id = j.job_id
AND     e.employee_id = 101
ORDER BY 1;


5-1-3. NON-EQUI JOIN
/*
EQUI-JOIN              NON-EQUI JOIN
동등연산자(=)     vs  비교연산자, 범위연산자, IN(=OR 대신)
*/
JOIN 하는 컬럼이 일치하지 않게 사용하는 JOIN 조건으로 *거의 사용하지* 않는다.

[예제5-7] 급여가 업무 상하한 범위 내에 있는 10번 부서원의 사번, 이름, 급여, 업무제목을
조회하시오

SELECT  e.employee_id, e.first_name, e.salary,
        j.job_title
FROM    employees e, jobs j
WHERE   e.salary BETWEEN j.min_salary AND j.max_salary
AND     e.department_id = 10;

/*
SELECT *
FROM    jobs;
*/

5-1-4. OUTER JOIN  <---> INNER JOIN
EQUI-JOIN은 JOIN하는 테이블들 간에 공통으로 만족되는 값을 가진 경우의 결과를 반환하지만,
OUTER JOIN은 만족되는 값이 없는 경우의 결과까지 반환한다.
* 만족되는 값이 없는 테이블 컬럼에 (+) 기호를 표시한다.

employees, departments 테이블을 이용해서 사번, 이름, 부서명을 조회하시오
SELECT employee_id, first_name,
        department_name
FROM    employees e, departments d
WHERE   e.department_id = d.department_id(+); -- 107 vs 106;


[예제5-9] 모든 사원의 사번, 이름, 급여, 부서코드, 부서명, 위치코드, 도시정보를 조회한다.
-- 사번, 이름, 급여, 부서코드 : employees
-- 부서명 : departments
-- 위치코드, 도시정보 : locations
/*
SELECT *
FROM    regions; -- 대륙정보(아시아, 유럽,아메리카,중앙아프리카)
SELECT *
FROM    countries; -- 국가정보(국가코드, 국가명, 대륙코드)
*/

SELECT  e.employee_id, e.first_name, e.salary, e.department_id,
        d.department_name, d.location_id,
        l.city
FROM    employees e, departments d, locations l
WHERE   e.department_id = d.department_id(+)
AND     d.location_id = l.location_id(+)
AND     e.employee_id = 178
ORDER BY 1;

5-1-5. SELF JOIN
SELF JOIN은 하나의 테이블을 두번 명시하여 동일한 테이블 두개로부터 JOIN을 통해
데이터를 조회한 결과를 반환하는 JOIN 연산
==> (A-B연산결과) 테이블 = A테이블 ~ B테이블

SELECT employee_id, first_name, manager_id
FROM employees;

[예제5-10] 사원의 사번, 이름, 매니저 사번, 매니저 이름 정보를 조회하시오
-- 매니저 정보 테이블 : 없음.
-- 사원 테이블 : 사원정보(매니저 코드 ~ 사번과 일치)

SELECT  e.employee_id, e.first_name,
        m.employee_id manager_id, m.first_name manager_name
FROM    employees e, employees m
WHERE   e.manager_id = m.employee_id
ORDER BY 1;



5-2. ANSI JOIN
모든 RDBMS에서 공통적으로 사용할 수 있는 국제 표준 JOIN 형식이다.
-- SQL vs NoSQL (Not Only SQL , Key:Value / Collection / Document)

5-2-1. INNER JOIN
오라클의 EQUI JOIN과 같은 기능을 하는 JOIN 형식 (=공통 컬럼을 기준으로 연산)
FROM 절에 INNER JOIN을 사용하고, JOIN 조건은 ON 절에 명시한다.

1) EQUI JOIN
SELECT  e.employee_id, e.first_name, d.department_name
FROM    employees e, departments d         -- INNER JOIN
WHERE   e.department_id = d.department_id  -- ON절
ORDER BY 1;

2) INNER JOIN : 내부 조인    vs   OUTER JOIN : 외부 조인
SELECT  e.employee_id, e.first_name, d.department_name
FROM    employees e INNER JOIN departments d         -- INNER JOIN
ON   e.department_id = d.department_id  -- ON절
ORDER BY 1;

[예제5-12] 사원의 사번, 이름, 부서코드, 부서명 정보를 조회하시오
SELECT  e.employee_id,
        e.first_name,
        e.department_id,
        d.department_name
FROM    employees e INNER JOIN departments d        
ON      e.department_id = d.department_id
ORDER BY 1; -- 106 rows . 1명 kimberely 누락 (department_id IS NULL)

* JOIN 조건에 사용하는 컬럼명이 같은 경우, ON 대신 USING을 사용할 수 있다.
* USING을 사용할때 컬럼명만 기술해야 한다.

[예제5-13] 사원의 사번, 이름, 부서코드, 부서명 정보를 조회하시오
SELECT  e.employee_id,
        e.first_name,
        e.department_id,
        d.department_name
FROM    employees e INNER JOIN departments d        
USING   (department_id)
ORDER BY 1; -- 106 rows . 1명 kimberely 누락 (department_id IS NULL)

-- ANSI 조인 : USING 사용시 컬럼명 앞에 Alias를 사용할 경우 에러
--ORA-01748: 열명 그 자체만 사용할 수 있습니다
--01748. 00000 -  "only simple column names allowed here"
-- Alias를 제외한 순수 (공통)컬럼명만 USING 절에 사용!

--ORA-00906: 누락된 좌괄호
--00906. 00000 -  "missing left parenthesis"
-- USING 절에 공통컬럼을 사용할 경우 ()로 묶어주면 된다!

* WHERE 절에 일반 조건 사용시, ON 또는 USING 절 다음에 위치해야 한다.

[예제5-14] 80번 부서원의 사번, 이름, 부서코드, 부서명을 조회하시오
SELECT  e.employee_id,
        e.first_name,
        e.department_id,
        d.department_name
FROM    employees e INNER JOIN departments d  
WHERE   e.department_id = 80 -- 일반적인 순서에 의해 작성
USING   (department_id)
ORDER BY 1;


--ORA-00905: 누락된 키워드
--00905. 00000 -  "missing keyword"
-- 일반 조건은 ON, USING 다음에 작성해야 한다.

SELECT  e.employee_id,
        e.first_name,
        department_id,
        d.department_name
FROM    employees e INNER JOIN departments d  
USING   (department_id)
WHERE   department_id = 80 -- ANSI JOIN > INNER JOIN의 경우 ON, USING 다음에 위치
ORDER BY 1;

SELECT  department_id,
        COUNT(*)
FROM    employees
GROUP BY department_id -- 80번 부서 34명,
ORDER BY 1;

--ORA-25154: USING 절의 열 부분은 식별자를 가질 수 없음
--25154. 00000 -  "column part of USING clause cannot have qualifier"
--*Cause:    Columns that are used for a named-join (either a NATURAL join
--           or a join with a USING clause) cannot have an explicit qualifier.
-- USING 절 작성시 WHERE 조건절은 USING절 이후에 작성하고, 컬럼에 테이블 
-- 식별자(Alias)를 제외해야 함.

* JOIN에 사용하는 테이블이 3개 이상인 경우, 첫번째 JOIN 결과에 두번째 JOIN을 추가하는
형태로 JOIN 형식을 사용한다.

[예제5-15] 사원의 사번, 이름, 부서코드, 부서명, 위치코드, 도시이름을 ANSI JOIN으로
조회하시오
-- 사번, 이름, 부서코드 : employees
-- 부서명 : departments
-- 위치코드, 도시이름 : locations


SELECT  e.employee_id,
        e.first_name,
        d.department_id,
        d.department_name,
        l.location_id, l.city
FROM    employees e JOIN departments d  
--FROM    employees e INNER JOIN departments d   -- INNER 생략가능
ON      e.department_id = d.department_id
INNER JOIN locations l
ON      d.location_id = l.location_id
--USING   (department_id)
--WHERE   department_id = 80 -- ANSI JOIN > INNER JOIN의 경우 ON, USING 다음에 위치
ORDER BY 1;



5-2-2. OUTER JOIN
(오라클) JOIN에서 OUTER JOIN은 기호 (+)를 사용하는 OUTER JOIN과 같은 기능을 하는
ANSI JOIN 형식이다.
* FROM절에 LEFT OUTER JOIN 또는 RIGHT OUTER JOIN을 사용하고 JOIN 조건은
ON 절에 명시한다.
[ORACLE JOIN]
SELECT 컬럼명1, 컬럼명2,..
FROM   테이블명1, 테이블명2, 테이블명3..
WHERE   테이블명1.컬럼명1 = 테이블명2.컬럼명2(+) -- 오라클JOIN은 오른쪽에 작성
AND     테이블명1.컬럼명1 = 테이블명3.컬럼명1(+) -- 2개 이상일때 모든 조인조건에 (+)
AND    일반조건;

[ANSI JOIN]
SELECT 컬럼명1, 컬럼명2,..
FROM   테이블명1 [LEFT | RIGHT| FULL ]OUTER JOIN 테이블명2,..
ON 조인조건절
-- USING (공통컬럼);

(+) ==> [방향] OUTER JOIN : 
[예제5-16] 사원의 사번, 이름, 부서코드, 부서명 정보를 OUTER JOIN으로 조회하시오~
SELECT  e.employee_id, e.first_name, e.department_id, 
        d.department_name
FROM    employees e LEFT OUTER JOIN departments d
ON   e.department_id = d.department_id
ORDER BY 1;


[예제5-17] LEFT OUTER JOIN을 RIGHT OUTER JOIN으로 바꿔보시오
SELECT  e.employee_id, e.first_name, e.department_id, 
        d.department_name
FROM    employees e FULL OUTER JOIN departments d
ON   e.department_id = d.department_id
ORDER BY 1;


[예제5-18] ON 대신 USING으로 바꾸서 조회하시오
SELECT  e.employee_id, e.first_name, e.department_id, 
        d.department_name
FROM    employees e RIGHT OUTER JOIN departments d
USING   (department_id)
ORDER BY 1;
--SELECT *
--FROM departments;











