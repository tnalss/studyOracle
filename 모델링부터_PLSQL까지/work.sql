CREATE TABLE Course(
course_id NUMBER NOT NULL,
course_name VARCHAR2(100),
start_date DATE,
end_date DATE,
professor_id NUMBER NOT NULL);

ALTER TABLE Course ADD CONSTRAINT COURSE_ID_PK PRIMARY KEY(course_id);

CREATE TABLE Department(
department_id NUMBER NOT NULL,
department_name VARCHAR2(100));

ALTER TABLE Department ADD CONSTRAINT DEPARTMENT_ID_PK PRIMARY KEY(department_id);

CREATE TABLE Professor(
professor_id NUMBER NOT NULL,
professor_name VARCHAR2(100),
department_id NUMBER NOT NULL);

ALTER TABLE Professor ADD CONSTRAINT PROFESSOR_ID_PK PRIMARY KEY(professor_id);


CREATE TABLE Student(
student_id NUMBER NOT NULL,
student_name VARCHAR2(100),
height NUMBER,
department_id NUMBER NOT NULL);


ALTER TABLE Student ADD CONSTRAINT STUDENT_ID_PK PRIMARY KEY(student_id);

CREATE TABLE Student_Course(
student_id NUMBER NOT NULL,
course_id NUMBER NOT NULL);


ALTER TABLE Course ADD CONSTRAINT PROFESSOR_ID_FK
FOREIGN KEY(professor_id)REFERENCES Professor(professor_id);

ALTER TABLE Professor ADD CONSTRAINT DEPARTMENT_ID_FK
FOREIGN KEY(department_id)REFERENCES Department(department_id);


ALTER TABLE Student_Course ADD CONSTRAINT COURSE_ID_FK 
FOREIGN KEY(course_id)REFERENCES Course(course_id);

ALTER TABLE Student_Course ADD CONSTRAINT STUDENT_ID_FK 
FOREIGN KEY(student_id)REFERENCES Student(student_id);

ALTER TABLE Student ADD CONSTRAINT fk_student_department 
FOREIGN KEY(department_id)REFERENCES Department(department_id);


insert into department values(1, '수학');
insert into department values(2, '국문학');
insert into department values(3, '정보통신공학');
insert into department values(4, '모바일공학');


insert into student values(1, '가길동', 177, 1);
insert into student values(2, '나길동', 178, 1);
insert into student values(3, '다길동', 179, 1);
insert into student values(4, '라길동', 180, 2);
insert into student values(5, '마길동', 170, 2);
insert into student values(6, '바길동', 172, 3);
insert into student values(7, '사길동', 166, 4);
insert into student values(8, '아길동', 192, 4);

insert into professor values(1, '가교수' ,1);
insert into professor values(2, '나교수' ,2);
insert into professor values(3, '다교수' ,3);
insert into professor values(4, '빌게이츠' ,4);
insert into professor values(5, '스티브잡스' ,3);



insert into course values(1, '교양영어', '2016/9/2', '2016/11/30', 1);
insert into course values(2, '데이터베이스 입문', '2016/8/20','2016/10/30', 3);
insert into course values(3, '회로이론', '2016/10/20', '2016/12/30', 2);
insert into course values(4, '공업수학', '2016/11/2', '2017/1/28', 4);
insert into course values(5, '객체지향프로그래밍', '2016/11/1', '2017/1/30', 3);


insert into student_course values(1, 1);
insert into student_course values(2, 1);
insert into student_course values(3, 2);
insert into student_course values(4, 3);
insert into student_course values(5, 4);
insert into student_course values(6, 5);
insert into student_course values(7, 5);

select * from student_course;

-- 과제 2-1
--안시 레프트 조인
select s.*,department_name
from student s left join department d
on s.department_id=d.department_id;

-- 과제 2-2
select professor_id
from professor
where professor_name='가교수';


-- 과제 2-3
select d.department_name, count(p.professor_id)
from department d left join professor p
on d.department_id =p.department_id
group by department_name;

-- 과제 2-4
select s.student_id,s.student_name,s.height, s.department_id, d.department_name
from student s left join department d
on s.department_id = d.department_id
where department_name='정보통신공학';

-- 과제 2-5
select p.professor_id,p.professor_name,p.department_id,d.department_name
from professor p left join department d
on p.department_id=d.department_id
where department_name='정보통신공학';


-- 과제 2-6
select department_name
from    student
where  department_id;

select department_id , count(department_id) c
from student
group by department_id
where =max(c);




-- 과제 2-7
select s.student_name, d.department_name
from student s left join department d
on s.department_id = d.department_id
where s.student_name like ('아%');

-- 과제 2-8
select count(student_id)
from student
where height between 180 and 190;

-- 과제 2-9
