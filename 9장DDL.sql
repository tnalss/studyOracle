9장. DDL (p.75)
------SQL 구분----
--DQL : SELECT 를 여기에 분류하기도 함.
--DML : SELECT, INSERT, UPDATE, DELETE
--DDL : CREATE, ALTER, DROP, TRUNCATE
--DCL : GRANT, REVOKE

9-1. 데이터 타입
9-1-1. 문자형 데이터 타입
문자형 데이터 타입은 CHARACTER에서 나온 약자로, CHAR(차~ vs 캐릭터~)
기본 : BYTE 설정 (도구 - 환경설정 - 데이터베이스 - NLS : National Language Support)
ex> 영문 1개문자 ==> 1Byte 처리, 한국어/중국어/일본어..나라별(National) 문자 길이 ==> 2~3Byte

CHAR(n) : Byte Size, 크기(Byte) - 고정문자열
CHAR(n char) : 문자열의 갯수
※ 영문일때는 1자 1Byte 이므로 차이가 없으나, 한글/일본어/중국어..등등 단어가 짤릴수 있고
용량이 남는 (공간 크고, 데이터 적게 들어가면...)
ex> 회원정보중 남성([M]ale), 여성([F]emale)
CREATE TABLE MEMBER(
    ...
    gender1 CHAR(1 char)   [M][a][l][e][null] -- byte  M or F
    gender2 CHAR(5 char) -- 문자갯수
    ...
)

LENGTH() : 문자열의 길이값을 숫자로 반환
LENGTHB() : 문자열의 바이트 수를 반환

SELECT LENGTH('가나다') LEN1, --count
        LENGTHB('가나다') LEN2 --Byte
FROM    dual;        


* VARCHAR2(n) : 가변 문자열(byte) <---> VARCHAR : 가급적 사용하지 않도록! (ORACLE에서~)
VARCHAR2(n char) :   "   (문자열갯수)
--데이터가 길이가 각기 다를경우      ORACLE에서 나중에 다른 용도로 사용할 예정

--name
---------------------
--Steven Jobs
--Michael Jordan
--Tom Cruise

* NCHAR(n), NVARCHAR2(n) : National 즉, 나라별 언어에 따른 고정문자/가변문자열
-- 그냥 오라클에서는 문자열은 : CHAR, VARCHAR2 만 기억...!
-- CHAR 타입으로 설계, 데이터가 byte보다 적게 들어오는 경우 --> 나머지 공간은 잉여?
-- VARCHAR 타입으로 설계, byte보다 적게 들어오는 경우 --> 나머지 공간은 잉여! + 구분기호~


9-1-2. 숫자형 데이터 
NUMBER : 길이 제한 x
NUMBER(n) : 길이 제한 o | 정수형 숫자
NUMBER(p, s) : 전체 숫자 길이 p, 소숫점 이하의 숫자 길이 s, 정수 길이는 p - s
NUMBER(-n) : 정수부에서 n을 반올림해서 정수로만 표시 <-- ROUND(n, i) 참고!
ex> AVG_SAL NUMBER(7, 2) <--- 12345.67


9-1-3. 날짜형 데이터
DATE : 날짜/시간 데이터
TIMEZONE :    "      + 밀리세컨즈(ms)


9-1-4. 그밖의 데이터 타입
LONG
LOB    : 단일 데이터 용량이 2GB~4GB 정도 되는 텍스트 데이터를 담는 타입
CLOB
-- 흔히 사용하진 않는...

-- 개발자 : DML, DDL 위주로~ CHAR,VARCHAR2,DATE,NUMBER 등만~!

9.2 DDL - CREATE

9-2-1. 테이블 생성 문법
* 테이블명 및 컬럼명 명명 규칙
1) 반드시 문자로 시작한다.
2) 숫자를 함께 사용할수 있다.
3) 최대 30바이트 까지 가능하다. (oracle 11g 기준. 2008년 기준)
4) 오라클 예약어를 사용할 수 없다. 단, 사용하려면 "예약어" 형식으로 작성
   생성시 "예약어" 사용했다면, 나머지 작업에도 "테이블명(예약어)"
-- 예약어 테이블, 뷰 존재 ==> RESERVED_WORDS
SELECT *
FROM v$reserved_words;
-- VERSION이라는 예약어로 테이블을 생성!
-- VERSION_ID..
-- VERSION_CODENAME ...
-- VERSION_DETAILS ..
DROP TABLE VERSION;
CREATE TABLE VERSION (
    VERSION NUMBER(3) NOT NULL,
    VERSION_CODENAME VARCHAR2(30),
    VERSION_DETAILS VARCHAR2(50)
);



