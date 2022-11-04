2-3. 연산자
2-3-1. 산술연산자 : +, -, *, /
산술연산자는 SELECT 목록, 조건절에 사용할 수 있다.

[예제2-4] 80번 부서 사원의 한 해 동안 받은 급여를 조회하시오
SELECT employee_id 사번, last_name 성, salary 월급여, salary * 12 연봉
FROM    employees
WHERE   department_id = 80; -- 34 rows : 34명의 사원정보 조회

[예제2-5] 한 해 동안 받은 급여(=연봉)이 120000인 사원 정보를 조회하시오
SELECT employee_id, last_name, salary * 12 annual_salary
FROM    employees
WHERE   salary * 12 = 120000;

연결 연산자 : ||
컬럼이나 문자열에 사용하여 연결된 문자열의 결과를 얻는다.
SELECT 목록과 조건절에 사용할 수 있다.

[예제2-6] 사번이 101번인 사원의 성명을 조회하시오 (last_name: 성, first_name : 이름)
SELECT  employee_id, first_name, last_name, first_name ||' '|| last_name full_name
FROM    employees
WHERE   employee_id = 101;

DESC employees;

SELECT  employee_id, first_name, last_name
FROM    employees;

----------------------------------------------------------
컬럼 별칭(=Column Alias): 컬럼에 이름대신 별칭을 붙여서 사용할때
* 공백을 두고 사용한다.
* 키워드 as 또는 AS 사용한다.
* 큰 따옴표를 사용한다.
----------------------------------------------------------
SELECT  employee_id "사번", first_name AS 이름, last_name as "성"
FROM    employees;

[예제2-7] 사번이 103번인 사원의 성명과 입사일, 부서코드를 조회하시오
SELECT employee_id 사번, first_name || ' ' || last_name 성명, hire_date 입사일
FROM    employees
WHERE   employee_id = 103;

[예제2-8] 사번이 100번인 사원의 성과 한 해 동안 받은 급여를 조회하시오
SELECT  employee_id, last_name as name, salary * 12 annual_salary
FROM    employees
WHERE   employee_id = 100;


비교 연산자 : =, >=, <=, >, <

[예제2-9] 급여가 3000 이하인 사원의 정보
SELECT  employee_id, last_name, salary, department_id
FROM    employees
WHERE   salary <= 3000; -- 30 : 구매부/자재부(=Purchasing), 50 : 물류부(=Shipping)

[예제2-10] 부서코드가 80번 초과인 사원의 정보
-- 부서코드 : 10 ~ 270번까지 27개가 존재 [Departments] / 10씩 증가
SELECT  employee_id, last_name, salary, department_id, job_id
FROM    employees
WHERE   department_id > 80;


* 문자 데이터와 날짜 데이터는 작은 따옴표(=Single Quote) 사용
  └ 큰따옴표는(=Double Quotation) Alias명 지정할때
* 연결연산자(||)로 새로운 컬럼 Alias를 지정
* 문자 데이터는 대소문자를 구분한다(★)

[예제2-11] 성(last_name)이 King인 사원의 정보를 조회하시오
※ 컬럼 255개 까지 사용가능 
-- 문자데이터 : 작은 따옴표
SELECT  employee_id, last_name, salary, department_id, job_id
FROM    employees
WHERE   last_name = 'King'; -- 2rows : 80/Sales 판매, 90/Executive 경영 

[예제2-12] 입사일이 2004년 1월 1일 이전인 사원의 정보를 조회한다.
-- 날짜데이터 : 작은 따옴표
DESC employees;
SELECT employee_id, last_name, hire_date
FROM    employees
WHERE   department_id = 100;

--EMPLOYEE_ID LAST_NAME                 HIRE_DAT
------------- ------------------------- --------
--        108 Greenberg                 02/08/17  <--> 교재 : 01-JAN-04
--        109 Faviet                    02/08/1

-- NLS : National Language Support [ 도구 > 환경설정 > 데이터베이스 > NLS, 날짜형식/시간형식 참고 ]
-- 만약, 설정을 변경한다 해도 일시적인 (=현재 로그인된 계정 세션에서만 유효, 영구적인 설정변경 x)

-- 06.01.04 이전에 입사한 사원중에서 사번,성,입사일 조회
SELECT employee_id, last_name, hire_date
FROM    employees
--WHERE   hire_date < '01-JAN-04';  -- CTRL+SHIFT+D : Duplicate Line
-- WHERE   hire_date < '01-01-04'; -- NLS 세팅 > 날짜형식 : RR/MM/DD (YY/MM/DD)
-- WHERE   hire_date < '01/01/04'; -- 01년도 01월 04일 이전 입사자를 조회 ==> 없음
WHERE   hire_date < '06/01/04'; -- 01년도 01월 04일 이전 입사자를 조회 ==> 없음

