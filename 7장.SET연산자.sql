7장. SET 연산자

* JOIN 과 SET 구분 : 종속적인 관계 vs 동등한 관계를 맺음.
* SET 연산자는 UNION, UNION ALL, INTERSECT, MINUS가 있다.
* 수학적 집합론 합집합, 교집합, 차집합에 해당한다.

*규칙1.SET 연산자로 묶이는 두 SELECT 절은 컬럼의 수와 데이터 타입이 일치해야 한다.
*규칙2.ORDER BY 절은 모든 쿼리문의 가장 마지막에 사용한다.

7-1. UNION (=합집합) : 중복을 제거한 행의 결과를 반환한다.
-- DISTINCT : 중복을 제거하는 연산자
SELECT DISTINCT department_id
FROM employees
ORDER BY department_id;

[예제7-1]
SELECT  1, 3, 4, 5, 7, 8, 9 first
FROM    dual
UNION
SELECT  2, 4, 5, 6, 8, null, 'B' second
FROM    dual
UNION
SELECT 1, 3, 4, 5, 7, 8, 'A' third
FROM    dual;

-- 컬럼 갯수가 안맞을 때 발생오류
--ORA-01789: 질의 블록은 부정확한 수의 결과 열을 가지고 있습니다.
--01789. 00000 -  "query block has incorrect number of result columns"

-- 컬럼의 데이터 타입이 안맞을때 발생하는 오류 : ex> 숫자-문자는 오류, NULL은 무관!
--ORA-01790: 대응하는 식과 같은 데이터 유형이어야 합니다
--01790. 00000 -  "expression must have same datatype as corresponding expression"

[예제7-2] 관리되고 있는 부서, 관리되고 있는 도시 정보를 조회한다.
DESC departments;

SELECT department_id code, department_name name
FROM    departments
UNION
SELECT location_id, city
FROM    locations;


[예제7-3] 관리되고 있는 도시와 국가 정보를 조회한다.
-- 변환 함수 : 한번에 다른 데이터로 변환시 데이터의 유실, 오류발생 (한번에 변환x,단계별 변환o)
--       TO_CHAR()         TO_DATE()
-- 숫자 <--------->  문자 <---------->  날짜
--      TO_NUMBER()        TO_CHAR()
SELECT TO_CHAR(location_id) code, city name
FROM    locations
UNION -- 중복된 데이터가 있다면 제거된 결과를 반환
SELECT country_id, country_name
FROM    countries;

--ORA-01790: 대응하는 식과 같은 데이터 유형이어야 합니다
--01790. 00000 -  "expression must have same datatype as corresponding expression"
-- 각 테이블의 컬럼 정의(=데이터 타입)를 확인,
-- DESC locations; -- location_id NUMBER, city VARCHAR2
-- DESC countries; -- country_id CHAR, country_name VARCHAR2


7-2. UNION ALL (=합집합)
합집합에 해당하는 연산자로 중복을 포함하는 행의 결과를 반환한다.
[예제7-4]
SELECT  1, 3, 4, 5, 7, 8, 'A' first
FROM    dual
UNION ALL
SELECT  2, 4, 5, 6, 8, null, 'B' second
FROM    dual
UNION ALL
SELECT 1, 3, 4, 5, 7, 8, 'A' third
FROM    dual;


7-3. INTERSECT (=교집합)
* 집합에서 교집합에 해당하는 연산자로, 공통된 행의 결과를 반환합니다.
[예제7-1]
SELECT  1, 3, 4, 5, 7, 8, 'A' first
FROM    dual
INTERSECT
SELECT  1, 3, 4, 5, 7, 8, 'A' third
FROM    dual;

[예제7-7] 80번 부서와 50번 부서 공통으로 있는 사원의 이름
SELECT first_name
FROM employees
WHERE department_id = 80 --34 rows
INTERSECT
SELECT first_name
FROM employees
WHERE department_id = 50; --45 rows

7-4. MINUS (=차집합)
집합에서 차집합에 해당하는 연산자
-- A-B :순수하게 A에 만 있는 (공통된 값은 제외된)
[예제7-8]
SELECT  1, 3, 4, 5, 7, 8, 'A' first
FROM    dual
UNION
SELECT  2, 4, 5, 6, 8, null, 'B' second
FROM    dual
MINUS
SELECT 1, 3, 4, 5, 7, 8, 'A' third
FROM    dual;

[예제7-9] 80번 부서원의 이름에서 50번 부서원의 이름을 제외하시오
-- 80 - 50
SELECT first_name
FROM employees
WHERE department_id = 80 --34 rows   , 공통 2건 (이름 기준), 1건(성 기준)
MINUS
SELECT first_name
FROM employees
WHERE department_id = 50; --45 rows

-- 50 - 80
SELECT first_name
FROM employees
WHERE department_id = 50 --45 rows   , 공통 2건 (이름 기준), 1건(성 기준)
MINUS
SELECT first_name
FROM employees
WHERE department_id = 80; --34 rows

[예제7-10] 사번이 150번 이하인 사원들의 사번,이름,업무코드 정보에서 업무코드가 ST_CLERK
인 사원들의 사번,이름, 업무코드 조회 결과를 제외하시오

DESC employees;

SELECT employee_id, first_name, job_id
FROM    employees
WHERE   employee_id <= 150 --51rows
MINUS
SELECT employee_id, first_name, job_id
FROM    employees
WHERE   job_id = 'ST_CLERK'; --20개
-- 총 31건


[연습문제7-1] 사원 테이블을 사용하여 다음과 같은 형태로 데이터가 조회되도록 쿼리문을
작성하시오
/*
--------------------------------------------------
EMP      NAME      DEPT       MANAGER     SALARY
사번      성명      부서명      매니저여부     급여
--------------------------------------------------
100      Steven      90        (null)      $24,000
                      .....
※단, 매니저 여부에 해당하는 사람은 Manager 라고 표기하고, 매니저가 아닌 사람은
  NULL(값이 없는 형태)로 표시되게 한다.
*/

SELECT employee_id emp, first_name||' '||last_name name, department_id dept,
       TO_CHAR(manager_id) manager, salary
FROM    employees
WHERE   manager_id is null
UNION
SELECT employee_id emp, first_name||' '||last_name name, department_id dept,
       NVL2(manager_id, 'Manager',null) manager, salary
FROM    employees
WHERE   manager_id IS NOT NULL;