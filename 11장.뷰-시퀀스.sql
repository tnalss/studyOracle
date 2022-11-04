11장. 뷰, 시퀀스

11-1. 뷰 (VIEW)
뷰는 데이터가 존재 하지 않는 가상의 테이블로 보안과 사용자 편의를 위해 사용한다.
물리적으로 존재하지 않는 (= 메모리에 존재, 쿼리 실행할때 생성)

보안을 위한 ==> 모든 데이터를 다 보여주는게 아니라, 기밀을 다루는 데이터의 경우 그것을
제외한 것들만 보여준다.

사용자 편의 ==> 반복적으로 요청하거나 같은 결과의 쿼리를 실행하는것과 비교..
-- 뷰 만드는 형식
CREATE OR REPLACE VIEW 뷰 이름 [AS]
SELECT 절

-- CTAS : 쿼리 실행 결과로 테이블을 생성하는 구문
CREATE TABLE 테이블명 AS
SELECT 절~

[예제11-11] v_emp80 이라는 뷰를 사원테이블 departments의 80번 부서에 해당하는 부서원들의
정보인 사번, 이름, 성, 입사일을 기준으로 작성하시오

-- NLS 파라미터 세팅 확인
--SELECT *
--FROM v$nls_parameters;

-- [시스템,사용자] 예약어 확인
--SELECT *
--FROM v$reserved_word;

CREATE OR REPLACE VIEW v_emp80 AS
SELECT employee_id emp_id,
        first_name,
        last_name,
        email,
        hire_date
FROM    employees
WHERE   department_id = 80;    

--View V_EMP80이(가) 생성되었습니다.
SELECT *
FROM    v_emp80; -- 80번 부서 : 판매, 배송 관련?

-- 그런데, 다시 v_emp80에 JOB_ID를 추가하고자 하면?
CREATE OR REPLACE VIEW v_emp80 AS
SELECT  employee_id emp_id,
        first_name,
        last_name,
        email,
        job_id, -- 깜박해서 다시 추가했다 or 요청이 있어서 다시 추가했다. alter table x
        hire_date
FROM    employees
WHERE   department_id = 80;   


[예제 11-2] v_dept 뷰를 생성하시오~
부서코드, 부서명, 최저급여, 최대급여, 급여평균을 포함하여야 한다.

CREATE OR REPLACE VIEW v_dept AS
SELECT  d.department_id, d.department_name, 
        MIN(e.salary) min_sal, MAX(e.salary) max_sal, ROUND(AVG(e.salary)) avg_sal
FROM    departments d, employees e        
WHERE   d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;

-- 조회
SELECT *
FROM v_dept
WHERE   department_id = 80;


-- 오라클 샘플 데이터베이스에 포함된 뷰를 조회
SELECT *
FROM emp_details_view;


-- VIEW 삭제
DROP VIEW v_dept;

-- INSERT 시도
INSERT INTO v_emp80 
VALUES (302, 'Gildong2', 'Hong2', 'gildong2001','ST_CLERK', TO_DATE('2022/01/26'));

SELECT *
FROM    v_emp80;

-- 실제 v_emp80에 삽입이 되지 않고, 참조하는 테이블인 employees에 삽입이 이뤄짐
-- 1 행 이(가) 삽입되었습니다...???
-- 하지만, 뷰는 삽입/삭제/수정 목적이 아닌 보여주는 목적이므로 원칙적으로 삽입이 안되게 해야
-- 맞음...우선 롤백!
-- ROLLBACK;


CREATE OR REPLACE VIEW v_emp80 AS
SELECT employee_id emp_id,
        first_name,
        last_name,
        email,
        hire_date
FROM    employees
WHERE   department_id = 80
WITH READ ONLY; -- 업데이트 되지 않도록!!! 옵션을 추가해서 view 생성

-- WITH READ ONLY 테스트
INSERT INTO v_emp80 
VALUES (302, 'Gildong2', 'Hong2', 'gildong2001', TO_DATE('2022/01/26'));

-- SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
-- 42399.0000 - "cannot perform a DML operation on a read-only view"



SELECT *
FROM employees;



11-2. 시퀀스
연속적인 번호의 생성이 필요한 경우, SEQUENCE를 사용하여 자동으로 만들어주는 기능을 제공한다.
의사컬럼 CURRVAL(=Current Value)과 NEXTVAL(=Next Value)를 통해서 조회하고 사용할 수
있다.

[예제11-4] 시퀀스를 아래와 같이 생성하시오
CREATE SEQUENCE emp_seq
START WITH 103
MAXVALUE 999999999
INCREMENT BY 1
NOCACHE -- 처리속도 향상을 위한 캐싱 기능 활성화
NOCYCLE; -- MAXVALUE 도달하면, 다시 START WITH 값부터 순환하는 기능

[예제11-5] EMP_TEST 테이블에 데이터 행을 삽입하시오~
SELECT *
FROM    emp_test; -- 테이블 데이터 확인


SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM emp_test
WHERE TABLE_NAME='emp_test';

-- 시퀀스 사용 안하면?  EMP_ID 를 기억해야..조회해야..
INSERT INTO emp_test
VALUES (104, 'gildong', 90, 'SH_MAN');
INSERT INTO emp_test
VALUES (105, 'gildong', 90, 'SH_MAN');

-- 시퀀스 사용시 : emp_seq
-- PK(EMP_ID), FK(DEPT_ID) 주의

TRUNCATE TABLE emp_test; -- 테이블 레코드 모두 삭제
-- 101, 102번 사원 정보를 넣어두고, emp_seq를 이용해 103번 부터~


INSERT INTO emp_test
VALUES (101, 'gil dong', 10, 'SH_MAN');
INSERT INTO emp_test
VALUES (102, 'dong su', 20, 'IT_PROG');
INSERT INTO emp_test
VALUES (emp_seq.NEXTVAL, 'min su', 50, 'ST_MAN');
INSERT INTO emp_test
VALUES (emp_seq.NEXTVAL, 'go su', 60, 'ST_CLERK');

SELECT *
FROM emp_test;

-- 시퀀스 삭제
DROP SEQUENCE emp_seq;

-- 접속 윈도우(=창) 에서 시퀀스에 마우스 우클릭, 새 시퀀스 선택해서 생성할 수 있음.
-- DBA가 테이블 설계, 컬럼의 정의, 시퀀스의 생성을 해서 개발자가 사용할 수 있도록 직무상
-- 각자의 업무가 나눠져 있음.

