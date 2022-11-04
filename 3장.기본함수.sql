/*
DML : Data Manipulation Language  (SELECT, INSERT, UPDATE, DELETE) / 데이터 다룸
DDL :  "    Definition      "     (CREATE, ALTER, DROP, TRUNCATE)  / 테이블, 뷰 생성
---------------------------
DCL :  "   Control        "        (GRANT, REVOKE)
*/

3장. 기본 함수
- 프로그래밍 언어에서 사용하는 함수와 비슷하다.
- 자주 사용하는 기능을 함수로 정의, 필요할때마다 호출하여 사용
- 함수의 유형 : 단일 행 함수 , 다중 행 함수 
- 함수에 사용하는 파라미터와 반환되는 값의 유형에 따라 함수를 구분한다.
- 함수의 종류는 1) 숫자 함수 2)문자 함수 3)날짜 함수 4)변환 함수 5)일반 함수가 있다.
※ 그밖에 데이터 사이언티스트가 사용하는 고급함수(?)도 있지만, 개발자 사용하는 함수는 일부!

SELECT SYSDATE
FROM dual;   -- dual : 가짜 테이블(dummy)


3-1. 숫자 함수
3-1-1.ABS(n) : n의 절대값을 반환하는 함수

[예제3-1] 다음 쿼리를 실행하시오
SELECT ABS(32), ABS(-32)
FROM dual;

3-1-2.SIGN(n) : n이 양수인지, 음수인지 여부를 판단하는 함수
--n이 양수면 1을,
--n이 음수면 -1을,
--0이면 0을 반환

SELECT SIGN(32), SIGN(-32), SIGN(0)
FROM dual;

3-1-3.ROUND(n [,i]) : n을 소수점 i번째 자리로 반올림한 결과를 반환 ★
--    ROUND(datetime) : 시간,날짜 데이터를 반올림한 결과를 반환 ★      
-- 즉, i는 소수점 아래 자릿수를 나타낸다.
-- i를 생략(=옵션, option) 기본값 0으로 인식해서 반올림 한다.
-- 즉, ROUND(n, 0) 과 ROUND(n)과 같은 결과를 반환한다.

[예제3-3] 
SELECT  ROUND(123.456789) ROUND1,
        ROUND(123.456789, 0) ROUND2,
        ROUND(123.456789, 2) ROUND3,--소수점 이하 둘째자리로 반올림, 3번째 자리에서 반올림
        ROUND(123.456789, -2) ROUND4 --└소수점 아래 자릿수가 2가 되게 한다.
FROM    dual;        

* i가 음수인 경우, 정수부 에서 반올림 한다.

[예제3-4]
SELECT  ROUND(123.456789, -2) ROUND1,
        ROUND(123456.789, -2) ROUND2
FROM    dual;        

3-1-4. TRUNC(n [,i]) : ROUND와 같은 방식,버림한 결과를 반환하는 함수
-- n을 생략하면 0 ==> TRUNC(n, 0) 과 같은 결과를 반환
-- i가 음수면, 정수부에서 버림~

[예제3-5]
SELECT  TRUNC(123.456789) T1,
        TRUNC(123.456789, 2) T2,
        TRUNC(123.456789, -2) T3,
        TRUNC(123456.789, -2) T4
FROM    dual;        

3-1-4.CEIL(n) : n과 같거나 큰 가장 작은 *정수*를 반환하는 함수
-- js: MATH.ceil(n)

SELECT  CEIL(0.12345) CEIL1,
        CEIL(123.45) CEIL2
FROM    dual;        

3-1-5.FLOOR(n) : n과 같거나 작은 가장 큰 *정수*를 반환하는 함수
SELECT  FLOOR(0.12345) FLOOR1,
        FLOOR(123.45) FLOOR2
FROM    dual;        

3-1-6.MOD(m, n) : m을 n으로 나눈 나머지 값을 반환하는 함수
*n에 0이 오면, m의 값을 그대로 반환한다.

-- 산술연산자 : +, -, *, /
-- % : 문자열 패턴 (여러 문자열) <---> LIKE '찾는 문자열'
-- _ : "         (하나의 문자)

