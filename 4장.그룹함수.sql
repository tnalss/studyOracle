3장. 일반함수 : 일반적인 목적으로 사용하는 함수들
4장. 그룹함수 : 중복제거 / 집계함수(aggression) - 평균, 표준편차, 1/4, 2/4 ...

4-1. DISTINCT / 구별되는~ 데이터의 중복을 제거한 결과를 반환하는 키워드, (NULL 포함)

[예제4-1]
SELECT DISTINCT department_id
FROM    employees
ORDER BY department_id; -- 사원들이 소속된 부서는 11개, 부서가 없는 사원 1명 (kimberly)

SELECT department_id
FROM    departments; -- 총 부서는 : 27개

[예제4-1]
-- DISTINCT를 사용하면 중복이 제거된다 (department_id)
-- DISTINCT를 사용하면 중복이 제거된다 (department_id + employee_id)
SELECT DISTINCT department_id, employee_id
FROM    employees;

-- 의도적으로 중복된 사번과 부서코드를 삽입 : sample 데이터는 제약조건! 
--INSERT INTO employees (first_name, employee_id, department_id)
--VALUES ('선영훈', 100, 90);


[연습문제4-1] 사원 테이블에서 이 회사의 매니저들을 조회하는 쿼리문을 작성하시오
SELECT DISTINCT manager_id
FROM employees
WHERE manager_id IS NOT NULL;

4-2-2. COUNT(): 데이터의 행이 몇개가 있는지 갯수를 반환 (NULL 제외)
[예제4-3]
SELECT  COUNT(*), 
        COUNT(employee_id), 
        COUNT(department_id), 
        COUNT(DISTINCT department_id)
FROM    employees;

SELECT DISTINCT department_id
FROM    employees;

4-2-3. SUM() : 숫자 데이터 컬럼의 전체 합계를 계산한 결과를 반환
[예제4-4]
SELECT  SUM(salary) total_sal, 
        ROUND(SUM(salary) / COUNT(*)) avg_sal1,
        TRUNC(SUM(salary) / COUNT(*)) avg_sal2,
        CEIL(SUM(salary) / COUNT(*)) avg_sal3,
        FLOOR(SUM(salary) / COUNT(*)) avg_sal4
FROM    employees; 


4-2-4. MAX() : 데이터 컬럼에서 가장 큰 값을 반환
* 모든 데이터 유형에서 사용할 수 있다.

SELECT  MAX(salary) MAX, 
        MIN(salary) MIN -- salary : 급여 (숫자)
FROM    employees;

-- 최대 급여를 받는 사원의 정보를 조회
SELECT employee_id, last_name, department_id, job_id
FROM    employees
WHERE   salary=24000;

-- 최저 급여를 받는 사원의 정보를 조회
SELECT employee_id, last_name, department_id, job_id
FROM    employees
WHERE   salary=2100;

SELECT  MAX(hire_date) "마지막 입사일", 
        MIN(hire_date) "최초 입사일" -- salary : 급여 (숫자)
FROM    employees;

4-2-5. MIN() : 데이터 컬럼에서 가장 작은 값을 반환
* 모든 데이터 유형에서 사용할 수 있다.

SELECT employee_id, last_name, department_id, job_id
FROM    employees
--WHERE   salary=24000
--OR      salary=2100;
WHERE   salary IN (2100, 24000);

4-2-6. AVG() : 숫자데이터 컬럼의 평균값을 계산하여 반환 / 소수점 (ROUND, TRUNC, CEIL, FlOOR)
SELECT SUM(salary) / COUNT(*) "급여 평균"
FROM    employees;

SELECT AVG(salary) "급여 평균"
FROM    employees;


4.3 GROUP BY 절
--GROUP BY 절에 특정 조건을 사용하여 데이터 행을 하나의 그룹으로 나눌 수 있다.
--GROUP BY 절에 그룹 짓는 기준이 되는 컬럼을 지정한다.

4-3-1. GROUP BY 절과 그룹 함수(COUNT, SUM, MAX, MIN, AVG()) / DISTINCT [키워드]
[예제4-8] 부서별(부서를 그룹짓는 기준) 급여 총액, 사원 수, 평균 급여를 조회하시오
SELECT  department_id,
        SUM(salary) "급여 총액",
        COUNT(*) "사원 수",
        ROUND(AVG(salary)) "평균 급여"
FROM    employees
--WHERE
GROUP BY department_id
ORDER BY 1;

-- 1. 그룹함수와 그룹함수를 사용하지 않은 (일반)컬럼을 함께 작성했을때 
--ORA-00937: 단일 그룹의 그룹 함수가 아닙니다
--00937. 00000 -  "not a single-group group function"
-- GROUP BY (일반)컬럼 에 작성해야 오류가 발생하지 않는다.

-- 2. ORDER BY는 위치를 잘못 작성하지 않았을 때
--ORA-00933: SQL 명령어가 올바르게 종료되지 않았습니다
--00933. 00000 -  "SQL command not properly ended"
-- ORDER BY 는 가장 마지막에 작성한다.

