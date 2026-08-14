Absolutely. 🔥 **Day 4 starts now.**

Today we're going to learn **Subqueries**, and I'm going to connect them directly to the problem you couldn't solve on Day 3:

> "Find the highest-paid employee in each department."

By the end of today, you'll understand **why a query sometimes needs another query inside it**.

---

# 🗓️ DAY 4 — SUBQUERIES

**Time:** 30–35 minutes
**Database:** Microsoft SQL Server / SSMS

### Today's goals

You'll learn:

* What a subquery is
* Scalar subqueries
* Subqueries with `WHERE`
* `IN` with subqueries
* Correlated subqueries
* `EXISTS`
* Subqueries with aggregates
* Subquery vs JOIN
* Common interview questions

---

# 1. First: What Is a Subquery?

A **subquery is simply a query inside another query.**

For example:

```sql
SELECT *
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
);
```

There are two queries here.

### Inner query:

```sql
SELECT AVG(Salary)
FROM Employees
```

It calculates:

```text
Average salary = 68,xxx
```

Then the outer query becomes conceptually:

```sql
SELECT *
FROM Employees
WHERE Salary > 68,xxx;
```

So think:

```text
          INNER QUERY
              ↓
        Calculate something
              ↓
          OUTER QUERY
              ↓
        Use that result
```

---

# 2. Our Dataset

We'll continue with the Day 3 tables because they're perfect for subqueries.

If you still have them in SSMS, you can use them directly.

Let's verify:

```sql
SELECT *
FROM Employees_Day3;

SELECT *
FROM Departments_Day3;
```

You should have:

### Employees

```text
EmployeeID | EmployeeName | DepartmentID | Salary
-----------|--------------|--------------|-------
101        | Alice        | 1            | 70000
102        | Bob          | 2            | 50000
103        | Charlie      | 1            | 90000
104        | David        | 4            | 60000
105        | Eva          | 2            | 80000
106        | Frank        | 3            | 55000
107        | Grace        | 4            | 75000
108        | Helen        | 1            | 95000
109        | Ian          | NULL         | 62000
```

---

# 3. Scalar Subquery ⭐

A **scalar subquery returns one value**.

For example:

```sql
SELECT MAX(Salary)
FROM Employees_Day3;
```

returns one value:

```text
95000
```

Now suppose we ask:

> Find the employee earning the highest salary.

We could use:

```sql
SELECT *
FROM Employees_Day3
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees_Day3
);
```

### Think about what happens:

Inner:

```sql
SELECT MAX(Salary)
FROM Employees_Day3
```

↓

```text
95000
```

Outer:

```sql
SELECT *
FROM Employees_Day3
WHERE Salary = 95000;
```

↓

```text
Helen
95000
```

That's your first important subquery pattern.

---

# 4. Second Highest Salary ⭐⭐⭐

This is one of the most common SQL interview questions.

We can solve it using a subquery:

```sql
SELECT MAX(Salary) AS SecondHighestSalary
FROM Employees_Day3
WHERE Salary < (
    SELECT MAX(Salary)
    FROM Employees_Day3
);
```

Let's understand it.

### Inner query:

```sql
SELECT MAX(Salary)
FROM Employees_Day3
```

returns:

```text
95000
```

Then:

```sql
WHERE Salary < 95000
```

removes the highest salary.

Remaining highest:

```text
90000
```

Then outer `MAX()` finds:

```text
90000
```

### Mental model:

```text
All salaries
     ↓
Find MAX → 95000
     ↓
Remove 95000
     ↓
Find MAX again
     ↓
90000
```

This is a classic interview pattern.

---

# 5. Subquery with `WHERE`

Another common question:

> Find employees earning more than the company's average salary.

```sql
SELECT EmployeeName,
       Salary
FROM Employees_Day3
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees_Day3
);
```

The inner query calculates the average.

The outer query compares every employee against it.

---

# 6. Subquery with `IN`

Now suppose we want:

> Find employees working in departments located in Bangalore.

Our `Departments_Day3` table contains:

```text
DepartmentID | DepartmentName | Location
-------------|----------------|----------
1            | IT             | Bangalore
2            | HR             | Mysore
3            | Finance        | Chennai
4            | Sales          | Delhi
5            | Marketing      | Mumbai
```

We could first find the department IDs in Bangalore:

```sql
SELECT DepartmentID
FROM Departments_Day3
WHERE Location = 'Bangalore';
```

Result:

```text
1
```

Then find employees whose department is 1.

We can combine both:

```sql
SELECT EmployeeName,
       DepartmentID
FROM Employees_Day3
WHERE DepartmentID IN (
    SELECT DepartmentID
    FROM Departments_Day3
    WHERE Location = 'Bangalore'
);
```

### Mental model:

```text
Departments
     ↓
Find Bangalore departments
     ↓
DepartmentID = 1
     ↓
Find employees whose DepartmentID IN (1)
```

---

# 7. `IN` vs `=`

This is important.

If your subquery returns **one value**, you can often use:

```sql
=
```

Example:

```sql
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees_Day3
);
```

If the subquery can return **multiple values**, use:

```sql
IN
```

Example:

```sql
WHERE DepartmentID IN (
    SELECT DepartmentID
    FROM Departments_Day3
    WHERE Location = 'Bangalore'
);
```

### Remember:

```text
One value  → =
Multiple   → IN
```

---

# 8. Subquery with `NOT IN`

Question:

> Find employees who don't belong to departments located in Bangalore.

```sql
SELECT EmployeeName,
       DepartmentID
FROM Employees_Day3
WHERE DepartmentID NOT IN (
    SELECT DepartmentID
    FROM Departments_Day3
    WHERE Location = 'Bangalore'
);
```

Conceptually:

```text
Bangalore departments
        ↓
       {1}
        ↓
Employees NOT IN {1}
```

### ⚠️ Important NULL warning

`NOT IN` can behave unexpectedly when the subquery contains `NULL`.

We'll discuss this properly when we cover NULL handling and `NOT EXISTS`.

---

# 9. EXISTS ⭐⭐⭐

Now we're going to learn something very important.

Suppose the question is:

> Find departments that have at least one employee.

We could use JOIN.

But we can also ask:

> "Does at least one matching employee exist?"

That's exactly what `EXISTS` does.

```sql
SELECT d.DepartmentName
FROM Departments_Day3 d
WHERE EXISTS (
    SELECT 1
    FROM Employees_Day3 e
    WHERE e.DepartmentID = d.DepartmentID
);
```

The inner query checks each department.

For IT:

```text
Does an employee exist with DepartmentID = 1?
        ↓
YES
```

HR:

```text
YES
```

Marketing:

```text
NO
```

Therefore Marketing is excluded.

---

# 🧠 EXISTS Mental Model

Think:

```text
EXISTS
   ↓
"Does at least one matching row exist?"
```

You don't care **how many**.

You only care whether one exists.

---

# 10. NOT EXISTS ⭐⭐⭐

Now:

> Find departments with no employees.

```sql
SELECT d.DepartmentName
FROM Departments_Day3 d
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees_Day3 e
    WHERE e.DepartmentID = d.DepartmentID
);
```

Result:

```text
Marketing
```

Compare this with what we learned yesterday:

### JOIN approach:

```sql
FROM Departments d
LEFT JOIN Employees e
    ON ...
WHERE e.EmployeeID IS NULL
```

### EXISTS approach:

```sql
WHERE NOT EXISTS (...)
```

Both can solve the problem.

---

# 11. Correlated Subquery 🔥

This is an important concept.

Look at:

```sql
SELECT d.DepartmentName
FROM Departments_Day3 d
WHERE EXISTS (
    SELECT 1
    FROM Employees_Day3 e
    WHERE e.DepartmentID = d.DepartmentID
);
```

Notice:

```sql
e.DepartmentID = d.DepartmentID
```

The inner query refers to the **outer query's `d.DepartmentID`**.

Therefore the inner query depends on the current outer row.

That's called a:

# Correlated Subquery

Think:

```text
Outer row
   ↓
Inner query uses outer row
   ↓
Result
   ↓
Next outer row
   ↓
Inner query runs based on that row
```

You don't need to memorize the execution details yet.

Just recognize:

> **If the inner query references a column from the outer query, it's correlated.**

---

# 12. Your Day 3 Problem Revisited 🔥

Remember:

> Find the highest-paid employee in each department.

Today we can get closer using a correlated subquery.

Think about one employee.

Suppose Alice earns 70,000 in IT.

We can ask:

> "Is there someone in Alice's department earning more than Alice?"

If yes → Alice isn't the highest.

If no → Alice is the highest.

This can be expressed using `NOT EXISTS`.

Conceptually:

```sql
SELECT e.EmployeeName,
       e.Salary,
       e.DepartmentID
FROM Employees_Day3 e
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees_Day3 e2
    WHERE e2.DepartmentID = e.DepartmentID
      AND e2.Salary > e.Salary
);
```

