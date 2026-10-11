Absolutely. 🔥 **Day 7 is your first SQL mini-interview day.**

You've learned enough now that I don't want to teach you another major syntax concept today. Instead, we're going to **combine Days 1–6** and identify your weak points before we move into **Window Functions**.

# 🗓️ DAY 7 — SQL Interview Problem Set

**Time:** ~35–45 minutes
**Database:** SQL Server / SSMS

### Topics being tested

```text
SELECT / WHERE
GROUP BY / HAVING
JOINs
Subqueries
CTEs
CASE
NULL
Conditional aggregation
TOP
```

Today's rule:

> **Try every question yourself before asking for hints.**

---

# Dataset

Use your existing:

```text
Employees_Day6
Departments_Day6
```

First run:

```sql
SELECT * FROM Employees_Day6;
SELECT * FROM Departments_Day6;
```

Make sure you're comfortable with the data before starting.

---

# 🟢 LEVEL 1 — Fundamentals

## Q1

Find all employees who:

* work in the IT department
* have salary greater than `80000`

Return:

```text
EmployeeName
Salary
DepartmentName
```

---

## Q2

Find employees whose salary is **greater than the average company salary**.

Return:

```text
EmployeeName
Salary
```

---

## Q3

Find the **highest salary** in the company.

Return only:

```text
HighestSalary
```

---

# 🟡 LEVEL 2 — GROUP BY + HAVING

## Q4

Find the number of employees in each department.

Return:

```text
DepartmentName
EmployeeCount
```

Include departments that have **zero employees**.

🔥 Think carefully about which table you should start from.

---

## Q5

Find departments where the **average salary is greater than 70,000**.

Return:

```text
DepartmentName
AverageSalary
```

---

## Q6

Find departments that have **at least 2 employees** whose salary is greater than `70000`.

Return:

```text
DepartmentName
HighSalaryEmployeeCount
```

This tests:

```text
WHERE
+
GROUP BY
+
HAVING
```

---

# 🟠 LEVEL 3 — SUBQUERIES

## Q7

Find the **second highest salary**.

Requirements:

* Use a subquery.
* Don't use `TOP 2`.
* Don't use window functions.

---

## Q8

Find employees who earn **more than every employee in the IT department**.

Use:

```text
ALL
```

---

## Q9

Find departments that **have no employees**.

Use:

```text
NOT EXISTS
```

---

# 🔵 LEVEL 4 — CASE + Conditional Aggregation

## Q10

For each department, return:

```text
DepartmentName
TotalEmployees
HighSalaryEmployees
LowSalaryEmployees
```

Where:

```text
HighSalary → Salary >= 70000
LowSalary  → Salary < 70000
```

Use **conditional aggregation**.

---

## Q11

For each department, calculate:

```text
DepartmentName
TotalSalary
HighSalaryTotal
```

Where `HighSalaryTotal` means the total salary of employees earning at least `70000`.

---

# 🔴 LEVEL 5 — INTERVIEW QUESTIONS

## Q12 ⭐

Find the **employee(s) with the highest salary in each department**.

Return:

```text
DepartmentName
EmployeeName
Salary
```

You may use:

* CTE
* self JOIN
* `NOT EXISTS`

### 🚨 Don't use window functions yet.

We haven't learned them properly.

Try to solve this using the concepts you've learned.

---

# Q13 ⭐⭐

Find the **department with the highest average salary**.

Return:

```text
DepartmentName
AverageSalary
```

Try solving it using a **CTE**.

---

# Q14 ⭐⭐

Find employees who **don't belong to any department**.

Return:

```text
EmployeeName
```

---

# Q15 🔥

Find departments where:

```text
AverageSalary > 70000
AND
EmployeeCount >= 2
```

Return:

```text
DepartmentName
AverageSalary
EmployeeCount
```

You can use a CTE.

---

# 🧠 THEORY ROUND

Don't skip this part. Your interview isn't only going to contain SQL coding.

## Q16

What is the difference between:

```text
WHERE
HAVING
```

Give me an interview-style answer.

---

## Q17

Explain:

```text
INNER JOIN
LEFT JOIN
```

---

## Q18

What is a CTE?

And why might you use one instead of a deeply nested subquery?

---

## Q19

What is the difference between:

