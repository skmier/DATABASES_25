create database elearing_platform;

create tablespace video_storoge
    location 'C:/pgsql/tablespaces/videos';

create table online_videos(
    video_id serial primary key ,
    course_id integer,
    video_title varchar(100),
    video_description text,
    time_duration time without time zone,
    file_size bigint,
    upload_data date,
    ispublic boolean,
    view_count integer
);

create table if not exists student_progress(
    progress_id serial primary key ,
    student_id integer,
    course_id integer,
    watch_precentege numeric(4,1),
    last_watched timestamp with time zone,
    completed boolean,
    notes text,
    bookmark_time time without time zone
);

alter table courses add column is_available boolean;

alter table courses alter column is_available set default false;

alter table courses add column platform_url varchar(200);


alter table courses alter column description set default 'no des available';


alter table students add column preef_lan char(5);

alter table students add column last_log timestamp without time zone;

create table quiz_attemp(
    id serial primary key ,
    stud_ref integer,
    quiz_name varchar(80),
    start_time timestamp with time zone,
    duration interval,
    score numeric(5,2),
    status boolean,
    attempt_number smallint
);
