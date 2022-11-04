2장. SQL

2-1. SQL (Strucured Query Language) 
데이터베이스로부터 데이터를 조회, 저장, 삭제하는등의 작업에 사용하는 질의어이다.
구조화된 언어로 일정한 틀, 패턴이 있고 패턴에 맞게 조건들을 나열해서 원하는 결과를
얻을 수 있다.

2-2. SQL 구분

- DML(Data Manipulation Language) : 데이터를 조회, 저장, 삭제하는 데이터 조작관련 명령 
    └ SELECT : 조회 명령
    └ DELETE : 삭제 명령
    └ INSERT : (신규 데이터) 저장 명령
    └ UPDATE : (기존 데이터) 변경/저장 명령
    
- DDL(Data Definition Language) : 데이터를 저장하는 테이블, 뷰등과 같은 객체관련 명령
    └ CREATE : (ex.테이블) 생성 명령
    └ DROP : 삭제 명령
    └ ALTER : 변경 명령
    └ TRUNCATE : 영구삭제 명령
※ 개발자가 주로 사용하는 SQL은 DML, DDL이고 그중에서 DML을 가장 많이 사용한다.

- DCL(Data Control Language) : 사용자 권한과 관련된 명령
    └ GRANT : 권한 부여 명령
    └ REVOKE : 부여된 권한 회수 명령    
※ 데이터베이스 관리자는 DCL을 (GRANT: 계정생성 후 권한부여, REVOKE : 권한회수)

2-3. SQL 작성방법
1) 대,소문자를 구분하지 않는다.
2) 절 단위 줄바꿈하여 작성한다.
    ex> SELECT username FROM dba_users;             [길어지면 가독성 떨어짐!]
        SELECT username   (SELECT 절)                [가독성 강조 측면~]
        FROM dba_users;   (FROM 절)
3) 문장의 끝에 ;을 기술하여 명령의 끝을 표시한다.
4) SQL 실행 : CTRL+ENTER
             (블럭 씌워서) CTRL+ENTER









