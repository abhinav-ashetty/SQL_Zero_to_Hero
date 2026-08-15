Absolutely. 🔥 **Day 5 starts now.**

Today we're going to learn **CTEs and Derived Tables**. These are important because you've already started writing queries that are becoming difficult to read.

More importantly, they prepare you for **Window Functions**, which are one of the mandatory topics for your interview.

# 🗓️ DAY 5 — CTEs + Derived Tables

**Time:** ~30 minutes
**Database:** Microsoft SQL Server / SSMS

### Today's goals

By the end, you'll understand:

* What a derived table is
* What a CTE is
* Why CTEs are useful
* CTE syntax in SQL Server
* CTE + aggregation
* CTE + JOIN
* CTE + multiple steps
* CTE vs subquery
* When to use CTEs in interviews

---

# 1. First: Why Do We Need CTEs?

Look at yesterday's problem:

> Find the department with the highest average salary.

We could write:

```sql
SELECT TOP 1
    DepartmentID,
    AVG(Salary) AS AverageSalary
FROM Employees_Day3
GROUP BY DepartmentID
ORDER BY AVG(Salary) DESC;
```

This isn't terrible.

But imagine a much more complicated query where we first calculate something, then filter it, then join it with another table.

The query can become difficult to understand.

A **CTE** lets us break a complicated query into logical steps.

Think:

```text
Step 1 → Create temporary result
             ↓
Step 2 → Work with that result
             ↓
Step 3 → Final result
```

---

# 2. Derived Table

Let's start with something you've already indirectly used.

A **derived table** is a subquery inside the `FROM` clause.

Example:

```sql
SELECT *
FROM
(
    SELECT DepartmentID,
           AVG(Salary) AS AverageSalary
    FROM Employees_Day3
    GROUP BY DepartmentID
) AS DepartmentSalary;
```

The inner query produces:

```text
DepartmentID | AverageSalary
-------------|--------------
1            | 85000
2            | 65000
3            | 55000
4            | 67500
```

Then the outer query treats that result like a table.

That's why we call it a:

> **Derived table**

---

# 🧠 Think of it like this

```text
Employees
    ↓
Inner Query
    ↓
DepartmentSalary
    ↓
Outer Query
```

The derived table exists only for that query.

---

# 3. Why `AS DepartmentSalary`?

This part:

```sql
) AS DepartmentSalary
```

gives the derived table a name.

SQL Server requires a derived table to have an alias.

For example:

```sql
FROM
(
   ...
) AS x;
```

works.

But:

```sql
FROM
(
   ...
);
```

❌ SQL Server will complain.

---

# 4. Now CTE

A **CTE (Common Table Expression)** allows us to give a name to a query result before using it.

Basic syntax:

```sql
WITH DepartmentSalary AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM Employees_Day3
    GROUP BY DepartmentID
)
SELECT *
FROM DepartmentSalary;
```

Read this as:

> "Create a temporary result called `DepartmentSalary`, then query it."

---

# 🧠 CTE Mental Model

```text
WITH DepartmentSalary AS
(
       QUERY
)
       ↓
SELECT FROM DepartmentSalary
```

It's almost like creating a temporary logical table for the duration of the statement.

---

# 5. CTE vs Derived Table

These two can do essentially the same thing.

### Derived table

```sql
SELECT *
FROM
(
    SELECT DepartmentID,
           AVG(Salary) AS AverageSalary
    FROM Employees_Day3
    GROUP BY DepartmentID
) AS DepartmentSalary;
```

### CTE

```sql
WITH DepartmentSalary AS
(
    SELECT DepartmentID,
           AVG(Salary) AS AverageSalary
    FROM Employees_Day3
    GROUP BY DepartmentID
)
SELECT *
FROM DepartmentSalary;
```

The CTE is often easier to read, especially when the query becomes large.

---

# 6. CTE + WHERE

Now suppose we want:

> Departments whose average salary is greater than 70,000.

First calculate average salary:

```sql
WITH DepartmentSalary AS
(
    SELECT
        DepartmentID,
        AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary
    FROM Employees_Day3
    GROUP BY DepartmentID
)
SELECT *
FROM DepartmentSalary
WHERE AverageSalary > 70000;
```

This is very clean.

Instead of trying to put an aggregate inside `WHERE`, we:

```text
Step 1
Calculate averages

      ↓

Step 2
Treat the result like a table

      ↓

Step 3
Filter it
```

---

# 7. CTE + JOIN ⭐

Now let's bring our Departments table back.

Question:

> Show department name and average salary for departments whose average salary is greater than 70,000.

