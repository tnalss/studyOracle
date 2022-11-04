--[연습문제8-1]
-- 
--1. EMP 테이블에서 다음과 같은 행을 저장한다(교재를 보고..)
INSERT INTO EMP (EMP_ID, FNAME, LNAME, HIRE_DATE, SALARY)
VALUES (400, 'johns', 'Hopkins', TO_DATE('2008/10/15','RR/MM/DD'), 5000);
INSERT INTO EMP (EMP_ID, FNAME, LNAME, HIRE_DATE, SALARY)
VALUES (401, 'Abraham', 'Lincoln', TO_DATE('2010/03/03','RR/MM/DD'), 12500);
INSERT INTO EMP (EMP_ID, FNAME, LNAME, HIRE_DATE, SALARY)
VALUES (402, 'Tomas', 'Edison', TO_DATE('2013/06/21','RR/MM/DD'), 6300);

SELECT *
FROM EMP
ORDER BY SALARY;


--2. EMP 테이블의 사번 401번 사원의 부서코드를 90, 업무코드를 SA_MAN 으로 변경하고,
--데이터행의 저장을 확정한다.
UPDATE EMP
SET DEPT_ID = 90,
    JOB_ID = 'SA_MAN'
WHERE EMP_ID = 401;    



--3. EMP테이블의 급여가 8000 미만인 모든 사원의 부서코드는 80으로 변경하고, 급여는 employees
--테이블의 80번 부서의 평균 급여를 가져와 변경한다.
--(단, 평균 급여는 반올림된 정수를 사용한다)
--ROLLBACK;
UPDATE EMP
SET DEPT_ID=90, -- 80으로 수정! 2번 문제에 90 어쩌구,..3번에서는 80번 맞음.
    SALARY = ( SELECT ROUND(AVG(salary)) avg_sal
               FROM hr.employees
               WHERE department_id=80 )
WHERE   SALARY < 8000;    



--4. EMP 테이블의 2010년 이전 입사한 사원의 정보를 삭제한다.
DELETE EMP
WHERE  TO_CHAR(HIRE_DATE, 'YYYY') < '2010';

--SELECT TO_CHAR(HIRE_DATE, 'YYYY')
--FROM EMP;
SELECT *
FROM EMP
ORDER BY HIRE_DATE;

-- 5. HR.EMPLOYEES 정보를 참고해서 NULL 값을 모두 업데이트 하시오!
-- 사번이 402번인 사원의 업무코드를 IT_PROG로 변경하시오
-- 급여가 10000인 사원의 부서를 20번으로 변경하시오

UPDATE EMP
SET JOB_ID='IT_PROG'
WHERE EMP_ID=402;

UPDATE EMP
SET DEPT_ID=20
WHERE SALARY=10000;

-- 최종 확인 
SELECT *
FROM EMP;

-- 최종 확정
COMMIT;