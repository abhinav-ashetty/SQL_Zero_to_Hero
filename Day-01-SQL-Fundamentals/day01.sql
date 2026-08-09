-- Practice questions solution:
--1.
SELECT EmployeeName, City FROM Employees;

--2.
SELECT * FROM Employees
WHERE City='Bangalore';

--3.
SELECT EmployeeName,Salary FROM Employees
WHERE Salary >= 75000;

--4.
SELECT EmployeeName,Department FROM Employees
WHERE NOT Department = 'Finance';
--or
SELECT EmployeeName,Department FROM Employees
WHERE Department <>'Finance';

--5. 
SELECT EmployeeName,Age FROM Employees
ORDER BY Age;

--6.
SELECT TOP 5 * FROM Employees
ORDER BY Salary DESC;

--7.
SELECT DISTINCT City FROM Employees;

--8.
SELECT EmployeeName, Department FROM Employees
WHERE Department IN ('HR','Sales');

--9.
SELECT EmployeeName , Age FROM Employees
WHERE Age BETWEEN 25 AND 30;

--10.
SELECT EmployeeName FROM Employees
WHERE EmployeeName LIKE 'H%';

--Homework Question's Solutions:
--1.
SELECT * FROM Employees
WHERE City = 'Bangalore' AND Salary > 80000;

--2.
SELECT TOP 2 * FROM Employees
ORDER BY Age;

--3.
SELECT EmployeeName FROM Employees
WHERE EmployeeName LIKE '%a%';

--4.
SELECT EmployeeName, City FROM Employees
WHERE NOT City IN ('Delhi','Mumbai');

--5.
SELECT * FROM Employees
ORDER BY Department, Salary DESC;