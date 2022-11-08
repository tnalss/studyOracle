-- PL/SQL(피엘에스큐엘)
-- 상용 관계형 데이터베이스 시스템인 오라클 DBMS에서 SQL 언어를 확장하기 위해 사용하는 
-- 컴퓨터 프로그래밍 언어
-- Procedural Language extensition to SQL : 순차적/절차적 처리 언어
-- 덧) SQL (Structural Query Language) : 구조적 질의어
-- ====================================================================================
-- 1. PL/SQL 기본 형식 (syntax)  <----> 익명 블록(Anonymouse Block) vs 함수,프로시저,패키지
-- ====================================================================================

-- 1-1. 선언부 : 변수/상수     [DECLARE]
--        └ 변수는 선언만 하고 초기화 하지 않아도 되지만, 상수는 초기화를 반드시 해야함.    
-- 1-2. 실행부 : 프로그래밍 실행  [BEGIN ~ END]
-- 1-3. (예외)처리부  : 예외 발생시 처리(자동 vs 별도의 예외처리) EXCEPTION WHEN 예외 THEN 처리~

-- CLI : SQLPLUS [시작  > CMD > SQLPLUS SYS AS SYSDBA]
--    └ / : PL/SQL (재)실행 명령
-- GUI : sqlDEVELOPER [보기 > DBMS 출력 : + 눌러서 계정선택(=스키마)

-- SQLPLUS에서 출력결과를 보여줄때
SET SERVEROUTPUT ON;    
-- / : PL/SQL (재)실행으로 

-- ====================================================================================
-- II. PL/SQL statement 구성요소
-- ====================================================================================

-- 1.변수
DECLARE  --  선언부
    counter INTEGER := 0; -- 선언과 초기화 :=
BEGIN    -- 실행부
    counter := counter + 1;
    dbms_output.put_line('counter : ' || counter);
END;
/

DECLARE
    message VARCHAR2(20); -- SQL variable type
    is_true BOOLEAN; --only PL/SQL  variable type
BEGIN   
    message := 'hello world';
    dbms_output.put_line(message); -- dbms_output 패키지
END;    
/
-- PL/SQL, SQL 타입별 최대 크기(약간 다름)
--https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/plsql-data-types.html#GUID-C3B938C9-7B0B-4AAC-8323-FEB2ED0225D0

-- 2.상수
-- 상수는 선언부(DECLARE)에서 초기화가 이뤄져야 함.
-- ORA-06550: 줄 3, 열5:PLS-00322: 'NPI' 상수 정의는 초기 할당 문을 포함하여야 합니다
DECLARE
    --nPI CONSTANT INTEGER := 3.14; -- 상수의 선언, 값의 초기화
    nPI CONSTANT INTEGER;
BEGIN
    nPI := 3.14; -- 상수의 선언, 값의 초기화
    dbms_output.put_line('nPI : ' || nPI);
END;    
/
-- 참조형 변수타입 : %TYPE   /  특정 컬럼 하나 (employee_id)
-- 복합형 변수타입 : %ROWTYPE / 특정 행 (employee_id 부터 job_id 까지)
--   └ 여러가지 컬럼을 한번에 조회해서 가져오는 타입..
-- 특정 테이블의 컬럼의 타입과 동일한 데이터 타입을 참조하여 설정하는 키워드
-- inherits the data type and size : 데이터 타입과 길이를 상속받음
-- NOT NULL 제약조건은 생략.
DESC employees;
DECLARE
    emp_name1 VARCHAR2(20); -- 직접 선언
    emp_name2 EMPLOYEES.first_name%TYPE; -- VARCHAR2(20)로 설정되는 효과
BEGIN
    NULL; -- 아무것도 하지 않음.
END;
/

DECLARE
  name     VARCHAR(25) NOT NULL := 'Smith'; -- 사용자 정의한 데이터타입, 값
  surname  name%TYPE := 'Jones'; -- name컬럼의 타입을 참조
BEGIN
  DBMS_OUTPUT.PUT_LINE('name=' || name);
  DBMS_OUTPUT.PUT_LINE('surname=' || surname);
END;
/
-- %ROWTYPE 예시 (departments 테이블)
DESC departments; -- 4개의 컬럼, 각각 NUMBER나 VARCHAR2 타입

DECLARE
  dept_rec departments%ROWTYPE; -- departments 테이블의 레코드(=컬럼들의 행)
BEGIN
  -- Assign values to fields:  
  dept_rec.department_id   := 10;  -- 부서코드
  dept_rec.department_name := 'Administration'; -- 부서명
  dept_rec.manager_id      := 200; -- 매니저코드
  dept_rec.location_id     := 1700; -- 위치코드
 
  -- Print fields: 
  DBMS_OUTPUT.PUT_LINE('dept_id:   ' || dept_rec.department_id);
  DBMS_OUTPUT.PUT_LINE('dept_name: ' || dept_rec.department_name);
  DBMS_OUTPUT.PUT_LINE('mgr_id:    ' || dept_rec.manager_id);
  DBMS_OUTPUT.PUT_LINE('loc_id:    ' || dept_rec.location_id);
END;
/


-- 에러처리 : 기본적으로 PL/SQL엔진이 담당하고 사용자가 별도로 에러처리할 수 있음
-- ORA-01476: 제수가 0 입니다. 0으로 나눌때 발생하는 오류
DECLARE
    nNumber INTEGER := 1;
BEGIN
    nNumber := nNumber / 0;
    EXCEPTION 
        WHEN ZERO_DIVIDE THEN
            nNumber := nNumber / 1;
            dbms_output.put_line('nNumber : ' || nNumber);    
        WHEN OTHERS THEN -- 에러, 예외 발생시 사용자가 에러핸들링
            dbms_output.put_line('Exception 발생');    
END;

-- 제어문(Control Statement)
-- 1) 조건문
-- 1-1) IF THEN : 단순 IF (조건이 TRUE일때 실행)
DECLARE
    nCount INTEGER := 1;
