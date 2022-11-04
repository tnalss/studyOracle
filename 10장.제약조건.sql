10장. 제약조건(p.79)

무결성 제약조건(Integrity Constraints)은 데이터의 정확성을 보장하기 위해 두는
제약조건 이다.

NOT NULL, CHECK, UNIQUE, PRIMARY KEY, FOREIGN KEY, DEFAULT의 6가지가 있다.
* 제약조건은 테이블 생성시에 정의할 수 있고, 테이블 생성 후에 추가할 수 있다.
--CREATE TABLE 테이블명 (
--    컬럼명 데이터유형 제약조건~
--)
--
--ALTER TABLE 테이블명
--MODIFY 컬럼명 데이터유형 제약조건~

10-1. NOT NULL 제약조건
* NULL 을 허용하지 않는 제약조건 <==> NULL 입력 시도시 에러발생!
* NOT NULL 로 지정된 컬럼은 반드시 데이터를 입력해야 한다.
* 테이블 생성시 컬럼 레벨에서 정의한다.
* 테이블 생성 후 정의한다.

[예제10-1] null_test 테이블을 생성하고 col에 NOT NULL 제약조건을 설정하시오
-- 컬럼 레벨에서 정의
CREATE TABLE null_test (
    col1 VARCHAR2(5) NOT NULL,
    col2 VARCHAR2(5) 
);

DESC null_test;

--이름   널?       유형          
------ -------- ----------- 
--COL1 NOT NULL VARCHAR2(5) 
--COL2          VARCHAR2(5)

[예제10-2] null_test 테이블에 다음 데이터를 삽입하시오
INSERT INTO null_test (col1) -- NOT NULL
VALUES ('AA');

SELECT *
FROM null_test;

--COL1  COL2 
------- -----
--AA    (NULL)

INSERT INTO null_test (col2)
VALUES ('BB');

--오류 보고 - 
--ORA-01400: NULL을 ("HANUL"."NULL_TEST"."COL1") 안에 삽입할 수 없습니다
-- col1이 NOT NULL 이므로, NULL 을 입력할때 제약조건에 따른 오류 발생

INSERT INTO null_test
VALUES ('BB','CC');

INSERT INTO null_test (col1, col2)
VALUES ('CC', NULL);

-- 테이블 생성 후 정의
* ALTER TABLE 명령을 사용한다!
* ADD, MODIFY, DROP COLUMN, RENAME COLUMN 이전컬럼명 TO 이후컬럼명

[예제10-4] null_test 테이블 생성 후 col2를 NOT NULL 제약조건을 지정하시오
ALTER TABLE null_test
MODIFY col2 NOT NULL; -- col2를 'BB'로 업데이트한 후 재실행

-- UPDATE 전이라서 col2에 NULL 이 있는 상태(3개 rows)
--ORA-02296: (HANUL.) 사용으로 설정 불가 - 널 값이 발견되었습니다.
--02296. 00000 - "cannot enable (%s.%s) - null values found"
-- col2의 NULL값을 모두 BB로 바꾼 뒤 재실행
UPDATE null_test
SET col2='BB';
--WHERE 생략

SELECT *
FROM null_test;

-- 널 값을 col2에 넣어보자~
INSERT INTO null_test
VALUES ('DD', ' '); -- NULL 또는 ''는 허용하지 않음 <--> NOT NULL

DESC null_test;

10-2. CHECK
CHECK는 조건에 맞는 데이터만 저장할 수 있도록 하는 제약조건
ex> 회원테이블의 AGE 컬럼 : 1살? <-- ? 
* 도메인 : 입력하는 값의 유효한 범위 정의
* 테이블 생성시 컬럼레벨에서 정의
* 테이블 레벨에서 정의

-- I.테이블 생성시 컬럼레벨에서 정의 (또는 테이블레벨 에서 정의)
CREATE TABLE check_test (
    name VARCHAR2(30) NOT NULL,
    gender VARCHAR2(10) NOT NULL CHECK (gender IN ('남성', '여성')), --컬럼 레벨
    salary NUMBER(8),
    dept_id NUMBER(4),
    CONSTRAINT check_salary_ck CHECK (salary > 2000) -- 테이블 레벨    
);

