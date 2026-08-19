

--1.
SELECT EmployeeName , Salary, 
AVG(Salary) OVER() AS CompanyAverage FROM Employees_Day6;

--2.
SELECT EmployeeName, DepartmentID, Salary,
AVG(Salary) OVER(PARTITION BY DepartmentID) AS DepartmentAverage 
FROM Employees_Day6;

--3.
SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    ROW_NUMBER() OVER(
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS RowNum
FROM Employees_Day6;

--4.
SELECT EmployeeName , Salary , RANK() OVER(ORDER BY Salary DESC) AS SalaryRank FROM Employees_Day6;

--5.
SELECT EmployeeName , Salary , DENSE_RANK() OVER(ORDER BY Salary DESC) AS SalaryRank FROM Employees_Day6;

--6.
SELECT EmployeeName ,DepartmentID, Salary , DENSE_RANK() OVER(
PARTITION BY DepartmentID
ORDER BY Salary DESC)
AS DepartmentRank FROM Employees_Day6;

--7.
WITH HighestPaidEmployee AS(
	SELECT e.EmployeeName ,d.DepartmentName, e.Salary , DENSE_RANK() OVER(
PARTITION BY e.DepartmentID
ORDER BY e.Salary DESC)
AS DepartmentRank FROM Employees_Day6 e
LEFT JOIN Departments_Day6 d ON e.DepartmentID = d.DepartmentID
)
SELECT * FROM HighestPaidEmployee 
WHERE DepartmentRank = 1;

--8.
WITH RankedEmployees AS
(
    SELECT
        EmployeeName,
        Salary,
        DENSE_RANK() OVER(
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM Employees_Day6
)
SELECT
    EmployeeName,
    Salary
FROM RankedEmployees
WHERE SalaryRank = 2;

--9.
WITH HighestPaidEmployee AS(
	SELECT e.EmployeeName ,d.DepartmentName, e.Salary , DENSE_RANK() OVER(
PARTITION BY e.DepartmentID
ORDER BY e.Salary DESC)
AS DepartmentRank FROM Employees_Day6 e
LEFT JOIN Departments_Day6 d ON e.DepartmentID = d.DepartmentID
)
SELECT * FROM HighestPaidEmployee 
WHERE DepartmentRank = 2;

--10.
/*
"I use ROW_NUMBER() when I need a unique sequential number for every row, 
even when values are tied. I use DENSE_RANK() 
when tied values should receive the same rank and I don't want gaps in the ranking.
*/