논리 (조건) 연산자 : AND, OR, NOT
AND : 조건 모두 true ==> 최종 true
OR : 하나라도 true ==> 최종 true
NOT : true <--> false

[예제2-13] 30번 부서(=부서코드) 사원중 급여가 10000 이하인 사원의 정보를 조회하시오
SELECT  employee_id,
        first_name ||' '|| last_name NAME,
        salary,
        department_id
FROM    employees
WHERE   department_id = 30
AND     salary <= 10000; -- 5rows
        
[예제2-13] 30번 부서에서 급여가 10000 이하이면서 2005년 이전에 입사한 사원의 정보를 조회하시오
-- 2005년 1월 1일 이전 입사자
-- 2004년 12월 31일 까지 입사자
SELECT  employee_id,
        first_name ||' '|| last_name NAME,
        hire_date,
        salary,
        department_id
FROM    employees
WHERE   department_id = 30
AND     salary <= 10000
AND     hire_date < '05/01/01';


* OR 연산자는 조건 중 하나만 TRUE이면, TRUE를 반환한다.
[예제2-15] 30번 부서나 60번 부서에 속한 사원의 정보를 조회한다.
SELECT employee_id, last_name, department_id, job_id
FROM    employees
WHERE   department_id = 30 -- 구매부서 : ex> 계산원
OR      department_id = 60; -- IT부서 : ex> 프로그래머

* AND 연산자, OR 연산자를 혼합하여 문장을 작성한다.
* AND와 OR 조건이 혼합되어 사용하는 경우 가독성을 위해 소괄호를 붙여주는 것이 좋다.

[예제2-16] 30번 부서의 급여가 10000 미만인 사원과 60번 부서의 급여가 5000 이상인
사원의 정보를 조회하시오

SELECT  employee_id, last_name, salary, department_id dept_id
FROM    employees
WHERE   (department_id = 30 AND salary < 10000)
OR      (department_id = 60 AND salary >= 5000)
OR      (department_id = 90 AND salary >= 15000);
        


범위 조건 연산자 : BETWEEN 초기값 AND 마지막값
-- 범위조건 : ~이상 , ~이하
-- WHERE 조건절 : BETWEEN 초기값 AND 마지막값;
-- 초기값 이상, 마지막값 이하와 같다.

[예제2-18] 사번이 110번 부터 120번 까지의 사원 정보를 조회하시오
-- 논리 연산자로 BETWEEN 처럼 데이터를 조회
SELECT  employee_id emp_id, last_name, salary, department_id dept_id, job_id
FROM    employees
WHERE   employee_id >= 110 AND employee_id <= 120;

[예제2-19] 사번(=employee_id)이 110번 부터 120번 까지의 사원 정보를 조회하시오
--WHERE [조건] BETWEEN 초기값 AND 마지막값;
SELECT  employee_id emp_id, last_name, salary, department_id dept_id
FROM    employees
WHERE   employee_id BETWEEN 110 AND 120;


[예제2-20] 사번이 110에서 120인 사원중, 급여가 5000 에서 10000 사이의 사원 정보를
조회하시오
SELECT  employee_id emp_id, last_name, salary, department_id dept_id
FROM    employees
WHERE   employee_id BETWEEN 110 AND 120
AND     salary BETWEEN 5000 AND 10000; -- 11rows

[예제2-21] 사번이 110번 미만, 120번 초과인 사원의 정보를 조회하시오
SELECT  employee_id emp_id, last_name, salary, department_id dept_id
FROM    employees
--WHERE   NOT employee_id BETWEEN 110 AND 120; -- NOT 조건 BETWEEN 초기값 AND 마지막값
WHERE   employee_id NOT BETWEEN 110 AND 120; -- NOT 조건 BETWEEN 초기값 AND 마지막값
-- 96 rows

* HR 스키마 > EMPLOYEES에 등록된 사원의 총 수는 107 rows
사번이 110 에서 120에 해당하는 사원수는 11 rows
그 외의 사원은 96 rows
총합 107 rows

* BETWEEN 이나 관계연산자로 비교할 수 있는 값은 숫자 데이터, 문자데이터, 날짜데이터이다.

[예제-23] 2005년 1월 1일 이후부터 2007년 12월 31일 사이에 입사한 사원의 정보를 조회하시오
SELECT employee_id emp_id, first_name ||' '|| last_name name, salary, hire_date
FROM    employees
WHERE   hire_date BETWEEN '05/01/01' AND '07/12/31';

* oracle 11g ==> '01-JAN-05'를 묵시적 형변환 <==> TO_DATE('문자'[,형식지정])를
이용해서 명시적으로 형변환!

