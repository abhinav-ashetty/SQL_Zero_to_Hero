Excellent. Welcome to **Day 1**.

From today onwards, think of me as your **SQL mentor**. I won't just teach syntax; I'll teach you **how to think in SQL**.

---

# 🗓️ Day 1 – SQL Fundamentals

## Topic:

* SELECT
* TOP
* WHERE
* ORDER BY
* DISTINCT
* Logical Operators (AND, OR, NOT)
* IN, BETWEEN, LIKE

**Time:** ~30 minutes

---

# 📌 Learning Objectives

By the end of today, you'll be able to:

* Retrieve data from a table
* Filter data
* Sort data
* Find unique values
* Search using patterns
* Write your first interview-quality SQL queries

---

# Step 1: Create the Database

Open **SQL Server Management Studio (SSMS)** and execute the following.

```sql
-- ============================
-- DAY 1 DATABASE SETUP
-- SQL Server (SSMS)
-- ============================

IF OBJECT_ID('Employees', 'U') IS NOT NULL
    DROP TABLE Employees;

CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    Department VARCHAR(30),
    Salary INT,
    City VARCHAR(30),
    Age INT,
    JoiningDate DATE
);

INSERT INTO Employees VALUES
(101,'Alice','IT',70000,'Bangalore',25,'2022-05-10'),
(102,'Bob','HR',50000,'Mysore',30,'2021-03-15'),
(103,'Charlie','IT',90000,'Bangalore',28,'2020-11-20'),
(104,'David','Sales',60000,'Delhi',35,'2019-07-18'),
(105,'Eva','HR',80000,'Mumbai',27,'2023-01-05'),
(106,'Frank','Finance',55000,'Delhi',31,'2021-08-12'),
(107,'Grace','Sales',75000,'Mumbai',29,'2022-09-14'),
(108,'Helen','IT',95000,'Bangalore',26,'2020-04-01'),
(109,'Ian','Finance',62000,'Chennai',33,'2018-12-25'),
(110,'Jack','HR',48000,'Hyderabad',24,'2024-02-11');
```

---

# Before We Learn SQL...

## Question

Suppose the Employees table has **10 million rows**.

When you write

```sql
SELECT EmployeeName
FROM Employees;
```

**What are you asking SQL Server to do?**

Not the syntax.

Think like you're talking to another person.

The answer is:

> "Go to the Employees table and return only the EmployeeName column for every row."

Notice something important.

SQL is **declarative**.

You tell SQL Server **what** you want.

You don't tell it **how** to retrieve it.

That's SQL Server's job.

---

# 1. SELECT

Retrieve all employees.

```sql
SELECT *
FROM Employees;
```

`*` means **every column**.

---

Retrieve only names.

```sql
SELECT EmployeeName
FROM Employees;
```

---

Retrieve multiple columns.

```sql
SELECT EmployeeName,
       Salary,
       Department
FROM Employees;
```

---

## Interview Question

> Which is better?

```sql
SELECT *
```

or

```sql
SELECT EmployeeName, Salary
```

✅ Always select only the required columns.

Why?

* Less memory
* Faster
* Less network traffic
* Better readability

---

# 2. WHERE

Think of WHERE as a filter.

Without WHERE:

```
Table
 ↓
Return Everything
```

With WHERE:

```
Table
 ↓
Filter
 ↓
Return Matching Rows
```

---

Example

```sql
SELECT *
FROM Employees
WHERE Department = 'IT';
```

Only IT employees.

---

Salary greater than 70,000.

```sql
SELECT *
FROM Employees
WHERE Salary > 70000;
```

---

Age less than 30.

```sql
SELECT EmployeeName,
       Age
FROM Employees
WHERE Age < 30;
```

---

# 3. Comparison Operators

| Operator | Meaning               |
| -------- | --------------------- |
| =        | Equal                 |
| >        | Greater than          |
| <        | Less than             |
| >=       | Greater than or equal |
| <=       | Less than or equal    |
| <>       | Not equal             |

Example:

```sql
SELECT *
FROM Employees
WHERE Salary <> 70000;
```

---

# 4. AND / OR / NOT

### AND

```sql
SELECT *
FROM Employees
WHERE Department='IT'
AND Salary>80000;
```

