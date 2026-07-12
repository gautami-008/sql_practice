-- Create database container (optional, uncomment if needed)
CREATE database SQL_Practice;
USE SQL_Practice;
--  Drop tables if they already exist to start fresh

 DROP TABLE IF EXISTS order1;
 DROP TABLE IF EXISTS employee1;
 DROP TABLE IF EXISTS department1;
-- 1. Create Departments Table
CREATE TABLE department1 (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL
);

-- 2. Create Employees Table
CREATE TABLE if not exists employees1 (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    department_id INT ,
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    manager_id INT,
    FOREIGN KEY (department_id) REFERENCES department1(department_id)
);

-- 3. Create Orders Table (E-commerce)
CREATE TABLE orders1 (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);

-- ==========================================
-- INSERTING MOCK DATA FOR REAL-TIME PRACTICE
-- ==========================================

INSERT INTO department1 (department_id, department_name, location) VALUES
(10, 'Data & Analytics', 'New York'),
(20, 'Engineering', 'San Francisco'),
(30, 'Marketing', 'London'),
(40, 'Sales', 'Delhi'); -- Will keep empty or minimal to test LEFT JOINs

INSERT INTO employees1 (emp_id, emp_name, department_id, salary, hire_date, manager_id) VALUES
(101, 'Arjun Sharma', 10, 95000.00, '2023-01-15', NULL),  -- Top Manager
(102, 'Priya Patel',  10, 98000.00, '2023-06-01', 101),   -- Earns more than manager (Q1)
(103, 'Amit Khan',    10, 85000.00, '2024-02-10', 101),
(104, 'Rohan Das',    20, 120000.00, '2022-03-22', NULL), -- Tech Lead
(105, 'Sneha Reddy',  20, 115000.00, '2023-08-11', 104),  -- Tie Salary for Ranking (Q3)
(106, 'Vikram Malhotra', 20, 115000.00, '2024-01-05', 104); -- Tie Salary for Ranking (Q3)

INSERT INTO orders1 (order_id, customer_id, order_date, total_amount) VALUES
(1001, 501, '2026-07-01', 250.00),
(1002, 502, '2026-07-01', 450.00), -- Combined day sales = 700
(1003, 501, '2026-07-02', 300.00), -- Day 2 sales = 300 (Drop from previous day)
(1004, 503, '2026-07-03', 1200.00);-- Day 3 sales = 1200 (Jump)

use sql_practice;
SELECT 
   e.emp_name as employee_name,
   e.salary as employee_salary,
   e.emp_id as emp_id ,
   m.emp_name as manager_name,
   m.salary as manager_salary,
   m.emp_id as m_id
   from employees1 e
   inner join employees1 m
   on m.emp_id =  e.manager_id 
   where e.salary >  m.salary;
   
select 
d.department_name,
count(e.emp_id) as total_employees,
case 
when sum(e.salary) is null then 0.00
else sum(e.salary)
end as total_salary_expenditure 
from department1 d 
left join employees1 e 
on d.department_id = e.department_id 
group by d.department_id , d.department_name
limit 0,1000;

with rankedsalaries as( 
select d.department_name,e.emp_name,e.salary,
rank() over (partition by e.department_id
 order by e.salary
 desc ) as salary_rank
 from employees1 e 
 inner join department1 d 
 on e.department_id = d.department_id 
 )
 select 
 department_name,
 emp_name ,
  salary ,
  salary_rank
  from rankedsalaries
  where salary_rank <= 2;
 
select * from (
select d.department_name , e.emp_name , e.salary ,
rank() over(partition by e.department_id order by e.salary desc) as rnk 
from employees1 e 
inner join department1 d on e.department_id = d.department_id
)temp
where rnk <= 2 ;



select order_date,
current_day_sales,
previous_day_sales,
(current_day_sales - previous_day_sales) as daily_growth
from(
select order_date,
sum(total_amount) as current_day_sales,
lag(sum(total_amount),1) over(order by order_date) as previous_day_sales
from orders1
group by order_date 
)temp;


select e.emp_name ,
 e.emp_id ,
m.emp_id as manager_id ,
m.emp_name  as m_name 
from employees1 e 
left join employees1 m 
on e.manager_id = m.emp_id
where e.manager_id is null 
limit 0,100 
;

SELECT 
    e.emp_name, 
    e.emp_id,
    m.emp_id AS manager_id,
    m.emp_name AS m_name 
FROM employees1 e 
LEFT JOIN employees1 m 
    ON e.manager_id = m.emp_id
WHERE e.manager_id IS NULL 
LIMIT 0, 100;






select 
m.emp_name as m_name,
m.emp_id as manager_id,
count(e.emp_id) as total_reports
from employees1 e 
left join employees1 m 
on e.manager_id = m.emp_id
group by m.emp_id,m.emp_name 
having count(e.emp_id) >1;

with deptAvg as(
select 
e.department_id,
avg(salary) as avg_salary 
from employees1  e 
group by e.department_id
)
select 
d.department_name,
e.emp_name,
e.salary,
round(a.avg_salary,2) as department_average
from employees1 e
join department1 d on d.department_id = e.department_id
join deptAvg a on d.department_id = a.department_id 
where e.salary > a.avg_salary;


select department_name ,emp_name ,salary,avg_salary
from(
select
d.department_name,
e.emp_name,
e.salary,
AVG(e.salary) over(partition by e.department_id) as avg_salary
from employees1 e 
join department1 d on d.department_id = e.department_id 
)temp
where salary > avg_salary;

select 
order_date,
current_day ,
previous_day,
(current_day - previous_day) as growth  
from (
select
       order_date,
      sum(total_amount) as current_day,
       lag(sum(total_amount),1)over (order by order_date)  as previous_day
 from orders1 
 group by order_date
 )temp;


select department_name,emp_name,hire_date
from(
select 
d.department_name,
e.emp_name,
e.hire_date,
rank()over(order by e.hire_date desc ) fresh_hire 
from employees1 e
join department1 d 
on  e.department_id = d.department_id 
)temp
where fresh_hire = 1;





