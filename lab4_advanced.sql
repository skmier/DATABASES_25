--LAB 4

create database lab4;

-- Create tables
CREATE TABLE employees (
 employee_id SERIAL PRIMARY KEY,
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 department VARCHAR(50),
 salary NUMERIC(10,2),
 hire_date DATE,
 manager_id INTEGER,
 email VARCHAR(100)
);

CREATE TABLE projects (
 project_id SERIAL PRIMARY KEY,
 project_name VARCHAR(100),
 budget NUMERIC(12,2),
 start_date DATE,
 end_date DATE,
 status VARCHAR(20)
);
CREATE TABLE assignments (
 assignment_id SERIAL PRIMARY KEY,
 employee_id INTEGER REFERENCES employees(employee_id),
 project_id INTEGER REFERENCES projects(project_id),
 hours_worked NUMERIC(5,1),
 assignment_date DATE
);


-- Insert sample data
INSERT INTO employees (first_name, last_name, department,
salary, hire_date, manager_id, email) VALUES
('John', 'Smith', 'IT', 75000, '2020-01-15', NULL,
'john.smith@company.com'),
('Sarah', 'Johnson', 'IT', 65000, '2020-03-20', 1,
'sarah.j@company.com'),
('Michael', 'Brown', 'Sales', 55000, '2019-06-10', NULL,
'mbrown@company.com'),
('Emily', 'Davis', 'HR', 60000, '2021-02-01', NULL,
'emily.davis@company.com'),
('Robert', 'Wilson', 'IT', 70000, '2020-08-15', 1, NULL),
('Lisa', 'Anderson', 'Sales', 58000, '2021-05-20', 3,
'lisa.a@company.com');
INSERT INTO projects (project_name, budget, start_date,
end_date, status) VALUES
('Website Redesign', 150000, '2024-01-01', '2024-06-30',
'Active'),
('CRM Implementation', 200000, '2024-02-15', '2024-12-31',
'Active'),
('Marketing Campaign', 80000, '2024-03-01', '2024-05-31',
'Completed'),
('Database Migration', 120000, '2024-01-10', NULL, 'Active');
INSERT INTO assignments (employee_id, project_id,
hours_worked, assignment_date) VALUES
(1, 1, 120.5, '2024-01-15'),
(2, 1, 95.0, '2024-01-20'),
(1, 4, 80.0, '2024-02-01'),
(3, 3, 60.0, '2024-03-05'),
(5, 2, 110.0, '2024-02-20'),
(6, 3, 75.5, '2024-03-10');

--PART 1
--Task 1.1
select first_name || ' ' || last_name as full_name,department,salary from employees;

--Task 1.2
select distinct department from employees;

--Task 1.3
select project_name, budget, case
    when budget > 150000 then 'Large'
    when budget between 100000 and 150000 then 'Medium'
    else 'Small'
end as budget_category
from projects;

--Task 1.4
select first_name || ' ' || last_name as full_name, coalesce(email, 'No email provided') from employees;


--PART 2
--Task 2.1

select * from employees where hire_date > '2020-01-01';

--Task 2.2
select * from employees where salary between 60000 and 70000;

--Task 2.3
select * from employees where last_name like 'S%' or last_name like 'J%';

--Task 2.4
select * from employees where manager_id is not null and department = 'IT';


--PART 3

--Task 3.1

select upper(first_name) as upper_first_name,length(last_name) as length_of_last_name ,substring(email,1,3)  from employees;

--Task 3.2

select salary * 12 as annual_salary, round(salary,2) as monthly_salary, salary * 1.1 as rise_salary from employees;

--Task 3.3
select format('Project: %s - Budget: $%s - Status: %s', project_name, budget,status ) from projects;

--Task 3.4
select first_name || ' ' || last_name as full_name, extract(YEAR from age(current_date, hire_date))  as how_many_work  from employees;

--PART 4
--Task 4.1
select department, avg(salary) from employees group by department;

--Task 4.2
select project_name,sum(extract(epoch from age(coalesce(end_date, current_date), start_date)) / 3600) as total_hour from projects
group by  project_name;

--Task 4.3

select department, count(employee_id) as count_of_emp from employees
group by department having count(employee_id) > 1;

--Task 4.4
select max(salary) as max_salary, min(salary) as min_salary, sum(salary) as sum_of_salary  from employees;


--PART 5
--Task 5.1
select employee_id, first_name || ' ' || last_name as full_name, salary from employees where salary > 65000
union
select employee_id, first_name || ' ' || last_name as full_name, salary from employees where hire_date > '2020-01-01';


--Task 5.2
select first_name || ' ' || last_name as full_name, department from employees where department = 'IT'
intersect
select first_name || ' ' || last_name as full_name, department from employees where salary > 65000;

--Task 5.3
select employee_id  from employees
except
select employee_id from assignments;

--PART 6

--Task 6.1
select employee_id,first_name || ' ' || last_name as full_name from employees
where exists(select 1 from assignments where employees.employee_id = assignments.employee_id);

--Task 6.2
select employee_id,first_name || ' ' || last_name as full_name  from employees where employee_id in (select employee_id from assignments where assignments.employee_id = employees.employee_id
and project_id in (select project_id from projects where status = 'Active'));

--Task 6.3
select *  from employees
where salary > any(select salary from employees where department = 'Sales');

--PART 7
--Task 7.1
with employees_work as (select employee_id , avg(hours_worked) as avg_hour from assignments group by employee_id)

select e.first_name || ' ' || e.last_name as employee_name,e.department,coalesce(eh.avg_hour, 0.0) as average_hours_worked,
       rank() over (
           partition by e.department
           order by e.salary desc
           )
as salary_rank_in_department
from employees e left join employees_work eh on e.employee_id = eh.employee_id
order by e.department,salary_rank_in_department;

--Task 7.2
select p.project_name,sum(a.hours_worked) as total_hours,count(distinct a.employee_id) as num_employees from projects p
join assignments a
    on p.project_id = a.project_id
group by p.project_name having sum(a.hours_worked) > 150 order by total_hours desc ;

--Task 7.3
select e.department,count(e.employee_id) as total_employees,round(avg(e.salary), 2) as avg_salary,max(e.salary) as highest_salary,greatest(max(e.salary), avg(e.salary)) as salary_comparison,
    (select concat(e2.first_name, ' ', e2.last_name) from employees e2 where e2.department = e.department order by e2.salary desc limit 1 ) AS highest_paid_employee
from employees e
group by e.department
order by avg_salary desc ;

