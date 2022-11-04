--[연습문제10-2]

--1. CHARACTERS 테이블의 EMAIL 컬럼에는 각 배역들의 이메일 주소가 저장되어 있다. 이메일 정보가
--없는 배역들의 모든 정보를 조회하는 쿼리문을 작성한다.
SELECT *
FROM CHARACTERS
WHERE EMAIL IS NULL;

--CHARACTER_ID CHARACTER_NAME                  MASTER_ID    ROLE_ID EMAIL                                   
-------------- ------------------------------ ---------- ---------- ----------------------------------------
--          10 랜도 칼리시안                                                                                
--          14 콰이곤 진                              21                                                    
--          15 아미달라 여왕                                                                                
--          16 아나킨 어머니                                                                                
--          17 자자빙크스(목소리)                                                                           
--          19 장고 펫 


--2. CHARACTERS 테이블에는 스타워즈에 등장하는 각 배역들의 정보가 들어있다. 이들 중 그 역할이
--시스에 해당하는 등장인물을 조회하는 쿼리문을 작성한다.
SELECT  c.CHARACTER_NAME 배역,
        r.ROLE_NAME 역할
FROM CHARACTERS c, ROLES r
WHERE c.ROLE_ID = r.ROLE_ID
AND c.ROLE_ID = 1002;


--3. 에피소드 4에 출연한 배우들의 실제 이름을 조회하는 쿼리문을 작성한다.
-- 영화(에피소드) 정보 : STAR_WARS
-- 등장인물과 실제 배우의 정보 : CASTING

SELECT EPISODE_ID, REAL_NAME
FROM    CASTING
WHERE EPISODE_ID=4;

--EPISODE_ID REAL_NAME                     
------------ ------------------------------
--         4 마크해밀                      
--         4 케니 베이커                   
--         4 나탈리 포트만                 
--         4 페르닐라 아우구스트           
--         4 크리스토퍼 리

4. 에피소드 5에 출연한 배우들의 배역이름과 실제 이름을 조회하는 쿼리문을 작성한다.
-- 에피소드번호     배역           배우이름
--     5        다쓰 베이더     헤이든 크리스텐슨	
SELECT ca.EPISODE_ID, 
       ch.CHARACTER_NAME,
       ca.REAL_NAME
FROM    CASTING ca, characters ch
WHERE   ca.CHARACTER_ID = ch.CHARACTER_ID
AND     ca.EPISODE_ID = 5;

--EPISODE_ID CHARACTER_NAME                 REAL_NAME                     
------------ ------------------------------ ------------------------------
--         5 다쓰 베이더                    헤이든 크리스텐슨             
--         5 자자빙크스(목소리)             아메드 베스트 



--5. 다음은 에피소드2에 출연한 모든 배우들의 배역이름, 실제이름, 역할을 조회하는 쿼리문이다.
--이것을 ANSI JOIN 으로 바꾸어 작성해본다.
-- ORACLE JOIN   vs   ANSI JOIN   : 오라클 전용   vs DBMS 범용
-- EQUI, NON-EQUI     INNER , OUTER [LEFT|RIGHT|FULL]
-- OUTER JOIN : (+) 
-- WHERE 조인조건      ON 조인조건 or   USING(공통컬럼명)
SELECT c.character_name, p.real_name, r.role_name
FROM characters c, casting p, roles r
WHERE c.character_id = p.character_id
AND c.role_id = r.role_id(+)
AND p.episode_id = 2;  -- 5rows

SELECT *
FROM CHARACTERS;

--CHARACTER_NAME                 REAL_NAME                      ROLE_NAME           
-------------------------------- ------------------------------ --------------------
--아나킨 스카이워커                  잭 애프론                           제다이              
--다쓰 몰                          레이 파크                           시스                
--레이아 공주                       캐리 피셔                           반란군              
--츄바카                           피터 메이휴                          반란군              
--장고 펫                          테무에라 모리슨                      (NULL)
SELECT *
FROM CHARACTERS;

SELECT c.character_name, p.real_name, r.role_name
FROM characters c INNER JOIN casting p
ON c.character_id = p.character_id
LEFT OUTER JOIN roles r
USING (role_id)
WHERE p.episode_id = 2;


--6.CHARACTERS 테이블에서 배역이름, 이메일, 이메일 아이디를 조회하는 쿼리문을 작성한다.
--(단, 이메일이 id@jedai.com 일 경우 이메일 아이디는 id 이다)
-- INSTR()
-- SUBSTR()
SELECT  CHARACTER_NAME, 
        EMAIL, 
        SUBSTR(EMAIL, 0, INSTR(EMAIL, '@') - 1) EMAIL_ID,
