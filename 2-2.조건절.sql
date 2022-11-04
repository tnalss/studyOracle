2.2 조건절

전체 데이터에서 특정 행 데이터를 제한하여 조회하기 위한 조건절
※조건절은 연산자와 연산의 대상으로 구성된다.
--SELECT 컬럼명1, 컬럼명2, ...
--FROM 테이블명
--WHERE 조건;

[예제2-3] 80번 부서의 사원 정보를 조회하시오 (부서코드가 80인 사원의 정보를 조회하시오)
SELECT employee_id, first_name, salary, department_id
FROM    employees
WHERE department_id = 80; -- DEPARTMENTS 테이블에서 부서코드를 확인후 자유롭게 조회

DESC departments;
-- * : asterisk, 애스터리스크, 모든 문자(=만능 문자)
SELECT employee_id, first_name, salary, department_id
FROM    employees
WHERE department_id = 60;

:: 조건절을 구성하는 항목의 분류
1) 컬럼, 숫자, 문자
2) 산술연산자(+,-,*,/), 비교연산자(=, >=, <=, <, >), 연결연산자(||)
3) AND, OR, NOT
4) LIKE, IN, BETWEEN, EXISTS, NOT
5) IS NULL, IS NOT NULL
6) ANY, SOME, ALL
7) [일반]함수 / 통계(=집계) 함수