I. DDL 사용해서 테이블 생성하는 구문
CREATE TABLE 테이블명(
    컬럼명1 데이터타입1,
    컬럼명2 데이터타입2,...    
);
-- AUTO COMMIT으로 자동으로 물리적으로 저장!


II. 접속 윈도우(=창)에서 계정명(=스키마) > 테이블에서 ,마우스 우클릭 - 새 테이블
테이블명,
컬럼명, 데이터타입, 기본값 설정..확인!


CREATE TABLE tmp (
    ID NUMBER(3),
    FNAME VARCHAR2(20),
    LNAME CHAR(20)
);

DESC tmp;

INSERT INTO tmp
VALUES (100, '길동', '홍');
INSERT INTO tmp
VALUES (200, '길동', '최');
INSERT INTO tmp
VALUES (300, '길동', '김');
INSERT INTO tmp
VALUES (500, 'Steven', 'Jobs');

--SELECT  LENGTHB(ID) LEN1,
--        LENGTHB(FNAME) LEN2,
--        LENGTHB(LNAME) LEN3
--FROM tmp;

[예제9-3] TMP 테이블에서 ID가 100번에 해당하는 사원의 FNAME을 '명보', LNAME을 '홍'
으로 변경하시오
SELECT *
FROM TMP;

UPDATE TMP
SET FNAME='명보',
    LNAME='홍'
WHERE ID=100;   

COMMIT;

9-2-2. CTAS
* CTAS
[C]REATE [T]ABLE 테이블명 [A]S
[S]ELECT 절;

* 키워드 AS 와 서브쿼리를 사용하여 이미 있는 테이블(HR.테이블)을 참조하여
복사하는 형태로 테이블을 생성할 수 있다.
-- AS  : ~처럼 [같이], ~로서, ~만큼 ~한...[사전적인 뜻]


[예제9-4] HR계정의 부서테이블 데이터를 복사하여, dept1 테이블을 생성하시오
CREATE TABLE dept1 AS
SELECT *
FROM    hr.employees;

DESC dept1;
SELECT * 
FROM    dept1;

[예제9-5] 사원 테이블의 사번, 이름, 입사일 컬럼의 데이터를 복사하여 emp20 이라는
테이블을 생성하시오

CREATE TABLE emp20 AS
SELECT employee_id, first_name, hire_date
FROM    hr.employees
WHERE   department_id=20;

SELECT * 
FROM    emp20;

DESC hr.employees;
--이름             널?       유형           
---------------- -------- ------------ 
--EMPLOYEE_ID    NOT NULL NUMBER(6)    
--FIRST_NAME              VARCHAR2(20) 
--HIRE_DATE      NOT NULL DATE         

DESC emp20;
--이름          널?       유형           
------------- -------- ------------ 
--EMPLOYEE_ID          NUMBER(6)    
--FIRST_NAME           VARCHAR2(20) 
--HIRE_DATE   NOT NULL DATE

* CTAS로 복사하는 경우 기존 테이블(hr.employees)의 PK컬럼인 employee_id는
PK(Primary Key) 제약조건(Constraints)은 복사되지 않음.

INSERT INTO employees (last_name, email, hire_date, job_id)
VALUES ('seon', 'sprax', TO_DATE('2022/10/26'), 'HA_TUTOR');

-- emp20에 삽입
INSERT INTO emp20 (employee_id, first_name, hire_date)
VALUES ('1', 'yeonghun', TO_DATE('2022/10/26'));

INSERT INTO emp20 (employee_id, first_name, hire_date)
SELECT employee_id, first_name, hire_date
FROM    hr.employees
WHERE   department_id=20;


SELECT *
FROM    emp20;

TRUNCATE TABLE emp20;

-- NOT NULL 제약조건 : NULL인 데이터를 삽입하고자 할때 발생
-- ORA-01400: NULL을 ("HANUL"."EMP20"."EMPLOYEE_ID") 안에 삽입할 수 없습니다
-- ??_ID는 유일한 식별자로 사용하므로 Primary Key로 지정하는데, 
-- UNIQUE하면서 NOT NULL인 조건을 만족해야 데이터를 삽입할 수 있는 제약조건!

-- 샘플 데이터를 삽입후에 제약조건을 추가하는 경우, (1)데이터가 손실 되거나
-- (2) PK경우는 제약조건을 추가하지 못함 (기존 데이터 삭제후 다시 시도)


9-3. 테이블 구조 변경  ALTER TABLE
-- 1) 테이블 설계시 구조/컬럼/데이터타입을 잘못 만듦
-- 2) 삭제하고 다시 생성 vs 이미 입력된 데이터가 있을 경우
I. Query 처리
9-3-1. 컬럼추가 : ADD
테이블에 컬럼을 추가하는 형식은 아래와 같다.
ALTER TABLE 테이블
ADD (추가할컬럼명1 데이터타입1, 
     추가할컬럼명2 데이터타입2, ...)

