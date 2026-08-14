-- practice question's Solutions:
--1.
SELECT TOP 1 * FROM Employees_Day3
ORDER BY Salary DESC;

SELECT * FROM Employees_Day3
WHERE Salary = (SELECT MAX(Salary) FROM Employees_Day3);

--2.
SELECT * FROM Employees_Day3
WHERE Salary > (SELECT AVG(CAST(Salary AS DECIMAL(10,2))) AS AvgSalary FROM Employees_Day3);

--3.
SELECT MAX(Salary) AS SecondHighestSalary FROM Employees_Day3
WHERE Salary < (SELECT MAX(Salary) FROM Employees_Day3);

--4.
SELECT * FROM Employees_Day3
WHERE DepartmentID IN (SELECT DepartmentID FROM Departments_Day3
WHERE Location = 'Bangalore');

--5.
SELECT * FROM Employees_Day3
WHERE DepartmentID NOT IN (SELECT DepartmentID FROM Departments_Day3 
WHERE DepartmentName= 'IT');
--there's no NULL, so your query works.
--But generally, when checking existence/non-existence, NOT EXISTS is often safer.
--We'll return to this later.

--6.
SELECT * FROM Departments_Day3 d
WHERE EXISTS ( SELECT 1 FROM Employees_Day3 e
WHERE e.DepartmentID = d.DepartmentID);

--7.
SELECT * FROM Departments_Day3 d
WHERE NOT EXISTS ( SELECT 1 FROM Employees_Day3 e
WHERE e.DepartmentID = d.DepartmentID);

--8.
SELECT * FROM Employees_Day3
WHERE Salary > ALL(SELECT Salary FROM Employees_Day3 WHERE DepartmentID=2);
-- means: Salary > ALL (50000, 80000) => Salary > 50000 AND Salary > 80000

--9.
SELECT
    e.EmployeeName,
    e.DepartmentID,
    e.Salary
FROM Employees_Day3 e
WHERE NOT EXISTS
(
    SELECT 1
    FROM Employees_Day3 e2
    WHERE e2.DepartmentID = e.DepartmentID
      AND e2.Salary > e.Salary
);

--10. 
-- in: Used when we want to compare a value against a set of values returned by a subquery.
--EXISTS: Checks whether the subquery returns at least one row.
--NOT EXISTS: Checks whether the subquery returns no rows.


--Challenge A
SELECT * FROM Employees_Day3
WHERE Salary < ALL(SELECT Salary FROM Employees_Day3 WHERE DepartmentID = 1);

--Challenge B 🔥
SELECT * FROM Employees_Day3 e
WHERE NOT EXISTS (
SELECT 1 FROM Employees_Day3 e2
WHERE e2.DepartmentID = e.DepartmentID AND e2.Salary > e.Salary);

--join concept
SELECT
    e1.EmployeeName,
    e1.DepartmentID,
    e1.Salary
FROM Employees_Day3 e1
LEFT JOIN Employees_Day3 e2
    ON e1.DepartmentID = e2.DepartmentID
    AND e2.Salary > e1.Salary
WHERE e2.EmployeeID IS NULL;