[예제3-8]
SELECT  MOD(17, 4) MOD1,
        MOD(17, -4) MOD2,
        MOD(-17, -4) MOD3,
        MOD(17, 0) MOD4
FROM dual;        


[연습문제3-1]

1. 사원 테이블에서 100번와 110번 부서의 사원에 대해 사번, 이름, 급여와 15% 인상된 급여를
조회하시오
(단, 15% 인상된 급여는 정수로 표시하고, 컬럼명은 Increased Salary라고 표시한다)
SELECT  employee_id, first_name, salary, salary * 0.15 "Increased Salary",
        ROUND(salary * 0.15) "Increased Salary1",
        ROUND(salary * 0.15, 0) "Increased Salary2",
        TRUNC(salary * 0.15) "Increased Salary3",
        TRUNC(salary * 0.15, 0) "Increased Salary4",
        CEIL(salary * 0.15) "Increased Salary5",
        FLOOR(salary * 0.15) "Increased Salary6"
FROM    employees
--WHERE   department_id=100
--OR      department_id=110
WHERE   department_id IN (100, 110);

-- employees 107명중 commission_pct가 NULL 이 많음
--SELECT  employee_id, first_name, salary, commission_pct
--FROM    employees
--WHERE   commission_pct IS NULL;

3-2. 문자 함수

3-2-1. CONCAT(char1, char2) : 두 문자 char1, char2를 연결하여 결과를 반환한다.
-- || : 문자열 연결 연산자
-- ' (single quotation) : 문자 데이터, 날짜 데이터
-- " (double quotation) : Alias 작성시 공백이 있으면 하나로 묶어서 "Increase Salary"
[예제3-9]
SELECT CONCAT('Hello', 'Oracle') CONCAT1,
        'Hello' || 'Oracle' CONCAT2
FROM    dual;        

-- * 대소문자 함수
3-2-2. INITCAP(char) :  파라미터로 입력받은 문자열에서 알파벳 단어 단위로 첫 글자를
대문자화 하여 결과를 반환하는 함수
3-2-3. UPPER(char) : 입력받은 문자열을 모두 대문자로 변환하여 반환하는 함수
3-2-4. LOWER(char) : 입력받은 문자을을 모두 소문자로 변환하여 반환하는 함수

[예제3-10] INITCAP, UPPER, LOWER 함수를 사용해 쿼리를 실행하시오
SELECT  INITCAP('i am a boy') CAP1,
        UPPER('i am a boy') CAP2,
        LOWER('I AM A BOY') CAP3
FROM    dual;        

3-2-5. LPAD(char1, n [,char2]) : 전체 문자열의 길이 n에서 char1의 문자길이를 뺀 만큼
                                 char2 문자표현으로 *왼쪽*을 채워서 반환하는 함수
       RPAD(char1, n [,char2]) : 전체 문자열의 길이 n에서 char1의 문자길이를 뺀 만큼
                                 char2 문자표현으로 *오른쪽을* 채워서 반환하는 함수
* char2를 생략하면, 공백문자 한 개가 디폴트이다.     

[예제3-11]
SELECT  LPAD('abc', 7) PAD1, -- 공백
        LPAD('abc', 7, '*') PAD2,
        RPAD('abc', 7) PAD3,
        RPAD('abc', 7, '#') PAD4
FROM    dual;        

* 왼쪽 / 오른쪽 정해진 방향에서 공백문자 또는 지정한 문자를 제거한 후 결과를 반환
3-2-6. LTRIM(char1 [,char2]) : 문자열 char1에서 char2로 지정한 문자를 *왼쪽에서* 제거한 결과를 
                               반환하는 함수
       RTRIM(char1 [,char2]) : 문자열 char1에서 char2로 지정한 문자를 *오른쪽에서* 제거한 결과를 
                               반환하는 함수
* char2를 생략하면, 공백문자 한 개가 디폴트이다.     