BEGIN
    IF  nCount > 0 THEN
    dbms_output.put_line('TRUE');
    END IF;
END;
-- 1-2) IF ELSE THEN : 조건문 IF (TRUE일때, FALSE 일때 각각 실행)
DECLARE
    nCount INTEGER := 1;
BEGIN
    IF  nCount > 0 THEN
        dbms_output.put_line('0보다 크다');
    ELSE
        dbms_output.put_line('0보다 크지않다');
    END IF;
END;
-- 1-3) IF ELSIF THEN : 조건이 여러개, 각각 만족할때 실행 (ELSIF)
DECLARE
    --nScore NUMBER := 90;
    sGrade CHAR(1) := 'B'; -- SQL 데이터 타입
BEGIN
    IF sGrade = 'A' THEN
        dbms_output.put_line('훌륭합니다!');
    ELSIF sGrade = 'B' THEN
        dbms_output.put_line('노력하세요!');
    ELSIF sGrade = 'C' THEN
        dbms_output.put_line('보통입니다!');
    ELSE
        dbms_output.put_line('부족합니다!');
    END IF;
END;

-- CASE문
-- DECODE, CASE문 (교재 : SQL 에서 IF~ ELSE와 같다)
--  함수  ,  표현식 (동등비교, 범위비교) : SQL 이론 및 실습(p.34~36)
-- CASE는 두가지 형태!
-- 1.simple CASE 구문 : 동등 비교
DECLARE
    sGrade CHAR(1) := 'D';
BEGIN
    CASE sGrade
        WHEN 'A' THEN DBMS_OUTPUT.PUT_LINE('A등급, 훌륭합니다!');
        WHEN 'B' THEN DBMS_OUTPUT.PUT_LINE('B등급, 노력하세요!');
        WHEN 'C' THEN DBMS_OUTPUT.PUT_LINE('C등급, 보통입니다~');
        ELSE
            DBMS_OUTPUT.PUT_LINE('등급에 없습니다. 분발하세요!');
    END CASE;        
END;

-- 2.searched CASE 구문 : 연산자를 이용한 비교(>,<,>=,<=,!=)
DECLARE
    sGrade CHAR(1) := 'D';
BEGIN
    CASE 
        WHEN sGrade = 'A' THEN DBMS_OUTPUT.PUT_LINE('A등급, 훌륭합니다!');        
        WHEN sGrade = 'B' THEN DBMS_OUTPUT.PUT_LINE('B등급, 노력하세요!');
        WHEN sGrade = 'C' THEN DBMS_OUTPUT.PUT_LINE('C등급, 보통입니다~');
        ELSE
            DBMS_OUTPUT.PUT_LINE('등급에 없습니다. 분발하세요!');
    END CASE;        
END;

