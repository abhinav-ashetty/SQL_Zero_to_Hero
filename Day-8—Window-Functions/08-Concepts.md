# 🚀 Day 8 — Window Functions

Today is **one of the most important days** in your SQL interview preparation because your interview explicitly requires:

* Window functions
* Ranking
* `DENSE_RANK()`
* Query patterns such as second-highest salary

You've already learned `GROUP BY`, CTEs, JOINs, and subqueries. Now we're going to connect them.

**Time:** ~35–40 minutes
**Database:** Microsoft SQL Server / SSMS

---

# 1. The problem with `GROUP BY`

Let's start with something you already know.

Suppose we want the highest salary in each department:

```sql
SELECT
    DepartmentID,
    MAX(Salary) AS HighestSalary
FROM Employees_Day6
GROUP BY DepartmentID;
```

This gives something like:

```text
DepartmentID | HighestSalary
-------------|--------------
1            | 95000
2            | 80000
3            | 72000
4            | 75000
```

That's fine.

But what if the interviewer asks:

> **Who** earns that highest salary?

We need:

```text
Department | EmployeeName | Salary
-----------|--------------|-------
IT         | Helen        | 95000
HR         | Eva          | 80000
Finance    | Nancy        | 72000
Sales      | Grace        | 75000
```

`GROUP BY` alone can't easily give us the employee's other columns.

That's where **window functions** become extremely powerful.

---

# 2. What is a Window Function?

A window function performs a calculation across a set of related rows **without collapsing those rows into one row**.

This is the most important difference:

```text
GROUP BY
→ combines rows

Window Function
→ keeps the original rows
```

For example:

```sql
SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    AVG(Salary) OVER() AS CompanyAverage
FROM Employees_Day6;
```

Every employee remains in the result.

You might get:

```text
Employee | Salary | CompanyAverage
---------|--------|---------------
Alice    | 70000  | 71000
Bob      | 50000  | 71000
Charlie  | 90000  | 71000
...
```

The average is calculated across all employees, but **no rows disappear**.

---

# 3. `OVER()` ⭐⭐⭐

This is the heart of window functions.

```sql
AVG(Salary) OVER()
```

Think:

```text
AVG(Salary)
     ↓
Calculate average

OVER()
     ↓
Define the window over which calculation happens
```

So:

```sql
SELECT
    EmployeeName,
    Salary,
    AVG(Salary) OVER() AS CompanyAverage
FROM Employees_Day6;
```

means:

> Calculate the average salary across the entire result set while keeping every employee row.

---

# 4. Window Function vs GROUP BY

Compare these.

### `GROUP BY`

```sql
SELECT
    DepartmentID,
    AVG(Salary) AS AverageSalary
FROM Employees_Day6
GROUP BY DepartmentID;
```

Result:

```text
1 | 85000
2 | 65000
3 | 63500
4 | 68333
```

One row per department.

---

### Window function

```sql
SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    AVG(Salary) OVER(
        PARTITION BY DepartmentID
    ) AS DepartmentAverage
FROM Employees_Day6;
```

Result conceptually:

```text
Employee | Dept | Salary | DeptAverage
---------|------|--------|------------
Alice    | IT   | 70000  | 87500
Charlie  | IT   | 90000  | 87500
Helen    | IT   | 95000  | 87500
Kevin    | IT   | 85000  | 87500
Bob      | HR   | 50000  | 65000
Eva      | HR   | 80000  | 65000
...
```

Every employee remains.

🔥 **This distinction is interview gold.**

---

# 5. `PARTITION BY`

Now we introduce the second important piece.

```sql
PARTITION BY DepartmentID
```

means:

> Divide the rows into separate groups for the window calculation.

For example:

```text
All Employees
      ↓
 ┌────┼────┬────┐
 IT   HR  Finance Sales
 ↓    ↓     ↓      ↓
Calculate separately
```

So:

```sql
AVG(Salary) OVER(
    PARTITION BY DepartmentID
)
```

means:

> Calculate average salary separately for each department.

---

# 6. Very Important: `PARTITION BY` is NOT `GROUP BY`

They may look similar, but they behave differently.

### `GROUP BY`

```sql
GROUP BY DepartmentID
```

collapses rows.

### `PARTITION BY`

```sql
PARTITION BY DepartmentID
```

does **not** collapse rows.

Think:

```text
GROUP BY
→ "Give me one result per group."

PARTITION BY
→ "Calculate separately within each group, but keep every row."
```

---

# 7. Ranking Begins 🔥

Now we get to the most important part.

SQL Server gives us ranking functions such as:

```text
ROW_NUMBER()
RANK()
DENSE_RANK()
```

Let's start with:

# `ROW_NUMBER()`

Suppose we want employees ordered by salary:

```sql
SELECT
    EmployeeName,
    Salary,
    ROW_NUMBER() OVER(
        ORDER BY Salary DESC
    ) AS RowNum
FROM Employees_Day6;
```

Conceptually:

```text
Employee | Salary | RowNum
---------|--------|-------
Helen    | 95000  | 1
Charlie  | 90000  | 2
Kevin    | 85000  | 3
Eva      | 80000  | 4
Grace    | 75000  | 5
...
```

---

# 8. What does `ROW_NUMBER()` do?

It gives **every row a unique sequential number**.

Even if two employees have the same salary:

```text
Alice   70000
Mike    70000
```

they will still receive different row numbers.

For example:

```text
Alice → 6
Mike  → 7
```

The exact order of tied rows can be nondeterministic unless you add a tie-breaker.

---

# 9. `ROW_NUMBER()` with `PARTITION BY`

Now here's where it becomes powerful.

Question:

> Rank employees by salary **within each department**.

```sql
SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    ROW_NUMBER() OVER(
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS RowNum
FROM Employees_Day6;
```

Conceptually:

```text
IT

Helen    95000 → 1
Charlie  90000 → 2
Kevin    85000 → 3
Alice    70000 → 4


HR

Eva      80000 → 1
Laura    65000 → 2
Bob      50000 → 3
Jack     NULL   → 4
```

Notice:

> The numbering **starts again from 1 for every department**.

That's what `PARTITION BY` does.

---

# 10. The General Window Function Structure

Memorize this structure:

```sql
FUNCTION() OVER(
    PARTITION BY ...
    ORDER BY ...
)
```

For example:

```sql
ROW_NUMBER() OVER(
    PARTITION BY DepartmentID
    ORDER BY Salary DESC
)
```

Read it as:

> **Number the employees separately within each department, starting with the highest salary.**

---

# 11. Now `RANK()` ⭐⭐⭐

`RANK()` is different from `ROW_NUMBER()` when ties exist.

Suppose salaries are:

```text
100000
90000
90000
80000
```

Using `RANK()`:

```text
Salary | Rank
-------|-----
100000 | 1
90000  | 2
90000  | 2
80000  | 4
```

Notice:

```text
1, 2, 2, 4
```

There is a gap after the tie.

---

# 12. `DENSE_RANK()` ⭐⭐⭐⭐⭐

Now the mandatory topic.

`DENSE_RANK()` handles ties differently.

For:

```text
100000
90000
90000
80000
```

we get:

```text
Salary | DenseRank
-------|----------
100000 | 1
90000  | 2
90000  | 2
80000  | 3
```

No gap.

```text
1, 2, 2, 3
```

### Memorize:

```text
ROW_NUMBER()
→ Unique number for every row

RANK()
→ Ties share rank, gaps occur

DENSE_RANK()
→ Ties share rank, no gaps
```

---

# 13. The Classic Interview Comparison 🔥

Suppose:

```text
Salary
------
100
90
90
80
70
```

### `ROW_NUMBER()`

```text
100 → 1
90  → 2
90  → 3
80  → 4
70  → 5
```

### `RANK()`

```text
100 → 1
90  → 2
90  → 2
80  → 4
70  → 5
```

### `DENSE_RANK()`

```text
100 → 1
90  → 2
90  → 2
80  → 3
70  → 4
```

This is **one of the most common SQL interview questions**.

---

# 14. Why `DENSE_RANK()` is Great for Salary Problems

Suppose:

```text
Alice   95000
Helen   95000
Charlie 90000
Kevin   85000
```

Question:

> Find the second-highest salary.

Using:

```sql
DENSE_RANK()
```

we get:

```text
95000 → Rank 1
95000 → Rank 1
90000 → Rank 2
85000 → Rank 3
```

Then:

```sql
WHERE SalaryRank = 2
```

returns:

```text
Charlie → 90000
```

---

# 15. But There Is a Problem

You might try:

```sql
SELECT *
FROM Employees_Day6
WHERE DENSE_RANK() OVER(
    ORDER BY Salary DESC
) = 2;
```

❌ SQL Server doesn't allow a window function directly in `WHERE`.

Why?

Because window functions are evaluated **after the filtering stage** in logical query processing.

This is where your Day 5 CTE knowledge becomes useful.

---

# 16. CTE + DENSE_RANK 🔥🔥🔥

We create the rank first:

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

This is an **extremely important interview pattern**.

Think:

```text
Employees
    ↓
DENSE_RANK()
    ↓
RankedEmployees CTE
    ↓
WHERE SalaryRank = 2
    ↓
Second-highest salary
```

---

# 17. Highest-Paid Employee in Each Department 🔥

Remember the problem we've been trying to solve since Day 3?

Now it's easy.

```sql
WITH RankedEmployees AS
(
    SELECT
        e.EmployeeName,
        d.DepartmentName,
        e.Salary,

        DENSE_RANK() OVER(
            PARTITION BY e.DepartmentID
            ORDER BY e.Salary DESC
        ) AS SalaryRank

    FROM Employees_Day6 e
    JOIN Departments_Day6 d
        ON e.DepartmentID = d.DepartmentID
)
SELECT
    DepartmentName,
    EmployeeName,
    Salary
FROM RankedEmployees
WHERE SalaryRank = 1;
```

🔥 This is exactly why we spent Days 1–7 building the foundation.

You now have:

```text
JOIN
+
CTE
+
PARTITION BY
+
DENSE_RANK
+
ORDER BY
```

all working together.

---

# 18. Why `DENSE_RANK()` Instead of `ROW_NUMBER()`?

Suppose IT has:

```text
Helen    95000
Kevin    95000
Charlie  90000
```

Using `ROW_NUMBER()`:

```text
Helen    → 1
Kevin    → 2
Charlie  → 3
```

If we ask:

```sql
WHERE RowNum = 1
```

we get only Helen.

But using:

```text
DENSE_RANK()
```

we get:

```text
Helen    → 1
Kevin    → 1
Charlie  → 2
```

Therefore:

```sql
WHERE SalaryRank = 1
```

returns **both highest-paid employees**.

### Interview rule

If the requirement says:

> **Return all employees tied for highest salary**

think:

```text
DENSE_RANK()
```

---

# 19. `ROW_NUMBER()` vs `RANK()` vs `DENSE_RANK()`

| Function       | Ties              | Gaps? | Unique number? |
| -------------- | ----------------- | ----- | -------------- |
| `ROW_NUMBER()` | Different numbers | N/A   | ✅              |
| `RANK()`       | Same rank         | ✅     | ❌              |
| `DENSE_RANK()` | Same rank         | ❌     | ❌              |

### Easy memory trick:

```text
ROW_NUMBER
→ Every row gets its own number

RANK
→ Tie → skip

DENSE_RANK
→ Tie → don't skip
```

---

# 20. One More Window Function: `SUM() OVER()`

Window functions aren't only for ranking.

For example:

```sql
SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    SUM(Salary) OVER() AS TotalCompanySalary
FROM Employees_Day6;
```

Every employee gets the same company total.

---

# 21. Running Total

We can also calculate a running total:

```sql
SELECT
    EmployeeName,
    Salary,
    SUM(Salary) OVER(
        ORDER BY EmployeeID
    ) AS RunningSalary
FROM Employees_Day6;
```

Conceptually:

```text
Alice    70000  → 70000
Bob      50000  → 120000
Charlie  90000  → 210000
...
```

This is another major use of window functions.

---

# 🧠 Day 8 Cheat Sheet

### Window function

```sql
FUNCTION() OVER(...)
```

### Partition

```sql
PARTITION BY DepartmentID
```

> Separates rows into independent windows.

### Order

```sql
ORDER BY Salary DESC
```

> Determines the calculation/ranking order.

### ROW_NUMBER

```sql
ROW_NUMBER() OVER(...)
```

> Unique sequential number.

### RANK

```sql
RANK() OVER(...)
```

> Ties share rank; gaps occur.

### DENSE_RANK

```sql
DENSE_RANK() OVER(...)
```

> Ties share rank; no gaps.

---

# 🎯 Day 8 Practice

Now **you solve these in SSMS**.

Use `Employees_Day6` and `Departments_Day6`.

## Q1 — Basic Window Function

Display:

```text
EmployeeName
Salary
CompanyAverage
```

where every employee should also see the **overall average company salary**.

---

## Q2

Display:

```text
EmployeeName
DepartmentID
Salary
DepartmentAverage
```

Use:

```text
AVG() OVER(PARTITION BY ...)
```

---

## Q3

Give every employee a unique row number based on salary:

> Highest salary = 1.

Return:

```text
EmployeeName
Salary
RowNum
```

Use `ROW_NUMBER()`.

---

## Q4

Rank employees by salary using `RANK()`.

Return:

```text
EmployeeName
Salary
SalaryRank
```

---

## Q5 ⭐

Rank employees by salary using `DENSE_RANK()`.

Return:

```text
EmployeeName
Salary
SalaryRank
```

---

## Q6 ⭐⭐

Rank employees **within each department** using `DENSE_RANK()`.

Return:

```text
EmployeeName
DepartmentID
Salary
DepartmentRank
```

---

## Q7 🔥

Find the **highest-paid employee in each department** using:

```text
DENSE_RANK()
+
CTE
```

Return:

```text
DepartmentName
EmployeeName
Salary
```

---

## Q8 🔥

Find the **second-highest salary in the company** using:

```text
DENSE_RANK()
```

Don't use `TOP`.

---

## Q9 🔥

Find the **second-highest-paid employee in each department**.

Use:

```text
DENSE_RANK()
+
PARTITION BY
```

---

## Q10 — Theory ⭐⭐⭐

Explain the difference between:

```text
ROW_NUMBER()
RANK()
DENSE_RANK()
```

Use this example in your explanation:

```text
100000
90000
90000
80000
```

Tell me what rank each function produces.

---

# 🚨 One Very Important Interview Question

Be prepared for:

> **"What is the difference between GROUP BY and PARTITION BY?"**

Your answer should eventually be:

> **`GROUP BY` combines rows into groups and produces fewer rows, whereas `PARTITION BY` divides rows into windows for calculation while preserving the individual rows.**

That's one of the most important concepts from today's lesson.

---

🔥 Now I Want You to REALLY Understand Ranking

This is probably the most important part of today's lesson.

Suppose we have:

Salary
------
100000
90000
90000
80000
70000
ROW_NUMBER()
100000 → 1
90000  → 2
90000  → 3
80000  → 4
70000  → 5
RANK()
100000 → 1
90000  → 2
90000  → 2
80000  → 4
70000  → 5
DENSE_RANK()
100000 → 1
90000  → 2
90000  → 2
80000  → 3
70000  → 4
The key difference:
ROW_NUMBER → 1 2 3 4 5
RANK       → 1 2 2 4 5
DENSE_RANK → 1 2 2 3 4
⭐ Interview Question You Must Know

Suppose the interviewer asks:

When would you use ROW_NUMBER() instead of DENSE_RANK()?

A good answer:

"I use ROW_NUMBER() when I need a unique sequential number for every row, even when values are tied. I use DENSE_RANK() when tied values should receive the same rank and I don't want gaps in the ranking."

Example:

Salary
100
90
90
80

ROW_NUMBER():

1
2
3
4

DENSE_RANK():

1
2
2
3
⭐ Another Interview Question
Why do we use a CTE with a window function?

Because:

DENSE_RANK() OVER(...)

cannot directly be used in the WHERE clause in SQL Server.

So:

Window Function
       ↓
CTE
       ↓
WHERE

Example:

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

This pattern is worth memorizing.

🧠 Your Biggest Achievement Today

You've gone from this:

SELECT MAX(Salary)
FROM Employees
GROUP BY DepartmentID;

which only tells you:

"The highest salary is 95,000."

to:

DENSE_RANK() OVER(
    PARTITION BY DepartmentID
    ORDER BY Salary DESC
)

which tells you:

"Helen and Kevin are rank 1 in IT, Charlie is rank 2, etc."

That's a major SQL skill jump.

Q10 — You Still Need to Answer This

Don't skip it because this is a very likely interview question.

Using:

100000
90000
90000
80000

tell me what the result would be for:

ROW_NUMBER()
RANK()
DENSE_RANK()

And explain the difference in your own words.

Once you answer Q10, we'll continue to Day 9, where we'll go deeper into window functions:

LAG()
LEAD()
Running totals
SUM() OVER()
Comparing current row with previous row
Finding salary differences
More real interview problems.
