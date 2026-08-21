--Practice Problems:
--1.
WITH SecondHighestSalary AS(
SELECT EmployeeName, Salary , DENSE_RANK() OVER(ORDER BY Salary DESC) AS SalaryRank FROM Employees_Day6
)
SELECT EmployeeName, Salary FROM SecondHighestSalary
WHERE SalaryRank = 2;


--2.
WITH SecondHighestSalary AS(
SELECT EmployeeName, Salary , DENSE_RANK() OVER(ORDER BY Salary DESC) AS SalaryRank FROM Employees_Day6
)
SELECT EmployeeName, Salary FROM SecondHighestSalary
WHERE SalaryRank = 3;

--3.
WITH RankedEmployees AS
(
    SELECT
        e.EmployeeName,
        e.DepartmentID,
        e.Salary,
        DENSE_RANK() OVER(
            PARTITION BY e.DepartmentID
            ORDER BY e.Salary DESC
        ) AS SalaryRank
    FROM Employees_Day6 e
)
SELECT
    EmployeeName,
    DepartmentID,
    Salary
FROM RankedEmployees
WHERE SalaryRank = 1;

--4.
WITH RankedEmployees AS
(
    SELECT
        EmployeeName,
        DepartmentID,
        Salary,
        DENSE_RANK() OVER(
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM Employees_Day6
)
SELECT
    EmployeeName,
    DepartmentID,
    Salary
FROM RankedEmployees
WHERE SalaryRank <= 2;

--5.
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS EmployeeCount FROM Departments_Day6 d
LEFT JOIN Employees_Day6 e ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > 70000
GROUP BY DepartmentName HAVING COUNT(e.EmployeeID) >2;

--6.
WITH AvgSal AS (
SELECT DepartmentID,AVG(Salary) AS DepartmentAverage FROM Employees_Day6
GROUP BY DepartmentID
)
SELECT e.EmployeeName,a.DepartmentID,e.Salary, a.DepartmentAverage FROM AvgSal a
LEFT JOIN Employees_Day6 e ON a.DepartmentID=e.DepartmentID
WHERE e.Salary > a.DepartmentAverage

--7.
SELECT
    EmployeeName,
    COUNT(*) AS DuplicateCount
FROM Employees_Day6
GROUP BY EmployeeName
HAVING COUNT(*) > 1;

--8.
SELECT
    EmployeeName,
    Salary,
    MAX(Salary) OVER() AS HighestCompanySalary,
    MAX(Salary) OVER() - Salary AS DifferenceFromHighest
FROM Employees_Day6;

--9.
WITH SecondHighestSalary AS(
SELECT d.DepartmentName, e.EmployeeName, e.Salary , DENSE_RANK() OVER(PARTITION BY e.DepartmentID ORDER BY e.Salary DESC) AS SalaryRank FROM Employees_Day6 e
LEFT JOIN Departments_Day6 d ON e.DepartmentID = d.DepartmentID
)
SELECT DepartmentName, EmployeeName, Salary FROM SecondHighestSalary
WHERE SalaryRank = 2;

--10.
-- choosing from employees_day6 - FROM
-- eliminate emmployees with salary less than 50000 - WHERE
-- grouping employees based on dept ID - GROUP BY
-- employees evg sal must be greater than 70000  are grouped - HAVING
-- selecting the preffered data from table - SELECT
-- is listed in descending order - ORDER BY
-- selected top 3 rows in listing - TOP 

/*
A. Why can't window functions be used directly in WHERE?

Your previous answer was correct:

Window functions are evaluated after the WHERE phase, so their result isn't available to WHERE. We use a CTE or subquery to calculate the window function first and then filter it.

B. WHERE vs HAVING

Your earlier answer was good:

WHERE filters individual rows before grouping, while HAVING filters groups after GROUP BY.

C. ROW_NUMBER vs DENSE_RANK

You should say:

ROW_NUMBER() gives every row a unique sequential number, even when values are tied. DENSE_RANK() gives the same rank to tied values and does not leave gaps.

Example:

Salary     ROW_NUMBER     DENSE_RANK
100000        1               1
90000         2               2
90000         3               2
80000         4               3
D. PARTITION BY

PARTITION BY divides the result into independent groups for the window function while keeping the individual rows.

For example:

PARTITION BY DepartmentID

means:

Calculate separately for each department.

E. Why does ORDER BY inside a window function matter?

This one is very important.

Compare:

AVG(Salary) OVER(
    PARTITION BY DepartmentID
)

with:

AVG(Salary) OVER(
    PARTITION BY DepartmentID
    ORDER BY EmployeeID
)

The first:

Department's overall average.

The second:

Running average within the department.

For ranking:

DENSE_RANK() OVER(
    PARTITION BY DepartmentID
    ORDER BY Salary DESC
)

ORDER BY Salary DESC determines who gets rank 1, rank 2, etc.

*/

