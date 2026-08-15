--Practice problems's solution
--1.
WITH EmployeeSalary AS
(
	SELECT EmployeeName, Salary FROM Employees_Day3
)

SELECT * FROM EmployeeSalary;

--2.
WITH DeptAvgSal AS
(
	SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary FROM Employees_Day3
	GROUP BY DepartmentID
)

SELECT d.DepartmentName , ds.AverageSalary FROM Departments_Day3 d
LEFT JOIN DeptAvgSal ds ON d.DepartmentID = ds.DepartmentID
WHERE ds.AverageSalary > 70000;

--3.
WITH HighestSalaryDept AS
(
	SELECT DepartmentID, MAX(Salary) HighestSalary FROM Employees_Day3
	GROUP BY DepartmentID
)
SELECT * FROM HighestSalaryDept

--4.
WITH TotalCount AS
(
	SELECT DepartmentID, COUNT(*) AS EmployeeCount FROM Employees_Day3
	GROUP BY DepartmentID
)
SELECT * FROM TotalCount

--5.
WITH DeptAvgSal AS
(
	SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary FROM Employees_Day3
	GROUP BY DepartmentID
)
,
TotalCount AS
(
	SELECT DepartmentID, COUNT(*) AS EmployeeCount FROM Employees_Day3
	GROUP BY DepartmentID
)
SELECT ds.DepartmentID , ds.AverageSalary , tc.EmployeeCount FROM DeptAvgSal ds
INNER JOIN TotalCount tc ON ds.DepartmentID = tc.DepartmentID
WHERE ds.AverageSalary > 70000 AND tc.EmployeeCount >=2;

--6.
WITH DeptAvgSal AS
(
	SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary FROM Employees_Day3
	GROUP BY DepartmentID
)
SELECT d.DepartmentName, ds.AverageSalary FROM Departments_Day3 d
INNER JOIN DeptAvgSal ds ON d.DepartmentID = ds.DepartmentID

--7.
WITH DeptAvgSal AS
(
	SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary FROM Employees_Day3
	GROUP BY DepartmentID
)
SELECT TOP 1 * FROM DeptAvgSal
ORDER BY AverageSalary DESC

--8.
WITH DeptAvgSal AS
(
	SELECT DepartmentID, AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary FROM Employees_Day3
	GROUP BY DepartmentID
)
SELECT TOP 1 * FROM DeptAvgSal
ORDER BY AverageSalary

--9.
-- A CTE and a subquery can often produce the same result. 
--A CTE gives a named query expression before the main query, which can make complex queries easier to read, organize, and maintain. 
--A subquery is embedded directly inside another query.

--10.
-- I would choose a CTE primarily for readability and maintainability when a query has multiple logical steps. 
--A CTE isn't automatically faster than an equivalent subquery; 
--performance depends on the query and execution plan.