Both conditions must be true.

---

### OR

```sql
SELECT *
FROM Employees
WHERE Department='IT'
OR Department='HR';
```

Either condition can be true.

---

### NOT

```sql
SELECT *
FROM Employees
WHERE NOT Department='Sales';
```

Everything except Sales.

---

# 5. ORDER BY

Ascending

```sql
SELECT *
FROM Employees
ORDER BY Salary;
```

Descending

```sql
SELECT *
FROM Employees
ORDER BY Salary DESC;
```

---

Multiple columns

```sql
SELECT *
FROM Employees
ORDER BY Department,
         Salary DESC;
```

Meaning:

Sort by Department first.

Within each department,

sort salary from highest to lowest.

---

# 6. TOP (SQL Server)

Highest paid employee.

```sql
SELECT TOP 1 *
FROM Employees
ORDER BY Salary DESC;
```

Top 3 highest salaries.

```sql
SELECT TOP 3 *
FROM Employees
ORDER BY Salary DESC;
```

---

# 7. DISTINCT

Find unique departments.

```sql
SELECT DISTINCT Department
FROM Employees;
```

Output

```
IT
HR
Sales
Finance
```

---

# 8. IN

Instead of

```sql
WHERE Department='IT'
OR Department='HR'
```

Write

```sql
SELECT *
FROM Employees
WHERE Department IN ('IT','HR');
```

Cleaner and easier to maintain.

---

# 9. BETWEEN

Employees earning between 60k and 80k.

```sql
SELECT *
FROM Employees
WHERE Salary BETWEEN 60000 AND 80000;
```

---

# 10. LIKE

Names starting with A.

```sql
SELECT *
FROM Employees
WHERE EmployeeName LIKE 'A%';
```

Names ending with e.

```sql
SELECT *
FROM Employees
WHERE EmployeeName LIKE '%e';
```

Names containing a.

```sql
SELECT *
FROM Employees
WHERE EmployeeName LIKE '%a%';
```

Exactly four letters.

```sql
SELECT *
FROM Employees
WHERE EmployeeName LIKE '____';
```

Each `_` matches exactly one character.

---

# ⭐ Common Interview Mistakes

❌

```sql
SELECT TOP 3 *
FROM Employees;
```

What's wrong?

Without `ORDER BY`, SQL Server can return **any** 3 rows.

Always pair `TOP` with `ORDER BY` when you want the "top" based on some value.

---

# 🧠 Mini Interview

If I ask:

> **"Find all employees except those in HR."**

Would you use:

A)

```sql
WHERE Department <> 'HR'
```

or

B)

```sql
WHERE NOT Department='HR'
```

✅ Both are correct.

In practice, `<>` is more common and concise.

---

# 🎯 Today's Practice (Don't Peek at the Answers Yet)

Write these queries yourself in SSMS:

1. Show only `EmployeeName` and `City`.
2. Find employees from **Bangalore**.
3. Find employees with salary **greater than or equal to 75,000**.
4. Find employees **not** in the Finance department.
5. Show all employees sorted by **Age (youngest first)**.
6. Show the **top 5 highest-paid employees**.
7. Display all **unique cities**.
8. Find employees from **HR or Sales**.
9. Find employees aged **25 to 30**.
10. Find employees whose names start with **H**.

---

## 🏆 Homework (Interview Level)

Using the same table, solve these:

1. Find employees from Bangalore **earning more than 80,000**.
2. Display the **top 2 youngest employees**.
3. Find employees whose names contain the letter **'a'** (case-insensitive in the default SQL Server collation).
4. Find all employees **except** those from Delhi and Mumbai.
5. Display employees sorted by:

   * Department (A–Z)
   * Salary (Highest to Lowest within each department)

---

### 📖 What to do next

1. Execute the setup script.
2. Solve the **10 practice questions**.
3. Then solve the **5 homework questions**.
4. Paste **your SQL queries only** here (don't worry about the output), and I'll review them like a real interviewer—checking correctness, readability, and suggesting improvements where appropriate.

**One rule for our course:** don't copy solutions from the internet. Even if a query is wrong, we'll use that to understand SQL more deeply, which is exactly how you'll improve.
