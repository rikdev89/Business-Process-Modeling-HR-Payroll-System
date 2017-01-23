--OPIM 5272:BPMDM
--PHASE 3 REPORT
--SQL QUERIES
--RAVI SHANKAR
--YAXIN JIANG
--ZHICHENG XIE
--RIKDEV BHATTACHARYA


-- QUERY 1 - FIND AVERAGE SALARY BY DEPARTMENTS
select d.DEPARTMENT_ID, avg(s.salary_amount) "Avg Salary"
from HR_DEPARTMENT d
join HR_SALARY_TXN_HISTORY s
on d.manager_id = s.EMPLOYEE_ID 
group by d.DEPARTMENT_ID
order by 2
desc;

-- QUERY 2 - FIND AN EMPLOYEE WITH LAST NAME WILLIAMS
SELECT employee_id, last_name, first_name
FROM   HR_employees
WHERE  LOWER(last_name) = 'williams';

-- QUERY 3 - FIND EMPLOYEES HIRED BEFORE 1 JAN 1990
SELECT last_name, TO_CHAR(HIRE_DATE, 'DD-Mon-YYYY') "HIRE DATE"
FROM  HR_employees
WHERE HIRE_DATE < TO_DATE('01-Jan-90','DD-Mon-RR');

-- QUERY 4 - FIND EMPLOYEES AND THE NUMBER OF SKILLS THEY HAVE
select e.EMPLOYEE_ID, count(*) "SKILL COUNT"
from HR_EMPLOYEES e
left join HR_SKILL_DETAILS es
on e.EMPLOYEE_ID = es.EMPLOYEE_ID
group by e.EMPLOYEE_ID
order by 2
desc;


-- QUERY 5 - FIND WHICH BANK HOLDS THE MAXIMUM NUMBER OF ACCOUNTS
select bank_name, count(*) "ACCOUNT COUNT"
from HR_EMPLOYEE_FINANCIALS
group by bank_name
order by 2
desc;

-- QUERY 6 - Query to display the manager number and the salary of the lowest paid
--employee for that manager. Exclude anyone who does not have a manager. Exclude any
--groups where the minimum salary is $2000 or less. Sort the output in descending order of
--salary. Name the columns properly.
Select manager_id "Manager ID", min(salary_amount) "Salary of Lowest Paid Employee"
from hr_employees e
join HR_SALARY_TXN_HISTORY s
on e.manager_id = s.EMPLOYEE_ID 
where manager_id is not null 
group by manager_id
having min(salary_amount) > 5000
order by min(salary_amount) DESC;


-- QUERY 6 - Query to output a single column displaying the following text for each
--employee:
--FIRST_NAME LAST_NAME is xxx years old and has worked in the company for xxx
--months. 
select e.first_name||' ' ||e.last_name||' is '|| round((sysdate-e.date_of_birth)/365)||
' years old and has worked in the company for '|| round(months_between(sysdate,e.hire_date))||' months. '"Employee Tenure"
from hr_employees e;

-- QUERY 7 - FIND EMPLOYEES WHO HAVE WORKED EXTRA HOURS
select e.last_name, e.first_name, p.HOURS_WORKED,
case p.extra_hours_worked when 0 then 'No extra hour worked'
else 'Extra hours worked' end "Extra Hours",
case p.leave_days when 0 then 'No leaves taken'
else 'Leaves Taken' end "Leaves (Y/N)"
from hr_employees e
join HR_PAYROLL_DETAILS p
on e.employee_id = p.employee_id;

-- QUERY 9 - RENAME RVW_SUB_DATE TO REVIEW_SUBMISSION_DATE
-- AND RVW_APP_DATE TO REVIEW_APPROVAL_DATE
ALTER TABLE HR_PAYROLL_REVIEW
RENAME COLUMN RVW_SUB_DATE TO REVIEW_SUBMISSION_DATE; 

ALTER TABLE HR_PAYROLL_REVIEW
RENAME COLUMN RVW_APP_DATE TO REVIEW_APPROVAL_DATE;

-- QUERY 10 - CREATE A VIEW TO FIND ALL EMPLOYEES IN DEPARTMENT 50
CREATE VIEW 	HR_EMPLOYEES_80
 AS SELECT  E.employee_id ID_NUMBER, E.last_name NAME, D.DEPARTMENT_ID DEPARTMENT, S.SALARY_AMOUNT SALARY
    FROM    HR_employees E
    JOIN HR_DEPARTMENT D
    ON E.MANAGER_ID=D.MANAGER_ID
    JOIN HR_SALARY_TXN_HISTORY S
    ON E.EMPLOYEE_ID=S.EMPLOYEE_ID
    WHERE   D.department_id = 80;
    
-- QUERY THE VIEW
select * from HR_EMPLOYEES_80;

-- QUERY 11 - FIND THE APPROVAL STATUS FOR MANAGER ID 
select employee_id, manager_id, review_submission_date, approval_status from hr_payroll_review
where employee_id in (select employee_id from hr_employees where manager_id = '10010003');

-- QUERY 12 - SALARY TIER USING CASE EXPRESSION AND ORDERED BY DESCENDING ORDER
select employee_id, SALARY_AMOUNT,
case when salary_amount < 2500 then 'Tier 3 Employee'
when SALARY_AMOUNT >= 2500 and SALARY_AMOUNT< 5000 then 'Tier 2 Employee'
when SALARY_AMOUNT> 5000 then 'Tier 1 Employee'
else 'NA'
end "Salary Tier"
from HR_SALARY_TXN_HISTORY
order by salary_amount desc;

