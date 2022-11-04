계층형 쿼리(=Hierarchical Query)
* 오라클에서 제공하는 기능

수직 형태의 구조 (부모-자식, 상사-직원) 데이터들을 분류하고 조회하는 오라클의 쿼리
* 종속관계

1) 조인 연산 : 사원테이블 (manager와 employee 관계) <--> 계층형 쿼리 [비교] : 비식별관계
     └ 사원정보, 매니저 정보
2) SET 연산 : 수평적인, 동등한 관계의 연산 [컬럼의 수, 데이터 타입 일치]

-- 사원 테이블을 계층구조로 조회
SELECT  'ORACLE' COMPANY,
--        employee_id, 
        LPAD(' ', 2 * (LEVEL-1)) || e.first_name name, -- 
        e.manager_id,
        e.department_id,
        d.department_name
FROM employees e, departments d
WHERE   e.department_id = d.department_id
START WITH e.manager_id IS NULL         -- 시작점 / 루트 노드 찾기
CONNECT BY PRIOR e.employee_id =  e.manager_id;   -- 관계, 부모로 식별하는 컬럼쪽에 PRIOR 붙이기

-- 계층형 쿼리의 의사컬럼들 : 검색~! <하지만, 그렇게 우리의 수업, 프로젝트에서 중요하게 사용x >











