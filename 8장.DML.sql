8장 DML

/* SQL 분류
1) DML : 데이터를 조회, 삽입, *갱신, *삭제 명령어 --> COMMIT or ROLLBACK 직접 수행!
    └ 갱신, 삭제명령은 WHERE 조건절 생략시 , 모든 레코드를 업데이트|삭제 하므로 !!!주의!!!
    
2) DDL : 데이터를 담는 객체(테이블, 뷰, 클러스터, 인덱스..)를 생성/삭제 명령어 : AUTO COMMIT; (=자동커밋)

--------- 개발자 자주 사용 ↑ DBA 자주사용 ↑↓ -----------
3) DCL : 권한을 주거나 회수하는 명령
*/

-- emp 테이블을 만들기 : DDL ( 테이블 객체를 생성 )
CREATE TABLE EMP(
    emp_id NUMBER NOT NULL, -- 숫자(정수,실수)
    fname VARCHAR2(20), -- 가변 문자형
    lname VARCHAR2(20),
    hire_date DATE -- 날짜,시간 : NLS
);


8.1 SELECT : 데이터 조회 명령
테이블에 데이터를 삽입 저장하는 기본 명령어

INSERT INTO 테이블명[(컬럼명1, 컬럼명2, ...)] -- 컬럼을 선택적으로, 생략하면 모든 컬럼
VALUES (값1, 값2, ...);

테이블에 데이터를 저장할때 저장할 컬럼 목록과 일대일 대응이 되도록 저장 값 목록을
VALUES 절에 나열 한다. 저장하지 않는 컬럼은 자동으로 NULL이 된다.
* 날짜 데이터는 날짜 포맷 형식을 사용해서 저장할 수 있다.

8.2 INSERT : 데이터 삽입 명령 (=신규 데이터를 삽입)
[예제8-1] 데이터를 삽입하시오
DESC EMP;
-- 1. NOT NULL 제약조건의 EMP_ID 컬럼만 삽입, 나머지 컬럼의 데이터는 자동으로 NULL
INSERT INTO EMP (EMP_ID)
VALUES (1);

INSERT INTO EMP (EMP_ID, fname, lname)
VALUES (2, 'Steven', 'Jobs');

INSERT INTO EMP (EMP_ID, fname, lname, hire_date)
VALUES (3, 'Bill', 'Gates', SYSDATE);

INSERT INTO EMP
VALUES (4, 'Warren', 'Buffet', TO_DATE('2020-10-24'));

INSERT INTO EMP
VALUES (5, 'Michael', 'Jordan', TO_DATE('2015-03-17'));

SELECT *
FROM EMP;

* TCL : Transaction Control Language (트랜잭션 제어 명령어)
-- 트랜잭션 : 거래 ~ (은행 A계좌 돈을 B계좌 송금하는 과정)
--                      1억원(-)      1억원(+)
--                            [정전!!]
-- 데이터의 무결성 제약조건 : ACID (Atomicity , 원자성) ALL OR NOTHING
                                (Consistencty, Isolation, Durability)
                                   일관성         고립성     영속성?
ROLLBACK; -- 데이터 삽입 전으로 돌아감 (NOTHING)
COMMIT; -- (ALL) 물리적으로 데이터가 삽입 (저장/공간에 기록 ==> TABLESPACE : 테이블스페이스)

* 컬럼 목록 없이 테이블의 모든 컬럼에 대한 저장 값 목록을 VALUES절에 나열한다.
NULL 또는 빈 문자열 '' 을 사용해 수동으로 NULL을 저장할 수 있다 ==> ' ' or NULL

INSERT INTO EMP
VALUES (6, 'Michael', '', '');

INSERT INTO EMP
VALUES (7, 'Julia', NULL, NULL);

INSERT INTO EMP (emp_id, fname) -- 지정하지 않은 컬럼은 자동으로 NULL 입력
VALUES (8, 'Britney'); 
/* EMP 생성 문법을 EMP2 생성 문법으로~ */
CREATE TABLE EMP2(
    emp_id NUMBER NOT NULL, -- 숫자(정수,실수)
    fname VARCHAR2(20), -- 가변 문자형
    lname VARCHAR2(20),
    hire_date DATE, -- 날짜,시간 : NLS
    job_id VARCHAR2(20),
    salary NUMBER(6) -- 
);

