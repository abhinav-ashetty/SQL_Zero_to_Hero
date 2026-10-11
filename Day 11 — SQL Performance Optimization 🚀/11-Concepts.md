# Day 11 — SQL Performance Optimization 🚀

Today we move from **“writing correct SQL” → “writing efficient SQL.”**

This is an important **DBMS interview topic**, especially for Software Engineer interviews.

### 🎯 Day 11 Goals

By the end of today, you should understand:

1. What SQL performance optimization means
2. Indexes — clustered vs non-clustered
3. Why `SELECT *` can be bad
4. SARGable vs non-SARGable queries
5. Filtering early
6. JOIN optimization
7. Execution plans in SSMS
8. Statistics
9. When indexes help and when they hurt
10. Common interview questions

---

# 1. What is SQL Performance Optimization?

Suppose you have **10 rows**:

```text
SELECT * FROM Employees
```

No big problem.

But imagine you have **10 million rows**.

A poorly written query may need to examine a huge amount of data.

**SQL performance optimization = making queries execute faster while using fewer resources.**

Main resources:

- CPU
- Memory
- Disk I/O
- Network
- Database locks

### Interview answer

> SQL performance optimization is the process of improving query execution time and reducing resource consumption by using proper indexing, efficient queries, filtering, optimized joins, and execution-plan analysis.

---

# 2. Indexes — The Most Important Topic

Think about a book.

If you want to find:

> "Database Management Systems"

You don't read every page.

You use the **index at the back of the book**.

A database index works similarly.

Without an appropriate index:

```text
Database
 ↓
Row 1
Row 2
Row 3
Row 4
...
Row 1,000,000
```

SQL Server may need to scan many rows.

With an index:

```text
Index
 ↓
Find required value
 ↓
Jump to required rows
```

Much faster for many lookup queries.

---

# 3. Create a Practice Table

Since you're using **SSMS / Microsoft SQL Server**, run this:

```sql
DROP TABLE IF EXISTS Employees_Performance;

CREATE TABLE Employees_Performance
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT,
    Salary INT,
    City VARCHAR(50)
);

INSERT INTO Employees_Performance
VALUES
(1, 'Rahul', 1, 50000, 'Bangalore'),
(2, 'Priya', 2, 70000, 'Mumbai'),
(3, 'Amit', 1, 60000, 'Bangalore'),
(4, 'Sneha', 3, 80000, 'Delhi'),
(5, 'Kiran', 2, 75000, 'Bangalore'),
(6, 'Arjun', 1, 55000, 'Chennai'),
(7, 'Neha', 3, 90000, 'Mumbai'),
(8, 'Ravi', 2, 65000, 'Delhi'),
(9, 'Pooja', 1, 72000, 'Bangalore'),
(10, 'Vikram', 3, 85000, 'Chennai');
```

---

# 4. `SELECT *` vs Selecting Required Columns

You might write:

```sql
SELECT *
FROM Employees_Performance
WHERE DepartmentID = 1;
```

It works.

But generally prefer:

```sql
SELECT EmployeeID,
       EmployeeName,
       Salary
FROM Employees_Performance
WHERE DepartmentID = 1;
```

### Why?

`SELECT *` may retrieve columns you don't need.

That can mean:

- More data read
- More memory
- More network transfer
- More I/O

### Interview point

> Avoid `SELECT *` in production queries when you only need specific columns.

---

# 5. Filtering Early

Consider:

```sql
SELECT *
FROM Employees_Performance
WHERE Salary > 70000;
```

This is good because SQL Server can eliminate unwanted rows based on the filter.

When working with multiple tables, filtering relevant rows early can reduce the amount of data involved in later operations.

---

# 6. Indexes

Let's create an index:

```sql
CREATE INDEX IX_Employees_DepartmentID
ON Employees_Performance(DepartmentID);
```

Now queries frequently filtering by `DepartmentID` can potentially benefit:

```sql
SELECT EmployeeName, Salary
FROM Employees_Performance
WHERE DepartmentID = 2;
```

### Important

Creating an index does **not** guarantee the query will use it.

SQL Server's optimizer decides whether the index is beneficial.

---

# 7. Clustered vs Non-Clustered Index

This is a **very common interview question**.

## Clustered Index

A clustered index determines the physical/logical ordering of the table's data structure.

