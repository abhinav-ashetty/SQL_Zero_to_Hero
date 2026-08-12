Absolutely. 🔥 **Day 3 starts now.**

Today is one of the most important SQL days because **JOINs are almost guaranteed in SQL interviews**.

We'll continue using **SQL Server / SSMS**, and I'll give you a ready-to-paste dataset.

# 🗓️ DAY 3 — SQL JOINs

**Time:** ~30–35 minutes

### Today's goals

By the end, you should understand:

* `INNER JOIN`
* `LEFT JOIN`
* `RIGHT JOIN`
* `FULL OUTER JOIN`
* How `ON` works
* `JOIN` vs `WHERE`
* How to join 3+ tables
* Common interview JOIN questions

---

# 1. Why Do We Need JOINs?

Imagine our `Employees` table:

```text
EmployeeID | EmployeeName | DepartmentID | Salary
-----------|--------------|--------------|-------
101        | Alice        | 1            | 70000
102        | Bob          | 2            | 50000
103        | Charlie      | 1            | 90000
```

And another table:

```text
DepartmentID | DepartmentName
-------------|---------------
1            | IT
2            | HR
3            | Finance
```

The employee table knows:

> Alice belongs to department **1**

But it doesn't contain:

> Department 1 = **IT**

The department table knows that.

So we need to **combine information from both tables**.

That's what a JOIN does.

---

# 2. Create Our Day 3 Dataset

We'll create a fresh set of tables so you can practice JOINs independently.

Paste this entire script into SSMS.

```sql
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
```

Notice something deliberately important:

### `Marketing` has no employees.

And:

### `Ian` has no department.

I deliberately created these because they'll help you understand the difference between JOIN types.

---

# 3. First Understand the Relationship

We have:

```text
Employees_Day3
        |
        | DepartmentID
        |
        ↓
Departments_Day3
```

The common column is:

```text
Employees_Day3.DepartmentID
          =
Departments_Day3.DepartmentID
```

That is our **JOIN condition**.

---

# 4. INNER JOIN ⭐⭐⭐

Let's start with the most common JOIN.

Question:

> Show each employee along with their department name.

```sql
SELECT
    e.EmployeeName,
    d.DepartmentName
FROM Employees_Day3 e
INNER JOIN Departments_Day3 d
    ON e.DepartmentID = d.DepartmentID;
```

Result conceptually:

```text
EmployeeName    DepartmentName
-------------   --------------
Alice           IT
Bob             HR
Charlie         IT
David           Sales
Eva             HR
Frank           Finance
Grace           Sales
Helen           IT
```

Notice:

**Ian is missing.**

Why?

Because Ian has:

```text
DepartmentID = NULL
```

There is no matching department.

And Marketing is missing because it has no employee.

That's exactly what `INNER JOIN` does:

> **Return only rows that have a match in both tables.**

genui{"data_networks_databases_learning_block":{"type_id":"SQL_JOIN"}}

---

# 🧠 Mental Model

Think:

```text
Employees       Departments

Alice ───────── IT       ✅
Bob ─────────── HR       ✅
Charlie ─────── IT       ✅
David ───────── Sales     ✅
...
Ian ─────────── NULL      ❌
Marketing ─────────────── ❌
```

INNER JOIN keeps only the ✅ matches.

---

# 5. JOIN vs INNER JOIN

These are equivalent:

```sql
SELECT *
FROM Employees_Day3 e
INNER JOIN Departments_Day3 d
    ON e.DepartmentID = d.DepartmentID;
```

and:

```sql
SELECT *
FROM Employees_Day3 e
JOIN Departments_Day3 d
    ON e.DepartmentID = d.DepartmentID;
```

`JOIN` by itself means **INNER JOIN**.

In interviews, you'll often see:

```sql
INNER JOIN
```

because it makes the intention explicit.

---

# 6. LEFT JOIN ⭐⭐⭐

Now imagine the interviewer asks:

> Show **ALL employees**, even if they don't belong to a department.

`INNER JOIN` won't work because Ian would disappear.

We need:

```sql
SELECT
    e.EmployeeName,
    d.DepartmentName
FROM Employees_Day3 e
LEFT JOIN Departments_Day3 d
    ON e.DepartmentID = d.DepartmentID;
```

Result:

```text
Alice       IT
Bob         HR
Charlie     IT
David       Sales
Eva         HR
Frank       Finance
Grace       Sales
Helen       IT
Ian         NULL
```

### Key rule:

> **LEFT JOIN keeps everything from the LEFT table.**

Here:

```text
LEFT TABLE
    ↓
Employees_Day3
```

So **all employees remain**.

---

