-- 학사 관리 시스템
-- 오라클 데이터베이스 (종합)실습과제 : 11.04
-- 물리 모델링 
-- ※ 정규화 : NULL값이 들어가지 않게, M:N의 관계를 1:N으로 만드는 과정들...(시험에서는, 도부이결다조~)

-- 학생 테이블 : STUDENT
-- 컬럼 : STUDENT_ID(PK), STUDENT_NAME, STUDENT_PHONE, 학과(어느 소속!)
CREATE TABLE students (
    student_id NUMBER(4),
    student_name VARCHAR2(30) NOT NULL,
    student_phone CHAR(11) NOT NULL,
    student_height NUMBER,
--    student_department NUMBER REFERENCES departments (department_id), -- 아직 학과가 없음
    CONSTRAINT student_id_pk PRIMARY KEY (student_id)
);

ALTER TABLE students
ADD student_dept_id NUMBER(4) REFERENCES departments (department_id);

-- ALTER TABLE로 제약조건을 추가/제거

CREATE TABLE departments (
    department_id NUMBER(4),
    department_name VARCHAR2(100) NOT NULL,
    --departments_chairman CHAR(11) REFERENCES professors (professor_id), -- 아직 교수없음
    CONSTRAINT department_id_pk PRIMARY KEY (department_id)
);

-- (학과)교수 테이블
CREATE TABLE professors (
    professor_id NUMBER(4),
    professor_name VARCHAR2(30) NOT NULL,
    professor_major VARCHAR2(50) NOT NULL, -- 전공
    professor_dept_id NUMBER(4) REFERENCES departments (departments_id),
    CONSTRAINT professor_id_pk PRIMARY KEY (professor_id)
);

-- 개설과목 테이블
CREATE TABLE class (
    class_id NUMBER(4),
    class_name VARCHAR2(100),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,  
    class_professor_id NUMBER(4),      
    CONSTRAINT class_id_pk PRIMARY KEY (class_id),
    CONSTRAINT professor_id_fk FOREIGN KEY (class_professor_id) REFERENCES professors (professor_id)
);

-- 수강(내역) 테이블
CREATE TABLE  registerations (
    reg_student_id NUMBER(4),
    reg_class_id NUMBER(4),
    CONSTRAINT reg_complex_pk PRIMARY KEY (reg_student_id, reg_class_id),
    CONSTRAINT reg_student_id_fk FOREIGN KEY (reg_student_id) REFERENCES students (student_id),
    CONSTRAINT reg_class_id_fk FOREIGN KEY (reg_class_id) REFERENCES class (class_id)
);







