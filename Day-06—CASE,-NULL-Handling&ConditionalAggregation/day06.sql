/*
========================================================
DAY 06 - CASE, NULL HANDLING & CONDITIONAL AGGREGATION
SQL Server / SSMS
========================================================
*/

IF OBJECT_ID('Employees_Day6', 'U') IS NOT NULL
    DROP TABLE Employees_Day6;

IF OBJECT_ID('Departments_Day6', 'U') IS NOT NULL
    DROP TABLE Departments_Day6;


-- ======================================================
-- DEPARTMENTS
-- ======================================================

CREATE TABLE Departments_Day6
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

INSERT INTO Departments_Day6
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Sales'),
(5, 'Marketing');


-- ======================================================
-- EMPLOYEES
-- ======================================================

CREATE TABLE Employees_Day6
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    DepartmentID INT NULL,
    Salary INT NULL,
    Age INT,
    PerformanceRating INT NULL
);

INSERT INTO Employees_Day6
VALUES
(101, 'Alice',   1, 70000, 25, 4),
(102, 'Bob',     2, 50000, 30, 3),
(103, 'Charlie', 1, 90000, 28, 5),
(104, 'David',   4, 60000, 35, 2),
(105, 'Eva',     2, 80000, 27, 4),
(106, 'Frank',   3, 55000, 31, NULL),
(107, 'Grace',   4, 75000, 29, 5),
(108, 'Helen',   1, 95000, 26, 5),
(109, 'Ian',     NULL, 62000, 33, 3),
(110, 'Jack',    2, NULL, 24, 2),
(111, 'Kevin',   1, 85000, 29, NULL),
(112, 'Laura',   2, 65000, 32, 3),
(113, 'Mike',    4, 70000, 28, 4),
(114, 'Nancy',   3, 72000, 27, NULL),
(115, 'Oscar',   NULL, NULL, 30, NULL);

--Practice problems
--1
SELECT EmployeeName, Salary, 
CASE
	WHEN Salary IS NULL THEN 'Not Available'
	WHEN Salary>= 80000 THEN 'High'
	WHEN Salary >= 60000 THEN 'Medium'
	ELSE 'Low'
END AS SalaryCategory FROM Employees_Day6

--2.
SELECT EmployeeName, ISNULL(Salary,0) FROM Employees_Day6

--3.
SELECT ISNULL(SUM(Salary),0) AS TotalSalary FROM Employees_Day6

--4.
SELECT COUNT(CASE WHEN Salary>=70000 THEN 1 END) FROM Employees_Day6

--5.
SELECT COUNT(*) AS TotalEmployees,
COUNT(CASE WHEN Salary>=70000 THEN 1 END) AS HighSalaryEmployee,
COUNT(CASE WHEN Salary<70000 THEN 1 END) AS LowSalaryEmployee
FROM Employees_Day6

--6.
SELECT
    d.DepartmentID,
    COUNT(e.EmployeeID) AS TotalEmployees,
    COUNT(CASE WHEN e.Salary >= 70000 THEN 1 END) AS HighSalaryEmployees
FROM Departments_Day6 d
LEFT JOIN Employees_Day6 e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID;

--7.
SELECT d.DepartmentID, ISNULL(SUM(Salary),0) AS TotalSalary,
COUNT(CASE WHEN e.Salary>=70000 THEN 1 END) AS HighSalaryTotal
FROM Departments_Day6 d 
LEFT JOIN Employees_Day6 e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID

--8.
SELECT AVG(CASE WHEN PerformanceRating >=4 THEN CAST(Salary AS DECIMAL(10,2)) END) AS AvgHighPerformanceSalary 
FROM Employees_Day6

--9.
SELECT EmployeeName,
CASE
WHEN PerformanceRating IS NULL THEN 'Not Rated'
WHEN PerformanceRating = 2 THEN 'Poor'
WHEN PerformanceRating = 3 THEN 'Average'
WHEN PerformanceRating = 4 THEN 'Good'
WHEN PerformanceRating = 5 THEN 'Excellent'
END AS PerformanceCategory
FROM Employees_Day6;

--10.
-- Conditional aggregation means using aggregate functions such as COUNT, SUM, or AVG together 
--with a condition, usually through CASE, to calculate metrics for only rows that satisfy that condition.

