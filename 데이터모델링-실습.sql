-- DEMO PDB1을 사용했습니다.

-- 1. 직접 DDL, DML 작성해보기
-- 2. 또는 sqlDeveloper에 포함된 Data Modeler 사용해서 해보기
--     └ 시퀀스 만들어보기 , 적용해보기 : 어제 수업했던 11장
--     

-- 게시판 테이블 : BOARD

CREATE TABLE BOARD (
    board_id NUMBER,
    board_title VARCHAR2(50),
    board_staff VARCHAR2(30),
    --board_post_qty NUMBER -- 트리거를 사용한다면,
    CONSTRAINT board_id_pk PRIMARY KEY (board_id)
);

-- 글이 작성되어 자동으로 BOARD 테이블의 글의 갯수를 카운팅 하려면? board_post_qty라는
-- 컬럼을 만들고, 트리거를 이용해 자동으로 업데이트 해줘야 함
-- 트리거는 데이터가 INSERT, UPDATE, DELETE 되면 자동으로 호출되어 실행되는 PL/SQL
-- PL/SQL은 보통 Procedure Language Extension To SQL라고 해서 절차적 프로그래밍을 수행하듯
-- 쿼리를 수행하는 문법


INSERT INTO BOARD
VALUES (BOARD_ID_SEQ.NEXTVAL, '새소식', '김혜운');
INSERT INTO BOARD
VALUES (BOARD_ID_SEQ.NEXTVAL, '질문답변', '박찬재');
INSERT INTO BOARD
VALUES (BOARD_ID_SEQ.NEXTVAL, '자유게시판', '김준호');
-- ID 열, 시퀀스 설정
INSERT INTO BOARD
VALUES (BOARD_ID_SEQ.NEXTVAL, '갤러리', NULL);

SELECT *
FROM BOARD;

UPDATE BOARD
SET BOARD_STAFF='김원희'
WHERE BOARD_ID=4;

-- 글 : POST
-- 외래 키 사용하는 테이블은 나중에 만드는것이 편함
CREATE TABLE POST (
    post_id NUMBER PRIMARY KEY,
    post_title VARCHAR2(100),
    post_body VARCHAR2(200),
--    attach_img BLOB,  -- Binary Large OBject : 사진
--    attach_file BFILE, -- Binary FILE : 영상, 오디오
    post_writer_id NUMBER,
--    post_board_id NUMBER -- 테이블 생성시 외래키사용할 컬럼 정의
);

-- 테이블 생성 후 컬럼 및 제약조건 추가
ALTER TABLE POST
ADD CONSTRAINT post_board_id_fk FOREIGN KEY (post_board_id) REFERENCES BOARD (board_id);


-- 테이블 생성 후 제약조건(FK) 추가
ALTER TABLE POST
ADD CONSTRAINT post_writer_id_fk FOREIGN KEY (post_writer_id) REFERENCES WRITER (writer_id);

-- POST와 BOARD의 식별관계 (부모 테이블의 PK가 자식테이블의 FK로 복사되는 과정) : 실선으로 표시
-- 컬럼 추가, 제약조건 설정


-- 샘플 데이터 추가
-- WRITER_ID를 참조하는 경우, 먼저 WRITER를 등록
INSERT INTO POST
VALUES (POST_ID_SEQ.NEXTVAL, '가입인사', '안녕하세요, 반갑습니다.', 1, 1);
INSERT INTO POST
VALUES (POST_ID_SEQ.NEXTVAL, '배송문의합니다', '지난주 주문한 감귤이 도착하지 않았습니다', 2, 2);
INSERT INTO POST
VALUES (POST_ID_SEQ.NEXTVAL, '아침저녁 쌀쌀합니다', '감기조심하세요!! 여러분~', 3, 3);


-- 작성자 : WRITER
CREATE TABLE WRITER (
    writer_id NUMBER PRIMARY KEY,
    write_name VARCHAR2(20) NOT NULL,
    write_phone CHAR(13),
    write_email VARCHAR2(30)
);

-- WRITER_ID_SEQ를 생성하지 않았음.
INSERT INTO WRITER
VALUES (1, '홍길동', '010-1234-5678', 'hong@naver.com');
INSERT INTO WRITER
VALUES (2, '박찬재', '010-2222-3333', 'pcj1004@daum.net');
INSERT INTO WRITER
VALUES (3, '김준호', '010-3333-4444', 'junho1004@gmail.com');


-- 댓글 : COMMENTS
CREATE TABLE COMMENTS (
    comm_id NUMBER PRIMARY KEY,
    comm_body VARCHAR2(300) NOT NULL,
    comm_date DATE DEFAULT SYSDATE,
    comm_post_id REFERENCES POST (post_id)
)