-- 동등 비교(simple CASE)  vs  값의 범위비교(searched CASE)
DECLARE
    sGrade INTEGER := 90;
BEGIN
    CASE 
        WHEN sGrade >= 90 THEN DBMS_OUTPUT.PUT_LINE('A학점, 훌륭합니다!');        
        WHEN sGrade > 80 AND sGrade <90 THEN DBMS_OUTPUT.PUT_LINE('B학점, 노력하세요!');
        WHEN sGrade >70 AND sGrade <80 THEN DBMS_OUTPUT.PUT_LINE('C학점, 보통입니다~');
        ELSE
            DBMS_OUTPUT.PUT_LINE('분발하세요!');
    END CASE;        
END;

-- 2) 반복문
-- https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/plsql-control-statements.html#GUID-4CD12F11-2DB8-4B0D-9E04-DF983DCF9358
-- 2-1. Basic LOOP (=그냥 LOOP)  / a.k.a while 반복문(변수)
-- 2-2. FOR LOOP
-- 2-3. WHILE LOOP
/*
...
BEGIN
    LOOP
    반복 실행할 구문;
    END LOOP;
END;
...
*/
-- 무한루프 --> 버퍼 용량 초과로 자동으로 중단!
-- ORA-20000: ORU-10027: buffer overflow, limit of 20000 bytes

-- (basic) LOOP 형태
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('infinite LOOP');        
    END LOOP;
END;    

-- (2) 루프 빠져나가기 : EXIT
DECLARE
    x NUMBER := 0;
BEGIN
    LOOP
        x := x + 1;
        DBMS_OUTPUT.PUT_LINE('Basic LOOP : ' || x || ' times.');
        IF x > 10 THEN
            EXIT;
        END IF;
    END LOOP;
END;    

-- 구구단 출력 LOOP 예제
-- 2단 구구단 출력 :   2 x 1 = 2
--                   2 x 9 = 18

DECLARE
    nStart NUMBER;
    nResult NUMBER;
BEGIN
    nStart := 1;
    LOOP
        nResult := 2 * nStart;
        IF nStart > 9 THEN
            --DBMS_OUTPUT.PUT_LINE('----------중단 되었습니다---------');
            EXIT;
        END IF;
        DBMS_OUTPUT.PUT_LINE('2 x ' || nStart || ' = ' || nResult);
        nStart := nStart +1;
    END LOOP;
END;

-- FOR LOOP 형태
DECLARE
    i NUMBER := 1;
BEGIN
  FOR i IN 1..3 LOOP    
      DBMS_OUTPUT.PUT_LINE(i);    
  END LOOP;
END;

-- FOR LOOP로 구구단 출력
DECLARE
    nResult NUMBER;
    nStart NUMBER;
BEGIN

  FOR nStart IN 1..9 LOOP  -- .. : 시작값..마지막값 범위  
      nResult := 2 * nStart;        
      DBMS_OUTPUT.PUT_LINE('2 x ' || nStart || ' = ' || nResult);
  END LOOP;
END;


-- NESTED FOR : 중첩 FOR
-- https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/plsql-control-statements.html#GUID-7E1AC17C-83EB-422C-98F4-2F13D9B694F4


-- WHILE LOOP : 조건이 TRUE일때 한번 또는 여러번 구문을 실행하는 반복문
/*
  WHILE condition LOOP
    statements;  
  END LOOP;
*/

DECLARE
    done BOOLEAN := TRUE;
    nStart NUMBER;
    nResult NUMBER;
BEGIN
    nStart := 1;
    WHILE done LOOP
        IF (nStart <= 9) THEN
            nResult := 2 * nStart;
            DBMS_OUTPUT.PUT_LINE('2 x ' || nStart || ' = ' || nResult);
            nStart := nStart +1;
        ELSE
            --EXIT;
            done := FALSE;
        END IF;        
    END LOOP;
END;

-- CURSOR FOR LOOP : CURSOR + FOR LOOP statement
-- 1. CURSOR 선언
-- I. 명시적 커서 : 일반적으로 선언하고 사용하는 커서
-- II. 묵시적 커서 : PL/SQL 엔진 내부에서 사용하는 커서
-- 결과값을 가르키는 포인터와 같은 형태를 PL/SQL에서는 커서 라고 한다.
-- SQL에서 쿼리의 실행의 결과로 반환된 결과값(Result Set) 이라고 한다.
-- https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/cursor-variable-declaration.html

