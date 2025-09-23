--TASK 1
--1.1
--1)
create database university_main
with
    owner = postgres
    template = template0
    encoding = 'UTF8';

--2)

create database university_archive
with
    connection limit  = 50
    template = template0;

--3)
create database university_test
with
    is_template = true
    connection limit  = 10
;


--1.2
--1)
create tablespace student_data
    location 'C:/pgsql/tablespaces/students';


--2)
create tablespace course_data
    owner postgres
    location 'C:\pgsql\tablespaces\courses';


--3)
create database university_distributed
with
    template = template0
    encoding = 'LATIN9'
    tablespace = student_data
    lc_collate = 'C' -- без них выдают ошибку
    lc_ctype = 'C';

--TASK 2

--2.1

--1)

create table if not exists students(
    student_id serial primary key ,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    phone char(15),
    date_of_birth date,
    enrollment_date date,
    gpa numeric(3,2),
    is_active boolean,
    graduation_year smallint
);


--2)
create table if not exists professors(
    professor_id serial primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    hire_date date,
    salary numeric(20,2),
    is_tenured boolean,
    years_experience integer
);

--3)
create table courses(
    course_id serial primary key ,
    course_code char(8),
    course_title varchar(100),
    description text,
    credits smallint,
    max_enrollment integer,
    course_fee numeric(10,2),
    is_online boolean,
    created_at timestamp without time zone
);

--2.2

--1)
create table class_schedule(
    schedule_id serial primary key ,
    course_id integer,
    professor_id integer,
    classroom varchar(20),
    class_date date,
    start_time time without time zone,
    end_time time without time zone,
    duration interval
);

--2)
create table student_records(
    record_id serial primary key ,
    student_id integer,
    course_id integer,
    semester varchar(20),
    year integer,
    grade char(2),
    attendance_percentage numeric(4,1),
    submission_timestamp timestamp with time zone,
    last_updated timestamp with time zone
);


--TASK 3

--3.1

--students table
--1)
alter table students add column midle_name varchar(30);

--2)
alter table students add column student_status varchar(20);

--3)
alter table students alter column phone type varchar(20);

--4)
alter table students alter column student_status set default 'ACTIVE';

--5)
alter table students alter column gpa set default 0.00;


--professors table
--1)
alter table professors add column department_code char(5);

--2)
alter table professors add column research_area text;

--3)
alter table professors alter column years_experience type smallint;

--4)
alter table professors alter column is_tenured set default false;

--5)
alter table professors add column last_promotion_date date;


--courses table
--1)
alter table courses add column prerequisite_course_id integer;

--2)
alter table courses add column difficulty_level smallint;

--3)
alter table courses alter column course_code type varchar(10);

--4)
alter table courses alter column credits set default 3;

--5)
alter table courses add column lab_required boolean default false;


--3.2

--for class_schedule table

--1)
alter table class_schedule add column room_capacity integer;

--2)
alter table class_schedule drop column duration;

--3)
alter table class_schedule add column session_type varchar(15);

--4)
alter table class_schedule alter column classroom type varchar(30);

--5)
alter table class_schedule add column equipment_needed text;


--for student_records table

--1)
alter table student_records add column extra_credit_points numeric(4,1);

--2)
alter table student_records alter column grade type varchar(5);

--3)
alter table student_records alter column extra_credit_points set default 0.0;

--4)
alter table student_records add column final_exam_date date;

--5)
alter table student_records drop column last_updated;


--TASK 4

--4.1

--1)
create table departments(
    department_id serial primary key,
    department_name varchar(100),
    department_code char(5),
    building varchar(50),
    phone varchar(15),
    budget numeric(10,2),
    established_year integer
);

--2)
create table library_books(
    book_id serial primary key ,
    isbn char(13),
    title varchar(200),
    author varchar(100),
    publisher varchar(100),
    publication_date date,
    price numeric(10,2),
    is_available boolean,
    acquisition_timestamp timestamp without time zone
);

--3)
create table student_book_loans(
    loan_id serial primary key ,
    student_id integer,
    book_id integer,
    loan_date date,
    due_date date,
    return_date date,
    fine_amount numeric(10,2),
    loan_status varchar(20)
);

--4.2
--1
--1.1
alter table professors add column department_id integer;

--1.2
alter table students add column advisor_id integer;

--1.3
alter table courses add column department_id integer;

--2

create table grade_scale(
    grade_id serial primary key ,
    letter_grade char(2),
    min_percentage numeric(4,1),
    max_percentage numeric(4,1),
    gpa_points numeric(3,2)
);

create table semester_calendar(
    semester_id serial primary key ,
    semester_name varchar(20),
    academic_year integer,
    start_date date,
    end_date date,
    registration_deadline timestamp with time zone,
    is_current boolean
);


--TASK 5
--5.1
--1)
--1.1)
drop table if exists student_book_loans;

--1.2)
drop table if exists library_books;

--1.3)
drop table if exists grade_scale;

--2)
create table grade_scale(
    grade_id serial primary key ,
    letter_grade char(2),
    min_percentage numeric(4,1),
    max_percentage numeric(4,1),
    gpa_points numeric(3,2),
    description text
);

--3)
drop table if exists semester_calendar cascade;

create table semester_calendar(
    semester_id serial primary key ,
    semester_name varchar(20),
    academic_year integer,
    start_date date,
    end_date date,
    registration_deadline timestamp with time zone,
    is_current boolean
);

--5.2
--1)
drop database if exists university_test; -- error потому что такой базы данных нет

--2)
drop database if exists university_distributed;

--3)
select pg_terminate_backend(pid)
from pg_stat_activity
where datname = 'university_main'
  and pid <> pg_backend_pid();

create database university_backup
with
    template = university_main;