[예제10-7] check_test 테이블에 다음 데이터를 삽입하시오
INSERT INTO check_test (name, gender, salary, dept_id)
VALUES ('홍길동', '남성', 3000, 10); -- 정상적으로 입력

INSERT INTO check_test (name, gender, salary, dept_id)
VALUES ('최길동', '남자', 3000, 20); -- 성별 제약조건 위배

INSERT INTO check_test (name, gender, salary, dept_id)
VALUES ('박길동', '남성', 1000, 30); -- 급여 제약조건 위배

INSERT INTO check_test (name, gender, salary, dept_id)
VALUES ('이길동', '남자', 1000, 30);

[예제10-9] check_test 테이블에서 이름이 홍길동인 사람의 급여를 2000으로 업데이트 하시오
SELECT *
FROM check_test;

UPDATE check_test
SET salary=2000
WHERE name='홍길동';
-- ORA-02290: 체크 제약조건(HANUL.CHECK_SALARY_CK)이 위배되었습니다

UPDATE check_test
SET gender='남자'
WHERE name='홍길동';
--ORA-02290: 체크 제약조건(HANUL.SYS_C008363)이 위배되었습니다


-- II. 테이블 생성 후 CHECK 지정
USER_CONSTRAINTS 에서 지정되어있는 constraint(제약조건)을 확인할 수 있다.

SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'CHECK_TEST';

[예제10-10] 기존 CHECK 제약조건을 먼저 삭제후에, 다시 추가해보시오
ALTER TABLE check_test
DROP CONSTRAINT check_salary_ck; 

[예제10-11] 다시 salary 컬럼의 check_salary_dept_ck 라는 이름의 CHECK 제약조건을
정의하시오
ALTER TABLE check_test
ADD CONSTRAINT check_salary_dept_ck CHECK (salary BETWEEN 2000 AND 10000 AND DEPT_ID IN (10,20,30));

INSERT INTO check_test (name, gender, salary, dept_id)
VALUES ('이길동', '남성', 3000, 50);

[예제10-12] 기존의 데이터에서 salary를 12000으로 변경 시도하시오
UPDATE check_test
SET salary=12000;

UPDATE check_test
SET dept_id=50;

UPDATE check_test
SET dept_id=30