```sql
WITH DepartmentSalary AS
(
    SELECT
        DepartmentID,
        AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary
    FROM Employees_Day3
    GROUP BY DepartmentID
)
SELECT
    d.DepartmentName,
    ds.AverageSalary
FROM Departments_Day3 d
JOIN DepartmentSalary ds
    ON d.DepartmentID = ds.DepartmentID
WHERE ds.AverageSalary > 70000;
```

Notice how clean this is.

### Step 1

```text
Employees
    ↓
GROUP BY DepartmentID
    ↓
Average salary
```

### Step 2

```text
DepartmentSalary
    ↓
JOIN Departments
```

### Step 3

```text
WHERE AverageSalary > 70000
```

---

# 8. Multiple CTEs 🔥

You can define multiple CTEs in one query.

Example:

```sql
WITH DepartmentSalary AS
(
    SELECT
        DepartmentID,
        AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary
    FROM Employees_Day3
    GROUP BY DepartmentID
),
DepartmentCount AS
(
    SELECT
        DepartmentID,
        COUNT(*) AS EmployeeCount
    FROM Employees_Day3
    GROUP BY DepartmentID
)
SELECT
    d.DepartmentName,
    ds.AverageSalary,
    dc.EmployeeCount
FROM Departments_Day3 d
JOIN DepartmentSalary ds
    ON d.DepartmentID = ds.DepartmentID
JOIN DepartmentCount dc
    ON d.DepartmentID = dc.DepartmentID;
```

Now we're building the result step-by-step.

```text
Employees
   ↓
 ┌───────────────┐
 │ Department    │
 │ Salary Avg    │
 └───────────────┘
       +
 ┌───────────────┐
 │ Department    │
 │ EmployeeCount │
 └───────────────┘
       ↓
     JOIN
       ↓
 Final Result
```

This is why CTEs are extremely useful in complex SQL.

---

# 9. CTE + TOP

Question:

> Find the department with the highest average salary.

We can do:

```sql
WITH DepartmentSalary AS
(
    SELECT
        DepartmentID,
        AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary
    FROM Employees_Day3
    GROUP BY DepartmentID
)
SELECT TOP 1
    d.DepartmentName,
    ds.AverageSalary
FROM DepartmentSalary ds
JOIN Departments_Day3 d
    ON d.DepartmentID = ds.DepartmentID
ORDER BY ds.AverageSalary DESC;
```

Notice how much easier this is to read.

---

# 10. CTE Does NOT Permanently Store Data

This is important.

When you write:

```sql
WITH DepartmentSalary AS (...)
```

SQL Server doesn't create a permanent table called `DepartmentSalary`.

It exists for the **single statement**.

For example:

```sql
WITH X AS
(
    SELECT *
    FROM Employees_Day3
)
SELECT *
FROM X;
```

Then:

```sql
SELECT *
FROM X;
```

❌ Won't work afterward.

The CTE is gone.

---

# 11. CTE vs Temporary Table

This is a common interview topic.

### CTE

```sql
WITH X AS (...)
SELECT ...
```

Generally used to make **one query easier to understand**.

### Temporary table

```sql
CREATE TABLE #X (...);
```

Actually creates a temporary table in `tempdb` and can be used across multiple statements within its scope.

For now:

```text
CTE
→ temporary logical result for one statement

#Temp table
→ actual temporary table that can be reused
```

We'll study temporary tables later.

---

# 12. CTE vs Subquery

You should be able to explain this in an interview.

### Subquery

```sql
SELECT *
FROM
(
    SELECT DepartmentID,
           AVG(Salary) AS AverageSalary
    FROM Employees_Day3
    GROUP BY DepartmentID
) AS X;
```

### CTE

```sql
WITH X AS
(
    SELECT DepartmentID,
           AVG(Salary) AS AverageSalary
    FROM Employees_Day3
    GROUP BY DepartmentID
)
SELECT *
FROM X;
```

Both can represent the same logical operation.

### Why prefer CTE?

When the query becomes complicated:

```text
CTE
 ↓
more readable
 ↓
easier to debug
 ↓
can separate logical steps
```

---

# ⭐ VERY IMPORTANT: CTE + Window Functions

This is why I'm teaching CTEs before window functions.

Remember your Day 3 problem:

> Highest-paid employee in each department.

Soon we'll write:

```sql
WITH RankedEmployees AS
(
    SELECT
        EmployeeName,
        DepartmentID,
        Salary,
        DENSE_RANK() OVER (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM Employees_Day3
)
SELECT *
FROM RankedEmployees
WHERE SalaryRank = 1;
```

