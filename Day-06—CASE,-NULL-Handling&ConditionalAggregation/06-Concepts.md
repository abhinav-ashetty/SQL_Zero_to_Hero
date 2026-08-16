Absolutely. 🔥 **Day 6 starts now.**

Today is a very useful day because we're going to learn SQL patterns that appear constantly in real applications and interviews. We're also going to fix one topic that has already caused a few mistakes in your practice: **`NULL`**.

# 🗓️ DAY 6 — CASE, NULL Handling & Conditional Aggregation

**Time:** ~30–35 minutes
**Database:** Microsoft SQL Server / SSMS

### Today's goals

By the end, you'll understand:

* `CASE`
* `ISNULL()`
* `COALESCE()`
* `NULL` behavior
* Conditional `COUNT`
* Conditional `SUM`
* Conditional `AVG`
* `CASE` inside aggregate functions
* Practical interview patterns

---

# 1. Our Day 6 Dataset

We'll continue with our existing tables, but let's create a slightly richer dataset specifically for today's exercises.

Paste this into SSMS:

```sql
/*
========================================================
DAY 06 - CASE, NULL HANDLING & CONDITIONAL AGGREGATION
SQL Server / SSMS
========================================================
*/

IF OBJECT_ID('Employees_Day6', 'U') IS NOT NULL
    DROP TABLE Employees_Day6;

IF OBJECT_ID('Departments_Day6', 'U') IS NOT NULL
    DROP TABLE Departments_Day6;


-- ======================================================
-- DEPARTMENTS
-- ======================================================

CREATE TABLE Departments_Day6
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

INSERT INTO Departments_Day6
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Sales'),
(5, 'Marketing');


-- ======================================================
-- EMPLOYEES
-- ======================================================

CREATE TABLE Employees_Day6
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    DepartmentID INT NULL,
    Salary INT NULL,
    Age INT,
    PerformanceRating INT NULL
);

INSERT INTO Employees_Day6
VALUES
(101, 'Alice',   1, 70000, 25, 4),
(102, 'Bob',     2, 50000, 30, 3),
(103, 'Charlie', 1, 90000, 28, 5),
(104, 'David',   4, 60000, 35, 2),
(105, 'Eva',     2, 80000, 27, 4),
(106, 'Frank',   3, 55000, 31, NULL),
(107, 'Grace',   4, 75000, 29, 5),
(108, 'Helen',   1, 95000, 26, 5),
(109, 'Ian',     NULL, 62000, 33, 3),
(110, 'Jack',    2, NULL, 24, 2),
(111, 'Kevin',   1, 85000, 29, NULL),
(112, 'Laura',   2, 65000, 32, 3),
(113, 'Mike',    4, 70000, 28, 4),
(114, 'Nancy',   3, 72000, 27, NULL),
(115, 'Oscar',   NULL, NULL, 30, NULL);
```

Notice we deliberately have:

* Employees with **NULL salary**
* Employees with **NULL department**
* Employees with **NULL performance rating**
* A department with **no employees**

These will be useful today.

---

# 2. What is `NULL`?

This is one of the most misunderstood concepts in SQL.

`NULL` does **not** mean:

```text
0
```

It does **not** mean:

```text
''
```

It does **not** mean:

```text
false
```

It means approximately:

> **The value is unknown / missing / not available.**

For example:

```text
Oscar
Salary = NULL
```

We don't know Oscar's salary.

---

# 3. Never Use `= NULL`

You already encountered this on Day 3.

❌ Wrong:

```sql
SELECT *
FROM Employees_Day6
WHERE Salary = NULL;
```

Correct:

```sql
SELECT *
FROM Employees_Day6
WHERE Salary IS NULL;
```

And:

```sql
SELECT *
FROM Employees_Day6
WHERE Salary IS NOT NULL;
```

### Memorize this:

```text
NULL
 ↓
IS NULL
IS NOT NULL
```

---

# 4. What Happens With NULL in Calculations?

Suppose:

```text
Salary:
70000
80000
NULL
90000
```

What is:

```sql
SUM(Salary)
```

SQL Server ignores the `NULL` value.

