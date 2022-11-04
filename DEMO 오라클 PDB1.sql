-- SQL 종류
1) DML : SELECT, INSERT, UPDATE, DELETE  -- Developer
2) DDL : CREATE, ALTER, DROP, TRUNCATE -- Developer
3) DCL : GRANT, REVOKE -- DBA

SELECT sysdate -- SYSDATE 함수 : 오늘 날짜 출력 명령
FROM dual; -- dual : 가짜 테이블

CREATE TABLE DEMOUSER(
    id  NUMBER  PRIMARY KEY,
    name    VARCHAR2(20) NOT NULL,
    addr    VARCHAR2(50),
    email   VARCHAR2(30)
);

DESC DEMOUSER; -- 테이블 구조 확인

DROP TABLE DEMOUSER; -- 테이블 삭제

CREATE TABLE MEMBER2 (
    num NUMBER PRIMARY KEY,
    name VARCHAR2(20),
    age NUMBER,
    tel VARCHAR(30),
    addr VARCHAR(50),
    join_date   DATE
);
-- 문자데이터, 시간날짜 데이터 : '
-- Alias(별칭) : "
-- 영문 1자 : 1Byte
-- 한글 1자 : 2Byte
INSERT INTO MEMBER (num, name, age, tel, addr)
VALUES (1, '홍길동', 30, '062-373-1234','광주 서구 농성동');
INSERT INTO MEMBER (num, name, age, tel, addr)
VALUES (2, '김길동', 20, '062-473-1234','광주 동구 지원동');
INSERT INTO MEMBER (num, name, age, tel, addr)
VALUES (3, '박길동', 25, '062-673-1234','광주 남구 백운동');
INSERT INTO MEMBER (num, name, age, tel, addr)
VALUES (4, '최길동', 22, '062-273-1234','광주 북구 일곡동');
INSERT INTO MEMBER (num, name, age, tel, addr)
VALUES (5, '이길동', 45, '062-573-1234','광주 광산구 월계동');

-- 데이터 조회 : SELECT FROM WHERE 조건;
SELECT *
FROM    MEMBER;

SELECT NAME, AGE, ADDR
FROM    MEMBER
WHERE   AGE > 25;

SELECT *
FROM    MEMBER
WHERE   NAME = '이길동';

COMMIT;






--COALESCE(null, null, expr1, null) : 최초로 null 아닌 값 expr1 반환 / 모두가 null이면 null 반환
--└어디에 쓸수 있을까?   회워정보 전화번호 phone_number    tel     phone  
--                                      3627797     (null)     (null)
--                                      (null)       3627798   (null)
--                                      (null)       (null)   3627799       
--            SELECT COALESCE(tel, phone, mobile) "연락처"

-- 1. DDL : CREATE, ALTER, DROP / 오라클 데이터베이스 객체(Entity)- 테이블,뷰,인덱스,클러스터,시노님,..
CREATE TABLE CONTACT(
    ID NUMBER NOT NULL, -- 숫자(정수,실수) : Java int, double --> NUMBER
    TEL VARCHAR2(13), -- 가변문자형 : Java > String --> VARCHAR2
    PHONE VARCHAR2(13),
    MOBILE VARCHAR2(13)
);
--   (DQL : SELECT) : 1) 시퀄~ 2) 에스큐엘~
-- 2. DML : SELECT, INSERT, UPDATE, DELETE 
INSERT INTO CONTACT(ID, TEL)
VALUES (1, '010-1234-5678');

INSERT INTO CONTACT(ID, MOBILE)
VALUES (2, '010-9999-8888');

INSERT INTO CONTACT(ID, PHONE)
VALUES (3, '062-362-7797');

-- 3. 데이터 조회
SELECT *
FROM    CONTACT;

-- 4. COALESCE 사용해서 조회 (최초로 NULL 아닌 값 반환, 모두가 NULL이면 NULL반환)
SELECT COALESCE(TEL, PHONE, MOBILE) "연락처"
FROM    CONTACT;



-- 합집합을 위한 테이블
-- 사람(HUMAN) 테이블 (ID, NAME)
-- 1  홍길동
-- 2  김길동
-- 관리자(MANAGER) 테이블 (NO, NICKNAME)
-- 1  홍길동
-- 2  최박사

CREATE TABLE HUMAN(
    ID NUMBER NOT NULL,
    NAME VARCHAR2(20)
)
INSERT INTO HUMAN
VALUES (1, '홍길동');
INSERT INTO HUMAN
VALUES (2, '최길동');
INSERT INTO HUMAN
VALUES (3, '김길동');

CREATE TABLE MANAGER(
    NO NUMBER NOT NULL,
    NICKNAME VARCHAR2(20)
);
INSERT INTO MANAGER
VALUES (1, '홍길동');
INSERT INTO MANAGER
VALUES (2, '박길동');
INSERT INTO MANAGER
VALUES (3, '김길동');
INSERT INTO MANAGER
VALUES (4, NULL);
INSERT INTO MANAGER
VALUES (5, ' ');

SELECT *
FROM HUMAN
INTERSECT
SELECT *
FROM MANAGER;