This is a **very powerful pattern**.

For each employee:

```text
Is there someone in the same department
with a higher salary?
        ↓
YES → exclude
NO  → keep
```

This gives the highest-paid employee in each department.

And now you can see why I didn't want you to memorize a window-function solution on Day 3.

You're now understanding **the reasoning behind the problem**.

---

# 13. Subquery vs JOIN

Interviewers may ask:

> "When would you use a JOIN versus a subquery?"

Don't give an absolute answer like:

> "JOIN is always faster."

That's not correct.

A better answer:

> "JOINs are useful when I need to combine columns or data from multiple tables. A subquery can be useful when I need the result of one query as a condition or intermediate result. The optimizer may transform equivalent queries, so performance should be evaluated using the execution plan."

That's a much stronger answer.

---

# 🧠 Today's Subquery Cheat Sheet

### One value

```sql
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees
)
```

### Multiple values

```sql
WHERE DepartmentID IN (
    SELECT DepartmentID
    FROM Departments
)
```

### At least one matching row

```sql
WHERE EXISTS (
    SELECT 1
    FROM Employees
    WHERE ...
)
```

### No matching row

```sql
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees
    WHERE ...
)
```

### Outer query referenced inside inner query

```text
→ Correlated subquery
```

---

# 🎯 Day 4 Practice

Now **you work**.

Run these in SSMS and write the queries yourself.

## Q1 — Easy

Find the employee with the **highest salary** using a subquery.

---

## Q2

Find employees whose salary is **greater than the average salary**.

---

## Q3

Find the **second highest salary** using a subquery.

Don't use `TOP`, `RANK`, or window functions.

---

## Q4

Find employees who work in departments located in **Bangalore**.

Use `IN` + subquery.

---

## Q5

Find employees who **do not work in the IT department** using a subquery.

---

## Q6 ⭐

Find departments that have **at least one employee**.

Use `EXISTS`.

---

## Q7 ⭐

Find departments that have **no employees**.

Use `NOT EXISTS`.

---

## Q8 🔥

Find employees who earn **more than every employee in the HR department**.

Hint:

```sql
> ALL (...)
```

Think carefully about what `ALL` means.

---

## Q9 🔥

Find the employee(s) with the **highest salary in each department**.

You can use the correlated `NOT EXISTS` technique we just discussed.

---

## Q10 — Interview Theory

Explain:

> **What is the difference between `IN`, `EXISTS`, and `NOT EXISTS`?**

Answer this in your own words, like you're answering an interviewer.

---

### One rule for today

**Don't solve Q9 by searching for a window-function solution.**

I specifically want you to solve it using the reasoning we just learned.
---

NOT IN + NULL can be dangerous.

Remember Ian:

Ian → DepartmentID = NULL

Because SQL's three-valued logic treats comparisons with NULL as UNKNOWN, NOT IN can behave unexpectedly when the subquery itself contains NULLs.

For this particular subquery:

SELECT DepartmentID
FROM Departments_Day3
WHERE DepartmentName = 'IT'

there's no NULL, so your query works.

But generally, when checking existence/non-existence, NOT EXISTS is often safer.

We'll return to this later.
---
Q8 🔥 — Let's Learn ALL

You said:

DON'T KNOW TO USE ALL

Good. Don't guess.

Question:

Find employees who earn more than every employee in the HR department.

First, let's find HR salaries:

SELECT Salary
FROM Employees_Day3
WHERE DepartmentID = 2;

We get:

50000
80000

Now the question says:

Salary greater than every HR salary.

Therefore the employee must earn:

> 50000
AND
> 80000

So effectively:

> 80000

SQL gives us:

ALL

So:

SELECT *
FROM Employees_Day3
WHERE Salary > ALL
(
    SELECT Salary
    FROM Employees_Day3
    WHERE DepartmentID = 2
);
🧠 Meaning
Salary > ALL (50000, 80000)

means:

Salary > 50000
AND
Salary > 80000

Therefore:

Salary > 80000

would qualify.

ALL vs ANY

This is worth remembering.

> ALL

Means:

Greater than every value.

Example:

> ALL (50k, 80k)

→ must be > 80k.

> ANY

Means:

Greater than at least one value.

Example:

> ANY (50k, 80k)

→ anything > 50k qualifies.

So:

> ALL → every
> ANY → at least one

That's the mental model.
---
IN

Used when we want to compare a value against a set of values returned by a subquery.

