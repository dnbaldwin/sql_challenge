

-- test success of data entry

SELECT * FROM departments

SELECT * FROM dept_emp

-- there is an issue here - each dept has more than one manager -> ?? how to resolve
SELECT * FROM dept_manager

SELECT * FROM employees

SELECT * FROM salaries

SELECT * FROM titles

-------------------------

-- 1. List the employee number, last name, first name, sex, and salary of each employee.
-- COMPLETED

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
INNER JOIN salaries
ON employees.emp_no=salaries.emp_no

-------------------------

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
-- COMPLETED

-- test data
SELECT EXTRACT(YEAR FROM hire_date)
FROM employees

-- COMPLETED
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date)=1986


-------------------------

-- 3. List the manager of each department along with their department number,
--    department name, employee number, last name, and first name.
-- COMPLETED

-- trial1
SELECT employees.emp_no, employees.first_name, employees.last_name, employees.sex, departments.dept_no, departments.dept_name
FROM employees
INNER JOIN departments
ON employees.emp_no=departments.emp_no

-- trial2
SELECT * FROM dept_manager
INNER JOIN departments
ON departments.dept_no=dept_manager.dept_no

-- trial3
SELECT * FROM dept_manager
INNER JOIN departments
ON departments.dept_no=dept_manager.dept_no

-- trial4 - appears to give correct result
SELECT
employees.emp_no,
employees.last_name,
employees.first_name,
departments.dept_no,
departments.dept_name
FROM employees
INNER JOIN dept_manager ON
employees.emp_no = dept_manager.emp_no
INNER JOIN departments ON
departments.dept_no = dept_manager.dept_no



-------------------------

-- 4. List the department number for each employee along with that employee’s employee number,
-- 	  last name, first name, and department name.
-- COMPLETED

-- trial1 - doesnt work (crashes)
SELECT employees.emp_no, employees.first_name, employees.last_name, dept_emp.dept_no
FROM employees, dept_emp
--INNER JOIN dept_emp
--ON employees.emp_no=dept_emp.emp_no

-- trial2 - seems to work
-- addit. have just noted that some employees appear to work for >1 department
-- note also some departments have >1 manager

SELECT
employees.emp_no,
employees.last_name,
employees.first_name,
--departments.dept_no,
departments.dept_name,
--dept_emp.emp_no,
dept_emp.dept_no
FROM employees
INNER JOIN dept_emp ON
employees.emp_no = dept_emp.emp_no
INNER JOIN departments ON
departments.dept_no = dept_emp.dept_no

-------------------------

--5.  List the first name, last name, and sex of each employee whose first name is Hercules
--    and whose last name begins with the letter B.
-- COMPLETED
SELECT first_name, last_name, sex
FROM employees
WHERE
	first_name = 'Hercules'
	AND last_name LIKE 'B%'
-------------------------

--6.  List each employee in the Sales department, including their employee number, last name, and first name.
-- COMPLETED - but doesnt show department

-- trial1
SELECT *
FROM departments
WHERE dept_name = 'Sales'

--trial2
SELECT *
FROM dept_emp
WHERE dept_no IN (
	SELECT dept_no
	FROM departments
	WHERE dept_name = 'Sales'
)

-- trial3: Gives RESULT
SELECT *
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM dept_emp
	WHERE dept_no IN (
		SELECT dept_no
		FROM departments
		WHERE dept_name = 'Sales'
		)
)

-- trial4: Attempt to show department name
SELECT employees.first_name, employees.last_name, departments.dept_name
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM dept_emp
	WHERE dept_no IN (
		SELECT dept_no
		FROM departments
		WHERE dept_name = 'Sales'
		)
)
INNER JOIN departments ON
employees.emp
-------------------------

--7.  List each employee in the Sales and Development departments,
--    including their employee number, last name, first name, and department name.
-- COMPLETED

-- Trial1
SELECT *
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM dept_emp
	WHERE dept_no IN (
		SELECT dept_no
		FROM departments
		WHERE 
			dept_name = 'Sales'
			OR dept_name = 'Development'
		)
)


-- Trial2
SELECT
employees.emp_no,
employees.last_name,
employees.first_name,
departments.dept_no,
departments.dept_name,
dept_emp.emp_no,
dept_emp.dept_no
FROM employees
INNER JOIN dept_emp ON
employees.emp_no = dept_emp.emp_no
INNER JOIN departments ON
departments.dept_no = dept_emp.dept_no

-- Trial3 - COMPLETE? - seems to work
SELECT
employees.emp_no,
employees.last_name,
employees.first_name,
departments.dept_no,
departments.dept_name,
dept_emp.emp_no,
dept_emp.dept_no
FROM employees
INNER JOIN dept_emp ON
employees.emp_no = dept_emp.emp_no
INNER JOIN departments ON
departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name = 'Sales'
	OR departments.dept_name = 'Development'

-------------------------

--8.  List the frequency counts, in descending order, 
--    of all the employee last names (that is, how many employees share each last name).
-- INCOMPLETE

SELECT last_name, COUNT(last_name) AS "last_name count"
FROM employees
--JOIN country ON city.country_id = country.country_id
GROUP BY employees.last_name order by last_name
--ORDER BY "last_name count" DESC;

-- quick to check data integrity
-- confirms at least that there are 205 Aamodt in the query
select * from employees order by last_name
