select employee_id, last_name || first_name name from employees; -- where employee_id=10;

--부서가 60번인 부서에 속한 
--사원들의 정보(사번, 성명, 업무코드, 업무제목, 급여, 입사일자) 조회
--오라클 조인형식
--from절에 table목록을 준비한다
--join조건절: where 
select employee_id, last_name || first_name name 
					, e.job_id, salary, hire_date, job_title 
from employees e, jobs j
where department_id = 60
and e.job_id = j.job_id
;

-- 5 * 19 : cartesian product
desc employees;
--ansi형식
--from 절 조인할 table간 조인형식을 지정
--조인형식: equi: inner join
--        outer: left/right outer join
--조인조건절: on절 /using절
--   on절: 컬럼명이 두 테이블에 모두 존재하는 경우 table명을 반드시 명시해야만 한다
--   using절: 조인조건에 사용한 컬럼명이 똑같은 경우- table명을 절대로 명시해서는 안된다
--데이터행의 제한: where절
select employee_id, last_name || first_name name 
					, e.job_id, salary, hire_date, job_title 
from employees e inner join jobs j 
on e.job_id = j.job_id
where department_id = 60
;

select employee_id, last_name || first_name name 
					, job_id, salary, hire_date, job_title 
from employees e inner join jobs j 
using (job_id)
where department_id = 60
;

--select절에 서브쿼리(스칼라서브쿼리)
select employee_id, last_name || first_name name 
					, job_id, salary, hire_date
                    , (select job_title from jobs where job_id=e.job_id) job_title 
from employees e
where department_id = 60
;

select employee_id, email, phone_number, salary
from employees
where employee_id=100;

--100번 사원의 이메일, 전화번호, 급여를 변경
update employees 
set email = 'king@naver.com'||employee_id, phone_number = '010.1234.5678', salary = 8000
where department_id = 60;
rollback;

desc employees;
--새로운 사원정보 등록
--성:홍, 명:길동, 이메일:hong@naver.com, job_id: IT_PROG
-- 부서코드 : 60, 입사일자:오늘날짜
insert into employees 
(employee_id, last_name, first_name, email
, job_id, department_id)
values (employees_seq.nextval, '홍', '길동', 'hong@naver.com'
, 'IT_PROG', 60);

alter table employees modify( hire_date default sysdate);

select * from employees 
order by employee_id desc;
rollback;   




select * from employees;

-- 사원의정보 + 부서명, 업무제목, 상급관리자사번, 상급관리자성명 조회
select last_name||' '||first_name name, department_name, e.* 
from jobs j, employees e, departments d
where e.department_id = d.department_id(+)
and e.job_id = j.job_id
and employee_id = 100
;

select d.location_id,city, e.last_name||' '||e.first_name name, job_title, department_name
        , e.manager_id, m.employee_id, m.last_name||' '||m.first_name manager_name        
        , e.* 
--from employees e left outer join departments d
from departments d right outer join employees e on e.department_id = d.department_id
inner join jobs j  on e.job_id = j.job_id
left outer join employees m on e.manager_id = m.employee_id
left outer join locations l on d.location_id=l.location_id
where e.employee_id = 101
;
   
select count(*) from employees;   
   
   