Similarly:

```sql
AVG(Salary)
```

doesn't treat NULL as zero; it ignores it.

So don't think:

```text
NULL = 0
```

Think:

```text
NULL = missing value
```

---

# 5. `ISNULL()` ⭐

SQL Server provides:

```sql
ISNULL(value, replacement)
```

Example:

```sql
SELECT
    EmployeeName,
    ISNULL(Salary, 0) AS Salary
FROM Employees_Day6;
```

If salary is NULL:

```text
NULL → 0
```

So Oscar becomes:

```text
Oscar | 0
```

---

# 6. Practical Example

Suppose we calculate total salary by department:

```sql
SELECT
    d.DepartmentName,
    SUM(e.Salary) AS TotalSalary
FROM Departments_Day6 d
LEFT JOIN Employees_Day6 e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;
```

Marketing has no employees.

Depending on the aggregate result, you may get:

```text
Marketing | NULL
```

If the business requirement says:

> "Show 0 instead of NULL."

Use:

```sql
SELECT
    d.DepartmentName,
    ISNULL(SUM(e.Salary), 0) AS TotalSalary
FROM Departments_Day6 d
LEFT JOIN Employees_Day6 e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;
```

Now:

```text
Marketing | 0
```

---

# 7. `COALESCE()`

Another way:

```sql
COALESCE(Salary, 0)
```

Example:

```sql
SELECT
    EmployeeName,
    COALESCE(Salary, 0) AS Salary
FROM Employees_Day6;
```

For simple SQL Server replacement:

```text
ISNULL(Salary, 0)
```

and:

```text
COALESCE(Salary, 0)
```

often give the same result.

But `COALESCE` can accept **multiple values**:

```sql
COALESCE(value1, value2, value3, 0)
```

It returns the first non-NULL value.

For example:

```sql
SELECT COALESCE(NULL, NULL, 50000, 0);
```

Result:

```text
50000
```

---

# 8. `ISNULL` vs `COALESCE`

For interviews, remember:

| ISNULL              | COALESCE          |
| ------------------- | ----------------- |
| SQL Server-specific | Standard SQL      |
| Takes 2 arguments   | Can take multiple |
| Common in T-SQL     | More portable     |

Since you're using **MSSQL**, you'll see `ISNULL()` frequently.

---

# 9. CASE ⭐⭐⭐

Now the really important part.

Suppose HR wants employees classified by salary:

```text
Salary >= 80000 → High
Salary >= 60000 → Medium
Otherwise       → Low
```

We can use:

```sql
SELECT
    EmployeeName,
    Salary,
    CASE
        WHEN Salary >= 80000 THEN 'High'
        WHEN Salary >= 60000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employees_Day6;
```

Example:

```text
Alice    70000 → Medium
Bob      50000 → Low
Charlie  90000 → High
```

---

# 🧠 CASE Mental Model

Think of it like Java's:

```text
if
else if
else
```

Conceptually:

```text
if Salary >= 80000
    High
else if Salary >= 60000
    Medium
else
    Low
```

This is one of the most useful SQL constructs.

---

# 10. CASE Evaluation Order

This is important.

Suppose:

```sql
CASE
    WHEN Salary >= 60000 THEN 'Medium'
    WHEN Salary >= 80000 THEN 'High'
    ELSE 'Low'
END
```

An employee earning 90,000 satisfies:

```text
Salary >= 60000
```

first.

So SQL returns:

```text
Medium
```

It doesn't continue to the next condition.

Therefore:

> **CASE conditions are evaluated in order.**

Put the most specific/highest-priority condition first.

Correct:

```sql
CASE
    WHEN Salary >= 80000 THEN 'High'
    WHEN Salary >= 60000 THEN 'Medium'
    ELSE 'Low'
END
```

---

# 11. CASE + NULL

What happens with Oscar?

```text
Salary = NULL
```

None of these:

```sql
Salary >= 80000
Salary >= 60000
```

is true.

So:

```sql
ELSE 'Low'
```

would execute.

If you don't want NULL salary to be classified as Low, explicitly handle it:

```sql
SELECT
    EmployeeName,
    Salary,
    CASE
        WHEN Salary IS NULL THEN 'Not Available'
        WHEN Salary >= 80000 THEN 'High'
        WHEN Salary >= 60000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employees_Day6;
```

---

# 12. CASE + Aggregate Functions 🔥

Now we're getting into **real interview SQL**.

Question:

> Count how many employees have salary >= 70,000.

One approach:

```sql
SELECT COUNT(*)
FROM Employees_Day6
WHERE Salary >= 70000;
```

But what if we want **multiple categories in one row**?

For example:

```text
HighSalaryEmployees | LowSalaryEmployees
--------------------|-------------------
8                   | 5
```

That's where conditional aggregation comes in.

---

# 13. Conditional COUNT

```sql
SELECT
    COUNT(CASE
        WHEN Salary >= 70000 THEN 1
    END) AS HighSalaryEmployees
FROM Employees_Day6;
```

### How does this work?

For every row:

```text
Salary >= 70000
      ↓
YES → 1
NO  → NULL
```

Then:

```sql
COUNT(...)
```

counts only the non-NULL values.

This is a **very important pattern**.

---

# 14. Multiple Conditions in One Query ⭐⭐⭐

```sql
SELECT
    COUNT(CASE
        WHEN Salary >= 70000 THEN 1
    END) AS HighSalaryEmployees,

    COUNT(CASE
        WHEN Salary < 70000 THEN 1
    END) AS LowSalaryEmployees
FROM Employees_Day6;
```

Now we're calculating two metrics in one query.

---

# 15. Conditional SUM

Another common pattern:

> Calculate total salary of IT employees.

```sql
SELECT
    SUM(
        CASE
            WHEN DepartmentID = 1 THEN Salary
            ELSE 0
        END
    ) AS ITTotalSalary
FROM Employees_Day6;
```

Think:

```text
IT employee
   ↓
Salary

Non-IT
   ↓
0

SUM everything
```

---

# 16. Conditional Aggregation by Department 🔥

Now:

> For each department, show total salary of employees earning at least 70,000.

```sql
SELECT
    DepartmentID,
    SUM(
        CASE
            WHEN Salary >= 70000 THEN Salary
            ELSE 0
        END
    ) AS SalaryOfHighEarners
FROM Employees_Day6
GROUP BY DepartmentID;
```

This pattern is extremely useful.

---

# 17. Conditional COUNT by Department

Question:

> For every department, count employees with salary >= 70,000.

```sql
SELECT
    DepartmentID,
    COUNT(
        CASE
            WHEN Salary >= 70000 THEN 1
        END
    ) AS HighSalaryEmployees
FROM Employees_Day6
GROUP BY DepartmentID;
```

Result conceptually:

```text
DepartmentID | HighSalaryEmployees
--------------|-------------------
1             | 4
2             | 1
3             | 1
4             | 2
```

---

# 18. A Very Important Interview Pattern

Suppose interviewer asks:

> "For each department, give me total employees and number of high-performing employees."

You can do:

```sql
SELECT
    DepartmentID,

    COUNT(*) AS TotalEmployees,

    COUNT(
        CASE
            WHEN PerformanceRating >= 4 THEN 1
        END
    ) AS HighPerformers

FROM Employees_Day6
GROUP BY DepartmentID;
```

🔥 This is **conditional aggregation**.

Learn this pattern well.

---

# 19. Conditional AVG

Suppose:

> Find the average salary of employees with rating >= 4.

```sql
SELECT
    AVG(
        CASE
            WHEN PerformanceRating >= 4
            THEN CAST(Salary AS DECIMAL(10,2))
        END
    ) AS AvgHighPerformerSalary
FROM Employees_Day6;
```

Why does this work?

Employees who don't satisfy the condition produce:

```text
NULL
```

`AVG()` ignores NULL.

So only qualifying employees contribute to the average.

---

# 20. CASE in ORDER BY

You can even use `CASE` to control sorting.

Suppose:

> Show IT employees first, then everyone else.