# 🧠 Very Important Interview Trick

When you see:

```sql
A
LEFT JOIN
B
```

Immediately think:

> **Keep everything from A.**

---

# 7. RIGHT JOIN

Now reverse the requirement.

> Show **all departments**, even if they don't have employees.

```sql
SELECT
    e.EmployeeName,
    d.DepartmentName
FROM Employees_Day3 e
RIGHT JOIN Departments_Day3 d
    ON e.DepartmentID = d.DepartmentID;
```

Result includes:

```text
Alice       IT
Bob         HR
Charlie     IT
David       Sales
Eva         HR
Frank       Finance
Grace       Sales
Helen       IT
NULL        Marketing
```

Marketing appears even though there are no employees.

Because:

> **RIGHT JOIN keeps everything from the right table.**

Here:

```text
RIGHT TABLE
     ↓
Departments_Day3
```

---

# ⭐ Professional SQL Tip

You can technically use `RIGHT JOIN`, but many developers prefer rewriting it as a `LEFT JOIN`.

Instead of:

```sql
FROM Employees_Day3 e
RIGHT JOIN Departments_Day3 d
    ON e.DepartmentID = d.DepartmentID
```

write:

```sql
FROM Departments_Day3 d
LEFT JOIN Employees_Day3 e
    ON d.DepartmentID = e.DepartmentID
```

Same result, but `LEFT JOIN` is often easier to read because you can consistently put the table you want to preserve on the left.

---

# 8. FULL OUTER JOIN

Now suppose the interviewer says:

> Show **everything from both tables**, matched wherever possible.

Use:

```sql
SELECT
    e.EmployeeName,
    d.DepartmentName
FROM Employees_Day3 e
FULL OUTER JOIN Departments_Day3 d
    ON e.DepartmentID = d.DepartmentID;
```

Now you'll get:

```text
Alice       IT
Bob         HR
Charlie     IT
David       Sales
Eva         HR
Frank       Finance
Grace       Sales
Helen       IT
Ian         NULL
NULL        Marketing
```

Why?

Because FULL OUTER JOIN keeps:

```text
Matched rows
+
Unmatched left rows
+
Unmatched right rows
```

---

# 🧠 JOIN Cheat Sheet

Memorize this:

```text
INNER JOIN
→ Only matching rows

LEFT JOIN
→ Everything from LEFT + matching RIGHT

RIGHT JOIN
→ Everything from RIGHT + matching LEFT

FULL OUTER JOIN
→ Everything from BOTH
```

---

# 9. The `ON` Clause

This is extremely important.

You wrote:

```sql
ON e.DepartmentID = d.DepartmentID
```

`ON` tells SQL Server:

> **How are these two tables related?**

It doesn't necessarily have to be the same column name.

For example:

```sql
ON e.DepartmentID = d.DepartmentID
```

means:

```text
employee's department
        =
department table's department
```

---

# 10. JOIN + WHERE ⭐⭐⭐

Suppose:

> Find IT employees.

```sql
SELECT
    e.EmployeeName,
    d.DepartmentName,
    e.Salary
FROM Employees_Day3 e
INNER JOIN Departments_Day3 d
    ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT';
```

Notice:

```text
JOIN
 ↓
WHERE
```

We first connect the tables, then filter the result.

---

# 11. JOIN + WHERE + ORDER BY

Now:

> Find IT employees earning more than 80,000, highest salary first.

```sql
SELECT
    e.EmployeeName,
    d.DepartmentName,
    e.Salary
FROM Employees_Day3 e
INNER JOIN Departments_Day3 d
    ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT'
  AND e.Salary > 80000
ORDER BY e.Salary DESC;
```

This is a very realistic interview query.

---

# 12. JOIN + GROUP BY 🔥

Now combine Day 2 and Day 3.

Question:

> Find the number of employees in each department.

```sql
SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Departments_Day3 d
LEFT JOIN Employees_Day3 e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;
```

Why did I use **LEFT JOIN** instead of INNER JOIN?

Because we want **Marketing** to appear:

```text
Marketing → 0
```

With INNER JOIN, Marketing would disappear.

This is a very important real-world pattern.

---

# 🚨 COUNT(*) vs COUNT(column)

This is an interview favorite.

Consider:

```sql
SELECT
    d.DepartmentName,
    COUNT(*) AS EmployeeCount
FROM Departments_Day3 d
LEFT JOIN Employees_Day3 e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;
```

For Marketing, the LEFT JOIN produces a row with NULL employee columns.

`COUNT(*)` counts that row.

So you could get:

```text
Marketing → 1
```

which is **wrong for employee count**.

Instead:

```sql
COUNT(e.EmployeeID)
```

doesn't count the NULL employee.

So:

```sql
SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Departments_Day3 d
LEFT JOIN Employees_Day3 e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;
```

gives:

```text
Finance    1
HR         2
IT         3
Marketing  0
Sales      2
```

🔥 **Remember this.**

> With a `LEFT JOIN`, `COUNT(*)` and `COUNT(right_table.column)` can produce different results.

---

# 🎯 Now It's Your Turn

Don't copy solutions. Run these in SSMS.

## Q1 — Easy

Display:

```text
EmployeeName
DepartmentName
```

for all employees who have a department.

---

## Q2

Display **all employees**, including employees without a department.

---

## Q3

Display **all departments**, including departments with no employees.

---

## Q4

Display all employees along with:

```text
EmployeeName
DepartmentName
Salary
```

but only employees earning **more than 70,000**.

---

## Q5 ⭐

Find the **number of employees in each department**, including departments with zero employees.

Expected:

```text
DepartmentName | EmployeeCount
---------------|--------------
Finance        | 1
HR             | 2
IT             | 3
Marketing      | 0
Sales          | 2
```

---

## Q6 ⭐

Find the **average salary of each department**, including departments with no employees.

Think carefully about what should happen to Marketing.

---

## Q7 🔥

Find the **highest-paid employee in each department**.

Expected structure:

```text
DepartmentName | EmployeeName | Salary
```

**Hint:** You don't need window functions yet. Try to solve it using what you've learned so far.

---

## Q8 🔥 Interview Question

Find employees who **do not belong to any department**.

Expected:

```text
Ian
```

---

## Q9 🔥 Interview Question

Find departments that **currently have no employees**.

Expected:

```text
Marketing
```

---

## Q10 ⭐⭐⭐

Explain in your own words:

> What is the difference between `INNER JOIN` and `LEFT JOIN`?

Don't give me a textbook definition. Explain it as if **I am the interviewer**.

---

# 🧠 Your Day 3 Challenge

Do **Q1–Q10 yourself in SSMS**.

---

Important distinction
ON     → How do I connect the tables?
WHERE  → Which rows do I want?

This distinction is extremely important.

---
Here's where I want you to stop.

Don't learn the solution yet.

This question is intentionally beyond today's basic JOIN knowledge.

To elegantly solve:

highest-paid employee per department

we need something we haven't learned yet:

Window Functions

Specifically:

ROW_NUMBER()
RANK()
DENSE_RANK()

And that's actually one of the mandatory interview topics you told me about at the beginning.

So don't memorize a complicated solution today.

We'll solve this properly when we reach Day 13–14.

---
Q8 ❌ — Very Important NULL Trap
🧠 Why doesn't = NULL work?

This is one of those things I want you to understand, not memorize.

NULL means:

Unknown / missing value.

Suppose:

Ian's DepartmentID = NULL

SQL cannot say:

Unknown = Unknown

and conclude that it's true.

Therefore:

= NULL

doesn't work as a NULL test.

Use:

IS NULL

or:

IS NOT NULL
Remember forever:
-- ❌ Wrong
WHERE DepartmentID = NULL

-- ✅ Correct
WHERE DepartmentID IS NULL

-- ❌ Wrong
WHERE DepartmentID <> NULL

-- ✅ Correct
WHERE DepartmentID IS NOT NULL

This is a very common interview trap.
---
🧠 Your Most Important Day 3 Lessons

You now have these patterns:

Matching records
INNER JOIN
Everything from left
LEFT JOIN
Everything from right
RIGHT JOIN
Everything from both
FULL OUTER JOIN
Records without a match
LEFT JOIN
...
WHERE right_table.id IS NULL
NULL checking
IS NULL
IS NOT NULL
Aggregation after JOIN
JOIN
↓
GROUP BY
↓
COUNT / AVG / SUM / etc.
🚨 One Concept I Want You to Remember

Look at these two questions:

Question A

Find employees who belong to IT.

Think:

Employees
   ↓
JOIN Departments
   ↓
WHERE Department = IT
Question B

Find departments with no employees.

Think:

Departments
   ↓
LEFT JOIN Employees
   ↓
WHERE EmployeeID IS NULL

The table you start from matters.

This is one of the biggest things beginners struggle with in JOINs.

🎯 One Final Mini Challenge

Before we officially finish Day 3, solve these without me giving you the answer:

Challenge 1

Find all employees who do not have a department.

Challenge 2

Find all departments that have at least one employee earning more than 80,000.

Challenge 3 🔥

Find the total salary paid by each department, including Marketing.

Use only concepts we've learned so far.




