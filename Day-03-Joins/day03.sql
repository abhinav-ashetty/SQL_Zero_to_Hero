/*
========================================================
DAY 03 - SQL JOINS
Database: Microsoft SQL Server
Tool: SSMS
========================================================
*/

-- ======================================================
-- 1. DROP TABLES IF THEY ALREADY EXIST
-- ======================================================

IF OBJECT_ID('Employees_Day3', 'U') IS NOT NULL
    DROP TABLE Employees_Day3;

IF OBJECT_ID('Departments_Day3', 'U') IS NOT NULL
    DROP TABLE Departments_Day3;


-- ======================================================
-- 2. CREATE DEPARTMENTS TABLE
-- ======================================================

CREATE TABLE Departments_Day3
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    Location VARCHAR(50)
);


-- ======================================================
-- 3. CREATE EMPLOYEES TABLE
-- ======================================================

CREATE TABLE Employees_Day3
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    DepartmentID INT,
    Salary INT
);


-- ======================================================
-- 4. INSERT DEPARTMENTS
-- ======================================================

INSERT INTO Departments_Day3
VALUES
(1, 'IT', 'Bangalore'),
(2, 'HR', 'Mysore'),
(3, 'Finance', 'Chennai'),
(4, 'Sales', 'Delhi'),
(5, 'Marketing', 'Mumbai');


-- ======================================================
-- 5. INSERT EMPLOYEES
-- ======================================================

INSERT INTO Employees_Day3
VALUES
(101, 'Alice',   1, 70000),
(102, 'Bob',     2, 50000),
(103, 'Charlie', 1, 90000),
(104, 'David',   4, 60000),
(105, 'Eva',     2, 80000),
(106, 'Frank',   3, 55000),
(107, 'Grace',   4, 75000),
(108, 'Helen',   1, 95000),
(109, 'Ian',     NULL, 62000);


--1.
SELECT e.EmployeeName , d.DepartmentName FROM Employees_Day3 e
INNER JOIN Departments_Day3 d ON e.DepartmentID = d.DepartmentID;

--2.
SELECT e.EmployeeName , d.DepartmentName FROM Employees_Day3 e
LEFT JOIN Departments_Day3 d ON e.DepartmentID = d.DepartmentID;

--3.
SELECT d.DepartmentName, e.EmployeeName FROM Departments_Day3 d
LEFT JOIN Employees_Day3 e ON d.DepartmentID=e.DepartmentID ;

--4.
SELECT e.EmployeeName,
       d.DepartmentName,
       e.Salary
FROM Employees_Day3 e
LEFT JOIN Departments_Day3 d
    ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 70000;

--5.
SELECT d.DepartmentName,
       COUNT(e.EmployeeID) AS EmployeeCount
FROM Departments_Day3 d
LEFT JOIN Employees_Day3 e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

--6.
SELECT d.DepartmentName, AVG(CAST(Salary AS DECIMAL(10,2))) AS AvgSalary FROM Departments_Day3 d
LEFT JOIN Employees_Day3 e ON d.DepartmentID=e.DepartmentID
GROUP BY d.DepartmentName;

--7. lets do it in other class

--8.
SELECT * FROM Employees_Day3
WHERE DepartmentID IS NULL;

--9.
SELECT d.DepartmentName
FROM Departments_Day3 d
LEFT JOIN Employees_Day3 e
    ON d.DepartmentID = e.DepartmentID
WHERE e.EmployeeID IS NULL;

--10. INNER JOIN returns only matching rows from both tables, 
--whereas LEFT JOIN returns all rows from the left table and matching rows from the right table. 
-- If there is no match, the right-side columns contain NULL.


--🎯 One Final Mini Challenge
--
SELECT * FROM Employees_Day3
WHERE DepartmentID IS NULL;

--
SELECT d.DepartmentName, COUNT(e.EmployeeName) EmpCount FROM Departments_Day3 d
LEFT JOIN Employees_Day3 e ON d.DepartmentID=e.DepartmentID
WHERE e.Salary > 80000
GROUP BY d.DepartmentName HAVING COUNT(e.EmployeeName) >= 1;

--
SELECT d.DepartmentName, ISNULL(SUM(e.Salary),0) AS AvgSalary FROM Departments_Day3 d
LEFT JOIN Employees_Day3 e ON d.DepartmentID=e.DepartmentID
GROUP BY d.DepartmentName;