🔥 **Don't worry about understanding `DENSE_RANK()` yet.**

We'll learn it properly.

But notice the architecture:

```text
Employees
     ↓
Window Function
     ↓
RankedEmployees CTE
     ↓
WHERE SalaryRank = 1
```

This pattern is extremely common in SQL interviews.

---

# 🧠 Today's Key Concepts

### Derived table

```sql
FROM
(
    SELECT ...
) AS X
```

### CTE

```sql
WITH X AS
(
    SELECT ...
)
SELECT *
FROM X;
```

### Multiple CTEs

```sql
WITH A AS (...),
     B AS (...)
SELECT ...
```

### Important rule

A CTE exists only for the **single statement immediately following it**.

---

# 🎯 Day 5 Practice

Now you solve these yourself in SSMS.

### Q1 — Easy

Create a CTE called `EmployeeSalary` containing:

```text
EmployeeName
Salary
```

Then display the CTE.

---

### Q2

Create a CTE that calculates the **average salary of each department**.

Then display only departments with an average salary **greater than 70,000**.

---

### Q3

Using a CTE, find the **highest salary in each department**.

Expected:

```text
DepartmentID | HighestSalary
```

---

### Q4

Using a CTE, find the **number of employees in each department**.

Expected:

```text
DepartmentID | EmployeeCount
```

---

### Q5 ⭐

Create a CTE that calculates:

```text
DepartmentID
AverageSalary
EmployeeCount
```

Then display departments where:

```text
AverageSalary > 70000
AND
EmployeeCount >= 2
```

---

### Q6 ⭐

Using a CTE + JOIN, display:

```text
DepartmentName
AverageSalary
```

for every department that has employees.

---

### Q7 🔥

Using a CTE, find the **department with the highest average salary**.

Don't use a subquery.

---

### Q8 🔥

Using a CTE, find the **department with the lowest average salary**.

---

### Q9 — Concept

Explain:

> **What is the difference between a CTE and a subquery?**

Answer in your own words.

---

### Q10 — Interview Thinking

Why might a developer choose a CTE instead of writing one huge nested query?

---

## 🚨 Important

Don't try to use window functions yet.

We're deliberately building the foundation:

```text
Day 1 → Basic SQL
     ↓
Day 2 → Aggregation
     ↓
Day 3 → JOINs
     ↓
Day 4 → Subqueries
     ↓
Day 5 → CTEs
     ↓
Day 6 → More SQL patterns
     ↓
Day 13 → Window Functions 🔥
```

Once we reach **`DENSE_RANK()`**, you'll understand *why* we often put window functions inside a CTE before filtering them.

Send me your **Q1–Q10 answers**, and I'll review them one by one like we've been doing.
---
Q9 ✅ — But Let's Make Your Interview Answer Better

You said:

CTE: logical result is same but CTE provides cleaner version of code.
Subquery: logical result is same but comparatively the query becomes complex.

The idea is correct, but an interviewer may ask:

"That's not always true. So what's the actual difference?"

A stronger answer:

"A CTE and a subquery can often produce the same result. A CTE gives a named query expression before the main query, which can make complex queries easier to read, organize, and maintain. A subquery is embedded directly inside another query."

That's interview-quality.

Q10 ⚠️ — Let's Improve This

You said:

A developer might choose a CTE instead of writing one huge nested query because the logical result is same but CTE provides cleaner version of code.

Correct.

But add three important reasons:

1. Readability

Instead of:

Huge nested query
     ↓
Hard to understand

You can do:

CTE 1 → Calculate salaries
CTE 2 → Calculate counts
CTE 3 → Combine them
     ↓
Final result
2. Maintainability

If you need to modify one logical step, you can modify that CTE instead of digging through deeply nested parentheses.

3. Multiple logical stages

For example:

WITH A AS (...),
B AS (...),
C AS (...)
SELECT ...

You can build a complicated problem step-by-step.

But here's an important interview point:

Don't say CTE is automatically faster than a subquery.

That's not generally true.

A good answer is:

"I would choose a CTE primarily for readability and maintainability when a query has multiple logical steps. A CTE isn't automatically faster than an equivalent subquery; performance depends on the query and execution plan."

🔥 That's the level I want you to reach.

🧠 One Important Concept Before We Finish

You might now think:

"CTE creates a temporary table."

Not exactly.

A CTE is better thought of as a named result set for a single statement.

WITH X AS (...)
SELECT *
FROM X;

After that statement finishes:

SELECT *
FROM X;

❌ X doesn't exist.

That's different from:

CREATE TABLE #X (...)

which creates a temporary table.

We'll cover that later.