10-3. UNIQUE
UNIQUE 제약조건은 데이터가 중복되지 않도록 유일성을 보장하는 제약 조건으로 NULL을 허용한다.
* 컬럼 레벨, 테이블 레벨에서 정의하고 [복합키]를 생성할 수 있다.
* UNIQUE + NOT NULL <==> PRIMARY KEY  : 유일하게 식별할 수 있는 키(중복x, NULL허용x(
-- I. 테이블 생성시 제약조건 설정 : 컬럼레벨, 테이블 레벨에서 정의
[예제10-13] unique_test 라는 테이블을 생성하고 unique 제약조건을 정의하시오
CREATE TABLE unique_test (
    id VARCHAR2(5) UNIQUE NOT NULL, -- 컬럼 레벨에서 정의
    code VARCHAR2(5),
    city VARCHAR2(5) NOT NULL,  -- 컬럼 레벨
    born VARCHAR2(5),
    CONSTRAINT unique_code_uk UNIQUE(code), -- 테이블 레벨, 유니크 제약조건 정의
    CONSTRAINT unique_born_uk UNIQUE (code, born) -- 테이블 레벨, 복합키 정의
);

[예제10-14] 다음의 데이터를 입력하시오
INSERT INTO unique_test
VALUES ('A1', 'B1', 'C1' ,'D1');

SELECT *
FROM unique_test;

INSERT INTO unique_test
VALUES ('A1', NULL, 'C1' ,'D1');

-- ORA-00001: 무결성 제약 조건(HANUL.SYS_C008369)에 위배됩니다
-- 제약조건을 먼저 확인
SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'UNIQUE_TEST';

INSERT INTO unique_test
VALUES ('A2', NULL, 'C1' ,'D1'); -- born 컬럼의 'D1'은 복합키

INSERT INTO unique_test
VALUES ('A3', 'B2', 'C2' ,'D1'); -- born 컬럼의 'D1'은 복합키


-- II.테이블 생성 후 UNIQUE 제약조건 지정

-- 컬럼 레벨에서 정의한 제약조건을 삭제
ALTER TABLE unique_test
DROP CONSTRAINT unique_code_uk;

ALTER TABLE unique_test
DROP CONSTRAINT unique_born_uk;


-- 테이블 생성 후 unique 제약조건 추가
ALTER TABLE unique_test
ADD CONSTRAINT unique_code_born_uk UNIQUE (code, born);

10-4. PRIMARY KEY
데이터의 행을 대표하도록(=식별,구분)하도록 하는 유일한 값/NOT NULL의 제약조건
* UNIQUE + NOT NULL <===> PRIMARY KEY
* 기본키, 주키, 식별자, PK라고 함
* 테이블 생성시 컬럼 레벨, 테이블 레벨에서 정의
* [복합키]를 생성할 수 있다.

-- I. 테이블 생성시 컬럼레벨, 테이블레벨 에서 정의
--DROP TABLE dept_test;
CREATE TABLE dept_test (
    DEPT_ID NUMBER(4) PRIMARY KEY, --컬럼 레벨
    DEPT_NAME VARCHAR2(20)
    --CONSTRAINT dept_test_id_pk PRIMARY KEY(DEPT_ID) --테이블 레벨
);

SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'DEPT_TEST';

[예제10-22] 데이터를 입력해 PK를 확인하시오

SELECT *
FROM dept_test;

INSERT INTO dept_test
VALUES (1000,'영업부'); -- 최초 삽입 ok

INSERT INTO dept_test
VALUES (1000,'개발부');  -- PK 위반

-- ORA-00001: 무결성 제약 조건(HANUL.DEPT_TEST_ID_PK)에 위배됩니다

INSERT INTO dept_test
VALUES (2000,'개발부');  

INSERT INTO dept_test
VALUES (3000,'개발부'); 

INSERT INTO dept_test
VALUES (2000,'마케팅부');

-- II. 테이블 생성 후 정의/지정

-- 테이블 생성시 정의된 제약조건을 삭제
ALTER TABLE dept_test
DROP CONSTRAINT SYS_C008376;

-- 테이블 생성시 정의된 제약조건을 다시 추가
ALTER TABLE dept_test
ADD CONSTRAINT dept_test_id_pk PRIMARY KEY(dept_id);

-- 기존에 있던 데이터 행을 변경 시도
UPDATE dept_test
SET dept_id = 2000
WHERE dept_name = '영업부';

-- ORA-00001: 무결성 제약 조건(HANUL.DEPT_TEST_ID_PK)에 위배됩니다

10-5. FOREIGN KEY (p.85)
-- 관계
부모 테이블의 컬럼을 참조하는 자식 테이블의 컬럼에 데이터의 무결성을 보장하기 위해
지정하는 제약조건으로, NULL을 허용한다.

* 참조키, 외래키, FK 라고 한다.
* 컬럼레벨, 테이블레벨 에서 정의하고 [복합키]를 생성할 수 있다.

-- I. 테이블 생성시 FK 정의
--- 컬럼 레벨에서1 : REFERENCES 부모테이블 (참조되는 컬럼)
--- 컬럼 레벨에서2 : CONSTRAINT 제약조건명 REFERENCES 부모테이블 (참조되는 컬럼)
--- 테이블 레벨에서 : CONSTRAINT 제약조건명 FOREIGN KEY (참조하는 컬럼) REFERENCES 부모테이블 (참조되는 컬럼)
[예제10-26] 
-- 테이블 레벨에서 정의
CREATE TABLE emp_test (
    emp_id NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(30) NOT NULL,
    dept_id NUMBER(4),
    job_id VARCHAR2(10),
    CONSTRAINT emp_test_dept_test_fk FOREIGN KEY (dept_id) REFERENCES departments (department_id)
);

SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'EMP_TEST';

COMMIT;

[예제10-27]
-- departments의 department_id : 10 ~ 110 / 부서원이 있는 부서의 코드
--                               120 ~ 270 / 부서원, 매니저사원 없음
INSERT INTO emp_test
VALUES (100, 'King', 10, 'ST_MAN'); -- JOBS 테이블 참조

INSERT INTO emp_test
VALUES (101, 'Kong', 300, 'AC_MGR'); -- JOBS 테이블 참조

INSERT INTO emp_test
VALUES (102, 'Gozilla', 270, 'ST_CLERK');

INSERT INTO emp_test
VALUES (103, 'alien', 280, 'ST_MAN');

-- ORA-02291: 무결성 제약조건(HR.EMP_TEST_DEPT_TEST_FK)이 위배되었습니다- 부모 키가 없습니다
SELECT *
FROM departments;

-- II. 테이블 생성 후 지정
-- 1.테이블 생성시 추가한 FK 제약조건 삭제
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE table_name='EMP_TEST';

ALTER TABLE emp_test
DROP CONSTRAINT EMP_TEST_DEPT_TEST_FK;

-- 제약조건 삭제 후 데이터 삽입
INSERT INTO emp_test
VALUES (103, 'alien', 280, 'ST_MAN');

SELECT *
FROM emp_test;

-- 2.테이블 생성후 제약조건 지정
-- 103	alien	280	ST_MAN  : 280 <-- 10~270 범위가 아니므로 제약조건을 추가할 경우 예외
ALTER TABLE emp_test
ADD CONSTRAINTS emp_test_dept_id_fk FOREIGN KEY (dept_id) REFERENCES departments (department_id); 

-- 제약조건 추가시 발생할 수 있는 오류
--ORA-02298: 제약 (HR.EMP_TEST_DEPT_ID_FK)을 사용 가능하게 할 수 없음 - 부모 키가 없습니다
--02298. 00000 - "cannot validate (%s.%s) - parent keys not found"
-- 1) 오타 가능성 (컬럼명)    2) 이미 입력된 테이블의 데이터중 FK 지정하려는 컬럼의 도메인 체크