-- 커밋하고 가세요!
COMMIT;
-- 테이블을 모두 만들고, 샘플데이터 입력했으면 다시한번 구조 확인, 데이터 확인
-- JOIN 연산 해보기


SELECT *
FROM COMMENTS;


-- 순환참조(=자기참조) | 비식별관계
CREATE TABLE ITEMS (
    item_id NUMBER(4) PRIMARY KEY, --SYS_C008245
    item_name VARCHAR2(30),
    parent_id NUMBER(4),
    item_qty NUMBER
);
-- PK 제약조건 지정 : 별도로 설정하지 않으면 SYS_C00**** 형태로 지정됨
ALTER TABLE ITEMS
ADD CONSTRAINT item_id_pk PRIMARY KEY (item_id);


ALTER TABLE ITEMS
ADD CONSTRAINT item_id_parent_fk FOREIGN KEY (parent_id) REFERENCES ITEMS (item_id);

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM USER_CONSTRAINTS;

-- 샘플데이터 입력
INSERT INTO ITEMS
VALUES (1001, '컴퓨터', NULL, 1);
INSERT INTO ITEMS
VALUES (1002, '본체', 1001, 1);
INSERT INTO ITEMS
VALUES (1003, '메인보드', 1002, 1);
INSERT INTO ITEMS
VALUES (1004, 'CPU', 1003, 1);
INSERT INTO ITEMS
VALUES (1005, 'RAM', 1003, 2);
INSERT INTO ITEMS
VALUES (1006, '그래픽카드', 1003, 1);
INSERT INTO ITEMS
VALUES (1007, '사운드카드', 1003, 1);
INSERT INTO ITEMS
VALUES (1008, '모니터', 1001, 1);
INSERT INTO ITEMS
VALUES (1008, '입력장치', 1001, 2);
INSERT INTO ITEMS
VALUES (1009, '키보드', 1008, 2);
INSERT INTO ITEMS
VALUES (1010, '마우스', 1008, 2);

SELECT *
FROM ITEMS;

-- 계층형 쿼리
-- LEVEL : 부모,자식 노드의 순서를 나타내는 의사컬럼 (부모 : 1, 자식 : 1+)
SELECT item_id, LPAD(' ', 2 * (LEVEL -1)) || item_name item_name
FROM    items
START WITH parent_id IS NULL -- 1. 부모 컬럼(널값)
CONNECT BY parent_id = PRIOR item_id;

-- 답변형 게시판 (글번호, 제목, 내용, 작성자,...)
-- ex> 카테고리 : 질문답변 게시판
-- board(=국내형) vs forum : 글타레~ (외국형)

CREATE TABLE qa_board (
    id NUMBER,
    p_id NUMBER,
    subject VARCHAR2(50) NOT NULL,
    content VARCHAR2(200)  NOT NULL,
    write_date DATE DEFAULT SYSDATE,
    CONSTRAINT id_pk PRIMARY KEY(id),
    CONSTRAINT p_id_fk FOREIGN KEY (p_id) REFERENCES qa_board (id)    
);

DESC qa_board;

-- 샘플 데이터
INSERT INTO qa_board
VALUES (1, NULL, '오늘 날씨 어때요?', '아침에 나올때 보니까 생각보다 춥던데, 금방 겨울같아요',TO_DATE('2022/10/24', 'YYYY/MM/DD'));
INSERT INTO qa_board
VALUES (2, 1, '몇일은 춥다고 해요~!', '출근길에 김영철의 파워FM에서 이번주는 반짝 추웠다가 따듯해진대요!',TO_DATE('2022/10/25', 'YYYY/MM/DD'));
INSERT INTO qa_board
VALUES (3, NULL, '광주에 축제가 뭐가 있나요?', '가을이라 곧 축제가 여기저기서 있을것 같은데, 광주에 대표할만한 축제가???',TO_DATE('2022/10/28', 'YYYY/MM/DD'));
INSERT INTO qa_board
VALUES (4, 3, '충장 축제 있어요!', '기간은 10월 말인데, 일주일밖에 안해요~',TO_DATE('2022/10/29', 'YYYY/MM/DD'));
INSERT INTO qa_board
VALUES (5, 3, '광주 세계 김치축제도 있어요!', '10월 20일부터 23일까지, 남구에서 행사 잇어요!',TO_DATE('2022/10/30', 'YYYY/MM/DD'));


SELECT *
FROM    qa_board;

SELECT ROWNUM 번호,
        LPAD(' ',4*(LEVEL-1)) || subject 글제목,
        TO_CHAR(write_date, 'MM/DD') 작성일
FROM    qa_board
START WITH p_id IS NULL
CONNECT BY p_id = PRIOR id; -- 부모쪽에 PRIOR(=우선?)