-- 1-1.커서의 선언(Creating Cursor Variables)
--  └TYPE type_name IS REF CURSOR [ RETURN return_type ]

-- 1-2.커서 열기, 닫기(Opening and Closing Cursor Variables)
--   OPEN()
--   CLOSE()
-- 1-3.데이터 패칭(Fetching Data with Cursor Variables)
/*
    LOOP
        FETCH 커서명 INTO 변수명
        EXIT WHEN emp_cur%NOTFOUND;
*/        

-- I. 명시적 커서
CURSOR 커서명 IS -- SELECT절을 수행한 결과를 가르키는 커서를 생성
SELECT 절;

OPEN 커서명;  -- 연결을 설정

FETCH 커서명 INTO 변수; -- 결과셋에서 데이터를(한개 또는 여러개) 조회 + LOOP (반복문)

CLOSE 커서명; -- 연결을 종료


-- 명시적 커서의 사용예시
DECLARE
    CURSOR emp_cursor IS
    SELECT employee_id
    FROM    employees
    WHERE   department_id = 100; -- 10~ 110번까지 사원들이 소속된 부서 (총 부서 27개)
    
    emp_id employees.employee_id%TYPE; -- employee_id는 NUMBER(6)으로 지정한것과 같음
    --emp_id NUMBER(6); -- employee_id는 NUMBER라고 안써도 %TYPE
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO emp_id;
        EXIT WHEN emp_cursor%NOTFOUND; -- Exception list는 레퍼런스 참고
            DBMS_OUTPUT.PUT_LINE('100번 부서원의 사번 : '||emp_id);
    END LOOP;
    CLOSE emp_cursor;
END;
-- 명시적 커서 식별 : TRUE, FALSE를 반환
-- %ISOPEN(연결되었는지), %FOUND(결과행 유), %NOTFOUND(결과행 무), %ROWCOUNT(결과행 유무)
--https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/implicit-cursor-attribute.html#GUID-5A938EE7-E8D2-468C-B60F-81898F110BE1
<<<<<<< HEAD



-- II. 묵시적 커서
-- 참조 : https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/static-sql.html#GUID-5C2BBA53-40E2-4BF4-9924-20845A9FB4B8
-- 따로 선언 없이 사용, 참조 예시에서는 프로시저명(파라미터)로 p(270)을 입력해서, 해당 부서코드가
-- 존재하는 dept_temp 테이블의 데이터를 삭제하는 예시


-- GOTO 문 : 라벨이 있는 블럭이나 구문으로 이동하는 분기명령
-- 참조 : https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/GOTO-statement.html
-- GOTO문은 FORTRAN, COBOL, BASIC 등의 언어에서 사용,..

-- NULL 문 : 값이 없다, 아무런 처리를 하지 않을때(IF ELSE~)
DECLARE

BEGIN
    NULL;
END;

-- ====================================================================================
-- III. 서브 프로그램 : Function, Procedure, Trigger, Package
-- ====================================================================================
-- 서브프로그램을 사용하는 이유 https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/plsql-subprograms.html#GUID-56B4253C-6113-4C97-A0D2-1488B6526076
-- PL/SQL block : Anonymous Block vs Named Block(=Subprograms)
-- Anonymous Block(=익명 블록) : 실행할때마다 코드작성하고, 반복해서 작업
--  컴파일과 동시에 코드 실행    vs   컴파일 따로, 실행 따로
-- 서브프로그램 : 저장해뒀다가 반복 재사용하기 위한 블럭(A PL/SQL subprogram is a named PL/SQL block that can be invoked repeatedly)

-- 1. 프로시저(=Procedure)
-- you use a procedure to perform an action : 단순히 어떠한 액션(=명령) 수행 / return 없음
-- 1-1. 프로시저 선언 : 데이터 타입의 자릿수는 생략 /
CREATE OR REPLACE PROCEDURE 프로시저명(파라미터명1 데이터타입1, 파라미터명2 데이터타입2,...) [AS]
IS
    변수 선언부...;
BEGIN
    명령 실행부;
EXCEPTION
    예외처리부;
END;
-- 1-2. 프로시저 호출 : 반환값이 없고 단순히 어떠한 실행을 위한 메소드라고 생각
EXEC 프로시저명(파라미터);
EXECUTE 프로시저명(파라미터);