[예제 3-12]
SELECT '[' || LTRIM('   ABCDEFG   ') || ']' LT1,
        LTRIM('ABCDEFG', 'AB') LT2,
        LTRIM('ABCDEFG', 'BA') LT3,
        LTRIM('ABCDEFG', 'BC') LT4
FROM    dual;        

[예제3-13]
SELECT '[' || RTRIM('   ABCDEFG   ') || ']' RT1,
        LTRIM('ABCDEFG', 'FG') RT2,
        LTRIM('ABCDEFG', 'GF') RT3,
        LTRIM('ABCDEFG', 'BC') RT4
FROM    dual;   

* 방향을 결정해서 공백문자 또는 지정한 문자를 제거한 결과를 반환
3-2-7. TRIM([LEADING | TRAILING | BOTH] [, trim_char] [FROM] char)
TRIM 함수는 문자열 char 에서 왼쪽(LEADING)이나 오른쪽(TRAILING) 또는 양쪽(BOTH)의
지정된 trim_char 문자를 제거한 결과를 반환하는 함수
* BOTH : 양쪽제거, 생략시 기본값
* trim_char : 생략시 기본 공백문자 한 개가 사용된다

ex> 양쪽에 공백이 있는 문자열에서 공백제거, RPAD(LPAD(char1 [,char2]) [,char2])
    TRIM(BOTH, char) : 양쪽제거
    
[예제3-14]
SELECT  '['|| TRIM('  ABCDEFG  ') || ']' T1,
        TRIM(LEADING 'A' FROM 'ABACDEFG') T2, -- 왼쪽에서 오른쪽으로 처음 만나는 A제거
        TRIM(TRAILING 'G' FROM 'ABCDGEFG') T3, -- 오른쪽에서 왼쪽로 처음 만나는 G제거
        TRIM(BOTH 'A' FROM 'ABCDEFG') T4,
        TRIM('A' FROM 'ABCDEFG') T5
FROM    dual;        



3-2-8.SUBSTR(char, position [,length]) : 문자열의 일부를 분리해 내어 반환하는 함수
char 문자열의 position으로 지정된 위치로 부터 length 개의 문자를 떼어내어 반환한다.
length는 생략하면, position으로 부터 문자열의 끝까지를 반환한다.
또한 position을 0으로 명시할 경우 디폴트로 1이 적용되어 첫번째 자리부터 length만큼의
문자열을 분리한다.

[예제3-15]
SELECT  SUBSTR('You are not alone', 9, 3) STR1,
        SUBSTR('You are not alone', 5) STR2,
        SUBSTR('You are not alone', 0, 5) STR3
FROM    dual;        

* position 값이 음수일 경우, 그 위치가 오른쪽부터 시작된다.

SELECT  SUBSTR('You are not alone', -9, 3) STR1,
        SUBSTR('You are not alone', -5) STR2
FROM    dual; 


3-2-8.REPLACE(char, search_string [,replace_string]) : 문자열중 일부를 다른 문자열로
변경하여 변경된 결과를 반환하는 함수
char 문자열에서 search_string 문자열을 replace_string 문자열로 대체하여 그 결과를 반환,
* replace_string 생략시 또는 null이 오면, search_string 문자를 제외한 결과를 반환한다.

[예제3-17]
SELECT  REPLACE('You are not alone', 'You', 'We') REP1,
        REPLACE('You are not alone', 'not') REP2,
        REPLACE('You are not alone', 'not', null) REP3
FROM    dual;   


[Quiz]
"너는 나를 모르는데 나는 너를 알겠느냐"를 REPLACE(), TRANSLATE()로 아래와 같이 변경하시오

-- REPLACE(char, search_string [replace_string])


1. REPLACE 함수 사용 : [나]는 나를 모르는데 나는 [나]를 알겠느냐
SELECT  REPLACE('너는 나를 모르는데 나는 너를 알겠느냐', '너', '나') REP1,
        REPLACE('너는 나를 모르는데 나는 너를 알겠느냐', '너') REP2
FROM    dual;

