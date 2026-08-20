# 🚀 Day 9 — Advanced Window Functions

Day 8 gave you the foundation:

```text
OVER()
PARTITION BY
ORDER BY
ROW_NUMBER()
RANK()
DENSE_RANK()
```

Today we're going to learn the **other major window-function patterns** that interviewers commonly ask:

* `LAG()`
* `LEAD()`
* Running totals
* Running averages
* Comparing current row with previous row
* Difference between current and previous salary
* `FIRST_VALUE()`
* `LAST_VALUE()`
* Window frames

**Time:** ~35–40 minutes
**Database:** SQL Server / SSMS

---

# 1. Why do we need `LAG()`?

Imagine employees ordered by salary:

```text
Employee   Salary
---------  ------
Helen      95000
Charlie    90000
Kevin      85000
Eva        80000
Grace      75000
```

Suppose the interviewer asks:

> "For each employee, show the salary of the employee immediately above them."

You might initially think about a self JOIN.

But SQL has a much cleaner solution:

```sql
LAG(Salary) OVER(...)
```

---

# 2. `LAG()` ⭐⭐⭐

`LAG()` allows you to access a value from a **previous row**.

```sql
SELECT
    EmployeeName,
    Salary,
    LAG(Salary) OVER(
        ORDER BY Salary DESC
    ) AS PreviousSalary
FROM Employees_Day6;
```

Conceptually:

```text
Employee   Salary   PreviousSalary
---------  -------  --------------
Helen      95000    NULL
Charlie    90000    95000
Kevin      85000    90000
Eva        80000    85000
Grace      75000    80000
```

The first row has no previous row, so:

```text
PreviousSalary = NULL
```

---

# 3. `LEAD()` ⭐⭐⭐

`LEAD()` does the opposite.

It looks at the **next row**.

```sql
SELECT
    EmployeeName,
    Salary,
    LEAD(Salary) OVER(
        ORDER BY Salary DESC
    ) AS NextSalary
FROM Employees_Day6;
```

Result conceptually:

```text
Employee   Salary   NextSalary
---------  -------  ----------
Helen      95000    90000
Charlie    90000    85000
Kevin      85000    80000
Eva        80000    75000
Grace      75000    NULL
```

### Memorize:

```text
LAG
↓
Previous row

LEAD
↓
Next row
```

---

# 4. `LAG()` Syntax

The basic syntax is:

```sql
LAG(column, offset, default)
OVER(...)
```

For example:

```sql
LAG(Salary, 1, 0) OVER(
    ORDER BY Salary DESC
)
```

Means:

```text
1 → look one row backward
0 → if there is no previous row, return 0
```

Usually you'll see:

```sql
LAG(Salary) OVER(...)
```

---

# 5. Comparing Current Salary With Previous Salary 🔥

This is a classic interview pattern.

```sql
SELECT
    EmployeeName,
    Salary,
    LAG(Salary) OVER(
        ORDER BY Salary DESC
    ) AS PreviousSalary,

    Salary -
    LAG(Salary) OVER(
        ORDER BY Salary DESC
    ) AS SalaryDifference

FROM Employees_Day6;
```

Conceptually:

```text
Employee   Salary   Previous   Difference
---------  -------  ---------  ----------
Helen      95000    NULL       NULL
Charlie    90000    95000      -5000
Kevin      85000    90000      -5000
Eva        80000    85000      -5000
```

---

# 6. A Cleaner Version Using a CTE

Rather than repeating `LAG()`:

```sql
WITH EmployeeSalary AS
(
    SELECT
        EmployeeName,
        Salary,
        LAG(Salary) OVER(
            ORDER BY Salary DESC
        ) AS PreviousSalary
    FROM Employees_Day6
)
SELECT
    EmployeeName,
    Salary,
    PreviousSalary,
    Salary - PreviousSalary AS SalaryDifference
FROM EmployeeSalary;
```

This is another example of why your **Day 5 CTE knowledge** matters.

---

# 7. `LAG()` Within Each Department 🔥

Now combine it with `PARTITION BY`.

Question:

> For each employee, show the salary of the previous employee in the same department.

```sql
SELECT
    EmployeeName,
    DepartmentID,
    Salary,

    LAG(Salary) OVER(
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS PreviousDepartmentSalary

FROM Employees_Day6;
```

Think:

```text
IT
 ↓
Sort salaries
 ↓
LAG within IT

HR
 ↓
Sort salaries
 ↓
LAG within HR
```

The previous row is therefore **department-specific**.

---

# 8. Example

Suppose IT contains:

```text
Helen    95000
Charlie  90000
Kevin    85000
Alice    70000
```

Then:

```text
Employee   Salary   PreviousSalary
---------  -------  --------------
Helen      95000    NULL
Charlie    90000    95000
Kevin      85000    90000
Alice      70000    85000
```

When SQL reaches HR, `LAG()` starts over:

```text
Eva        80000    NULL
Laura      65000    80000
Bob        50000    65000
```