SELECT *
FROM EMP;
---------- 멀티테넌트 환경(오라클 12c 이상부터) 가상화 개념을 도입한 사례
----------              CDB      VS            PDB
----------         물리적인 DB     vs     가상의 플러그인 DB
----------              C:\               D:\DEMO_DB 
----------  [오랫동안 사용한 방식]   vs     [새롭게 도입된 방식]

SELECT *
FROM employees;

-- hanul 계정에 emp 생성
CREATE TABLE EMP(
    emp_id NUMBER NOT NULL, -- 숫자(정수,실수)
    fname VARCHAR2(20), -- 가변 문자형
    lname VARCHAR2(20),
    hire_date DATE, -- 날짜,시간 : NLS
    job_id VARCHAR2(20),
    salary NUMBER(6) -- 
);

[예제8-5] EMP 테이블에 HR계정의 사원테이블에서 부서코드가 10, 20번에 해당하는 사원정보를
삽입하시오~
-- EMP 테이블에 조회된 결과를 삽입하는 방법 
INSERT INTO EMP (emp_id, fname, lname, hire_date)
VALUES (300, 'Steven', 'Jobs', TO_DATE('2003-11-20', 'YYYY-MM-DD'));

INSERT INTO EMP (emp_id, fname, lname, hire_date)
VALUES (301, 'Bill', 'Gates', SYSDATE);

INSERT INTO EMP
VALUES (302, 'Warren', 'Buffet', TO_DATE('2020-10-24'),null, null);

* 다른 테이블에서 조회된 결과행을 EMP에 삽입하는 구문
INSERT INTO EMP (emp_id, fname, lname, hire_date, job_id, salary)
SELECT  employee_id, first_name, last_name, hire_date, job_id, salary
FROM    hr.employees
WHERE   department_id IN (10, 20);

SELECT *
FROM EMP; -- p.70 결과

-- ROLLBACK;
COMMIT;


[예제8-6] 월별 급여 관리 테이블에 부서코드 행 데이터를 삽입, 저장하는 쿼리를 작성하시오
-- 테이블명 : month_salary
-- 컬럼 : dept_id, emp_count, tot_sal, avg_sal
-- 코멘트 : 부서코드, 부서의 사원수, 급여 합, 급여 평균
DROP TABLE month_salary; -- 테이블 삭제 (AUTO COMMIT)

CREATE TABLE month_salary (
    dept_id NUMBER,   -- 숫자형 데이터
    emp_count NUMBER, -- 숫자형 데이터
    tot_sal NUMBER(6), -- 숫자형 데이터 / 6바이트 (6자)
    avg_sal NUMBER(7,2),-- 숫자형 데이터 / 정수부 : 5자, 소수부 : 2자
    magam_date DATE DEFAULT SYSDATE -- 생략시 쿼리 실행기준 날짜를 기본값으로 입력
);

SELECT LAST_DAY(SYSDATE)
FROM dual;

DESC hr.employees;
DESC month_salary;

--INSERt INTO month_salary
--VALUES (99, 1, 10000, 19333.44);
--ROLLBACK;
TRUNCATE TABLE month_salary; --테이블 구조는 그대로 두고, 데이터만 모두 삭제
DELETE -- 선택적으로 조건에 맞는 데이터만 삭제 or 모두 삭제(WHERE 생략시)

INSERT INTO month_salary (dept_id, emp_count, tot_sal, avg_sal, magam_date)
SELECT department_id, COUNT(*), SUM(salary), ROUND(AVG(salary), 2), LAST_DAY(SYSDATE)
FROM    hr.employees
GROUP BY department_id
ORDER BY department_id;

SELECT *
FROM EMP; -- 6 rows

COMMIT;