-- TRANSLATE(char, from_string, to_string) , 1:1로 변환(from을 to로)
2. TRANSLATE 함수 사용 : 나는 너를 모르는데, 너는 나를 알겠느냐
SELECT  TRANSLATE('너는 나를 모르는데 나는 너를 알겠느냐','너나','나너') TRANS1,
        TRANSLATE('너는 나를 모르는데 나는 너를 알겠느냐','너나는','나너') TRANS2
FROM    dual;



3-2-8. TRANSLATE(char, from_string, to_string) : 문자열 char에서 from_string에
해당하는 문자를 찾아 to_string에 해당하는 문자로 1대1로 변환한 결과를 반환한다.

[예제3-18]
SELECT TRANSLATE('u! You are not alone','You','We') TRANS
FROM    dual;


3-2-9. INSTR(char, search_string [,position] [,_th]) : 문자열에서 특정 문자열의 시작
위치를 반환한다. 
* position, _th : 생략가능, 생략시 디폴트 1이다.
문자열의 position 위치에서부터 특정 문자열을 찾기 시작하여, _th번째에 해당하는
시작위치를 반환한다.
* 찾는 문자열이 발견되지 않으면 0을 반환한다.
* 찾는 문자열의 시작위치로 부터 문자열을 분리해내어 원하는 정보로 가공!!
-- ex> 010.0505.3223 --> 국번 : 010 전화번호 : 0505-3223

[예제3-19]
SELECT  INSTR('Every Sha-la-la-la', 'la') INSTR1,
        INSTR('Every Sha-la-la-la', 'la', 7) INSTR2,
        INSTR('Every Sha-la-la-la', 'la', 1, 2) INSTR3,
        INSTR('Every Sha-la-la-la', 'la', 12, 2) INSTR4,
        INSTR('Every Sha-la-la-la', 'la', 15, 2) INSTR5, -- 두번째 la 못찾아서 0
        SUBSTR('Every Sha-la-la-la',INSTR('Every Sha-la -la-la', 'la')) SUBSTR1, --끝까지
        SUBSTR('Every Sha-la-la-la',INSTR('Every Sha-la -la-la', 'la'), 5) SUBSTR2 --갯수만큼
FROM    dual;

3-2-10. LENGTH(char) : 문자열의 길이를 반환하는 함수

[예제3-20] 
SELECT  LENGTH('Every Sha-la-la-la') LEN1,
        LENGTH('무궁화 꽃이 피었습니다') LEN2,
        LENGTHB('Every Sha-la-la-la') LENB1, -- 영문 1자 : 1Byte
        LENGTHB('무궁화 꽃이 피었습니다') LENB2 -- 한글 1자 : 2Byte 이지만, SQL엔진(=오라클) 2~3Byte 설정
FROM    dual;        

-- 데이터베이스 설정
-- sqlDeveloper > 도구 > 환경설정 > 데이터베이스 > NLS 정보
SELECT *
FROM    v$nls_parameters; -- NLS 테이블에서 일부만 가상의 테이블(=VIEW)로 제공

SELECT *
FROM    NLS_DATABASE_PARAMETERS; -- 데이터베이스의 NLS 설정값

/* 오라클 자료형
1.숫자 타입 : NUMBER (정수, 실수)  ex> 10, 10.5, 123.4567
INT, double ==> NUMBER
2.문자(열) 타입 : VARCHAR2(size BYTE|CHAR) / 가변(데이터 길이 달라지는)   ex> '대한민국', '홍길동' , '광주 서구 경열로...'
                CHAR(size BYTE|CHAR) / 고정 (M,W)
                NVARCHAR2(size)
                NCHAR(size)
String ==> 
3.날짜타입 : DATE                 ex> 2022/10/19, 2022-10-19(RR/MM/DD YY/MM/DD) 
4.시간날짜 타입 : TIMEZONE         ex> 2022.10.19 14:12:50
5. 기타 : LONG   |   LOB / CLOB : 방대한 텍스트 저장용
         (2GB)     (4GB old, new)
*/

3-3. 날짜 함수
날짜 함수는 날짜와 시간을 연산 대상으로 한다.