---

# 9. `LEAD()` Within Departments

Same concept:

```sql
SELECT
    EmployeeName,
    DepartmentID,
    Salary,

    LEAD(Salary) OVER(
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS NextDepartmentSalary

FROM Employees_Day6;
```

---

# 10. Running Total ⭐⭐⭐

Now let's move beyond `LAG()` and `LEAD()`.

Suppose employees are ordered by `EmployeeID`:

```text
Employee   Salary
Alice      70000
Bob        50000
Charlie    90000
David      60000
```

A **running total** means:

```text
70000
120000
210000
270000
```

We can calculate it with:

```sql
SELECT
    EmployeeName,
    Salary,

    SUM(Salary) OVER(
        ORDER BY EmployeeID
    ) AS RunningTotal

FROM Employees_Day6;
```

### Why does this work?

The window expands as we move down:

```text
Row 1:
70000

Row 2:
70000 + 50000

Row 3:
70000 + 50000 + 90000

Row 4:
70000 + 50000 + 90000 + 60000
```

---

# 11. Running Total by Department

Now combine:

```text
SUM
+
OVER
+
PARTITION BY
+
ORDER BY
```

```sql
SELECT
    EmployeeName,
    DepartmentID,
    Salary,

    SUM(Salary) OVER(
        PARTITION BY DepartmentID
        ORDER BY EmployeeID
    ) AS DepartmentRunningTotal

FROM Employees_Day6;
```

Conceptually:

```text
IT

Alice     70000
Charlie   160000
Helen     255000
Kevin     340000
```

Then HR starts again:

```text
Bob       50000
Eva       130000
...
```

---

# 12. Running Average

Same idea:

```sql
SELECT
    EmployeeName,
    Salary,

    AVG(Salary) OVER(
        ORDER BY EmployeeID
    ) AS RunningAverage

FROM Employees_Day6;
```

This gives:

```text
Row 1 → average of row 1
Row 2 → average of rows 1–2
Row 3 → average of rows 1–3
...
```

---

# 13. `FIRST_VALUE()` ⭐

This returns the first value in the window.

For example:

```sql
SELECT
    EmployeeName,
    DepartmentID,
    Salary,

    FIRST_VALUE(Salary) OVER(
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS HighestDepartmentSalary

FROM Employees_Day6;
```

Every employee in IT will see:

```text
HighestDepartmentSalary = 95000
```

Every employee in HR will see:

```text
HighestDepartmentSalary = 80000
```

This is useful when you want to compare each row with the first row in its partition.

---

# 14. Example: Salary Difference From Department Maximum

We can do:

```sql
SELECT
    EmployeeName,
    DepartmentID,
    Salary,

    FIRST_VALUE(Salary) OVER(
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS HighestSalary

FROM Employees_Day6;
```

Then with a CTE:

```sql
WITH EmployeeData AS
(
    SELECT
        EmployeeName,
        DepartmentID,
        Salary,

        FIRST_VALUE(Salary) OVER(
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS HighestSalary

    FROM Employees_Day6
)
SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    HighestSalary,
    HighestSalary - Salary AS DifferenceFromHighest
FROM EmployeeData;
```

Now you can see:

```text
Helen    95000   95000   0
Charlie  90000   95000   5000
Kevin    85000   95000   10000
Alice    70000   95000   25000
```

That's a very useful analytical query.

---

# 15. `LAST_VALUE()` — Be Careful ⚠️

`LAST_VALUE()` is slightly tricky.

You might write:

```sql
LAST_VALUE(Salary) OVER(
    PARTITION BY DepartmentID
    ORDER BY Salary DESC
)
```

But SQL Server's default window frame can cause unexpected results.

For example, if you actually want the **lowest salary in the department**, you need to define the frame explicitly:

```sql
LAST_VALUE(Salary) OVER(
    PARTITION BY DepartmentID
    ORDER BY Salary DESC
    ROWS BETWEEN UNBOUNDED PRECEDING
             AND UNBOUNDED FOLLOWING
) AS LowestSalary
```

Don't worry about memorizing this yet.

Just remember:

> **`LAST_VALUE()` often requires an explicit window frame when you want the actual last row of the entire partition.**

---

# 16. Window Frames

You've already seen:

```sql
OVER(
    ORDER BY EmployeeID
)
```

A window can be more precisely defined using:

```sql
ROWS BETWEEN ...
```

For example:

```sql
ROWS BETWEEN UNBOUNDED PRECEDING
         AND CURRENT ROW
```

This means:

```text
Start from the first row
        ↓
Continue through current row
```

That's exactly what we want for a running total.

So this:

```sql
SUM(Salary) OVER(
    ORDER BY EmployeeID
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

explicitly says:

> Sum from the first row through the current row.

---

# 17. Running Total — Explicit Version

```sql
SELECT
    EmployeeName,
    Salary,

    SUM(Salary) OVER(
        ORDER BY EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND CURRENT ROW
    ) AS RunningTotal