WHERE DepartmentID IN (
    SELECT DepartmentID ...
)

Think:

"Is this value present in this set?"

EXISTS

Checks whether the subquery returns at least one row.

Think:

"Does a matching row exist?"

It doesn't care how many rows match.

NOT EXISTS

Checks whether the subquery returns no rows.

Think:

"Does a matching row NOT exist?"

🧠 Your Day 4 Mental Model

You now have four powerful tools:

= 
↓
One value

IN
↓
Value belongs to a set

EXISTS
↓
At least one matching row exists

NOT EXISTS
↓
No matching row exists

And:

ALL
↓
Condition must be true for every value

ANY
↓
Condition must be true for at least one value
🔥 One Interview-Level Insight

Notice how the same problem can often be solved multiple ways.

For example:

Departments with no employees.

LEFT JOIN
SELECT d.DepartmentName
FROM Departments_Day3 d
LEFT JOIN Employees_Day3 e
    ON d.DepartmentID = e.DepartmentID
WHERE e.EmployeeID IS NULL;
NOT EXISTS
SELECT d.DepartmentName
FROM Departments_Day3 d
WHERE NOT EXISTS
(
    SELECT 1
    FROM Employees_Day3 e
    WHERE e.DepartmentID = d.DepartmentID
);

Both are valid.

A strong SQL developer doesn't just know syntax—they know multiple ways to express the same requirement and can reason about readability and performance.

🎯 One Final Challenge Before Day 4 Ends

I want you to solve these two yourself. They're designed specifically around today's mistakes.

Challenge A

Find employees who earn less than every employee in the IT department.

Use ALL.

Challenge B 🔥

Find employees who have the highest salary in their department.

Use the NOT EXISTS technique from Q9.

---
Challenge B 🔥 Can be solved in different ways:

Yes. And this is a **very good question**, because it teaches you that the same SQL problem can be solved using different techniques.

For:

> **Find employees who have the highest salary in their department**

we can use a **self `LEFT JOIN`**.

### Step 1: Think about two copies of the same table

```text
e1 = employee we are checking
e2 = another employee in the same department
```

We want to find:

> Is there another employee in the same department who earns **more** than `e1`?

So:

```sql
e2.DepartmentID = e1.DepartmentID
AND e2.Salary > e1.Salary
```

### Step 2: LEFT JOIN

```sql
SELECT
    e1.EmployeeName,
    e1.DepartmentID,
    e1.Salary
FROM Employees_Day3 e1
LEFT JOIN Employees_Day3 e2
    ON e1.DepartmentID = e2.DepartmentID
    AND e2.Salary > e1.Salary
WHERE e2.EmployeeID IS NULL;
```

### 🧠 Why does this work?

Take Helen:

```text
Helen → IT → 95000
```

SQL looks for another IT employee with salary:

```text
> 95000
```

There isn't one.

Therefore:

```text
e2.EmployeeID = NULL
```

So Helen passes:

```sql
WHERE e2.EmployeeID IS NULL
```

---

Take Alice:

```text
Alice → IT → 70000
```

SQL finds:

```text
Charlie → IT → 90000
Helen   → IT → 95000
```

So Alice gets matching `e2` rows.

Therefore:

```text
e2.EmployeeID IS NOT NULL
```

Alice is removed.

---

### The mental model 🔥

```text
e1 = employee we're checking
             ↓
       LEFT JOIN e2
             ↓
"Is there someone in the same department
 who earns MORE than e1?"
             ↓
       YES → e2 exists → REMOVE
       NO  → e2 NULL   → KEEP
```

This is essentially the **LEFT JOIN version** of the `NOT EXISTS` solution.

### `NOT EXISTS` version

```sql
SELECT e1.EmployeeName, e1.DepartmentID, e1.Salary
FROM Employees_Day3 e1
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees_Day3 e2
    WHERE e2.DepartmentID = e1.DepartmentID
      AND e2.Salary > e1.Salary
);
```

### LEFT JOIN version

```sql
SELECT e1.EmployeeName, e1.DepartmentID, e1.Salary
FROM Employees_Day3 e1
LEFT JOIN Employees_Day3 e2
    ON e1.DepartmentID = e2.DepartmentID
    AND e2.Salary > e1.Salary
WHERE e2.EmployeeID IS NULL;
```

Both express the same fundamental idea:

> **Keep the employee for whom no higher-paid employee exists in the same department.**

This is called a **self join** because we're joining `Employees_Day3` to itself. This pattern is worth remembering for interviews.