3-3-1. SYSDATE()   vs   SYSDATE : 일반적으로 SYSDATE, 파라미터로 전달할 값이 x
- 현재 시스템의 현재 날짜를 가져오는 함수. 이 날짜는 시각을 포함하고 있다.
- 다른 함수와 달리 파라미터가 없다. ()를 사용하지 않는다.

SELECT sysdate
FROM    dual;

-- 날짜 형태를 확인(NLS : National Language Support) : 각 대륙/국가별 설정이 다름
-- NLS_DATABASE_PARAMETER 테이블 : 진짜 오라클엔진 설정
SELECT *
FROM v$nls_parameters;

-- DDL : 데이터베이스 객체 정의 (CREATE, ALTER, DROP, TRUNCATE)
-- ALTER : 변경 <---> 데이터가 있는데, 삭제하면 ? 데이터 유실..
--         추가, 제거, 변경(CHAR --> VARCHAR2) 
-- 세션 : 현재 로그인한 계정(HR) ==> 영구 설정이 아니다~

ALTER SESSION SET nls_date_format = 'RR/MM/DD';


3-3-2. ADD_MONTHS(date, n) : 날짜 date에 지정한 개월 n을 더해서 그 결과를 반환하는 함수

SELECT  ADD_MONTHS(SYSDATE, 1) MONTH1,
        ADD_MONTHS(SYSDATE, 2) MONTH2,
        ADD_MONTHS(SYSDATE, -3) MONTH3,
        ADD_MONTHS('2022/08/15', 2) MONTH4
FROM    dual;        


3-3-3.MONTHS_BETWEEN(after_date1, before_date2) : 두 날짜 date 사이의 개월 수를 구하여 반환하는 함수
반환되는 데이터는 숫자형을 반환.
날짜 사이의 선후 관계 : date1(이후 날짜) - date2(이전 날짜)

[예제 3-22]
SELECT  ROUND(MONTHS_BETWEEN(SYSDATE, '2013-03-20')) PASSED,
        TRUNC(MONTHS_BETWEEN('2013-08-28', SYSDATE)) REMAINED
FROM    dual;


3-3-4.LAST_DAY(date) : date에 해당하는 달의 마지막 날짜를 반환한다.
날짜가 3월이면 31을 반환하고, 4월이면 30일을 반환한다.

SELECT LAST_DAY(SYSDATE) LAST1,
        LAST_DAY('2013-02-01') LAST2
FROM    dual; -- 10월 31일


3-3-5. NEXT_DAY(date, char) : date 이후의 날짜 중에서 char로 명시된 첫번째 일자를
반환한다.
char 에는 요일에 해당하는 문자 SUNDAY, MONDAY,...와 약어인 SUN, MON, TUE,..를
사용할 수 있다.
* 월요일, 화요일, 수요일... 또는 약어인 월, 화, 수..[NLS_LANGUAGE에 KOREAN 설정]
* 1:일요일, 2:월요일 ... 7:토요일로 사용할 수 있다.

[예제3-24]
SELECT NEXT_DAY(SYSDATE, 'monday') N1,
        NEXT_DAY(SYSDATE, 'mon') N2,
        NEXT_DAY(SYSDATE, 2) N3,
        NEXT_DAY(SYSDATE, 'MONDAY') N4,
        NEXT_DAY(SYSDATE, 'MON') N5
--        NEXT_DAY(SYSDATE, '월요일') N6,
--        NEXT_DAY(SYSDATE, '월') N7
FROM    dual;        
        
SELECT *
FROM v$nls_parameters;

-- SYSDATE : 날짜, 시간을 포함 / 설정에 따라서 다름
ALTER SESSION SET NLS_DATE_FORMAT='YY/MM/DD HH24:MI:SS'; --24시간

SELECT  SYSDATE, -- 현재 시스템의 날짜, 시간정보 | NLS_DATE_FORMAT에 따름!
        CURRENT_DATE, -- 타임존에 따른 시간
        SYSTIMESTAMP, -- 시스템 날짜 + 밀리세컨즈 (정교한 작업)
        CURRENT_TIMESTAMP -- 타임존에 따른 시간/ 지역/ 밀리세컨즈(정교한 작업)