-- 1-3. 신입사원 등록 처리용 프로시저 작성
-- 예)HR 스키마 : EMPLOYEES (사원정보) <-- 신입사원 입사했다..누군가? 신입사원에 대한 정보를 테이블에 등록
-- 매번 테이블 명세를 확인하고 컬럼의 데이터타입을 참조하며 레코드를 직접 입력하는 반복적인 작업이 이뤄짐
-- 30번 부서에 first_name, last_name 사원이 SYSDATE에 IT_PROG 직무를 수행하는 사원을 등록하는 프로시저
EXEC add_emp(first_name, last_name, SYSDATE, 'IT_PROG', 30); -- 만들려면 프로시저

SELECT *
FROM employees;
DESC employees; -- 테이블명에 커서를 두고, [SHIFT+F4]
-- employee_id : EMPLOYEES_SEQ.NEXTVAL
-- email : NOT NULL
-- hire_date : NOT NULL
-- job_id : NOT NULL
-- last_name : NOT NULL
-- department_id : FOREIGN KEY (10~270)
-- salary : CHECK (salary > 0);
SELECT EMPLOYEES_SEQ.NEXTVAL -- 다음 시퀀스 번호 체크
FROM dual; -- 211. 홍길동 데이터 삭제

DELETE FROM employees
WHERE employee_id = 210; -- 생략하지 않도록
-- exec add_emp(a,b,c,d);
CREATE OR REPLACE PROCEDURE add_emp 
    (
        f_name VARCHAR2, 
        l_name VARCHAR2,
        e_mail VARCHAR2,
        hire_d DATE,
        job_id VARCHAR2        
    )
IS

BEGIN
    -- 신입 사원의 정보를 EMPLOYEES 테이블에 입력하는 쿼리를 작성
    INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, hire_date, job_id)
    VALUES (EMPLOYEES_SEQ.NEXTVAL, f_name, l_name, e_mail, SYSDATE, 'IT_PROG');
    -- 트랜잭션 처리
    COMMIT;
    -- 예외처리 : 어떠한 예외가 발생하면, 입력작업 취소!
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK; 
END;

-- Procedure ADD_EMP이(가) 컴파일되었습니다. -- 프로시저가 컴파일되어 사용할 수 있는 상태
-- 샘플 데이터 : gildong, hong, TO_DATE('2022/10/02'), 'IT_PROG', 30
EXEC add_emp('gildong', 'hong','gildong1004', TO_DATE('2022/10/02'), 'IT_PROG');
EXEC add_emp('yeonghun', 'seon','seonyeonghun', SYSDATE, 'SA_MAN');
-- PL/SQL 프로시저가 성공적으로 완료되었습니다. -- 사원등록 프로시저(=a.k.a 메소드)가 정상 실행
-- 실제 데이터 조회
SELECT *
FROM employees
WHERE email='gildong1004';
SELECT *
FROM employees
WHERE last_name='seon';

-- Quiz. 사원등록 프로시저는 add_emp, 퇴사자 발생시 EMPLOYEES의 사원 정보를 삭제하는
-- 프로시저를 만들어 보세요!
-- employee_id : PK (식별자 / 중복 , NOT NULL)
-- 예) EXECUTE del_emp (target_emp_id, dept_id);

CREATE OR REPLACE PROCEDURE del_emp
    (
        target_emp_id NUMBER
    )
IS
    -- 퇴사자의 수를 집계하기 위한 변수  vs 별도의 테이블(LEAVE_EMP)
    del_count NUMBER := 0;
BEGIN
    -- 자식 래코드 삭제 : JOB_HISTORY (EMPLOYEES 테이블에 데이터 등록시 자동등록되는 테이블)
    DELETE FROM JOB_HISTORY
    WHERE employee_id = target_emp_id;
    
    -- 부모 래코드 삭제 : EMPLOYEES
    DELETE FROM EMPLOYEES
    WHERE employee_id = target_emp_id;    
    COMMIT;
    del_count := del_count + 1;    
        
    DBMS_OUTPUT.PUT_LINE('총 퇴사자 수 : ' || del_count);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('알수없는 예외 발생, 관리자 확인 바람!!');
        ROLLBACK;
END;

