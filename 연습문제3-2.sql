[연습문제3-2] 다음 문제를 해결하시오~

1. 사원 테이블에서 이름(first_name)이 A로 시작하는 모든 사원의 이름과 이름의 길이를 
조회하시오
-- LIKE 연산자 + %,_, [ESCAPE]
SELECT first_name, LENGTH(first_name) LEN, LENGTHB(first_name) "LEN BYTE"
FROM    employees
--WHERE   first_name LIKE 'A%'; -- 10rows
--WHERE   NOT first_name LIKE 'A%'; -- 97rows
WHERE   NOT first_name LIKE 'a%'; -- 97rows



2. 80번 부서원의 이름과 급여를 조회하는 쿼리문을 작성하시오
(단, 급여는 15자 길이로 왼쪽에 $ 기호가 채워진 형태로 표시되도록 한다)
--DESC employees;
SELECT  first_name, 
        salary salary1,
        LPAD(salary, 15, '$') salary2,
        department_id
FROM    employees
WHERE   department_id = 80; --34rows



3. 60번, 80번, 100번 부서에 소속된 사원의 사번, 이름, 전화번호, 전화번호의 지역번호를
조회하시오
(단, 지역번호는 phone_number 컬럼에서 조회하고 "Local Number" 컬러이라고 표시해야함)
515.124.4169 --------> 515
590.423.4568 --------> 590   / 지역번호
011.44.1344.498718 --> 011
0404.33.1350.8877  --> 0404 -- employees 전화번호는 모두 3자리 지역번호!

SELECT  employee_id,
        first_name,
        phone_number,
        SUBSTR(phone_number, 1, 3) "Local Number1",
        SUBSTR(phone_number, 1, INSTR(phone_number, '.', 1, 1) - 1) "Local Number2",
        department_id
FROM    employees
WHERE   department_id IN (60, 80, 100);

-- INSTR() 으로 .의 위치를 확인
SELECT INSTR(phone_number, '.', 1, 1) INSTR1
FROM    employees;
1234
515.124.4169 --------> 515