/* 작성하는 순서 ..진행 [교재]
SELECT                  SELECT
FROM                    FROM
WHERE             --->  WHERE
ORDER BY                GROUP BY
GROUP BY                ORDER BY
...
*/

[예제4-9] 부서별, 업무별 [그룹 짓는 기준] 급여총액, 평균급여를 조회하시오
SELECT  department_id, job_id,
        COUNT(*),
        SUM(salary) total_sal,
        ROUND(AVG(salary)) avg_sal
FROM    employees
GROUP BY department_id
ORDER BY 1;

-- 3. 그룹짓는 기준을 누락했을때
--ORA-00979: GROUP BY 표현식이 아닙니다.
--00979. 00000 -  "not a GROUP BY expression"
-- GROUP BY 절에 일반 컬럼(=그룹 함수를 사용하지 않은 컬럼)을 모두 작성!

* SELECT 절에 사용되는 그룹 함수 이외의 컬럼은 반드시 GROUP BY 절에 (모두)명시해야 함.
* 그러나 GROUP BY 절에 명시된 컬럼은 SELECT 절에 사용하지 않아도 된다.
-- 그래도 쓰는게 낫다 (생략하면, 어떤 데이터인지 파악이 어렵다)

SELECT  COUNT(*),
        SUM(salary) total_sal,
        ROUND(AVG(salary)) avg_sal
FROM    employees
GROUP BY department_id, job_id
ORDER BY 1;

[예제4-10] 80 번 부서의 급여 총액과 평균 급여를 조회하시오
SELECT  department_id,
        SUM(salary) "급여 총액",
        ROUND(AVG(salary)) "평균 급여"
FROM    employees
WHERE   department_id = 80
GROUP BY department_id;

4.4 HAVING 절 (조건절)
/*
SELECT
FROM
WHERE
GROUP BY
HAVING  : 여기에 작성!
ORDER BY
*/
- HAVING 절을 사용해서 그룹을 제한한다.
- WHERE 절에 사용하는 조건을 HAVING 절에 사용할 수도 있으나, 그룹 함수가 포함된 조건은
  HAVING 절 에서만 사용할 수 있다.                  [COUNT, SUM, AVG, MAX, MIN]
-- 일반조건은 WHERE 또는 HAVING 에도 쓴다
-- 그룹함수가 포함된 조건 : ex> 사원수가 5명인, 급여평균 8000이하인, 급여총액이 15000인 부서..
  
[예제 4-11] 80 번 부서의 평균 급여를 조회한다.
-- HAVING 없이,
SELECT department_id,
        ROUND(AVG(salary)) avg_sal
FROM    employees
WHERE   department_id = 80
GROUP BY department_id;
  

-- HAVING을 포함해서
SELECT department_id,
        ROUND(AVG(salary)) avg_sal
FROM    employees
--WHERE   department_id = 80
GROUP BY department_id
HAVING  ROUND(AVG(salary)) = 8000

[예제4-12] 부서에 소속된 사원의 수가 5명 이하인 부서와 그 수를 조회하시오
-- 그룹함수를 조건으로 비교 : HAVING 절에만!! (WHERE 절에 사용하면 오류 발생)
SELECT  department_id,
        COUNT(*)
FROM    employees
WHERE   department_id IS NOT NULL
GROUP BY    department_id
HAVING  COUNT(*) <= 5
ORDER BY 1;


4.5 ROLLUP과 CUBE 
4-5-1. ROLLUP() : GROUP BY 절에 ROLLUP 함수를 사용하여 GROUP BY 구문에 의한 결과와 함께 
단계별 소계, 총계 정보를 구할 수 있다.

[예제 4-13] 부서별 사원수와 급여 합계, 총계를 조회하시오
-- ROLLUP 사용 전
SELECT  department_id,
        COUNT(*) cnt,
        SUM(salary) sum_salary
FROM    employees
GROUP BY department_id
ORDER BY 1;

-- ROLLUP 사용
SELECT  department_id,
        COUNT(*) cnt,
        SUM(salary) sum_salary
FROM    employees
GROUP BY ROLLUP(department_id)
ORDER BY 1;

-- CUBE 사용
SELECT  department_id,
        COUNT(*) cnt,
        SUM(salary) sum_salary
FROM    employees
GROUP BY CUBE(department_id)
ORDER BY 1;

[예제4-14] 부서 내 업무별 사원의 수와 급여합계, 부서별 소계, 총계를 조회 하시오
SELECT  department_id,
        COUNT(*) cnt,
        SUM(salary) sum_sal
FROM    employees        
WHERE   department_id IS NOT NULL
GROUP BY ROLLUP(department_id)
ORDER BY 1;


4-5-2. CUBE() : GROUP BY 절에 ROLLUP 함수를 사용하여 GROUP BY 구문에 의한 결과와 함께
모든 경우의 조합에 대한 소계, 총계 정보를 구할 수 있다.

[예제4-15] 부서 내 업무별 사원수와 급여합계, 부서별 소계, 업무별 소계, 총계를 조회하시오
SELECT  department_id, job_id, COUNT(*) cnt, SUM(salary) sum_sal
FROM    employees
WHERE   department_id IS NOT NULL
GROUP BY ROLLUP(department_id, job_id)
ORDER BY 1;

