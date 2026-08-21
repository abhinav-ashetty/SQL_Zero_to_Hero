# 🚀 Day 10 — SQL Interview Masterclass

Today is **very important** because we're connecting everything you've learned so far to the kind of SQL questions interviewers actually ask.

**Goal:** By the end of today, you should be able to explain **query execution order** and solve the most common SQL interview problems confidently.

**Time:** ~35–40 minutes
**Database:** SQL Server / SSMS

---

# 1. 🔥 Query Execution Order — MUST KNOW

When you write:

```sql
SELECT DepartmentID, AVG(Salary) AS AvgSalary
FROM Employees_Day6
WHERE Salary > 50000
GROUP BY DepartmentID
HAVING AVG(Salary) > 70000
ORDER BY AvgSalary DESC;
```

You **read** it from:

```text
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
```

But SQL logically processes it approximately as:

```text
1. FROM
2. JOIN
3. WHERE
4. GROUP BY
5. HAVING
6. SELECT
7. DISTINCT
8. ORDER BY
9. TOP / OFFSET-FETCH
```

### 🔥 Memorize this:

> **FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → TOP**

This is one of the most common DBMS interview questions.

---

# 2. Why does `WHERE` come before `GROUP BY`?

Suppose:

```sql
SELECT DepartmentID, AVG(Salary)
FROM Employees_Day6
WHERE Salary > 70000
GROUP BY DepartmentID;
```

Think:

```text
Employees
    ↓
FROM
    ↓
Remove employees with Salary <= 70000
    ↓
WHERE
    ↓
Group remaining employees
    ↓
GROUP BY
    ↓
Calculate AVG
    ↓
SELECT
```

So:

> `WHERE` filters **individual rows before grouping**.

---

# 3. Why does `HAVING` come after `GROUP BY`?

Consider:

```sql
SELECT
    DepartmentID,
    AVG(Salary) AS AvgSalary
FROM Employees_Day6
GROUP BY DepartmentID
HAVING AVG(Salary) > 70000;
```

The process is:

```text
FROM
 ↓
GROUP BY Department
 ↓
Calculate AVG for each department
 ↓
HAVING
 ↓
Keep departments whose average > 70000
```

Therefore:

### `WHERE`

Filters **rows**

### `HAVING`

Filters **groups**

---

# 4. WHERE vs HAVING — Interview Answer

If interviewer asks:

> What's the difference between WHERE and HAVING?

Say:

> **`WHERE` filters individual rows before grouping, while `HAVING` filters groups after `GROUP BY` and is commonly used with aggregate functions.**

Example:

```sql
-- Row filtering
SELECT *
FROM Employees_Day6
WHERE Salary > 70000;
```

versus:

```sql
-- Group filtering
SELECT DepartmentID, AVG(Salary) AS AvgSalary
FROM Employees_Day6
GROUP BY DepartmentID
HAVING AVG(Salary) > 70000;
```

---

# 5. 🔥 Why Can't We Use SELECT Alias in WHERE?

Consider:

```sql
SELECT
    Salary * 12 AS AnnualSalary
FROM Employees_Day6
WHERE AnnualSalary > 1000000;
```

SQL Server will complain.

Why?

Because logically:

```text
WHERE
 ↓
SELECT
```

`WHERE` is evaluated before `SELECT`.

Therefore `AnnualSalary` doesn't exist yet when `WHERE` is logically processed.

---

# 6. But Why Does Alias Work in ORDER BY?

This works:

```sql
SELECT
    Salary * 12 AS AnnualSalary
FROM Employees_Day6
ORDER BY AnnualSalary DESC;
```

Because:

```text
SELECT
 ↓
ORDER BY
```

So the alias has already been created.

### Interview answer:

> A SELECT alias generally cannot be referenced in WHERE because WHERE is logically evaluated before SELECT, while ORDER BY is evaluated after SELECT.

---

# 7. Why Can't Window Functions Be Used in WHERE?

You've already encountered this.

This is invalid:

```sql
SELECT
    EmployeeName,
    Salary,
    DENSE_RANK() OVER(
        ORDER BY Salary DESC
    ) AS SalaryRank
FROM Employees_Day6
WHERE SalaryRank = 2;
```

Why?

Because the ranking hasn't been calculated when `WHERE` is evaluated.

So we use a CTE:

```sql
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
SELECT *
FROM RankedEmployees
WHERE SalaryRank = 2;
```

This pattern should now be automatic for you.

---

# 8. 🔥 Common Interview Question — Second Highest Salary

You already know several ways.