[예제2-24] TO_DATE() 함수를 이용해 문자데이터를 날짜 데이터로 형변환 하시오
SELECT employee_id emp_id, first_name ||' '|| last_name name, salary, hire_date
FROM    employees
WHERE   hire_date BETWEEN TO_DATE('05-JAN-01') AND TO_DATE('07-DEC-31');

-- NLS 파라미터 조회 : 도구 > 환경설정 > 데이터베이스 > NLS와 같음
-- select * from v$nls_parameters;
-- 변환함수 p.30 CASTING : 형변환 [묵시적 , 명시적(v)]
-- TO_CHAR() : 숫자데이터, 날짜데이터 --> 문자로 형변환
-- TO_NUMBER() : 문자데이터 --> 숫자로 형변환
-- TO_DATE() : 문자데이터 --> 날짜로 형변환


IN 조건 연산자 : 여러개의 값 중에 일치하는 값이 있는지 비교할때 사용하는 연산자
IN (값1, 값2, 값3, ...) 형태로 비교하는 값의 목록을 나열한다.
[예제2-25] 30번 부서원 또는 60번 부서원 또는 90번 부서원
-- 30 : 구매부 / 단순직무
-- 60 : IT부  / 중간정도(?)
-- 90 : 경영부 / 중요직무

SELECT employee_id emp_id, 
        first_name||' '||last_name name,
        salary,
        department_id dept_id
FROM    employees
WHERE   department_id = 30 
OR      department_id = 60
OR      department_id = 90; -- 14rows(행) selected(선택)되었습니다.

[예제2-26] 예제2-25를 IN 조건 연산자를 사용해서 다시한번 작성해보시오
SELECT employee_id emp_id, 
        first_name||' '||last_name name,
        salary,
        department_id dept_id
FROM    employees
WHERE   department_id IN (30,60,90); --14개 행이 선택되었습니다.

* IN 연산자는 OR 연산자와 동일한 기능을 수행한다고 볼 수 있다. 비교할 값들이 많을때
OR 연산자를 사용하면 SQL 문장이 길어지고 복잡해지는데 IN 연산자를 사용하면
문장이 깔끔해지고 가독성이 높아진다.

* 1) IN 연산자 바로 앞이나 2)컬럼명 앞에 NOT 연산자를 두어 반대되는 조건을 만든다.
[예제2-27] 30번, 60번, 90번 부서 이외의 부서에 속한 사원의 정보를 조회하시오
SELECT employee_id emp_id, 
        first_name||' '||last_name name,
        salary,
        department_id dept_id
FROM    employees
--WHERE   department_id IN (30,60,90) -- 30,60,90 번 부서원
WHERE   department_id NOT IN (30,60,90); -- 30,60,90 번 부서원이 아닌 부서원
-- 94 rows(나머지 부서원) + 14rows (30,60,90부서원) : 106+1 vs 107 rows
-- 1명이 부서가 배정되지 않는 사원(이지만, 근로자) : Kimberely Grant 

-- [블럭씌우고] CTRL + F7 : 자동 포맷팅 (for 가독성)

SELECT employee_id   emp_id,    first_name    || ' '    || last_name  name,
    salary,department_id dept_id
FROM    employees; -- 107 rows


LIKE 연산자 : 컬럼값들 중 특정 패턴에 속하는 값을 조회하고자 할때 LIKE 연산자를 사용
1) % : 여러개의 문자열을 나타낸다.
2) _ : 하나의 문자를 나타낸다.

[예제2-28] 이름이 K로 시작하는 사원 정보를 조회하시오
-- 문자 데이터는 대,소문자를 구분함!

SELECT  employee_id emp_id,
        first_name||' '||last_name name, 
        salary,
        phone_number phone
FROM    employees
--WHERE   first_name LIKE 'K%'; --7 rows
WHERE   first_name LIKE 'S%'; --7 rows, S로 시작하는

[예제2-29] 이름이 s로 끝나는 사원의 정보를 조회하시오
SELECT  employee_id emp_id,
        first_name||' '||last_name name, 
        salary,
        phone_number phone
FROM    employees
--WHERE   last_name LIKE '%s'; --18 rows
WHERE   last_name LIKE '%a'; --18 rows, a로 끝나는

[예제2-30] 이름이 b가 들어가 있는 사원정보를 조회하시오
SELECT  employee_id emp_id,
        first_name||' '||last_name name, 
        salary,
        phone_number phone
FROM    employees
--WHERE   first_name||' '||last_name LIKE '%b%'; --3 rows
WHERE   first_name||' '||last_name LIKE '%t%'; --3 rows


-- email, phone_number 확인
SELECT  employee_id emp_id,
        first_name||' '||last_name name, 
        email, -- 이메일ID
        phone_number phone
FROM    employees;

[예제2-31] 이메일의 세번째 문자가 B인 사원정보를 조회하시오
SELECT  employee_id emp_id,
        first_name||' '||last_name name, 
        email,
        phone_number phone