--2) 이미 입력된 테이블의 데이터중 FK 지정하려는 컬럼의 도메인 체크
UPDATE emp_test
SET dept_id=200
WHERE emp_id=103;

-- 제약조건 추가후 다시 확인
INSERT INTO emp_test
VALUES (104, 'alien', 280, 'ST_MAN');

--오류 보고 -
--ORA-02291: 무결성 제약조건(HR.EMP_TEST_DEPT_ID_FK)이 위배되었습니다- 부모 키가 없습니다


10-6. DEFAULT

DEFAULT는 컬럼 단위로 지정되는 속성으로 데이터를 입력하지 않아도 지정된 값이 기본으로 입력되게 한다.

ex> 회원가입 --> 가입일 : 기본으로 가입일이 입력되게 처리~
    광고,마케팅 정보제공 동의 --> [선택] 기본으로 체크되게~

DEFAULT는 제약조건은 아니며, 컬럼의 데이터 타입 *바로 옆에* 지정한다.
* 컬럼 레벨에서 정의
* 테이블 레벨에서 정의 ??


[예제10-30] default_test 라는 테이블을 생성하고 name, hire_date, salary 컬럼을 각각
가변문자 10바이트, 시간날짜, 숫자 8자 타입으로 정의하고 hire_date 컬럼은 오늘 날짜를 기본으로
입력되게 하시오~

-- I. 테이블 생성시
CREATE TABLE default_test (
    name VARCHAR2(10) NOT NULL, 
--    hire_date DATE NOT NULL DEFAULT SYSDATE,     -- 순서주의, 에러발생
    hire_date DATE DEFAULT SYSDATE NOT NULL, 
    salary NUMBER(8) CHECK (salary > 2500)
);

-- 데이터 입력
INSERT INTO default_test
VALUES ('홍길동', TO_DATE('2022-10-27','YYYY-MM-DD'), 2600);

INSERT INTO default_test (name, salary)
VALUES ('홍길동', 2600);

SELECT *
FROM default_test;

-- DEFAULT 제거?
--ALTER TABLE default_test
--DROP CONSTRAINT ????


SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE table_name='DEFAULT_TEST';

SELECT *
FROM ALL_CONSTRAINTS; -- 시스템 테이블의 이름앞에 ALL_, DBA_, USER_를 붙여보자!
--                       얼마나 많은 제약조건이 있는지 (시간이 남으신 분들은) 확인!                












