-- Practice Problem's Solution

--1.
SELECT EmployeeName,Salary, LAG(Salary,1,0) OVER( ORDER BY Salary DESC)  AS PreviousSalary FROM Employees_Day6;

--2.
SELECT EmployeeName,Salary, LEAD(Salary,1,0) OVER( ORDER BY Salary DESC)  AS NextSalary FROM Employees_Day6;

--3.
SELECT EmployeeName,DepartmentID, Salary, LAG(Salary,1,0) 
OVER( 
PARTITION BY DepartmentID
ORDER BY Salary DESC)  AS PreviousDepartmentSalary FROM Employees_Day6;

--4.
SELECT EmployeeName,Salary, LAG(Salary,1,0) OVER( ORDER BY Salary DESC)  AS PreviousSalary,
Salary - LAG(Salary,1,0) OVER( ORDER BY Salary DESC) AS SalaryDifference
FROM Employees_Day6;

--5.
SELECT EmployeeName,Salary, SUM(Salary) OVER( ORDER BY EmployeeID)  AS RunningTotal FROM Employees_Day6;

--6.
SELECT EmployeeName,Salary, SUM(Salary) OVER( PARTITION BY DepartmentID ORDER BY EmployeeID)  AS DepartmentRunningTotal FROM Employees_Day6;

--7.
SELECT EmployeeName,DepartmentID, Salary, FIRST_VALUE(Salary) OVER( PARTITION BY DepartmentID ORDER BY Salary DESC)  AS HighestDeptSalary FROM Employees_Day6;

--8.
WITH HighDeptSal AS (
SELECT EmployeeName,DepartmentID, Salary, FIRST_VALUE(Salary) OVER( PARTITION BY DepartmentID ORDER BY Salary DESC)  AS HighestDeptSalary FROM Employees_Day6
)
SELECT EmployeeName,DepartmentID, HighestDeptSalary , HighestDeptSalary - Salary  AS HighestSalaryDifference FROM HighDeptSal;

--9.
SELECT EmployeeName,DepartmentID, Salary, AVG(Salary) OVER( PARTITION BY DepartmentID)  AS RunningAvg
,CASE 
WHEN Salary > AVG(Salary) OVER( PARTITION BY DepartmentID) THEN 'Above Department Average'
WHEN Salary = AVG(Salary) OVER( PARTITION BY DepartmentID) THEN 'Equal to Department Average'
WHEN Salary < AVG(Salary) OVER( PARTITION BY DepartmentID) THEN 'Below Department Average'
END AS SalaryStatus
FROM Employees_Day6;

--10.
WITH RankedEmployees AS
(
    SELECT
        e.EmployeeName,
        d.DepartmentName,
        e.Salary,

        DENSE_RANK() OVER(
            PARTITION BY e.DepartmentID
            ORDER BY e.Salary DESC
        ) AS SalaryRank,
		FIRST_VALUE(Salary) 
		OVER(PARTITION BY e.DepartmentID 
		ORDER BY e.Salary DESC) AS HighesSalary
    FROM Employees_Day6 e
    JOIN Departments_Day6 d
        ON e.DepartmentID = d.DepartmentID
)
SELECT
    DepartmentName,
    EmployeeName,
    Salary, HighesSalary
FROM RankedEmployees
WHERE SalaryRank = 2;

--Theory
--1.
-- LAG() accesses a previous row, while LEAD() accesses a subsequent row within the window.

--2.
--A running total is the cumulative sum of values up to the current row.
--3.
--GROUP BY collapses multiple rows into one row per group, whereas window functions perform calculations across related rows while preserving the original rows.

--4.
/*
Window functions are evaluated after the WHERE phase, so their results aren't directly available to the WHERE clause. 
We can use a CTE or subquery to calculate the window function first and then filter its result.
*/

--5.
-- we will have to use CTE with windows function because we can't use windows function directly with where as a condition