```text
IN
EXISTS
NOT EXISTS
```

---

## Q20 🔥

What is `NULL` in SQL?

And what's the difference between:

```sql
Salary = NULL
```

and:

```sql
Salary IS NULL
```

---

# 🚨 Don't Look at Solutions

For today's session, I deliberately **won't give you the answers beforehand**.

I want to see what you can produce after six days of learning.

Send me your answers like:

```sql
-- Q1
...

-- Q2
...

-- Q3
...
```

For the theory questions, write your answers in plain English.

---

# 🎯 How I'll Evaluate You

I'll categorize each mistake as:

### 🟢 Syntax mistake

You understood the logic but wrote SQL incorrectly.

### 🟡 Concept mistake

You misunderstood how something works.

### 🔴 Interview-risk mistake

A mistake that an interviewer would likely consider a significant weakness.

This distinction matters because **syntax errors are easy to fix; conceptual errors need more practice.**

---

## One important thing

Don't worry if you can't solve Q12.

The problem:

> **highest-paid employee in each department**

Sure. Here are the **interview-ready answers for Q16–Q20**. Don't just memorize the wording—understand the mental model.

---

## Q16. Difference between `WHERE` and `HAVING`

### Interview answer:

> **`WHERE` filters individual rows before grouping, whereas `HAVING` filters groups after `GROUP BY` and aggregation.**

Example:

```sql
-- WHERE filters rows
SELECT *
FROM Employees_Day6
WHERE Salary > 70000;
```

Here, individual employees are filtered.

```sql
-- HAVING filters groups
SELECT
    DepartmentID,
    COUNT(*) AS EmployeeCount
FROM Employees_Day6
GROUP BY DepartmentID
HAVING COUNT(*) >= 2;
```

Here, departments/groups are filtered based on their employee count.

### Remember:

```text
WHERE
→ filters rows

GROUP BY
→ creates groups

HAVING
→ filters groups
```

### ⭐ Interview trap

You generally cannot do:

```sql
WHERE COUNT(*) > 2
```

because `COUNT()` is calculated after `WHERE`.

Instead:

```sql
HAVING COUNT(*) > 2
```

---

# Q17. Difference between `INNER JOIN` and `LEFT JOIN`

### Interview answer:

> **`INNER JOIN` returns only rows that have matching records in both tables. `LEFT JOIN` returns all rows from the left table and matching rows from the right table; when there is no match, the right-side columns contain `NULL`.**

Example:

```sql
SELECT
    e.EmployeeName,
    d.DepartmentName
FROM Employees_Day6 e
INNER JOIN Departments_Day6 d
    ON e.DepartmentID = d.DepartmentID;
```

Only employees with matching departments appear.

With:

```sql
SELECT
    e.EmployeeName,
    d.DepartmentName
FROM Employees_Day6 e
LEFT JOIN Departments_Day6 d
    ON e.DepartmentID = d.DepartmentID;
```

**every employee** appears, including employees whose department is `NULL`.

### Mental model:

```text
INNER JOIN
A ∩ B
→ Matching rows only


LEFT JOIN
A + matching B
→ Everything from A
```

---

# Q18. What is a CTE and why would you use one?

### Interview answer:

> **A CTE, or Common Table Expression, is a named query expression that can be referenced by the main query immediately following it. It is mainly useful for making complex queries more readable, maintainable, and easier to break into logical steps.**

Example:

```sql
WITH DepartmentStats AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary,
        COUNT(*) AS EmployeeCount
    FROM Employees_Day6
    GROUP BY DepartmentID
)
SELECT *
FROM DepartmentStats
WHERE AverageSalary > 70000;
```

Instead of putting everything into one deeply nested query:

```text
CTE
 ↓
Calculate intermediate result
 ↓
Main query
 ↓
Filter / JOIN / process
```

### Important interview point:

Don't say:

> "CTEs are faster than subqueries."

That's not necessarily true.

Better:

> **"I primarily use CTEs for readability and maintainability. Performance depends on the actual query and execution plan."**

---

# Q19. Difference between `IN`, `EXISTS`, and `NOT EXISTS`

### `IN`

`IN` checks whether a value belongs to a set of values.

Example:

```sql
SELECT *
FROM Employees_Day6
WHERE DepartmentID IN
(
    SELECT DepartmentID
    FROM Departments_Day6
    WHERE DepartmentName IN ('IT', 'HR')
);
```

Think:

```text
IN
↓
"Is my value in this set?"
```

---

### `EXISTS`

`EXISTS` checks whether the subquery returns **at least one row**.

```sql
SELECT d.DepartmentName
FROM Departments_Day6 d
WHERE EXISTS
(
    SELECT 1
    FROM Employees_Day6 e
    WHERE e.DepartmentID = d.DepartmentID
);
```

Think:

```text
EXISTS
↓
"Does at least one matching row exist?"
```

It doesn't matter whether there are:

```text
1 employee
10 employees
100 employees
```

As soon as a matching row exists, `EXISTS` is true.

---

### `NOT EXISTS`

Checks whether **no matching row exists**.

```sql
SELECT d.DepartmentName
FROM Departments_Day6 d
WHERE NOT EXISTS
(
    SELECT 1
    FROM Employees_Day6 e
    WHERE e.DepartmentID = d.DepartmentID
);
```

Think:

```text
NOT EXISTS
↓
"Does a matching row NOT exist?"
```

This finds departments with no employees.

---

### Quick comparison

| Operator     | Mental model                          |
| ------------ | ------------------------------------- |
| `IN`         | Is this value in this set?            |
| `EXISTS`     | Does at least one matching row exist? |
| `NOT EXISTS` | Does no matching row exist?           |

### ⭐ Interview bonus

If asked about `NOT IN` vs `NOT EXISTS`, mention:

> **`NOT IN` can produce unexpected results when NULLs are involved, so `NOT EXISTS` is often preferred for anti-matching logic.**

That's a good interview-level observation.

---

# Q20. What is `NULL`?

### Interview answer:

> **`NULL` represents a missing, unknown, or unavailable value. It is not the same as zero, an empty string, or false.**

For example:

```text
EmployeeName = Oscar
Salary = NULL
```

means:

> We don't have Oscar's salary value.

It does **not** mean:

```text
Salary = 0
```

---

## Why doesn't this work?

```sql
SELECT *
FROM Employees_Day6
WHERE Salary = NULL;
```

Because SQL uses **three-valued logic**:

```text
TRUE
FALSE
UNKNOWN
```

Comparing something with `NULL` using `=` doesn't produce TRUE.

Instead, use:

```sql
WHERE Salary IS NULL;
```

And:

```sql
WHERE Salary IS NOT NULL;
```

### Remember:

```sql
-- ❌ Wrong
Salary = NULL

-- ✅ Correct
Salary IS NULL

-- ❌ Wrong
Salary <> NULL

-- ✅ Correct
Salary IS NOT NULL
```

---

# 🎯 Your 5 Interview Answers — Memorize the Concepts

If tomorrow the interviewer asks these rapidly, you should be able to answer:

### WHERE vs HAVING

> **WHERE filters rows; HAVING filters groups after aggregation.**

### INNER vs LEFT JOIN

> **INNER JOIN returns matching rows from both tables; LEFT JOIN keeps all rows from the left table and matching rows from the right.**

### CTE

> **A named query expression used mainly to make complex SQL easier to read and maintain.**

### IN vs EXISTS

> **IN checks whether a value belongs to a set; EXISTS checks whether a matching row exists; NOT EXISTS checks whether no matching row exists.**

### NULL

> **NULL represents an unknown or missing value and must be checked using IS NULL or IS NOT NULL rather than `=`.**

You should be able to say each of those **without thinking for more than 5 seconds** in an interview.
---
WHERE       → filters rows
HAVING      → filters groups

INNER JOIN  → matching rows
LEFT JOIN   → all left + matching right

CTE         → named query expression for readability

IN          → value in a set
EXISTS      → at least one match
NOT EXISTS  → no match

NULL        → unknown/missing
IS NULL     → check for NULL
---

# 🔥 Window Functions

After Day 7, we'll start:

**`ROW_NUMBER()` → `RANK()` → `DENSE_RANK()` → `PARTITION BY` → `ORDER BY` inside `OVER()`**

And you'll finally see the elegant solution to the problem you've been trying to solve since Day 3.

**Go ahead with Q1–Q20.**