A table can have **only one clustered index**.

Example:

```sql
CREATE CLUSTERED INDEX IX_Employees_EmployeeID
ON Employees_Performance(EmployeeID);
```

However, remember:

```sql
PRIMARY KEY
```

in SQL Server is **clustered by default**, unless another choice is specified or a clustered index already exists.

---

## Non-Clustered Index

A non-clustered index is a separate index structure that points toward the actual table rows.

You can have **multiple non-clustered indexes**.

Example:

```sql
CREATE NONCLUSTERED INDEX IX_Employees_Salary
ON Employees_Performance(Salary);
```

### Easy interview comparison

| Clustered | Non-Clustered |
|---|---|
| Determines table data organization | Separate index structure |
| Usually one per table | Multiple possible |
| Good for range/order access | Good for frequent lookups |
| Leaf level contains table data | Leaf level contains index keys + row locator |

### Memory trick

> **Clustered = the table's main ordering structure.**  
> **Non-clustered = separate lookup structure.**

---

# 8. SARGable Queries 🔥

This is a more advanced interview topic.

**SARGable** means the query is written in a way that allows SQL Server to efficiently use an index for searching.

Suppose we have an index on:

```sql
Salary
```

Good:

```sql
SELECT *
FROM Employees_Performance
WHERE Salary > 70000;
```

SQL Server can potentially use the index efficiently.

---

## Potentially problematic

```sql
SELECT *
FROM Employees_Performance
WHERE Salary + 1000 > 70000;
```

Here we're applying an expression to the indexed column.

Better:

```sql
SELECT *
FROM Employees_Performance
WHERE Salary > 69000;
```

### Another common example

Suppose:

```sql
WHERE YEAR(SomeDate) = 2026
```

Applying `YEAR()` to every row can prevent efficient index seeking.

A range-based condition is generally preferable:

```sql
WHERE SomeDate >= '2026-01-01'
  AND SomeDate < '2027-01-01'
```

### Interview answer

> A SARGable predicate allows the database engine to efficiently use an index to locate matching rows instead of evaluating an expression against every row.

---

# 9. Indexes Are NOT Always Good

This is important.

You might think:

> "More indexes = faster database."

❌ Wrong.

Indexes improve **read performance**, but they also have costs.

Suppose you execute:

```sql
INSERT INTO Employees_Performance
VALUES (...);
```

SQL Server may need to update the relevant indexes too.

Similarly:

```sql
UPDATE
DELETE
```

can become more expensive with many indexes.

### Therefore:

> Indexes improve reads but can increase storage requirements and write overhead.

---

# 10. When Should You Consider an Index?

Indexes are particularly useful for columns frequently used in:

```sql
WHERE
JOIN
ORDER BY
GROUP BY
```

For example:

```sql
SELECT *
FROM Employees_Performance
WHERE DepartmentID = 2;
```

An index on:

```text
DepartmentID
```

may help.

Similarly:

```sql
SELECT *
FROM Employees_Performance e
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID;
```

Indexes on join columns can be useful depending on the query and data distribution.

---

# 11. Execution Plan 🔥

This is one of the most important practical skills in **SSMS**.

SQL Server provides an **Execution Plan** showing how it intends to execute a query.

In SSMS:

### Option 1

Press:

```text
Ctrl + M
```

Then execute your query.

### Option 2

Use:

```text
Query → Include Actual Execution Plan
```

Then run:

```sql
SELECT *
FROM Employees_Performance
WHERE DepartmentID = 2;
```

You'll see operators such as:

```text
Index Seek
Index Scan
Table Scan
Sort
Hash Match
Nested Loops
```

---

# 12. Index Seek vs Index Scan

Very important.

### Index Seek

SQL Server directly finds relevant portions of the index.

Think:

> "I know where the data is."

Usually desirable for selective lookups.

### Index Scan

SQL Server scans a larger portion or all of an index.

Think:

> "I need to look through a lot of this index."

A scan isn't automatically bad.

For example, if you're retrieving a large percentage of the table, a scan may actually be the best plan.

### Interview trap ⚠️

Don't say:

> "Index Scan is always bad."

Instead:

> "Index Scan can be less efficient for highly selective queries, but whether a scan is good or bad depends on the query, table size, data distribution, and execution plan."

