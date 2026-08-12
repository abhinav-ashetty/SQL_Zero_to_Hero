Absolutely. **Day 2 starts now.** 🔥

Today we're going to build on yesterday's `SELECT + WHERE + ORDER BY` and move into one of the most important SQL concepts for interviews:

# 🗓️ DAY 2 — Aggregate Functions + GROUP BY + HAVING

**Time:** ~30 minutes
**Database:** SQL Server / SSMS
**Goal:** By the end, you should understand not just *how* `GROUP BY` works, but **why it exists**.

---

# 0️⃣ Quick Recall — 2 Minutes

Before we start, remember yesterday's mental model:

```text
FROM
  ↓
WHERE
  ↓
SELECT / ORDER BY / TOP
```

Today we're adding:

```text
FROM
  ↓
WHERE
  ↓
GROUP BY
  ↓
HAVING
  ↓
SELECT
  ↓
ORDER BY
```

Don't memorize that yet. We'll understand **why** as we go.

---

# 1️⃣ Our Dataset

You already have the `Employees` table from Day 1.

But let's add a few more employees so our grouping becomes more interesting.

Run this in SSMS:

```sql
INSERT INTO Employees VALUES
(111,'Kevin','IT',85000,'Bangalore',29,'2022-06-15'),
(112,'Laura','HR',65000,'Mysore',32,'2021-10-20'),
(113,'Mike','Sales',70000,'Delhi',28,'2023-03-12'),
(114,'Nancy','Finance',72000,'Chennai',27,'2022-01-18'),
(115,'Oscar','IT',78000,'Hyderabad',30,'2024-04-22');
```

Now we have **15 employees**.

---

# 2️⃣ The Problem Aggregate Functions Solve

Suppose your manager asks:

> "How many employees do we have?"

Yesterday you could retrieve the employees:

```sql
SELECT *
FROM Employees;
```

But you don't want 15 rows.

You want **one number**:

```text
15
```

That's where **aggregate functions** come in.

---

# 3️⃣ COUNT()

```sql
SELECT COUNT(*)
FROM Employees;
```

Result:

```text
15
```

`COUNT(*)` counts rows.

---

### Count employees in IT

```sql
SELECT COUNT(*)
FROM Employees
WHERE Department = 'IT';
```

Notice something important:

```text
FROM
 ↓
WHERE
 ↓
COUNT
```

We're filtering first and then counting.

---

# 4️⃣ SUM()

Suppose the company wants:

> "What is the total salary we're paying?"

```sql
SELECT SUM(Salary)
FROM Employees;
```

This adds all salaries.

---

# 5️⃣ AVG()

Average salary:

```sql
SELECT AVG(Salary)
FROM Employees;
```

This returns the average salary.

### SQL Server detail ⭐

Because `Salary` is an `INT`, depending on the expression, SQL Server can perform integer-based aggregation.

For a precise decimal average, you can explicitly convert:

```sql
SELECT AVG(CAST(Salary AS DECIMAL(10,2)))
FROM Employees;
```

We'll revisit data types later.

---

# 6️⃣ MIN() and MAX()

Lowest salary:

```sql
SELECT MIN(Salary)
FROM Employees;
```

Highest salary:

```sql
SELECT MAX(Salary)
FROM Employees;
```

---

# 🧠 So remember:

| Function  | Purpose               |
| --------- | --------------------- |
| `COUNT()` | Number of rows/values |
| `SUM()`   | Total                 |
| `AVG()`   | Average               |
| `MIN()`   | Minimum               |
| `MAX()`   | Maximum               |

These are called **aggregate functions** because they take multiple rows and produce a summary value.

---

# 7️⃣ Now Comes GROUP BY 🔥

Here's where things get interesting.

Suppose I ask:

> "How many employees are in each department?"

We can't simply write:

```sql
SELECT COUNT(*)
FROM Employees;
```

because that gives us the total.

We want:

```text
IT       → ?
HR       → ?
Sales    → ?
Finance  → ?
```

We need to tell SQL Server:

> "Create a separate group for every department."

That's exactly what `GROUP BY` does.

```sql
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department;
```

You'll get something like:

```text
Department    EmployeeCount
---------------------------
Finance       3
HR            4
IT            5
Sales         3
```

---

# 🧠 Think About GROUP BY Like This

Imagine:

```text
Employees
    │
    ├── IT
    │    ├── Alice
    │    ├── Charlie
    │    ├── Helen
    │    ├── Kevin
    │    └── Oscar
    │
    ├── HR
    │    ├── Bob
    │    ├── Eva
    │    ├── Jack
    │    └── Laura
    │
    ├── Sales
    │    ├── David
    │    ├── Grace
    │    └── Mike
    │
    └── Finance
         ├── Frank
         ├── Ian
         └── Nancy
```

`GROUP BY Department` creates these groups.

Then:

```sql
COUNT(*)
```

runs **inside each group**.

---

# 8️⃣ GROUP BY + AVG ⭐

Now:

> "Find the average salary of each department."

```sql
SELECT 
    Department,
    AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary
FROM Employees
GROUP BY Department;
```

Result conceptually:

```text
Department    AverageSalary
---------------------------
Finance       ...
HR            ...
IT            ...
Sales         ...
```

This is an **extremely common interview pattern**.

---

# 9️⃣ GROUP BY + SUM

> "Find the total salary paid by each department."

```sql
SELECT 
    Department,
    SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department;
```

---

# 🔥 Now Think Like an Interviewer

Suppose they ask:

> **Find the highest salary in each department.**

Don't immediately look for the answer.

Break the problem down.

We need:

```text
Department
+
highest Salary
```

Highest → `MAX()`

One result per department → `GROUP BY`

Therefore:

```sql
SELECT 
    Department,
    MAX(Salary) AS HighestSalary
FROM Employees
GROUP BY Department;
```

That's the thought process I want you to develop.

---

# 🔟 WHERE + GROUP BY

Now:

> "Find the average salary of IT and HR employees."

First filter:

```sql
WHERE Department IN ('IT','HR')
```

Then group:

```sql
GROUP BY Department
```

So:

```sql
SELECT
    Department,
    AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary
FROM Employees
WHERE Department IN ('IT','HR')
GROUP BY Department;
```

### Mental model:

```text
ALL EMPLOYEES
      ↓
WHERE IT / HR
      ↓
GROUP BY Department
      ↓
AVG(Salary)
```

This distinction is **very important**.

---

# 1️⃣1️⃣ HAVING — The Important Part ⭐⭐⭐

Now imagine the interviewer asks:

> "Find departments having more than 3 employees."

We cannot use:

```sql
WHERE COUNT(*) > 3
```

❌ That's invalid.

Why?

Because `WHERE` filters **individual rows**.

But `COUNT(*)` exists **after grouping**.

We need something that filters groups.

That's:

# HAVING

```sql
SELECT
    Department,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department
HAVING COUNT(*) > 3;
```

---

# 🧠 WHERE vs HAVING

This is one of the questions you should be able to answer instantly.

### WHERE

Filters **rows**.

```sql
WHERE Salary > 70000
```

### HAVING

Filters **groups**.

```sql
HAVING AVG(Salary) > 70000
```

---

## Example

> Find departments whose average salary is greater than 70,000.

```sql
SELECT
    Department,
    AVG(CAST(Salary AS DECIMAL(10,2))) AS AverageSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 70000;
```

The key is:

```text
WHERE → rows
HAVING → groups
```

---

# 1️⃣2️⃣ WHERE + GROUP BY + HAVING 🔥

Now we're getting into interview-level SQL.

Question:

> Find departments that have more than 2 employees whose salary is greater than 60,000.

Think carefully.

### Step 1

We only care about employees earning > 60,000:

```sql
WHERE Salary > 60000
```

### Step 2

Group them by department:

```sql
GROUP BY Department
```

### Step 3

Only keep departments with >2 such employees:

```sql
HAVING COUNT(*) > 2
```

Complete query:

```sql
SELECT
    Department,
    COUNT(*) AS EmployeeCount
FROM Employees
WHERE Salary > 60000
GROUP BY Department
HAVING COUNT(*) > 2;
```

This pattern is **very important**.

---

# 🧠 The Golden Mental Model

When you see a question, identify these:

### "Which rows?"

→ `WHERE`

### "Group by what?"

→ `GROUP BY`

### "Which groups?"

→ `HAVING`

### "What calculation?"

→ `COUNT / SUM / AVG / MIN / MAX`

---

# 🎯 Your Practice — YOU WRITE THESE

Don't look for solutions. Run them in SSMS.

### Q1

Find the **total number of employees**.

---

### Q2

Find the **average salary of all employees**.

---

### Q3

Find the **highest salary in the company**.

---

### Q4

Find the **number of employees in each department**.

Expected structure:

```text
Department | EmployeeCount
```

---

### Q5

Find the **average salary of each department**.

---

### Q6

Find the **highest salary in each department**.

---

### Q7 ⭐

Find departments having **more than 3 employees**.

---

### Q8 ⭐

Find departments whose **average salary is greater than 70,000**.

---

### Q9 🔥

Find departments having **at least 3 employees whose salary is greater than 60,000**.

---

### Q10 🔥 Interview Question

> Find the department with the **highest average salary**.

**Hint:** You will need to combine today's concepts.

Don't worry if you don't immediately know Q10. **Try it.**

---

# 🧠 One Important Interview Question

If the interviewer asks:

> **"What's the difference between WHERE and HAVING?"**

Your answer should be:

> "`WHERE` filters individual rows before grouping, while `HAVING` filters groups after `GROUP BY`. `HAVING` is commonly used with aggregate functions such as `COUNT`, `AVG`, and `SUM`."

That's a strong interview answer.

---

## 🚀 Your Task Now

Run the queries yourself in **SSMS** for Q1–Q10 and send me your solutions.

**Don't send screenshots. Send only your SQL.**

I'll grade every query individually, and for any wrong query, **I'll make you reason it out before showing the answer.**

After Day 2, we'll move to **Day 3: JOINs**, where SQL starts becoming much more powerful.

For interview purposes, remember the logical query processing order as:

FROM
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
TOP