FROM dual;



3-3-6. ROUND(number [,n]) : 숫자데이터를 소숫점 n번까지 반올림 결과를 반환하는 함수
       ROUND(date, fmt) : 날짜를 사용하여 반올림 된 날짜를 반환하는 함수
       
[예제3-25]      


SELECT  ROUND(TO_DATE('2013-06-30'), 'YYYY') R1,
        ROUND(TO_DATE('2013-07-01'), 'YY') R2,
        ROUND(TO_DATE('2013-07-01'), 'YEAR') R3,
        ROUND(TO_DATE('2013-07-01'), 'MONTH') R4,
        ROUND(TO_DATE('2013-07-01'), 'MON') R5,
        ROUND(TO_DATE('2013-07-01'), 'MM') R6,
        ROUND(TO_DATE('2013-05-29'), 'DAY') R7,
        ROUND(TO_DATE('2013-05-29'), 'DD') R8,
        ROUND(TO_DATE('2013-05-29'), 'DDD') R9
FROM    dual;


3-3-7. TRUNC(date, fmt) : ROUND는 반올림하지만, TRUNC는 fmt 따라서 날짜를 버린
결과를 반환 (date포맷)

SELECT  TRUNC(TO_DATE('2013-06-30'), 'YYYY') T1,
        TRUNC(TO_DATE('2013-07-01'), 'YY') T2,
        TRUNC(TO_DATE('2013-07-01'), 'YEAR') T3,
        TRUNC(TO_DATE('2013-07-01'), 'MONTH') T4,
        TRUNC(TO_DATE('2013-07-01'), 'MON') T5,
        TRUNC(TO_DATE('2013-07-01'), 'MM') T6,
        TRUNC(TO_DATE('2013-05-29'), 'DAY') T7,
        TRUNC(TO_DATE('2013-05-29'), 'DD') T8,
        TRUNC(TO_DATE('2013-05-29'), 'DDD') T9
FROM    dual;

--R1       R2       R3       R4       R5       R6       R7       R8       R9      
---------- -------- -------- -------- -------- -------- -------- -------- --------
--13/01/01 14/01/01 14/01/01 13/07/01 13/07/01 13/07/01 13/05/26 13/05/29 13/05/29
--
--T1       T2       T3       T4       T5       T6       T7       T8       T9      
---------- -------- -------- -------- -------- -------- -------- -------- --------
--13/01/01 13/01/01 13/01/01 13/07/01 13/07/01 13/07/01 13/05/26 13/05/29 13/05/29



3-4. 변환함수 
오라클 연산시 묵시적 자동 형변환을 하지만, 사용자가 직접 명시적으로 형변환 할때
사용하는 함수

[묵시적 형변환 예시]
SELECT 1+'1' -- 먼저 1이 (숫자) 에 맞게 '1'를 숫자 묵시적 형변환
FROM    dual;

[명시적 형변환 함수]
--CHAR: 캐릭터~ vs 차~
--VARCHAR2(50) : 바~캐릭터 vs 바차~
3-4-1.TO_CHAR(date [, fmt]) : 날짜를 문자로 변환하는 함수 ★
※ 교재30p. fmt 표를 참조!
1) 날짜를 문자로 명시적 변환


[예제3-27]
1-1) 변환함수 사용
SELECT TO_CHAR(SYSDATE) CHAR1,
        TO_CHAR(SYSDATE, 'YYYY') CHAR2,
        TO_CHAR(SYSDATE, 'YY-MM-DD') CHAR3,
        TO_CHAR(SYSDATE, 'YYYY-MONTH-DAY HH24:MI:SS') CHAR4
FROM    dual;

1-2) 설정을 바꾸어서 하려면? 매번 가능? 불가능~
SELECT *
FROM v$nls_parameters;

ALTER SESSION SET DATE_FORMAT='YY-MM-DD HH:MI:SS';

2) 숫자를 문자로 명시적 변환 : $, ,(천단위)

