2-4. 데이터 정렬
데이터가 입력된 순서대로 조회가 됨 ==> 원하는 순서로 조정하기 위함.
ORDER BY 절은 SELECT 문의 가장 마지막에 위치한다.

1) 형식
SELECT 컬럼명1, 컬럼명2, ...
FROM 테이블명
WHERE   조건
ORDER BY 정렬대상(=정렬 기준);

2) 정렬방법
- ASC : Ascending / 오름차순 [=기본값, 생략가능]
- DESC : Descending / 내림차순

[예제2-40] 80번 부서의 사원 정보에 대해 이름을 오름차순으로 정렬하여 조회하시오
-- 오름차순 : A -> Z
-- ORDER BY 전 : 데이터베이스에 입력된 데이터의 순서대로~
SELECT employee_id, first_name, job_id, department_id
FROM    employees
WHERE   department_id = 80;

-- ORDER BY 적용 : ASC (=기본값), DESC
SELECT employee_id, first_name, job_id, department_id
FROM    employees
WHERE   department_id = 80
--ORDER BY first_name; -- ASC : 기본값 / 생략가능
ORDER BY first_name ASC; -- ASC 명시

[예제2-41] 80번 부서의 사원 정보에 대해 이름을 내림차순으로 정렬하여 조회하시오
--내림차순 : Z --> A
SELECT employee_id, first_name, job_id, department_id
FROM    employees
WHERE   department_id = 80
ORDER BY first_name DESC; -- DESC 명시, 34rows


* ORDER BY 절에 Alias를 사용하여 정렬할 수 있다.
[예제2-42] 60번 부서의 사원정보에 대해 년급여(=연봉)을 오름차순으로 정렬하여 조회하시오
SELECT  employee_id emp_id,
        last_name,
        salary * 12 annual_salary,
        department_id dept_id
FROM    employees
WHERE   department_id = 60
--ORDER BY annual_salary;
ORDER BY 3;

* ORDER BY 절에 컬럼의 위치(=번호)를 사용하여 정렬할 수 있다.
[예제2-43] 사원테이블에서 부서는 오름차순, 월급여는 내림차순으로 정렬하여 사원정보를 조회하시오

SELECT  employee_id, last_name, salary, department_id dept_id
FROM    employees
--ORDER BY department_id, 3 DESC;
--ORDER BY dept_id ASC, 3 DESC;
ORDER BY 4 ASC, 3 DESC;