### Method 1 — `TOP` + subquery

```sql
SELECT TOP 1 Salary
FROM Employees_Day6
WHERE Salary < (
    SELECT MAX(Salary)
    FROM Employees_Day6
)
ORDER BY Salary DESC;
```

---

### Method 2 — `DENSE_RANK()`

```sql
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
SELECT *
FROM RankedEmployees
WHERE SalaryRank = 2;
```

### Which is better?

If interviewer specifically asks about **ranking**, use `DENSE_RANK()`.

If they simply ask:

> Find second highest salary.

Both are valid.

---

# 9. 🔥 What If There Are Duplicates?

Suppose:

```text
100000
90000
90000
80000
```

What is the second-highest salary?

Answer:

```text
90000
```

That's why:

```sql
DENSE_RANK()
```

is useful.

```text
100000 → 1
90000  → 2
90000  → 2
80000  → 3
```

---

# 10. Third Highest Salary

Exactly the same pattern:

```sql
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
SELECT *
FROM RankedEmployees
WHERE SalaryRank = 3;
```

---

# 11. Nth Highest Salary

Make it dynamic:

```sql
DECLARE @N INT = 3;

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
SELECT *
FROM RankedEmployees
WHERE SalaryRank = @N;
```

🔥 This is a nice interview-level answer.

---

# 12. 🔥 Top 2 Employees Per Department

Very common interview question.

Question:

> Find the top 2 highest-paid employees in every department.

Use:

```sql
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
SELECT *
FROM RankedEmployees
WHERE SalaryRank <= 2;
```

Notice:

```sql
PARTITION BY DepartmentID
```

This is what makes the ranking restart for every department.

---

# 13. Top 1 Employee Per Department

```sql
WITH RankedEmployees AS
(
    SELECT
        EmployeeName,
        DepartmentID,
        Salary,

        ROW_NUMBER() OVER(
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS RowNum

    FROM Employees_Day6
)
SELECT *
FROM RankedEmployees
WHERE RowNum = 1;
```

### Why `ROW_NUMBER()` here?

Because you want exactly **one employee per department**.

If two employees tie for highest salary:

```text
Employee A → 1
Employee B → 2
```

Only A is selected.

If the requirement says:

> Return **all employees tied for highest salary**

then use:

```sql
DENSE_RANK()
```

---

# 14. 🔥 Duplicate Records

Another classic interview question.

Suppose:

```text
EmployeeName | Email
-------------|----------------
John         | john@gmail.com
John         | john@gmail.com
David        | david@gmail.com
```

Find duplicate emails:

```sql
SELECT
    Email,
    COUNT(*) AS DuplicateCount
FROM Employees_Day6
GROUP BY Email
HAVING COUNT(*) > 1;
```

Remember:

```text
GROUP BY
+
HAVING COUNT(*) > 1
```

is the classic duplicate-detection pattern.

---

# 15. Delete Duplicate Records — Concept

If asked how you would remove duplicates while keeping one record, `ROW_NUMBER()` is very useful.

For example:

```sql
WITH DuplicateEmployees AS
(
    SELECT
        EmployeeID,
        Email,

        ROW_NUMBER() OVER(
            PARTITION BY Email
            ORDER BY EmployeeID
        ) AS RowNum

    FROM Employees
)
DELETE FROM DuplicateEmployees
WHERE RowNum > 1;
```

⚠️ Don't execute this on your real database without understanding exactly what it will delete.

For interview purposes, understand the pattern:

```text
PARTITION BY duplicate-defining columns
        ↓
ROW_NUMBER()
        ↓
Keep RowNum = 1
        ↓
Remove RowNum > 1
```

---

# 16. 🔥 Employees Earning More Than Their Department Average

You already know this from Day 9.

```sql
SELECT
    EmployeeName,
    DepartmentID,
    Salary
FROM
(
    SELECT
        EmployeeName,
        DepartmentID,
        Salary,

        AVG(Salary) OVER(
            PARTITION BY DepartmentID
        ) AS DepartmentAverage

    FROM Employees_Day6
) E
WHERE Salary > DepartmentAverage;
```

This is a beautiful example of:

```text
Window Function
+
Subquery
+
WHERE
```

---

# 17. Employees Earning More Than Their Manager

This is a very common **self JOIN** interview problem.

Imagine:

```text
EmployeeID
EmployeeName
Salary
ManagerID
```

Example:

```text
Employee  Salary  Manager
Alice     60000   5
Bob       80000   5
Manager   70000   NULL
```

Question:

> Find employees earning more than their manager.

Join the table to itself:

```sql
SELECT
    e.EmployeeName,
    e.Salary,
    m.EmployeeName AS ManagerName,
    m.Salary AS ManagerSalary
FROM Employees e
JOIN Employees m
    ON e.ManagerID = m.EmployeeID
WHERE e.Salary > m.Salary;
```

### Understand this:

```text
Employees e
     ↓
Employee

Employees m
     ↓
Manager
```

Same table, different aliases.

This is called a:

> **Self Join**

---

# 18. 🔥 Query Execution Order Example

Look at:

```sql
SELECT
    DepartmentID,
    COUNT(*) AS EmployeeCount
FROM Employees_Day6
WHERE Salary > 70000
GROUP BY DepartmentID
HAVING COUNT(*) >= 2
ORDER BY EmployeeCount DESC;
```

Logical execution:

```text
1. FROM Employees_Day6

2. WHERE Salary > 70000

3. GROUP BY DepartmentID

4. HAVING COUNT(*) >= 2

5. SELECT DepartmentID, COUNT(*)

6. ORDER BY EmployeeCount DESC
```

Notice:

```text
EmployeeCount
```

is an alias created in `SELECT`.

Therefore it can be used in `ORDER BY`.

---

# 19. SQL Execution Order — Memorize This

Write this in your GitHub notes:

```text
FROM
 ↓
JOIN
 ↓
WHERE
 ↓
GROUP BY
 ↓
HAVING
 ↓
SELECT
 ↓
DISTINCT
 ↓
ORDER BY
 ↓
TOP / OFFSET-FETCH
```

### But one important nuance:

For **logical query processing**, `TOP` is generally treated with the final result processing rather than as a simple standalone phase. For interview purposes, the safest core sequence to memorize is:

```text
FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY
```

Then remember `TOP`/`OFFSET-FETCH` limits the final ordered result.

---

# 20. 🔥 TOP vs OFFSET-FETCH in SQL Server

Since you're using **SSMS / SQL Server**, don't use:

```sql
LIMIT
```

That's MySQL/PostgreSQL-style syntax.

You already encountered this problem.

### SQL Server:

```sql
SELECT TOP 5 *
FROM Employees_Day6
ORDER BY Salary DESC;
```

For pagination:

```sql
SELECT *
FROM Employees_Day6
ORDER BY EmployeeID
OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY;
```

Meaning:

```text
OFFSET 5
↓
Skip first 5

FETCH NEXT 5
↓
Return next 5
```

---

# 🎯 Day 10 Practice

Now I want you to solve these **without looking at the answers**.

Use `Employees_Day6` and `Departments_Day6` unless otherwise specified.

## Level 1

### Q1

Find the **second-highest distinct salary**.

---

### Q2

Find the **third-highest distinct salary**.

---

### Q3

Find the **highest-paid employee in each department**.

If two employees have the same highest salary, return **both**.

---

### Q4

Find the **top 2 highest-paid employees in each department**, including ties.

---

## Level 2

### Q5

Find departments having **more than 2 employees** whose salary is greater than `70000`.

Return:

```text
DepartmentName
EmployeeCount
```

---

### Q6

Find employees whose salary is **greater than their department's average salary**.

Return:

```text
EmployeeName
DepartmentID
Salary
DepartmentAverage
```

---

### Q7

Find duplicate employee names.

Return:

```text
EmployeeName
DuplicateCount
```

---

## Level 3 🔥

### Q8

For every employee, show:

```text
EmployeeName
Salary
HighestCompanySalary
DifferenceFromHighest
```

Use a window function.

---

### Q9

For every department, return the employee(s) with the **second-highest salary**.

Return:

```text
DepartmentName
EmployeeName
Salary
```

---

### Q10 — Interview Theory 🔥🔥

Without running SQL, explain the logical execution order of:

```sql
SELECT TOP 3
    DepartmentID,
    AVG(Salary) AS AvgSalary
FROM Employees_Day6
WHERE Salary > 50000
GROUP BY DepartmentID
HAVING AVG(Salary) > 70000
ORDER BY AvgSalary DESC;
```

Write the order in this format:

```text
1. ______
2. ______
3. ______
...
```

---

# 🧠 One Last Challenge

After solving Q1–Q10, answer these **from memory**:

**A.** Why can't we use a window function directly in `WHERE`?

**B.** Difference between `WHERE` and `HAVING`?

**C.** Difference between `ROW_NUMBER()` and `DENSE_RANK()`?

**D.** What does `PARTITION BY` do?

**E.** Why does `ORDER BY` inside a window function matter?