EXECUTE del_emp(212);
EXEC del_emp(213);
EXEC del_emp(214);
-- Quiz. 신입사원의 데이터(=레코드, 로우) 중에 NULL 이 있는데, 이것을 업데이트 하는 프로시저를
-- 작성해보기
-- ex> 신입사원 등록 : 김철수 
EXEC add_emp('cheolsu', 'kim', 'cheolsu2004', SYSDATE, 'ST_CLERK');
SELECT *
FROM employees
WHERE last_name='kim';
-- ex> 신입사원 전화번호, 급여, 상여율, 매니저코드, 부서코드  등을 업데이트 하려는 프로시저를 작성
-- 50번 부서에 ST_CLERK 직무를 수행하는 김철수 라는 사람이 입사한 뒤 부서배치를 받고 급여와 매니저등이 배정되었다를
-- 프로시저로 작성해보세요, 그리고 결과를 확인해봅시다.

-- 해당 부서 확인
SELECT *
FROM departments; -- 50번 부서 : 배송(shipping)

-- 직무가 무엇인지 확인
SELECT job_id   -- ST_CLERK : 직무(배송사원?), SH_STOCK도 있음
FROM employees
WHERE department_id = 50;

-- 부서의 매니저 : 부서장?
SELECT manager_id    -- 121번 사원이 MANAGER
FROM departments
WHERE department_id =: dep_id; -- 바인드 변수 : 컴파일 하고 쿼리를 수행할때 변수값을 동적할당!

-- 커미션 율 :
SELECT commission_pct    -- NULL! (사람이 자주 바뀌거나~ 고급 인력이 아니거나..부서가 힘이 없다)
FROM employees
WHERE department_id = 50;

-- 직무에 따른 급여 상,하한선 조회
SELECT *   -- 배송사원의 Salary 범위 조회 :  2500 ~ 5000;
FROM JOBS; 

-- 사원정보 업데이트(=사원의 부서배치, 급여, 보너스~) 프로시저
CREATE OR REPLACE PROCEDURE emp_set
    (
        target_emp_id NUMBER, -- 대상 사원번호
        target_dept_id NUMBER, -- 대상 부서번호 : 배정된 부서번호
        target_phone VARCHAR2, -- 대상 연락처
        target_salary NUMBER -- 대상 급여 : 커미션x, 2500 ~ 5000 확인
    )
IS
    -- 업데이트 하려는 사원의 부서장의 사번을 담는 변수
    target_emp_manager_id NUMBER;
BEGIN
    -- 데이터를 조회 (매니저, 급여상하한선, 커미션)
    SELECT manager_id    -- 121번 사원이 MANAGER
    INTO target_emp_manager_id -- 조회된 결과값을 대상 사원의 매니저 번호 변수에 저장
    FROM departments
    WHERE department_id = target_dept_id; -- 샘플로 50번 부서, 즉 매니저는 121번 사원
    
    -- 데이터를 업데이트 하는 DML
    UPDATE EMPLOYEES
    SET phone_number = target_phone,
        department_id = target_dept_id,
        salary = target_salary,
        manager_id = target_emp_manager_id
    WHERE employee_id = target_emp_id;    
    COMMIT;
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('예외발생, 담당자 확인이 필요합니다!');
    ROLLBACK;
END;

-- 대상사원 레코드 조회
SELECT *
FROM employees
ORDER BY employee_id DESC;
WHERE last_name='kim';

-- 사번 214를 50번 부서로 배치
EXEC emp_set(214, 50, '062.362.7797', 3000); 