--      SUBSTR(EMAIL, INSTR(EMAIL, '@') + 1) EMAIL_DOMAIN
FROM CHARACTERS;

--SELECT SUBSTR('yoda@jedai.com', 0, 4)
--FROM dual;
--
--SELECT INSTR('yoda@jedai.com', '@')
--FROM dual;

COMMIT;



--7. 역할이 제다이에 해당하는 배역들의 배역이름과 그의 마스터 이름을 조회하여 다음의 결과가 
--나오도록 작성하는 쿼리문으로 ( ) 안에 알맞게 채워본다.
--(교재 91p. 하단의 표/쿼리문 참고)

SELECT  c.character_name , m.character_name masters
FROM    characters c, roles r, characters m
WHERE   c.role_id = r.role_id
AND     r.role_name = '제다이'
AND     c.master_id = m.character_id(+)
ORDER BY 1;

SELECT *
FROM characters
WHERE role_id = 1001;


--8. 역할이 제다이에 해당하는 배역들의 배역이름, 이메일, 마스터의 이메일을 조회하였더니 다음과 같다.
--(교재 92p. 표 참고)
--
--위 결과에 제다이 기사의 이메일이 있으면 제다이 기사의 이메일을, 없으면 마스터의 이메일을 사용하는
--EMAILS 컬럼까지 추가하여 조회하는 쿼리문을 작성한다.

SELECT  c.character_name, 
        NVL2(c.email, c.email, m.email) jedai_email,
        m.email master_email
FROM    characters c, characters m
WHERE   c.master_id = m.character_id(+)
AND     c.role_id = 1001
ORDER BY 1;

-- 콰이곤 진 ==> ROLE_ID를 제다이족인 1001로 업데이트
--UPDATE characters
--SET role_id = 1001
--WHERE character_id = 14;


--9. 스타워즈 시리즈별로 출연한 배우의 수를 파악하고자 한다. 에피소드 이름과 출연 배우수를 개봉년도 순으로
--조회하는 쿼리문을 작성한다.

SELECT  s.open_year, s.episode_name, COUNT(*) cnt
FROM    star_wars s, casting c
WHERE   s.episode_id = c.episode_id
GROUP BY s.open_year, s.episode_name
ORDER BY s.open_year;


select *
from casting;



10. 스타워즈 전체 시리즈에서 각 배우별 배역이름, 실제이름, 출연 횟수를 조회하는데 출연 횟수가
많은 배역이름, 실제이름 순으로 조회하는 쿼리문을 작성한다.
SELECT  ch.character_name, --characters
        ca.real_name, --casting
        count(*) cnt
FROM    characters ch, casting ca
WHERE   ch.character_id = ca.character_id
GROUP BY ch.character_name, ca.real_name
ORDER BY cnt DESC;

-- ※ 단, 여러 시리즈에 한번 이상 반복 출연한 배우도 있을텐데, 그것들은 고려하지 않음.
-- 리암 니슨 : 시리즈 1,2에 콰이곤 진 으로 연기한것으로 파악(구글 검색)

--UPDATE casting
--SET episode_id=2
--WHERE REAL_NAME='리암 니슨'; --한 솔로 해리슨 포드




11. 위 쿼리문을 참고하여 출연횟수가 많은 상위 3명의 배역명, 실명, 출연 횟수를 조회하는 쿼리문을
작성한다.
-- ROWNUM, DENSE_RANK, RANK, AVERAGE_RANK : 순위관련
SELECT ROWNUM, s.*
FROM    ( SELECT  ch.character_name, --characters
                  ca.real_name, --casting
                  count(*) cnt
          FROM    characters ch, casting ca
          WHERE   ch.character_id = ca.character_id
          GROUP BY ch.character_name, ca.real_name
          ORDER BY ch.character_name ) s
WHERE ROWNUM < 4;          
--character_name     real_name       cnt
------------------------------------------
--루크 스카이워커	    마크해밀	       1
--두쿠 백작	            크리스토퍼 리	   1
--레이아 공주	        캐리 피셔	       1

12. 스타워즈 시리즈별로 어떤 시리즈에 몇 명의 배우가 출연했는지 조회하고자 한다. 에피소드 시리즈
번호, 에피소드이름, 출연배우 수를 조회하는데 출연배우 수가 많은 순으로 조회하는 쿼리문을 작성한다.

SELECT  s.episode_id,
        s.episode_name,
        count(*) cnt
FROM    star_wars s, casting c
WHERE   s.episode_id = c.episode_id
GROUP BY s.episode_id, s.episode_name
ORDER BY cnt DESC;

COMMIT;