[예제8-7] HR계정의 사원 테이블에서 부서번호 30에서 60번에 해당하는 사원의 정보들을
조회하여 EMP 테이블에 삽입하시오
INSERT INTO EMP
SELECT employee_id, first_name, last_name, hire_date, job_id, salary
FROM    hr.employees
WHERE   department_id BETWEEN 30 AND 60; --57 rows

SELECT *
FROM EMP; --63 rows

COMMIT;

8.3 UPDATE : 데이터 갱신 명령 (=기존 데이터를 수정하여 삽입)
테이블의 데이터를 변경, 저장하는 DML 명령어

--UPDATE 테이블명
--SET 컬럼명1=값1,
--    컬럼명2=값2,...
--WHERE 조건;

* WHERE 조건절의 조건에 이치하는 행의 컬럼 데이터를 새로운 데이터 값으로 변경한다.
* WHERE 조건절을 생략 ==> 모든 데이터가 업데이트 ==> ROLLBACK ==> 다시~ WHERE절~추가

[예제8-8] EMP테이블에서 사번이 300번 이상인 사원의 부서코드를 20으로 변경한다.
--                                           급여를 10000으로 변경한다.
UPDATE EMP
SET salary=10000,
    job_id='HR_CONSULTANT'
WHERE emp_id >= 300;
--ROLLBACK;
SELECT *
FROM EMP;

COMMIT;

[예제8-9] 사번이 300번인 사원의 급여를 2000으로 업무코드를 'IT_PROG'로 변경하시오
UPDATE EMP
SET salary = 2000,
    job_id = 'IT_PROG'
WHERE EMP_ID = 300;

--ROLLBACK;

SELECT *
FROM EMP;

COMMIT;

* 서브쿼리를 사용해 데이터를 변경할 수 있다. UPDATE 문의 서브쿼리는 SET 절과
WHERE 절에 사용할수 있다.

[예제8-11] EMP 테이블 사번 103번인 사원의 급여를 employees 테이블 20번 부서의 최대
급여로 변경한다.
-- 그룹함수 : 결과행이 하나 <==> 서브쿼리 : 단일 행 (단일컬럼) 서브쿼리
-- 서브 쿼리의 구분 I. 단일 행 (단일컬럼), 다중 행(단일 컬럼), (다중 행) 다중 컬럼 서브쿼리
--               II. 연관성을 따져서(=JOIN연산) : 상호연관 서브쿼리
--              III. 사용하는 위치를 따져서 : SELECT(스칼라 서브쿼리/컬럼처럼)
--                                         FROM (인라인 뷰 서브쿼리 / 테이블처럼)
--                                         WHERE (일반 서브쿼리 / 대부분 여기서..)

SELECT MAX(salary) 
FROM    hr.employees
WHERE   department_id=20; -- 13000

UPDATE EMP
SET salary = ( SELECT MAX(salary) 
               FROM    hr.employees
               WHERE   department_id=20 ) -- 원래 SALARY : 9000 -->
WHERE   emp_id=103;

ROLLBACK;

[예제8-12] emp 테이블에서 사번 180번 사원과 같은 해 에 입사한 사원들의 급여를
employees 테이블 50번 부서의 평균 급여로 변경(UPDATE)한다.
-- 평균 급여
SELECT ROUND(AVG(salary), 2)
FROM    hr.employees
WHERE   department_id=50; -- $ 3475.55

------------- NLS DATE FORMAT 설정에 따름 ------------
-- RR/MM/DD vs YY/MM/DD    |  RRRR/MM/DD  vs YYYY/MM/DD
SELECT *
FROM v$nls_parameters; -- 초기 설정, NLS_DATE_FORMAT	RR/MM/DD

--ALTER SESSION SET NLS_DATE_FORMAT='RRRR/MM/DD';

SELECT  TO_CHAR(hire_date, 'YYYY') hire_year
FROM    EMP
WHERE   EMP_ID = 180; --06/01/24

UPDATE EMP
SET salary = ( SELECT ROUND(AVG(salary), 2)
               FROM    hr.employees
               WHERE   department_id=50 )