-- 사원 삭제(=퇴사)시 레코드가 실제 반영 안되는 오류 발생
-- ORA-02292: 무결성 제약조건(HR.JHIST_EMP_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다
-- 원인 : HR 스키마는 샘플스키마, 테이블 생성시 ON DELETE CASCADE; (참조하는 키값의 래코드도 모두 찾아서 삭제하는 옵션)
-- 없어서, 직접 해당 레코드(=자식 레코드) 지우고 사원 데이터를 삭제해야 함.

EXEC del_emp(214); -- 실제 데이터에 반영
DELETE employees
WHERE employee_id = 214;

-- 조치 1. HR.JHIST_EMP_FK를 어디서 정의하는지 먼저 확인
select
    constraint_name,
    table_name,
    r_constraint_name
from
    user_constraints
where
    constraint_name = 'JHIST_EMP_FK'; 
-- JOB_HISTORY 테이블에서 EMPLOYEES 테이블의 employee_id를 FK로 지정

SELECT *
FROM JOB_HISTORY; 
-- 원인 : EMPLOYEES 테이블에 레코드 추가시 자동으로 실행되는 트리거가 있어서, 이것이
-- JOB_HISTORY 테이블에 자동으로 업데이트 하는 프로시저(ADD_JOB_HISTORY)가 실행됨으로
-- 결과적으로 오류를 발생하게 됨.

-- 최종 조치 : JOB_HISTORY 에서 214번 사원을 삭제
DELETE JOB_HISTORY
WHERE employee_id = 214;

EXEC del_emp(214); -- 다시, 우리가 만든 프로시저로 EMPLOYEES 테이블의 사원 정보를 삭제!
SELECT *
FROM employees
WHERE employee_id = 214;

-- 그럼 다시 del_emp 프로시저를 수정해서 한번에 문제 없도록! (수정하고)
-- (수정해서) 컴파일 하고 
-- 다시 추가 --> 삭제 테스트
EXEC add_emp('yeonghun', 'seon', 'seonyeonghun', SYSDATE, 'IT_PROG');
SELECT *
FROM employees
WHERE last_name='seon'; --217
EXEC del_emp(215);

-- 
DELETE JOB_HISTORY
WHERE employee_id = 215;

-- 재고관리
-- 입고, 출고를 합쳐서 재고 라고 하자
CREATE TABLE jaegoTBL (
    jaego_item_id NUMBER,
    jaego_item_name VARCHAR2(50) NOT NULL,
    jaego_item_qty NUMBER DEFAULT 1,
    jaego_item_price NUMBER(8, 2) NOT NULL,
    jaego_manager VARCHAR2(20),
    CONSTRAINT ipgo_item_id_fk FOREIGN KEY (jaego_item_id) REFERENCES ipgoTBL (ipgo_item_id)
);

CREATE TABLE ipgoTBL (
    ipgo_item_id NUMBER,
    ipgo_item_name VARCHAR2(50) NOT NULL,
    ipgo_item_qty NUMBER DEFAULT 1,
    ipgo_item_price NUMBER(8, 2) NOT NULL,
    CONSTRAINT ipgo_item_id_pk PRIMARY KEY(ipgo_item_id)
);

EXEC add_item('엄마손 도시락',10,5500);
-- item_id용 시퀀스
CREATE SEQUENCE ipgo_item_seq; -- 기본 시퀀스 1로 시작하게 됨

SELECT ipgo_item_seq.NEXTVAL -- 시퀀스 값 조회
FROM dual;

CREATE OR REPLACE PROCEDURE add_item
    (
--        ipgo_item_id NUMBER,  
        item_name VARCHAR2, -- 바이트 수는 적지 않음 : PLS-00103 심볼 (를 만났습니다 오류!
        item_qty NUMBER,
        item_price NUMBER
    )
IS
    --ipgo_staff VARCHAR2 := '홍길동'
BEGIN
    INSERT INTO ipgoTBL
    VALUES (ipgo_item_seq.NEXTVAL, item_name,item_qty,item_price);
    COMMIT;
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception Occured!');
        ROLLBACK;
END;
-- * 입고관리 프로시저 *
-- 상품 등록 프로시저
EXEC add_item('엄마손 도시락',10,5500);
EXEC add_item('생과일 100% 쥬스',50,2500);
EXEC add_item('아빠손 파이',20,3000);
EXEC add_item('해물파스타맛 라면',10,4500);

select *
from ipgoTBL;

-- 상품 업데이트 프로시저


-- 상품 삭제 프로시저 
CREATE OR REPLACE PROCEDURE drop_item(target_item_id NUMBER) IS
    remain_item_qty NUMBER;
BEGIN
    -- 조회 : 상품의 갯수
    IF 조건 THEN
        처리
    END IF;
    -- 삭제 : 상품의 갯수가 0이면
    DELETE FROM ipgoTBL
    WHERE ipgo_item_id = target_item_id;    
    COMMIT;
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception Occured!');
        ROLLBACK;
END;



-- 결과적으로 <---> 판매시 상품 삭제(=모든 상품 완판), 판매시 집계(상품갯수 업데이트) 트리거


DROP TABLE ipgoTBL;
=======
>>>>>>> 08d7393815d6b1487896ff9a439d3d4971031b52



-- II. 묵시적 커서
-- 참조 : https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/static-sql.html#GUID-5C2BBA53-40E2-4BF4-9924-20845A9FB4B8
-- 따로 선언 없이 사용, 참조 예시에서는 프로시저명(파라미터)로 p(270)을 입력해서, 해당 부서코드가
-- 존재하는 dept_temp 테이블의 데이터를 삭제하는 예시


-- GOTO 문 : 라벨이 있는 블럭이나 구문으로 이동하는 분기명령
-- 참조 : https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/GOTO-statement.html
-- GOTO문은 FORTRAN, COBOL, BASIC 등의 언어에서 사용,..

-- NULL 문 : 값이 없다, 아무런 처리를 하지 않을때(IF ELSE~)
DECLARE

BEGIN
    NULL;
END;

-- ====================================================================================
-- III. 서브 프로그램
-- ====================================================================================
-- 서브프로그램을 사용하는 이유 https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/plsql-subprograms.html#GUID-56B4253C-6113-4C97-A0D2-1488B6526076
-- PL/SQL block : Anonymous Block vs Named Block(=Subprograms)
-- Anonymous Block(=익명 블록) : 실행할때마다 코드작성하고, 반복해서 작업
-- 서브프로그램 : 저장해뒀다가 반복 재사용하기 위한 블럭(A PL/SQL subprogram is a named PL/SQL block that can be invoked repeatedly)

-- 1. 프로시저(=Procedure)
-- you use a procedure to perform an action : 단순히 어떠한 액션(=명령) 수행 / return 없음

<<<<<<< HEAD

-- 2. 함수(=Function)
-- a function to compute and return a value. : 명령 수행 후 결과값을 반환 / return 있음
-- ※ 프로시저 vs 함수 : 반환값 없음 vs 반환값 있음 (return value)

-- 3. 트리거(=Trigger)
-- 자동으로 실행되는 프로시져 (이벤트 감지 : INSERT, UPDATE, DELETE 작업)
-- 트리거는 생성과 동시에 실행

-- 4. 패키지(=Package)
-- PL/SQL 구성요소들 (변수, 상수, 표현식, 커서, 함수, 프로시저 등등)의 묶음

/* 프로시저의 또는 함수의 파츠(=문법) */
--Declarative Part [옵션] : 선언부
--Excutable Part [필수] : 실행부
--Exception-handling Part [옵션] : 에러처리부





/* 레퍼런스 샘플
=======
-- 2. 함수(=Function)
-- a function to compute and return a value. : 명령 수행 후 결과값을 반환 / return 있음

-- ※ 프로시저 vs 함수 : 반환값 없음 vs 반환값 있음 (return value)

/* 프로시저의 또는 함수의 파츠(=문법) */
--Declarative Part [옵션]
--Excutable Part [필수]
--Exception-handling Part [옵션]

>>>>>>> 08d7393815d6b1487896ff9a439d3d4971031b52
DECLARE
  first_name employees.first_name%TYPE;
  last_name  employees.last_name%TYPE;
  email      employees.email%TYPE;
  employer   VARCHAR2(8) := 'AcmeCorp';
 
  -- Declare and define procedure
 
  PROCEDURE create_email (  -- Subprogram heading begins
    name1   VARCHAR2,
    name2   VARCHAR2,
    company VARCHAR2
  )                         -- Subprogram heading ends
  IS
                            -- Declarative part begins
    error_message VARCHAR2(30) := 'Email address is too long.';
  BEGIN                     -- Executable part begins
    email := name1 || '.' || name2 || '@' || company;
  EXCEPTION                      -- Exception-handling part begins
    WHEN VALUE_ERROR THEN
      DBMS_OUTPUT.PUT_LINE(error_message);
  END create_email;
 
BEGIN
  first_name := 'John';
  last_name  := 'Doe';
 
  create_email(first_name, last_name, employer);  -- invocation
  DBMS_OUTPUT.PUT_LINE ('With first name first, email is: ' || email);
 
  create_email(last_name, first_name, employer);  -- invocation
  DBMS_OUTPUT.PUT_LINE ('With last name first, email is: ' || email);
 
  first_name := 'Elizabeth';
  last_name  := 'MacDonald';
  create_email(first_name, last_name, employer);  -- invocation
END;

-- 프로시저 실행
<<<<<<< HEAD
 exec create_email('yeonghun', 'seon', 'HANUL');
 excute create_email('yeonghun', 'seon', 'HANUL');
*/ 
 
 
=======
-- exec create_email('yeonghun', 'seon', 'HANUL');
>>>>>>> 08d7393815d6b1487896ff9a439d3d4971031b52