---

# 13. Statistics

SQL Server maintains **statistics** about data distribution.

For example, SQL Server may know approximately how many employees belong to:

```text
Department 1 → 1000
Department 2 → 50
Department 3 → 10
```

This helps the optimizer decide:

> Should I use an index?

or

> Should I scan the table?

If statistics are outdated, SQL Server may make a poor execution-plan choice.

### Interview answer

> Statistics describe data distribution and help the SQL Server optimizer estimate the number of rows a query will return and choose an efficient execution plan.

---

# 14. Avoid Functions on Indexed Columns

Suppose:

```sql
WHERE YEAR(HireDate) = 2026
```

Potentially less efficient.

Prefer:

```sql
WHERE HireDate >= '2026-01-01'
AND HireDate < '2027-01-01'
```

The second form allows SQL Server to work with the column's range more directly.

---

# 15. Avoid Unnecessary DISTINCT

You might write:

```sql
SELECT DISTINCT DepartmentID
FROM Employees_Performance;
```

`DISTINCT` is useful when you genuinely need unique results.

But don't use it simply to hide duplicate rows caused by an incorrect JOIN.

Bad thinking:

```text
JOIN creates duplicates
        ↓
add DISTINCT
        ↓
problem solved
```

Instead ask:

> Why did the JOIN produce duplicates?

---

# 16. JOIN Optimization

Suppose:

```sql
SELECT e.EmployeeName,
       d.DepartmentName
FROM Employees_Performance e
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID;
```

Good practices include:

- Join using appropriate keys
- Index frequently used join columns when justified
- Select only required columns
- Filter unnecessary rows
- Avoid accidental Cartesian products

### Dangerous:

```sql
SELECT *
FROM Employees e
JOIN Departments d;
```

No proper join condition → potentially a **Cartesian product**.

If:

```text
Employees = 100 rows
Departments = 10 rows
```

You could get:

```text
100 × 10 = 1000 rows
```

---

# 17. The Big Performance Checklist 🧠

When a query is slow, think:

```text
1. Do I need SELECT *?
        ↓
2. Can I filter earlier?
        ↓
3. Are JOIN conditions correct?
        ↓
4. Are appropriate indexes available?
        ↓
5. Is the predicate SARGable?
        ↓
6. What does the execution plan show?
        ↓
7. Are statistics current?
        ↓
8. Am I sorting/grouping huge amounts of data?
        ↓
9. Am I using unnecessary DISTINCT?
        ↓
10. Is the query returning more data than necessary?
```

---

# 🎯 Day 11 Interview Questions

Try answering these **without looking back**.

### Q1
What is SQL query optimization?

### Q2
What is an index and why is it useful?

### Q3
What is the difference between clustered and non-clustered indexes?

### Q4
Why can too many indexes be harmful?

### Q5
What is a SARGable query?

### Q6
What is the difference between Index Seek and Index Scan?

### Q7
Why should we avoid `SELECT *`?

### Q8
What are SQL Server statistics?

### Q9
How can you investigate a slow query in SSMS?

### Q10 — Interview scenario 🔥

You have this query:

```sql
SELECT *
FROM Employees_Performance
WHERE Salary + 5000 > 70000;
```

An index exists on `Salary`.

**How would you rewrite this query to make it more index-friendly?**

---

## 🧪 Day 11 Practical Challenge

Don't just memorize the theory.

Run:

```sql
CREATE INDEX IX_Employees_Salary
ON Employees_Performance(Salary);
```

Then compare these:

### Query A

```sql
SELECT EmployeeName, Salary
FROM Employees_Performance
WHERE Salary > 70000;
```

### Query B

```sql
SELECT EmployeeName, Salary
FROM Employees_Performance
WHERE Salary + 5000 > 70000;
```

Turn on **Actual Execution Plan (`Ctrl + M`)** and inspect what SQL Server chooses.

---

### ⭐ Your Day 11 target

If you can confidently explain:

> **Index → Clustered/Non-clustered → SARGable → Seek/Scan → Execution Plan → Statistics → Index trade-offs**

then you've covered the core of **SQL Performance Optimization** for interviews.

Send me your **Q1–Q10 answers**, and I'll evaluate them like an interviewer and give you a **Day 11 score out of 10**.