WHERE   TO_CHAR(hire_date, 'YYYY') = ( SELECT  TO_CHAR(hire_date, 'YYYY') hire_year
                                       FROM    EMP
                                       WHERE   EMP_ID = 180 ) -- 해 : 년도 YEAR

SELECT *
FROM EMP;

COMMIT;

[예제8-13] month_salary 테이블에 각 부서별 사원수, 급여합계, 평균 급여를 변경 저장한다.
SELECT *
FROM    month_salary; -- ??! [예제 8-6] 상태(부서코드만 있는 상태로..) 
                      -- UPDATE를 시켜보자!
--TRUNCATE TABLE month_salary;

SAVEPOINT SP1; -- ROLLBACK SP1;

-- 1. 먼저 employees 테이블의 부서코드를 조회하고 이것을 month_salary에 삽입
INSERT INTO month_salary (dept_id)
SELECT DISTINCT department_id
FROM    hr.employees
WHERE   department_id IS NOT NULL
ORDER BY    department_id;

SAVEPOINT SP2; -- 부서코드만 조회해서 입력한 상태(시점)
-- 부서별 사원수 
SELECT department_id, COUNT(*)
FROM    hr.employees
GROUP BY department_id
ORDER BY 1;
-- 부서별 급여 합계 
SELECT department_id, SUM(salary)
FROM    hr.employees
GROUP BY department_id
ORDER BY 1;
-- 부서별 급여 평균
SELECT department_id, AVG(salary)
FROM    hr.employees
GROUP BY department_id
ORDER BY 1;

-- 서브쿼리가 SET절에 반복/재사용 ==> 코드 길어짐!
UPDATE month_salary m
SET EMP_COUNT = ( SELECT COUNT(*)
                  FROM    hr.employees e
                  WHERE   e.department_id = m.dept_id
                  GROUP BY e.department_id ),
    TOT_SAL = ( SELECT SUM(salary)
                FROM    hr.employees e
                WHERE   e.department_id = m.dept_id
                GROUP BY e.department_id ),
    AVG_SAL = ( SELECT AVG(salary)
                FROM    hr.employees e
                WHERE   e.department_id = m.dept_id
                GROUP BY e.department_id );
    
ROLLBACK;

-- 다중 컬럼 서브쿼리로 null 값을 업데이트 ==> 코드 짧아짐!
[예제8-14] 예제8-13을 다중 컬럼 서브쿼리를 사용하여 업데이트 하시오~
UPDATE month_salary m
SET (EMP_COUNT, TOT_SAL, AVG_SAL) = ( SELECT COUNT(*), SUM(e.salary), AVG(e.salary)
                                      FROM  hr.employees e
                                      WHERE e.department_id = m.dept_id
                                      GROUP BY e.department_id );

SELECT *
FROM    month_salary;

ROLLBACK SP1;
COMMIT;




8.4 DELETE : 데이터 삭제 명령 -- 테이블의 구조/컬럼은 남아있다!
-- 테이블 삭제 : DROP (데이터베이스 객체 - 테이블, 뷰) 테이블의 구조/컬럼 삭제
테이블의 행(=ROW) 데이터를 삭제하는 기본형식은 아래와 같음
DELETE FROM 테이블명
WHERE 조건; 
* 조건을 생략하면, 모든 행이 삭제가 되므로 주의!!
* 조건에 일치하는 행 데이터를 삭제한다.

[예제8-15] EMP 테이블에서 60번 부서의 사원 정보를 삭제하시오
SELECT *
FROM    EMP; -- 63 rows
-- DEPT_ID가 NULL 이므로, HR.employees에서 먼저 60번 부서원들을 조회
SELECT employee_id, first_name, department_id
FROM    hr.employees
WHERE   department_id = 60;

-- 60번 부서원 : 103 ~ 107 사원
DELETE FROM EMP
WHERE   EMP_ID BETWEEN 103 AND 107; -- 58 rows

ROLLBACK;
-- 모든 행을 삭제
DELETE FROM EMP;
--WHERE ~