[예제3-28]
SELECT  TO_CHAR(100000, '$999,999,999,999') NUM_FMT1,
        TO_CHAR(100000, 'L999,999,999,999') NUM_FMT2
FROM    dual;

SELECT *
FROM v$nls_parameters; -- NLS_CURRENCY : ￦

SELECT employee_id, TO_CHAR(salary, '$999,999') salary, department_id
FROM    employees
WHERE   department_id = 80;


3-4-2.TO_DATE(char, fmt) : 문자를 날짜로 변환하는 함수 / 날짜 형식 ★
1) 문자를 날짜로 변환

3-4-3.TO_NUMBER(char) : 문자를 숫자로 변환하는 함수
1) 문자를 숫자로 명시적 변환

※ 자주 사용하지 않지만, TO_CHAR() / TO_DATE()는 꼭 암기!

----------------- 변환함수 정리 --------------------
--※ 숫자 --> 날짜 변환 : 오류!
--      TO_CHAR()        TO_DATE()
--숫자              문자             날짜
--      TO_NUMBER()      TO_CHAR()
---------------------------------------------------



3-4. NULL 관련 함수
-- exp : expression / 표현식 [숫자,문자,연산자,함수 등을 사용하는]
3-4-1. NVL(exp1, exp2) : exp1가 NULL 이면 exp2를 반환, exp1이 NULL 아니면 exp1을 반환하는 함수
* NVL 함수의 파라미터는 데이터의 유형이 같아야 한다.
-- EMPLOYEES 테이블에 NULL 이 있는 컬럼
-- 1) commission_pct : 상여율   / _pct : percentage
-- 2) department_id : 부서코드 (Kimberly Grant?)
-- 3) manager_id : 매니저 코드
--SELECT employee_id, last_name, manager_id, commission_pct, department_id
--FROM    employees
--WHERE manager_id IS NULL;

[예제3-31] 커미션 금액이 1000 미만인 사원의 사번, 이름, 급여, 커미션율, 커미션 금액을
조회하시오
※ 커미션 금액 컬럼은 없음!! 급여 x 커미션 = 보너스(금액)
SELECT  employee_id, 
        last_name, 
        salary, 
        department_id,
        commission_pct,
        salary * NVL(commission_pct, 0) "커미션 금액"
FROM    employees
WHERE   salary * NVL(commission_pct, 0) < 1000; --78 rows


3-4-2. NVL2(exp1, exp2, exp3) : exp1이 NULL이면 exp3을 반환하고, exp1이 NULL이 아니면
exp2를 반환하는 함수
* salary와 커미션 금액을 합한 급여 ==> 총 급여, 커미션을 받지 않는 사원은 salary가
총 급여가 된다.

SELECT  employee_id, 
        last_name, 
        department_id,
        salary, 
        NVL(commission_pct, 0) commission,
        salary * NVL(commission_pct, 0) bonus,
        NVL2(commission_pct, salary+(salary*commission_pct), salary) total_salary
FROM    employees
ORDER BY total_salary ASC, bonus DESC;

3-4-3. COALESCE(exp1, exp2, exp3, ...) : 입력받은 파라미터중 첫번째로 NULL이 아닌
파라미터를 반환하는 함수
* NULL 아닌 값은 한개쯤 존재한다(있어야 한다)
* 모든 파라미터가 NULL 이면 , NULL 반환
--SELECT COALESCE(null, null, null, 'aaaa')
--FROM    dual;

[예제3-35]
SELECT  COALESCE('A', 'B', NULL) first,
        COALESCE(NULL, 'B', 'C') second,
        COALESCE(NULL, NULL, 'C') third
FROM    dual;        