DESC emp20;
--이름          널?       유형           
------------- -------- ------------ 
--EMPLOYEE_ID NOT NULL NUMBER(6)    
--FIRST_NAME           VARCHAR2(20) 
--HIRE_DATE   NOT NULL DATE     
--SALARY               NUMBER       [+]
--JOB_ID               VARCHAR2(20) [+]

[예제9-7] emp20에 급여 NUMBER, 업무코드 VARCHAR2 컬럼을 추가하시오
ALTER TABLE emp20
ADD salary NUMBER(10,2); -- 1개 컬럼 추가

ALTER TABLE emp20
ADD (job_id VARCHAR2(5), email VARCHAR2(30));  -- 2개이상 추가

DESC emp20;

SELECT *
FROM emp20;
     
9-3-1. 컬럼변경 : MODIFY 
컬럼의 데이터 타입, 크기(Byte)를 변경하는 형식

ALTER TABLE 테이블명
MODIFY 변경할컬럼명1 데이터타입(크기)

* 테이블 행이 없거나 컬럼이 NULL 값만 포함하고 있어야 데이터 타입을 변경할 수
있다.

* 컬럼에 저장되어 있는 데이터의 크기 이상까지 데이터의 크기를 줄일 수 있다.
-- ex>1000000.35 라는 salary 컬럼을 NUMBER(8, 2) --> (5, 2)로 변경 시도하면!!
--이미 입력된 데이터가 있는 컬럼의 데이터타입/크기를 변경하고자 할때
--ORA-01440: 정도 또는 자리수를 축소할 열은 비어 있어야 합니다
--01440. 00000 -  "column to be modified must be empty to decrease precision or scale"

[예제9-8] emp20 테이블의 급여 컬럼(salary)와 업무코드 컬럼(job_id)의 데이터
크기를 변경하시오
-- salary NUMBER(8, 2) was (10, 2)
-- job_id VARCHAR2(10) was 5

ALTER TABLE emp20
--MODIFY salary NUMBER(8, 2);
MODIFY salary NUMBER(5, 2);




ALTER TABLE emp20
MODIFY (job_id VARCHAR2(10), email VARCHAR2(20));

DESC emp20;

SELECT *
FROM emp20;

-- 값을 입력한 후에 MODIFY를 시도한다면?
UPDATE emp20
SET salary=100000.35
WHERE employee_id=1;

9-3-1. 컬럼삭제 : DROP COLUMN
테이블의 컬럼을 삭제하는 형식으로,

ALTER TABLE 테이블명
DROP COLUMN 삭제할컬럼명;

SELECT *
FROM emp20;

[예제9-9] emp20 테이블의 업무코드 컬럼(job_id)을 삭제하시오
ALTER TABLE emp20
DROP COLUMN job_id; -- 
--DROP COLUMN salary; -- 데이터가 있어도 삭제 | 경고 x

II. UI로 처리 : 접속 윈도우 -> 해당 계정의 -> 테이블명 에서 우클릭, [편집]


9-4. 테이블 삭제 : DROP TABLE
테이블의 행 데이터와 구조(=컬럼, field)를 삭제하는 명령문!  (AUTO COMMIT!)

DROP TABLE 삭제할테이블명;

[예제9-10] emp20 테이블을 삭제하시오
DROP TABLE emp20;
ROLLBACK;

9-5. 테이블 컬럼명 변경 : RENAME COLUMN 이전 컬럼명  TO 이후 컬럼명
테이블의 컬럼명을 변경하고자 할때 사용하는 형식

ALTER TABLE emp20
RENAME COLUMN id TO emp_id;

* 접속 윈도우(=창) 에서 해당 테이블에서 마우스 우클릭 , 열 > 이름바꾸기 와 같음.
                          컬럼에서 마우스 우클릭 > 이름 바꾸기 와 같음.


9-6. 테이블 데이터 삭제 : TRUNCATE TABLE
테이블의 행 데이터를 삭제하고 구조는 남겨두는 명령

TRUNCATE TABLE 삭제할테이블명;

DESC dept1;
SELECT *
FROM dept1;

[예제9-11] dept1 테이블의 데이터를 모두 삭제하시오
TRUNCATE TABLE dept1;

-- MOKAROO 에서 무료 데이터 1000건을 *.CSV 형태로 다운받고,
-- 접속 윈도우(=창)을 이용해 (GUI)으로 테이블에 데이터를 삽입해보세요!
-- CSV(Comma Separate Value) : ,로 구분된 데이터 
-- 테이블 생성, 데이터 임포트~ *.csv 와 컬럼/데이터 매칭해서 처리!
-- sqlDeveloper에서 새 테이블 생성, 컬럼 정의