FROM    employees
--WHERE   email LIKE '__B%'; --3 rows
WHERE   email LIKE '__A%'; --3 rows

[예제 2-32] 이메일의 뒤에서부터 세번째 문자가 B인 사원 정보를 조회하시오
-- %
-- _

SELECT employee_id emp_id,
       first_name||' '||last_name name,
       salary,
       email
FROM    employees
WHERE   email LIKE '%B__'; --2rows


* LIKE 역시 BETWEEN, IN 연산자처럼 NOT 연산자와 같이 사용할 수 있다.
1) NOT 조건 LIKE '조건~'
2) 조건 NOT LIKE '조건~'

[예제2-33] 전화번호가 6으로 시작하지 않는 사원의 정보를 조회
SELECT  employee_id emp_id, 
        first_name||' '||last_name name,
        salary, 
        phone_number phone
FROM    employees
--WHERE   phone_number LIKE '6%'; -- 6으로 시작하는
--WHERE   phone_number NOT LIKE '6%'; -- 6이 아닌 다른 번호로 시작하는
WHERE   NOT phone_number LIKE '6%'; -- 6으로 시작하는
        
* %나 _ 자체를 문자열로 조회하고자 할때는 어떻게 할까요?
[예제2-34] JOB_ID에 _A가 들어간 사원정보를 조회하시오
SELECT employee_id, 
        first_name||' '||last_name name,
        salary,
        job_id
FROM    employees
WHERE   job_id LIKE '%_A%';  --FI_ACCOUNT (회계부서_회계사)

-- job_id가 포함된 사원의 정보를 조회
SELECT employee_id, 
        first_name||' '||last_name name,
        salary,
        job_id
FROM    employees;
-- jobs 테이블 조회
SELECT *
FROM    jobs;

* '%_A%' 로 조회된 데이터 행의 결과가 _A 가 아닌 A가 포함된 결과로 귀결!
_를 하나의 문자열이 아닌 문자 자체로 검색을 하려면 (또는 %) ESCAPE 식별자를 사용해야 한다.
WHERE 조건 LIKE '조건/A' ESCAPE '/'

SELECT employee_id, 
        first_name||' '||last_name name,
        salary,
        job_id
FROM    employees
WHERE   job_id LIKE '%\_A%' ESCAPE '\';  --FI_ACCOUNT (회계부서_회계사)
-- 글꼴크기 : 20 --> _ 안보임


NULL 조건 처리

-- 각 부서의 위치 정보를 가진 LOCATIONS 테이블을 사용해, 다음과 같이 조회하시오
SELECT TABLE_NAME
FROM USER_TABLES;

--TABLE_NAME                                                                                                                      
----------------
--REGIONS       : 지역 테이블
--LOCATIONS     : 위치(도시/주/광역시) 테이블
--DEPARTMENTS   : 부서 테이블
--JOBS          : 업무/직무 테이블
--EMPLOYEES     : 사원정보 테이블 (commission_pct, manager_id, department_id)
--JOB_HISTORY   : 업무이력 테이블
--COUNTRIES     : 나라/국가 테이블

-- 구조조회
DESC    locations;
--이름             널?       유형           
---------------- -------- ------------ 
--LOCATION_ID    NOT NULL NUMBER(4)    : 위치코드
--STREET_ADDRESS          VARCHAR2(40) : 주소
--POSTAL_CODE             VARCHAR2(12) : 우편번호 (null)
--CITY           NOT NULL VARCHAR2(30) : 도시명
--STATE_PROVINCE          VARCHAR2(25) : 광역시 vs 주 (null)
--COUNTRY_ID              CHAR(2)      : 국가코드

SELECT *
FROM    locations; --23rows

[예제2-36] 주 정보가 있는 위치테이블에서 조회
SELECT location_id loc_id,
        street_address addr,
        city,
        state_province
FROM    locations
WHERE   state_province LIKE '%'; -- 17rows

* 총 locations에 데이터는 23건, null 데이터 6건 그래서~ 17건이 조회됨.
==> null 데이터는 조회되지 않음 (누락)
==> null 데이터를 조회할때는 별도의 구문인 IS NULL 을 사용한다.

SELECT location_id loc_id,
        street_address addr,
        city,
        state_province
FROM    locations
WHERE   state_province IS NULL; -- 17rows

* NOT을 이용해서 반대되는 결과를 만들수 있다.
1) BETWEEN + NOT
2) IN + NOT
3) LIKE + NOT
4) IS NULL + NOT

[예제 2-39] state_province가 null이 아닌 데이터를 조회하시오
SELECT location_id loc_id,
        street_address addr,
        city,
        state_province
FROM    locations
WHERE   state_province IS NOT NULL; -- 17rows