FROM Employees_Day6;
```

This is the more explicit version.

---

# 18. Important Interview Concept

You should now understand three different categories:

### Ranking

```sql
ROW_NUMBER()
RANK()
DENSE_RANK()
```

### Previous/next row

```sql
LAG()
LEAD()
```

### Aggregation without collapsing rows

```sql
SUM() OVER()
AVG() OVER()
COUNT() OVER()
```

And also:

```sql
FIRST_VALUE()
LAST_VALUE()
```

---

# 🧠 Day 9 Cheat Sheet

| Function        | Purpose                |
| --------------- | ---------------------- |
| `ROW_NUMBER()`  | Unique row number      |
| `RANK()`        | Ranking with gaps      |
| `DENSE_RANK()`  | Ranking without gaps   |
| `LAG()`         | Previous row           |
| `LEAD()`        | Next row               |
| `SUM() OVER()`  | Window/running total   |
| `AVG() OVER()`  | Window/running average |
| `FIRST_VALUE()` | First value in window  |
| `LAST_VALUE()`  | Last value in window   |

---

# 🔥 The Most Important Pattern Today

You should be able to immediately understand this:

```sql
LAG(Salary) OVER(
    PARTITION BY DepartmentID
    ORDER BY Salary DESC
)
```

Read it in English:

> **"For each department, order employees by salary from highest to lowest, and give me the salary of the previous employee."**

And:

```sql
SUM(Salary) OVER(
    PARTITION BY DepartmentID
    ORDER BY EmployeeID
)
```

means:

> **"For each department, calculate a running salary total ordered by employee ID."**

---

# 🎯 Day 9 Practice

Use `Employees_Day6`.

## Q1 — LAG

Display:

```text
EmployeeName
Salary
PreviousSalary
```

Order employees by salary descending.

---

## Q2 — LEAD

Display:

```text
EmployeeName
Salary
NextSalary
```

Order employees by salary descending.

---

## Q3 ⭐

Display:

```text
EmployeeName
DepartmentID
Salary
PreviousDepartmentSalary
```

Use `LAG()` with:

```text
PARTITION BY DepartmentID
ORDER BY Salary DESC
```

---

## Q4 ⭐

Calculate the salary difference between an employee and the previous employee when ordered by salary descending.

Return:

```text
EmployeeName
Salary
PreviousSalary
SalaryDifference
```

Use a CTE.

---

## Q5 ⭐⭐

Calculate a **running total of salaries** ordered by `EmployeeID`.

Return:

```text
EmployeeID
EmployeeName
Salary
RunningTotal
```

---

## Q6 ⭐⭐

Calculate a **running total of salary within each department**.

Return:

```text
EmployeeName
DepartmentID
Salary
DepartmentRunningTotal
```

---

## Q7 🔥

For every employee, show:

```text
EmployeeName
DepartmentID
Salary
HighestDepartmentSalary
```

Use `FIRST_VALUE()`.

---

## Q8 🔥

For every employee, show:

```text
EmployeeName
DepartmentID
Salary
HighestDepartmentSalary
DifferenceFromHighest
```

Use `FIRST_VALUE()` + CTE.

---

## Q9 🔥 Interview Problem

For every employee, determine whether their salary is:

```text
Above Department Average
Equal to Department Average
Below Department Average
```

Return:

```text
EmployeeName
Salary
DepartmentAverage
SalaryStatus
```

**Hint:** Combine a window function with `CASE`.

---

## Q10 🔥🔥

Find the employee whose salary is the **second-highest in each department**, but this time return:

```text
DepartmentName
EmployeeName
Salary
HighestDepartmentSalary
```

Use:

```text
DENSE_RANK()
+
FIRST_VALUE()
+
CTE
```

This is intentionally challenging.

---

# 🚨 Interview Questions for Day 9

Also be ready to explain:

### 1.

> What is the difference between `LAG()` and `LEAD()`?

### 2.

> What is a running total?

### 3.

> What is the difference between `GROUP BY` and a window aggregate like `SUM() OVER()`?

### 4.

> What does `PARTITION BY` do in a window function?

### 5.

> Why might you use a CTE together with a window function?

---

## Your current SQL roadmap

You've now covered:

```text
Day 1  → SELECT / WHERE / ORDER BY
Day 2  → Aggregate Functions
Day 3  → JOINs
Day 4  → Subqueries
Day 5  → CTEs
Day 6  → CASE / NULL / Conditional Aggregation
Day 7  → Interview Problems
Day 8  → Window Functions + Ranking
Day 9  → LAG / LEAD / Running Calculations
```

After Day 9, we'll shift toward the **other mandatory interview areas you originally gave me**:

```text
Window Functions        ✅
DENSE_RANK              ✅
Joins                   ✅
Second highest salary   ✅
CTEs/Subqueries         ✅

Query execution order  → next
Performance optimization → next
ACID properties        → next
Normalization           → next
```

So we're now moving from **SQL query writing** into the broader **DBMS interview preparation**.
