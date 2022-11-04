2.1 데이터 조회

-- 테이블의 구조를 조회
-- DESC 테이블명;
DESC countries;
--desc countries;
--describe countries;

--이름           널?       유형           
-------------- -------- ------------ 
--COUNTRY_ID   NOT NULL CHAR(2)      
--COUNTRY_NAME          VARCHAR2(40) 
--REGION_ID             NUMBER

-- 테이블의 데이터를 조회
--SELECT 컬럼명1, 컬럼명2,...
--FROM    테이블명;

SELECT  country_id, country_name
FROM    countries;

[예제2-1] employeess 테이블에 있는 모든 컬럼을 조회하시오
DESC employees;
--이름             널?       유형           
---------------- -------- ------------ 
--EMPLOYEE_ID    NOT NULL NUMBER(6)     : 사번 / 사원번호
--FIRST_NAME              VARCHAR2(20)  : 이름
--LAST_NAME      NOT NULL VARCHAR2(25)  : 성 [친하지 않은 사람에게]
--EMAIL          NOT NULL VARCHAR2(25)  : 이메일
--PHONE_NUMBER            VARCHAR2(20)  : 연락처
--HIRE_DATE      NOT NULL DATE          : 입사일
--JOB_ID         NOT NULL VARCHAR2(10)  : 업무코드/직무코드
--SALARY                  NUMBER(8,2)   : (월)급여
--COMMISSION_PCT          NUMBER(2,2)   : 상여율(%)
--MANAGER_ID              NUMBER(6)     : 매니저 코드
--DEPARTMENT_ID           NUMBER(4)     : 부서코드
SELECT  *
FROM    employees; -- 107명의 데이터가 저장되어 있음.

SELECT employee_id, first_name, salary, hire_date, department_id
FROM    employees;