-- QUERY 13 - DISPLAY THE LAST NAME AND HIRE DATE OF EVERY EMPLOYEE WHO WAS HIRED IN 1994.
select last_name, hire_date
from hr_employees
where hire_date like '%89';

-- QUERY 14 - THE HR DEPARTMENT WANTS TO FIND THE LENGTH OF EMPLOYMENT FOR EACH EMPLOYEE. FOR EACH EMPLOYEE, DISPLAY THE LAST NAME AND 
--CALCULATE THE NUMBER OF MONTHS BETWEEN TODAY AND THE DATE ON WHICH THE EMPLOYEE WAS HIRED.
select last_name "Employee", round(months_between(sysdate,hire_date))"Months_Worked"
from hr_employees
order by 'Months_Worked';

-- QUERY 15 - THE HR DEPARTMENT NEEDS EMPLOYEES' BANK ACCOUNT NUMBER AND BANK ACCOUNT NAME. FOR EACH EMPLOYEE, DESPLAY THE LAST NAME, BANK ACCONT
--NAME AND BANK ACCOUNT NUMBER
select e.last_name, b.bank_name, b.bank_account_number
from hr_employees e join hr_employee_financials b
on e.employee_id = b.employee_id;

-- QUERY 16 - THE HR DEPARTMENT WANTS TO DETERMINE THE NAMES OF ALL EMPLOYEES WHO WERE HIRED AFTER TRUMP. CREATE A QUERY TO DISPLAY THE NAME
--AND HIRE DATE OF ANY EMPLOYEE HIRED AFTER EMPLOYEE TRUMP
Select e.last_name, e.hire_date
from hr_employees e join hr_employees Trump
on (Trump.last_name = 'Trump')
where Trump.hire_date < e.hire_date;


-- QUERY 17 - CREATE A REPORT FOR HR THAT DISPLAYS THE LAST NAME AND PHONE NUMBER OF EVERY EMPLOYEE WHO REPORTS TO BENTON
Select last_name, phone_number
from hr_employees
where manager_id = (select employee_id
from hr_employees
where last_name = 'Benton');

-- QUERY 18 - DISPLAY THE EMPLOYEE'S NAME AND THEIR SKILLS DETAILS. THE PURPOSE IS TO MAKE EASIER FOR HR TO RECODE THE EACH EMPLOYEE'S SKILLS.
SELECT FIRST_NAME, LAST_NAME,SKILL_DETAILS
FROM HR_EMPLOYEES,HR_SKILL,HR_SKILL_DETAILS
WHERE HR_EMPLOYEES.EMPLOYEE_ID = HR_SKILL_DETAILS.EMPLOYEE_ID
AND HR_SKILL_DETAILS.SKILL_ID = HR_SKILL.SKILL_ID;

-- QUERY 19 - DISPLAY THE DEPARTMENT NAME, LOCATION NAME, ADDRESS AND THE WORK HOURS PER WEEK IN EACH LOCATION. LIST ALL OF THE PAY HOURS DESCENDING. 
SELECT DEPARTMENT_NAME,LOCATION_NAME,LOCATION_ADDRESS,PAYHOUR_RATE AS "Work Hours/w"
FROM HR_DEPARTMENT,HR_JOB_DETAILS,HR_LOCATION
WHERE HR_DEPARTMENT.LOCATION_ID = HR_LOCATION.LOCATION_ID
AND HR_JOB_DETAILS.DEPARTMENT_ID = HR_DEPARTMENT.DEPARTMENT_ID
ORDER BY HR_JOB_DETAILS.PAYHOUR_RATE DESC;

--- QUERY 20 - DISPLAY EACH EMPLOYEE'S SALARY AMOUNT, SSN, EXTRA HOURS WORKED AND THE BANK ACCOUNT NUMBER TO MAKE A REPORT FOR EMPLYEE'S EXTRA HOUR DETAIL LIST.
SELECT HR_EMPLOYEES.FIRST_NAME,HR_EMPLOYEES.LAST_NAME,HR_SALARY_TXN_HISTORY.SALARY_AMOUNT,HR_SALARY_TXN_HISTORY.SSN,HR_PAYROLL_DETAILS.EXTRA_HOURS_WORKED
FROM HR_SALARY_TXN_HISTORY,HR_EMPLOYEES,HR_PAYROLL_DETAILS
WHERE HR_SALARY_TXN_HISTORY.EMPLOYEE_ID = HR_EMPLOYEES.EMPLOYEE_ID
AND HR_PAYROLL_DETAILS.EMPLOYEE_ID = HR_EMPLOYEES.EMPLOYEE_ID
AND HR_PAYROLL_DETAILS.EXTRA_HOURS_WORKED > 0;

--- QUERY 21 - IMPROVE THE SPEED OF QUERY ACCESS TO THE FIRST_NAME COLUMN IN THE HR_EMPLOYEES TABLE USING INDEXING
CREATE INDEX 	first_name_index
ON hr_employees(first_name);
 
--- QUERY 22 – UPDATE THE DEPARTMENT NAME OF ‘IT DEPARTMENT’ TO ‘ITES DEPARTMENT’ IN THE HR_DEPARTMENT TABLE
UPDATE HR_DEPARTMENT
SET   department_name= 'ITes Department'
WHERE department_name= 'IT Department';

  
--- QUERY 23 – CREATING A TABLE FOR ALL EMPLOYEES WHO HAVE BEEN HIRED AFTER 1ST JAN 2000.
CREATE TABLE 	HR_NEW_JOINEES AS
SELECT  employee_id, FIRST_NAME, last_name, hire_date
          FROM    HR_employees  
          WHERE   HIRE_DATE > '01-JAN-00';

 
--VIEW DETAILS 
DESCRIBE HR_NEW_JOINEES
 





