\--Practice questions solutions:
\--1.
SELECT COUNT(\*) AS EmployeeCount FROM Employees;
\--2.
SELECT AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary FROM Employees;
\--3.
SELECT MAX(Salary) AS HighestSalary FROM Employees;
\--4.
SELECT Department, COUNT(*) AS EmployeeCount FROM Employees
GROUP BY Department;
\--5.
SELECT Department, AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary FROM Employees
GROUP BY Department;
\--6.
SELECT Department, MAX(Salary) AS MaxSalary FROM Employees
GROUP BY Department;
\--7.
SELECT Department, COUNT(*) AS EmployeeCount FROM Employees
GROUP BY Department HAVING COUNT(*) > 3;
\--8.
SELECT Department, AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary FROM Employees
GROUP BY Department HAVING AVG(CAST(Salary AS DECIMAL(10,2))) > 70000;
\--9.
SELECT Department, COUNT(*) AS EmployeeCount FROM Employees
WHERE Salary > 60000
GROUP BY Department HAVING COUNT(*) >2;
\--10.
SELECT TOP 1
       Department,
       AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary
FROM Employees
GROUP BY Department
ORDER BY AVG(CAST(Salary AS DECIMAL(10,2))) DESC;
\--11
SELECT TOP 1
    Department,
    AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary
FROM Employees
GROUP BY Department
ORDER BY AVG(CAST(Salary AS DECIMAL(10,2)));