```sql
SELECT
    EmployeeName,
    DepartmentID,
    Salary
FROM Employees_Day6
ORDER BY
    CASE
        WHEN DepartmentID = 1 THEN 0
        ELSE 1
    END,
    EmployeeName;
```

Because IT gets `0` and others get `1`:

```text
IT employees
     ↓
Other employees
```

This is an advanced but useful pattern.

---

# 🧠 Today's Core Mental Models

### NULL

```text
NULL ≠ 0
NULL ≠ ''
NULL = missing/unknown
```

Use:

```sql
IS NULL
IS NOT NULL
```

---

### ISNULL

```sql
ISNULL(value, replacement)
```

---

### COALESCE

```sql
COALESCE(value1, value2, value3, ...)
```

Returns first non-NULL value.

---

### CASE

```sql
CASE
    WHEN condition THEN result
    WHEN condition THEN result
    ELSE result
END
```

Think:

```text
if
else if
else
```

---

### Conditional aggregation

```sql
COUNT(CASE WHEN condition THEN 1 END)
```

and:

```sql
SUM(CASE WHEN condition THEN value ELSE 0 END)
```

These two patterns are **very important for interviews**.

---

# 🎯 Day 6 Practice

Now it's your turn. **Don't look for solutions.**

Use `Employees_Day6`.

## Q1

Display:

```text
EmployeeName
Salary
SalaryCategory
```

where:

* `Salary >= 80000` → `High`
* `Salary >= 60000` → `Medium`
* Otherwise → `Low`
* NULL salary → `Not Available`

---

## Q2

Display every employee's:

```text
EmployeeName
Salary
```

Replace NULL salary with **0**.

---

## Q3

Find the **total salary of all employees**, treating NULL salary as 0.

---

## Q4

Find the **number of employees whose salary is >= 70000** using `CASE` + `COUNT`.

Don't use `WHERE`.

---

## Q5 ⭐

Find, in one query:

```text
TotalEmployees
HighSalaryEmployees
LowSalaryEmployees
```

where:

```text
High → Salary >= 70000
Low  → Salary < 70000
```

---

## Q6 ⭐

For each department, find:

```text
DepartmentID
TotalEmployees
HighSalaryEmployees
```

where High Salary means:

```text
Salary >= 70000
```

---

## Q7 🔥

For each department, calculate:

```text
DepartmentID
TotalSalary
HighSalaryTotal
```

where `HighSalaryTotal` is the total salary of employees earning >= 70,000.

---

## Q8 🔥

Find the average salary of employees whose:

```text
PerformanceRating >= 4
```

---

## Q9 🔥

Display every employee with a new column:

```text
PerformanceCategory
```

Rules:

```text
Rating = 5 → Excellent
Rating = 4 → Good
Rating = 3 → Average
Rating = 2 → Poor
NULL        → Not Rated
```

---

## Q10 — Interview Question ⭐⭐⭐

Explain:

> **What is conditional aggregation, and why would you use `COUNT(CASE WHEN...)` instead of running multiple separate queries?**

Answer this in your own words.

---

# 🚨 One Challenge I Especially Want You to Notice

Look at this:

```sql
COUNT(
    CASE
        WHEN Salary >= 70000 THEN 1
    END
)
```

versus:

```sql
SUM(
    CASE
        WHEN Salary >= 70000 THEN 1
        ELSE 0
    END
)
```

Both can count qualifying rows.

Understanding **why** both work will make your SQL much stronger.

Don't just memorize them.

Try Q1–Q10 in **SSMS**, send me your SQL, and I'll review them one by one like the previous days.

🧠 Day 6 Takeaway

Today you learned:

NULL
 ↓
IS NULL / IS NOT NULL


ISNULL()
 ↓
Replace NULL


COALESCE()
 ↓
First non-NULL value


CASE
 ↓
if / else if / else


COUNT(CASE...)
 ↓
Conditional counting


SUM(CASE...)
 ↓
Conditional summation


AVG(CASE...)
 ↓
Conditional average

And you're now starting to combine multiple concepts:

JOIN
+
GROUP BY
+
CASE
+
COUNT/SUM/AVG

That's real SQL interview territory.