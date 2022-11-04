--[연습문제6-4]
--1. 급여가 적은 상위 5명 사원의 순위, 사번, 이름, 급여를 조회하는 쿼리문을 인라인 뷰
--서브쿼리를 이용해 작성하시오
-- 1-1. ROWNUM을 사용해서 조회
SELECT ROWNUM, e.employee_id, e.first_name, e.salary
FROM    ( SELECT employee_id, first_name, salary
          FROM    employees
          ORDER BY salary ) e -- e라는 별칭으로 임시테이블로부터 조회
WHERE ROWNUM <= 5;          

-- 1-2. RANK 함수 : RANK(), DENSE_RANK()   
SELECT e.*
FROM    ( SELECT employee_id, 
          first_name, 
          salary,
          NVL(commission_pct, 0) comm_pct,
          AVERAGE_RANK() OVER(order by salary) rank          
          FROM    employees ) e
WHERE   ROWNUM <= 5;
          --ORDER BY salary



--2. 부서별로 가장 급여를 많이 받는 사원의 사번, 이름, 부서번호, 급여, 업무코드를 조회하는
--쿼리문을 인라인 뷰 서브쿼리를 사용하여 작성하시오

-- 2-1. ROWNUM 으로 해결 : 인라인 뷰 서브쿼리
SELECT  MAX(salary) max_salary
FROM    employees
GROUP BY department_id
ORDER BY 1;

SELECT  e.employee_id, e.first_name, e.department_id, e.salary, e.job_id
FROM    employees e, ( SELECT  MAX(salary) max_salary
                       FROM    employees
                       GROUP BY department_id ) m
WHERE   e.salary = m.max_salary
ORDER BY e.department_id;

-- 2. 다중컬럼 서브쿼리
-- 부서별 최대 급여를 조회 : (다중 행) 다중 컬럼을 반환
SELECT  department_id, MAX(salary) max_salary
FROM    employees
GROUP BY department_id
ORDER BY 1;


SELECT *
FROM    employees
WHERE commission_pct IS NULL;

-- 서브쿼리: 위치에 따른 구분, 연관성에 따른 구분, 반환결과값에 따른 구분
-- department_id가 NULL 인 사원 : 178번 Kimberely Grant
-- NULL 처리 함수 : NVL(expr1, expr2) : expr1 NULL 이면 expr2를 아니면 expr1 반환
--                   └커미션 금액(=수수료, 보너스)를 지급할때 , NULL을 0으로 처리
--                 NVL2(expr1, expr2, expr3) : expr1이 NULL expr3을 아니면 expr2를 
--                   └manger의 유무 표현
--                 COALESCE(null, null, expr1, null) : 최초로 null 아닌 값 expr1 반환 / 모두가 null이면 null 반환
--                   └어디에 쓸수 있을까?   회워정보 전화번호 phone_number    tel     phone  
--                                                         3627797     (null)     (null)
--                                                         (null)       3627798   (null)
--                                                         (null)       (null)   3627799       
--            SELECT COALESCE(phone_number, tel, phone, mobile) "연락처"
SELECT  e.employee_id, e.first_name, e.department_id, e.salary, e.job_id
FROM    employees e, ( SELECT  department_id, MAX(salary) max_salary
                       FROM    employees
                       GROUP BY department_id ) m
WHERE   e.salary = m.max_salary
AND     NVL(e.department_id, 0) = NVL(m.department_id, 0)
ORDER BY e.department_id;  -- kimberely 있는 12 rows


-- 2-2. 다중 컬럼 서브쿼리 : 매니저가 없는 사원이 근무하는 부서정보(부서코드, 부서이름)
-- INSERT, UPDATE, DELETE 할때는 자주 사용
SELECT  e.employee_id, e.first_name, e.department_id, e.salary, e.job_id
FROM    employees e
WHERE   (e.department_id, e.salary) IN ( SELECT  department_id, MAX(salary) max_salary
                                         FROM    employees
                                         GROUP BY department_id )
ORDER BY 3;    -- kimberely 없는 11 rows                                      