[연습문제3-4]
1. 사원의 사번, 이름, 부서(코드), 매니저 코드를 조회하는 쿼리를 작성하시오
(단, 매니저가 있는 사원은 Manager, 매니저가 없는 사원은 No Manager로 표시한다)
-- manager_id : null인 사원은 Steven King [급여도 제일 많이 받음, 24000$]
-- Steven King ==> 대표(사장님, 
SELECT  employee_id, 
        first_name, 
        job_id,
        department_id, 
        manager_id,
        NVL2(manager_id, 'manager', 'no manager') "비고"
FROM    employees;


3.6 DECODE() 와 CASE
-- 일반적인 프로그래밍 언어에서 조건에 따른 명령을 실행 : IF ~ ELSE IF ~
/*
if(조건식1) {
    true일때
} else if (조건식2) {
    true일때
} else {
    일치하는 조건이 없을때 (=default)
}
*/

-- 오라클에서는 DECODE 또는 CASE로 같은 기능을 한다.

3-6-1. DECODE(exp, search1, result1, search2, result2, ... [,default]) :
exp 표현식(=값,연산자,함수..)을 검사하여 search1과 일치하면 result1을 반환,
search2와 일치하면 result2를 반환하고..(그렇게 검사하고 일치하는 값을 반환)
모든 search와 일치하지 않으면 default 를 반환한다.
* default는 생략할 수 있는데, 생략하는 경우 일치하는 search 값을 반환하고 없으면
null을 반환한다. ==> 가급적이면 default를 명시하는게 좋겠다.

* 총급여 = 급여 + 커미션(=보너스, 수수료)
* 커미션 금액 = 급여 * commission_pct(=커미션율)

[예제3-36] 보너스 지급에 있어서 20번 부서는 급여의 20%를 보너스로 지급하고,
                            30번 부서는 급여의 30%를 보너스로 지급하고,
                            40번 부서는 급여의 40%를 보너스로 지급하고,
                            그 외의 부서는 보너스를 지급하지 않는다.
-- 자동정렬 : (블럭 씌우고)CTRL + F7
SELECT  employee_id,
        last_name,
        decode(department_id, 20, salary * 0.2, 
                              30, salary * 0.3,
                              40, salary * 0.4, 
                               0) bonus
FROM    employees
ORDER BY 3 DESC;

3-6-2. CASE : 함수보다 더 큰 개념을 가진 표현식이다....(?)
DECODE에서는 동등 비교만 할 수 있으나 CASE는 더 다양한 비교연산(>, <, !=,...)를 할 수 있다.
-- CASE 형식 1. 동등비교 (구분하는 ,가 없다)
CASE exp WHEN search1 THEN result1
         WHEN search2 THEN result2, ...
         [ELSE default]
END

-- CASE 형식 2. 다양한 비교연산(>,<,>=,<=)
CASE WHEN condition1 THEN result1
     WHEN condition2 THEN result2, ...
     [ELSE default]
END     

* DECODE를 CASE 표현식으로 바꿔보자 (20번 부서는 급여의 20%를 보너스로, 30번 30%,...)
-- SYSDATE vs SYSDATE() : 파라미터로 전달할 필요가 없는 함수

[예제3-37]
-- 동등비교 : DECODE와 같음.
SELECT  employee_id,
        last_name,
        salary,
        department_id,
        CASE department_id WHEN 20 THEN salary * 0.2
                           WHEN 30 THEN salary * 0.3
                           WHEN 40 THEN salary * 0.4
                           ELSE 0
        END bonus                           
FROM    employees
ORDER BY department_id;

-- BETWEEN 시작값 AND 마지막값 : 포함되는 값 (시작값 ~ 마지막값)
* 보너스 지급에 있어  30번 미만 급여의 10%를 보너스로 지급
                   30번 부터 50번 부서까지는 급여의 20%를 보너스로 지급
                   60번 부터 80번 부서까지는 급여의 30%를 지급하고
                   그 외의 부서는 40%를 지급한다고 한다.
* 조건 연산자를 사용하는 CASE를 이용해 문제를 해결하시오~                   

SELECT  employee_id,
        last_name,
        salary,
        department_id,
        CASE WHEN department_id < 30 THEN salary * 0.1
             WHEN department_id BETWEEN 30 AND 50 THEN salary * 0.2
             WHEN department_id BETWEEN 60 AND 80 THEN salary * 0.3             
             ELSE salary * 0.4
        END bonus
FROM    employees;



