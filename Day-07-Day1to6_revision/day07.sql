SELECT * FROM Employees_Day6;
SELECT * FROM Departments_Day6;

--Level 1 - Fundamentals
--1.
SELECT
    e.EmployeeName,
    e.Salary,
    d.DepartmentName
FROM Employees_Day6 e
JOIN Departments_Day6 d
    ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT'
  AND e.Salary > 80000;

--2.
SELECT EmployeeName,Salary FROM Employees_Day6
WHERE Salary > (SELECT AVG(CAST(Salary AS DECIMAL(10,2))) FROM Employees_Day6);

--3.
SELECT MAX(Salary) AS HighestSalary FROM Employees_Day6

--Level 2 - GROUP BY + HAVING
--4.
SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Departments_Day6 d
LEFT JOIN Employees_Day6 e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

--5.
SELECT d.DepartmentName,AVG(CAST(e.Salary AS DECIMAL(10,2))) AS AvgSalary FROM Departments_Day6 d
LEFT JOIN Employees_Day6 e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName HAVING AVG(CAST(e.Salary AS DECIMAL(10,2))) > 70000;

--6.
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS HighSalaryEmployeeCount FROM Departments_Day6 d
LEFT JOIN Employees_Day6 e ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > 70000
GROUP BY d.DepartmentName HAVING COUNT(e.EmployeeID) >=2;


--Level 3 - SUBQUERIES
--7.
SELECT MAX(Salary) AS SecondHighestSalary FROM Employees_Day6
WHERE Salary < (SELECT MAX(Salary) FROM Employees_Day6);

--8.
SELECT
    EmployeeName,
    Salary
FROM Employees_Day6
WHERE Salary > ALL
(
    SELECT Salary
    FROM Employees_Day6
    WHERE DepartmentID = 1
);

--9.
SELECT d.DepartmentName FROM Departments_Day6 d
WHERE NOT EXISTS(
SELECT 1 FROM Employees_Day6 e 
WHERE e.DepartmentID = d.DepartmentID
)

--Level 4 - CASE + Conditnal Aggregation
--10.
SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID) AS TotalEmployees,
    COUNT(CASE
        WHEN e.Salary >= 70000 THEN 1
    END) AS HighSalaryEmployees,
    COUNT(CASE
        WHEN e.Salary < 70000 THEN 1
    END) AS LowSalaryEmployees
FROM Departments_Day6 d
LEFT JOIN Employees_Day6 e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

--11.
SELECT
    d.DepartmentName,

    ISNULL(SUM(e.Salary), 0) AS TotalSalary,

    ISNULL(
        SUM(
            CASE
                WHEN e.Salary >= 70000 THEN e.Salary
                ELSE 0
            END
        ),
        0
    ) AS HighSalaryTotal

FROM Departments_Day6 d
LEFT JOIN Employees_Day6 e
    ON d.DepartmentID = e.DepartmentID

GROUP BY d.DepartmentName;

--LEVEL -5
--12
SELECT e.EmployeeName,
       e.Salary,
       e.DepartmentID
FROM Employees_Day6 e
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees_Day6 e2
    WHERE e2.DepartmentID = e.DepartmentID
      AND e2.Salary > e.Salary
);

--13.
WITH DeptAverageSalary AS(
SELECT d.DepartmentName,AVG(CAST(e.Salary AS DECIMAL(10,2))) AS AverageSalary FROM Departments_Day6 d
LEFT JOIN Employees_Day6 e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
)
SELECT TOP 1 * FROM DeptAverageSalary
ORDER BY AverageSalary DESC;

--14.
SELECT EmployeeName FROM Employees_Day6
WHERE DepartmentID IS NULL

--15
WITH DeptAverageSalary AS(
SELECT d.DepartmentID,d.DepartmentName,
ISNULL(AVG(CAST(e.Salary AS DECIMAL(10,2))),0) AS AverageSalary,
COUNT(e.EmployeeID) AS EmployeeCount 
FROM Departments_Day6 d
LEFT JOIN Employees_Day6 e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName,d.DepartmentID
)
SELECT DepartmentName, AverageSalary ,EmployeeCount FROM DeptAverageSalary
WHERE AverageSalary > 70000 AND EmployeeCount >=2;

/*
🎯 Your 5 Interview Answers — Memorize the Concepts

If tomorrow the interviewer asks these rapidly, you should be able to answer:

WHERE vs HAVING

WHERE filters rows; HAVING filters groups after aggregation.

INNER vs LEFT JOIN

INNER JOIN returns matching rows from both tables; LEFT JOIN keeps all rows from the left table and matching rows from the right.

CTE

A named query expression used mainly to make complex SQL easier to read and maintain.

IN vs EXISTS

IN checks whether a value belongs to a set; EXISTS checks whether a matching row exists; NOT EXISTS checks whether no matching row exists.

NULL

NULL represents an unknown or missing value and must be checked using IS NULL or IS NOT NULL rather than =.

You should be able to say each of those without thinking for more than 5 seconds in an interview.


*/
