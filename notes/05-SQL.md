# Database & SQL

## SQL Basics

**#. What is SQL and what are its main categories?**

SQL (Structured Query Language) is a standard language for managing and manipulating relational databases. It has several categories: **DDL (Data Definition Language)** for defining database structure - CREATE, ALTER, DROP, TRUNCATE. **DML (Data Manipulation Language)** for manipulating data - SELECT, INSERT, UPDATE, DELETE. **DCL (Data Control Language)** for controlling access - GRANT, REVOKE. **TCL (Transaction Control Language)** for managing transactions - COMMIT, ROLLBACK, SAVEPOINT. **DQL (Data Query Language)** - sometimes separated, just SELECT for querying. SQL is declarative - you specify what you want, not how to get it. It's standardized but databases have dialects with variations.

**#. Explain the difference between DELETE, TRUNCATE, and DROP.**

DELETE removes rows based on conditions and can be rolled back. It's slower because it logs each deleted row. Example: DELETE FROM users WHERE status='inactive'. You can use WHERE to delete specific rows. TRUNCATE removes all rows from a table, resets auto-increment counters, and cannot be rolled back in most databases. It's faster because it doesn't log individual rows. Example: TRUNCATE TABLE users. You cannot use WHERE clause. DROP removes the entire table structure and data from the database. Example: DROP TABLE users. The table no longer exists. Use DELETE for selective deletion with rollback option, TRUNCATE for quickly emptying tables, DROP for removing tables completely.

**#. What are the different types of SQL joins?**

SQL has several join types. **INNER JOIN** returns rows where there's a match in both tables. **LEFT JOIN (LEFT OUTER JOIN)** returns all rows from left table and matched rows from right, nulls where no match. **RIGHT JOIN (RIGHT OUTER JOIN)** opposite of left join - all from right, matched from left. **FULL OUTER JOIN** returns all rows from both tables, nulls where no match. **CROSS JOIN** returns Cartesian product - every row from first table with every row from second. **SELF JOIN** joins table to itself. Example: SELECT * FROM employees e INNER JOIN departments d ON e.dept_id = d.id. Choose join type based on what data you need from which tables.

**#. Explain INNER JOIN vs LEFT JOIN with an example.**

INNER JOIN returns only matching rows from both tables. LEFT JOIN returns all rows from left table and matching rows from right, with NULLs where no match. Example: SELECT e.name, d.name FROM employees e INNER JOIN departments d ON e.dept_id = d.id returns only employees who have a department. SELECT e.name, d.name FROM employees e LEFT JOIN departments d ON e.dept_id = d.id returns all employees, including those without departments (d.name will be NULL). Use INNER JOIN when you need only matched records. Use LEFT JOIN when you need all records from one table regardless of matches. LEFT JOIN is common for finding records without matches: WHERE d.id IS NULL finds employees without departments.

**#. What is the difference between WHERE and HAVING clauses?**

WHERE filters rows before grouping - it works on individual rows. HAVING filters after grouping - it works on aggregated results. WHERE can't use aggregate functions, HAVING can. Example: SELECT dept_id, COUNT(*) FROM employees WHERE salary > 50000 GROUP BY dept_id filters employees before counting. SELECT dept_id, COUNT(*) FROM employees GROUP BY dept_id HAVING COUNT(*) > 10 filters departments after counting. Use WHERE for row-level filtering, HAVING for group-level filtering. You can use both: WHERE filters first, then grouping happens, then HAVING filters groups. HAVING is specifically for conditions on aggregate results like COUNT, SUM, AVG.

**#. Explain the ORDER BY clause.**

ORDER BY sorts query results. Syntax: SELECT * FROM users ORDER BY last_name. Default is ascending (ASC). For descending: ORDER BY age DESC. Multiple columns: ORDER BY last_name, first_name sorts by last name, then first name for same last names. You can mix: ORDER BY last_name ASC, age DESC. Order by position: ORDER BY 2 sorts by second column (avoid this, less readable). Order by expression: ORDER BY salary * 0.1. NULL values sort first or last depending on database and ASC/DESC. Performance tip: if you order by indexed columns, it's faster. Always specify ASC/DESC explicitly for clarity. Sorting happens after WHERE and GROUP BY.

**#. What are aggregate functions in SQL?**

Aggregate functions perform calculations on multiple rows and return a single value. Common ones: **COUNT(*)** counts all rows, **COUNT(column)** counts non-null values. **SUM(column)** sums numeric values. **AVG(column)** calculates average. **MIN(column)** finds minimum. **MAX(column)** finds maximum. Example: SELECT COUNT(*), AVG(salary), MAX(salary) FROM employees. Use with GROUP BY for per-group aggregates: SELECT dept_id, AVG(salary) FROM employees GROUP BY dept_id. Aggregate functions ignore NULL values except COUNT(*). You can use DISTINCT: COUNT(DISTINCT dept_id) counts unique departments. They're essential for statistics and reporting queries.

**#. Explain the GROUP BY clause.**

GROUP BY groups rows with same values into summary rows. Used with aggregate functions. Example: SELECT dept_id, COUNT(*), AVG(salary) FROM employees GROUP BY dept_id returns one row per department with count and average salary. Columns in SELECT must be in GROUP BY or be aggregate functions. Multiple columns: GROUP BY dept_id, job_title groups by combination. GROUP BY happens after WHERE and before HAVING. Common use: reports by category, summaries by date, counts by status. Important: all non-aggregated columns in SELECT must be in GROUP BY. This ensures meaningful aggregation. Think of GROUP BY as "for each unique value of these columns."

**#. What is the DISTINCT keyword?**

DISTINCT removes duplicate rows from results. Example: SELECT DISTINCT dept_id FROM employees returns unique department IDs. Without DISTINCT, you get all dept_ids including duplicates. Works on multiple columns: SELECT DISTINCT dept_id, job_title returns unique combinations. DISTINCT applies to all columns in SELECT - SELECT DISTINCT first_name, last_name removes duplicate name combinations, not just duplicate first names. Performance consideration: DISTINCT requires sorting or hashing, can be slow on large datasets. If possible, use GROUP BY instead as it's often more explicit. COUNT(DISTINCT column) counts unique values. DISTINCT is essential for finding unique values in your data.

**#. Explain the UNION and UNION ALL operators.**

UNION combines results from multiple SELECT statements into one result set. It removes duplicates. Example: SELECT name FROM employees UNION SELECT name FROM contractors returns unique names from both tables. UNION ALL also combines but keeps duplicates - it's faster. Requirements: same number of columns, compatible data types, in same order. Column names from first query are used. Example use: SELECT 'Employee' as type, name FROM employees UNION ALL SELECT 'Contractor', name FROM contractors. Use UNION when you need unique rows, UNION ALL when duplicates are okay or when you know there are no duplicates (faster). INTERSECT and EXCEPT are similar operators for set operations.

**#. What are subqueries and where can they be used?**

Subqueries are queries nested inside another query. They can appear in SELECT, FROM, WHERE, HAVING. **In WHERE**: SELECT * FROM employees WHERE salary > (SELECT AVG(salary) FROM employees) finds employees above average salary. **In FROM**: SELECT dept_stats.* FROM (SELECT dept_id, AVG(salary) as avg_sal FROM employees GROUP BY dept_id) dept_stats. **In SELECT**: SELECT name, (SELECT dept_name FROM departments WHERE id = e.dept_id) FROM employees e. Subqueries can be correlated (reference outer query) or non-correlated (independent). Use parentheses around subqueries. They're powerful for complex filtering but can impact performance. Often can be rewritten as joins for better performance.

**#. Explain correlated vs non-correlated subqueries.**

**Non-correlated subquery** executes once and returns a value used by outer query. It's independent. Example: SELECT * FROM employees WHERE dept_id IN (SELECT id FROM departments WHERE location='NY'). Inner query executes once. **Correlated subquery** references columns from outer query and executes once per outer row. Example: SELECT * FROM employees e WHERE salary > (SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id). Inner query executes for each employee with their dept_id. Correlated subqueries are slower because they execute repeatedly. Use joins instead when possible. Non-correlated are faster - executed once, result cached. Correlated are necessary when comparison depends on outer row values.

**#. What is the difference between IN and EXISTS?**

IN checks if value is in a list of values. EXISTS checks if subquery returns any rows. Example with IN: SELECT * FROM employees WHERE dept_id IN (SELECT id FROM departments WHERE location='NY'). Example with EXISTS: SELECT * FROM employees e WHERE EXISTS (SELECT 1 FROM departments d WHERE d.id = e.dept_id AND d.location='NY'). EXISTS is often faster, especially with large subquery results, because it stops when it finds the first match. IN evaluates the entire subquery. EXISTS returns TRUE/FALSE, IN returns the actual values. Use EXISTS for correlated subqueries or when you just need to know if something exists. Use IN for small lists or non-correlated subqueries. NOT EXISTS is also useful for finding non-matching records.

**#. Explain the CASE statement.**

CASE provides conditional logic in SQL, like if-then-else. Two forms: **Simple CASE**: CASE status WHEN 'active' THEN 'Active User' WHEN 'inactive' THEN 'Inactive User' ELSE 'Unknown' END. **Searched CASE**: CASE WHEN salary < 50000 THEN 'Low' WHEN salary < 100000 THEN 'Medium' ELSE 'High' END. Use in SELECT for conditional columns: SELECT name, CASE WHEN age < 18 THEN 'Minor' ELSE 'Adult' END as age_group FROM users. Use in WHERE, ORDER BY, or UPDATE. CASE returns a value, not a boolean. It's evaluated top to bottom, first match wins. ELSE is optional (defaults to NULL). Essential for data transformation and conditional logic in queries.

**#. What are NULL values and how do you handle them?**

NULL represents missing or unknown data - it's not zero or empty string. NULL comparisons are special: you can't use =, must use IS NULL or IS NOT NULL. Example: SELECT * FROM users WHERE email IS NULL. NULL in expressions returns NULL: 10 + NULL = NULL. Aggregate functions ignore NULLs except COUNT(*). Use COALESCE to provide defaults: COALESCE(phone_number, 'No Phone') returns first non-null value. Use NULLIF: NULLIF(value, 0) returns NULL if value is 0. In ORDER BY, NULLs sort first or last depending on database. NULL handling is critical - unexpected NULLs cause bugs. Always consider NULL when writing WHERE conditions. Use IS NULL/IS NOT NULL, never = NULL.

## SQL Constraints & Keys

**#. What are SQL constraints?**

Constraints enforce rules on table data to maintain integrity. Types: **NOT NULL** ensures column can't be null. **UNIQUE** ensures all values are different. **PRIMARY KEY** combination of NOT NULL and UNIQUE, identifies each row. **FOREIGN KEY** links tables, ensures referential integrity. **CHECK** ensures values meet condition. **DEFAULT** provides default value. Example: CREATE TABLE users (id INT PRIMARY KEY, email VARCHAR(100) UNIQUE NOT NULL, age INT CHECK (age >= 18), status VARCHAR(20) DEFAULT 'active'). Constraints are enforced by database - inserts/updates violating constraints fail. They're essential for data integrity. Define at column level or table level. Named constraints can be modified or dropped later.

**#. Explain PRIMARY KEY and its characteristics.**

PRIMARY KEY uniquely identifies each row in a table. Characteristics: must contain unique values, cannot contain NULLs, table can have only one primary key (but can be composite - multiple columns). Example: CREATE TABLE users (id INT PRIMARY KEY, name VARCHAR(100)). Or composite: PRIMARY KEY (order_id, product_id). Primary key is automatically indexed for fast lookups. It's referenced by foreign keys in other tables. Choose columns that are unique, stable (don't change), and minimal. Auto-increment integers are common: id INT AUTO_INCREMENT PRIMARY KEY. Natural keys (like SSN) vs surrogate keys (generated IDs) - surrogate keys are usually better. Primary key is fundamental for relational design.

**#. What is a FOREIGN KEY and referential integrity?**

FOREIGN KEY creates link between tables and enforces referential integrity - ensures referenced record exists. Example: CREATE TABLE orders (id INT PRIMARY KEY, user_id INT, FOREIGN KEY (user_id) REFERENCES users(id)). This ensures every user_id in orders exists in users table. Actions on referenced table: **ON DELETE CASCADE** - delete referenced row deletes child rows. **ON DELETE SET NULL** - sets foreign key to null. **ON DELETE RESTRICT** - prevents deletion if child rows exist (default). **ON UPDATE CASCADE** - updates foreign key when referenced key changes. Foreign keys maintain consistency - you can't have orders for non-existent users. They're crucial for relational integrity but can impact performance and complicate deletion.

**#. Explain the difference between UNIQUE and PRIMARY KEY constraints.**

Both ensure uniqueness but differ. PRIMARY KEY: table can have only one, cannot contain NULLs, automatically indexed, used to identify row, referenced by foreign keys. UNIQUE: table can have multiple, can contain one NULL (in most databases, NULL != NULL so multiple NULLs allowed), may or may not be indexed automatically, ensures uniqueness for that column(s). Example: CREATE TABLE users (id INT PRIMARY KEY, email VARCHAR(100) UNIQUE, ssn VARCHAR(11) UNIQUE). Use PRIMARY KEY for the main identifier. Use UNIQUE for other columns that should be unique like email or username. UNIQUE is like a less strict PRIMARY KEY. In practice, PRIMARY KEY is special - semantically represents the row's identity.

**#. What is a composite key?**

Composite key is a primary key made of multiple columns. Example: CREATE TABLE order_items (order_id INT, product_id INT, quantity INT, PRIMARY KEY (order_id, product_id)). The combination must be unique, but individual columns can have duplicates. Common in junction tables for many-to-many relationships. Also called compound key. Use when no single column uniquely identifies row but a combination does. Foreign keys can reference composite keys: FOREIGN KEY (order_id, product_id) REFERENCES order_items(order_id, product_id). Composite keys can be awkward - consider using surrogate key (single auto-increment ID) plus UNIQUE constraint on the natural key combination for simplicity.

**#. Explain CHECK constraint with examples.**

CHECK constraint ensures column values meet a condition. Example: CREATE TABLE employees (id INT PRIMARY KEY, age INT CHECK (age >= 18 AND age <= 65), salary DECIMAL(10,2) CHECK (salary > 0), status VARCHAR(20) CHECK (status IN ('active', 'inactive', 'suspended'))). The condition is a boolean expression. Inserts/updates violating the constraint fail. Multiple checks allowed. Table-level check can reference multiple columns: CHECK (end_date > start_date). Not all databases fully support CHECK (MySQL historically didn't enforce them). Named checks: CONSTRAINT age_check CHECK (age >= 18) - useful for dropping/modifying later. CHECK constraints add business rule validation at database level, complementing application validation.

**#. What is a DEFAULT constraint?**

DEFAULT provides automatic value when none is specified in INSERT. Example: CREATE TABLE orders (id INT PRIMARY KEY, order_date DATETIME DEFAULT CURRENT_TIMESTAMP, status VARCHAR(20) DEFAULT 'pending', quantity INT DEFAULT 1). Insert without specifying defaults: INSERT INTO orders (id) VALUES (1) - order_date, status, quantity get default values. Explicitly pass NULL: INSERT INTO orders (id, status) VALUES (2, NULL) - NULL is inserted, not default (unless column is NOT NULL). Defaults can be literals, expressions, or functions. Use for common values, timestamps, status fields. Simplifies INSERT statements. Improves data consistency. Can modify default later: ALTER TABLE orders ALTER COLUMN status SET DEFAULT 'new'.

**#. Explain candidate keys, super keys, and alternate keys.**

**Super key** is any combination of columns that can uniquely identify a row. Multiple super keys possible. **Candidate key** is a minimal super key - no proper subset is a super key. Example: users table with id, email, ssn. {id}, {email}, {ssn} are candidate keys. {id, email} is super key but not candidate (not minimal). **Primary key** is the selected candidate key. **Alternate keys** are candidate keys not selected as primary key. They're typically defined with UNIQUE constraints. So if id is primary key, email and ssn are alternate keys. This terminology is more theoretical than practical SQL, but understanding helps with database design. Choose primary key based on stability, simplicity, and meaning.

**#. What is referential integrity?**

Referential integrity ensures relationships between tables remain consistent. Foreign keys enforce this - you can't insert child record without parent, can't delete parent with existing children (unless cascade). Example: if orders.user_id is foreign key to users.id, you can't insert order with user_id=999 if user 999 doesn't exist. You can't delete user 5 if orders exist for user 5 (with RESTRICT). Referential integrity prevents orphaned records and maintains data consistency. Actions control behavior: CASCADE, SET NULL, SET DEFAULT, RESTRICT/NO ACTION. It's fundamental to relational databases. Without it, data can become inconsistent. Most databases enforce referential integrity automatically when foreign keys are defined.

**#. How do you create and drop constraints?**

Create constraints during table creation or alter table. During creation: CREATE TABLE users (id INT PRIMARY KEY, email VARCHAR(100) UNIQUE NOT NULL, age INT CHECK (age >= 18)). Add later: ALTER TABLE users ADD CONSTRAINT email_unique UNIQUE (email); ALTER TABLE users ADD CONSTRAINT age_check CHECK (age >= 18); ALTER TABLE orders ADD FOREIGN KEY (user_id) REFERENCES users(id). Drop: ALTER TABLE users DROP CONSTRAINT email_unique (SQL Server/Oracle/PostgreSQL). ALTER TABLE users DROP INDEX email (MySQL for unique). ALTER TABLE users DROP CHECK age_check. Named constraints are easier to drop. Modifying constraints usually requires drop and recreate. Different databases have slightly different syntax.

## SQL Indexes & Performance

**#. What are indexes and why are they important?**

Indexes are database structures that improve query performance by allowing fast data retrieval without scanning entire table. Like a book index - you can jump to the page instead of reading every page. Indexes store sorted copies of column values with pointers to actual rows. Benefits: dramatically speed up WHERE, JOIN, ORDER BY queries. Drawbacks: slow down INSERT/UPDATE/DELETE because indexes must be maintained, consume storage space. Example: CREATE INDEX idx_email ON users(email). Now lookups by email are fast. Primary keys are automatically indexed. Indexes are critical for performance on large tables. Choose indexed columns based on query patterns - columns in WHERE, JOIN, ORDER BY. Too many indexes hurt write performance.

**#. Explain clustered vs non-clustered indexes.**

**Clustered index** determines physical order of data in table. Table can have only one because data can be sorted only one way. The table data itself is the clustered index. Primary key is usually clustered index. Rows are stored in clustered index order. Example: clustered index on id means rows are physically ordered by id. **Non-clustered index** is separate structure pointing to data rows. Table can have multiple non-clustered indexes. Contains indexed columns and pointer to actual row. Like a book index pointing to pages. Clustered index lookup is faster (direct access), non-clustered requires additional lookup. In SQL Server, this distinction is important. In MySQL InnoDB, primary key is always clustered, others are non-clustered.

**#. What is a composite index?**

Composite index (multi-column index) includes multiple columns. Example: CREATE INDEX idx_name ON users(last_name, first_name). Order matters! This index helps queries filtering/sorting by last_name or both, but not just first_name. The leftmost prefix rule: composite index (A, B, C) helps queries on A, (A,B), or (A,B,C), but not just B or C. Use for queries filtering on multiple columns. Example: WHERE last_name='Smith' AND first_name='John' uses the index effectively. WHERE first_name='John' doesn't (first_name not leftmost). Design based on query patterns. Composite indexes save space vs multiple single-column indexes and can cover more columns in a query.

**#. Explain index selectivity and cardinality.**

**Cardinality** is the number of distinct values in a column. High cardinality (many unique values) like email or ID. Low cardinality (few unique values) like gender or status. **Selectivity** is cardinality divided by row count - proportion of unique values. High selectivity (close to 1) means most values are unique. Low selectivity means many duplicates. Indexes work best on high selectivity columns. Example: index on gender (M/F) has low selectivity - helps little because half the rows match each query. Index on email has high selectivity - finds specific row quickly. When evaluating indexes, consider selectivity. Generally index high cardinality columns used in WHERE clauses.

**#. What is a covering index?**

Covering index includes all columns needed by a query, so database can satisfy query entirely from index without accessing table data. Example: query SELECT email, age FROM users WHERE last_name='Smith'. Composite index CREATE INDEX idx_cover ON users(last_name, email, age) covers this query - all needed columns are in index. Benefits: much faster because avoids table lookup, reduces I/O. Called "index-only scan" in query plans. To create covering indexes, include WHERE columns first, then SELECT columns. Drawback: larger indexes, more maintenance cost. Use for frequently-run queries where performance is critical. Check query execution plans to verify index covering. Balance coverage vs index size.

**#. When should you not use indexes?**

Avoid indexes when: small tables (full scan is fast anyway), columns with low cardinality (like boolean or small enum), columns rarely used in queries, tables with heavy INSERT/UPDATE/DELETE (index maintenance overhead), columns with frequent updates (index must be maintained), when table scan is faster (selecting large percentage of rows). Example: gender column with M/F - index helps little. Status column updated frequently - index maintenance costly. Reporting table loaded in batch - index during load, then rebuild. Too many indexes hurt overall performance. Monitor index usage - drop unused indexes. Every index has cost. Only create indexes that demonstrably improve query performance for your workload.

**#. How do you analyze query performance?**

Use database tools to analyze queries. **EXPLAIN/EXPLAIN ANALYZE** shows query execution plan - which indexes used, join methods, row counts. Example: EXPLAIN SELECT * FROM users WHERE email='test@example.com' shows if index is used. Look for: full table scans (bad on large tables), index scans (good), nested loop joins (can be slow), missing indexes. **Query execution time** - measure actual runtime. **Database profiler** logs slow queries. **Query plan**: check for table scans, check estimated vs actual rows, look for expensive operations. Optimize by: adding indexes, rewriting queries, breaking complex queries, using proper joins, limiting result sets. Enable slow query log to identify problem queries. Performance tuning is iterative - measure, optimize, measure again.

**#. What is query optimization and how does it work?**

Query optimization is the process of finding the most efficient way to execute a query. The **query optimizer** (part of database engine) analyzes multiple execution strategies and chooses the best one. Process: parse query, generate possible execution plans (different join orders, access methods, index choices), estimate cost of each plan (using statistics on table size, index selectivity, data distribution), select lowest cost plan. Optimizer uses: table/index statistics (row counts, cardinality), available indexes, join algorithms (nested loop, hash join, merge join), sort methods. You help optimizer by: creating appropriate indexes, updating statistics (ANALYZE TABLE), writing clear queries. EXPLAIN shows chosen plan. Sometimes manually hint or restructure query if optimizer chooses poorly.

**#. Explain full table scan vs index scan.**

**Full table scan** reads every row in the table sequentially. Used when: no useful index exists, query needs most/all rows, table is small, optimizer determines scan is faster. Slow on large tables but simple. **Index scan** uses index to find rows. Types: **index seek** (or index range scan) finds specific values using B-tree traversal - very fast. **Index scan** (full index scan) reads entire index in order - faster than table scan if index is smaller or needed columns are in index. **Index-only scan** when query is covered by index. Optimizer chooses based on selectivity - if query matches many rows (low selectivity), table scan might be faster than many index lookups. Check EXPLAIN to see which is used.

**#. What are execution plans and how do you read them?**

Execution plan shows how database will execute a query - the steps, order, and methods. Get it with EXPLAIN or EXPLAIN ANALYZE. Key information: **access methods** (seq scan, index scan, index seek), **join methods** (nested loop, hash join, merge join), **row estimates** (how many rows at each step), **cost estimates** (relative cost, not time), **actual rows** (with ANALYZE, actual vs estimated). Reading tips: read bottom-up or inside-out (depending on database), look for expensive operations (high cost, large row counts), identify table scans on large tables, check if indexes are used, verify join methods are appropriate, compare estimated vs actual rows (big differences indicate stale statistics). Use execution plans to identify bottlenecks and guide optimization.

## Advanced SQL

**#. What are window functions and how do they differ from aggregate functions?**

Window functions perform calculations across set of rows related to current row, but unlike GROUP BY, they don't collapse rows. Each row keeps its identity. Common window functions: ROW_NUMBER(), RANK(), DENSE_RANK(), LAG(), LEAD(), SUM(), AVG() with OVER(). Example: SELECT name, salary, AVG(salary) OVER(PARTITION BY dept_id) as dept_avg FROM employees. Each employee row shows their department's average salary. Compare to GROUP BY which would return one row per department. Window functions use OVER clause defining the window: PARTITION BY divides rows into groups, ORDER BY orders within partition. Use for: running totals, rankings, comparing row to aggregate, accessing other rows (LAG/LEAD). More powerful than GROUP BY for analytical queries.

**#. Explain ROW_NUMBER, RANK, and DENSE_RANK.**

All assign rankings but differ in handling ties. **ROW_NUMBER()** assigns unique sequential numbers, even for ties (arbitrary order for equal values). **RANK()** assigns same rank to ties, then skips next ranks. **DENSE_RANK()** assigns same rank to ties but doesn't skip ranks. Example with salaries 100, 90, 90, 80: ROW_NUMBER gives 1,2,3,4. RANK gives 1,2,2,4 (skips 3). DENSE_RANK gives 1,2,2,3 (no skip). Syntax: SELECT name, salary, ROW_NUMBER() OVER(ORDER BY salary DESC) as row_num, RANK() OVER(ORDER BY salary DESC) as rank, DENSE_RANK() OVER(ORDER BY salary DESC) as dense_rank FROM employees. Use ROW_NUMBER for pagination, RANK for typical rankings with gaps, DENSE_RANK for rankings without gaps.

**#. What are LAG and LEAD functions?**

LAG accesses previous row's value. LEAD accesses next row's value. Both useful for comparing rows. Syntax: LAG(column, offset, default) OVER(ORDER BY ...). Example: SELECT date, revenue, LAG(revenue, 1, 0) OVER(ORDER BY date) as prev_revenue, revenue - LAG(revenue, 1, 0) OVER(ORDER BY date) as difference FROM daily_sales. Shows revenue change from previous day. LEAD works similarly but looks ahead. Offset defaults to 1. Default value used when LAG/LEAD goes beyond window bounds. Use PARTITION BY for per-group comparisons: LAG(salary) OVER(PARTITION BY dept_id ORDER BY hire_date). Useful for: time series analysis, change calculations, sequence analysis.

**#. Explain CTEs (Common Table Expressions).**

CTE is a temporary named result set defined within a query using WITH clause. More readable than subqueries. Syntax: WITH cte_name AS (SELECT ...) SELECT * FROM cte_name. Example: WITH high_earners AS (SELECT * FROM employees WHERE salary > 100000) SELECT dept_id, COUNT(*) FROM high_earners GROUP BY dept_id. Benefits: improved readability, can reference multiple times, can be recursive (for hierarchical data). Multiple CTEs: WITH cte1 AS (...), cte2 AS (...) SELECT. Recursive CTE example: WITH RECURSIVE subordinates AS (SELECT id, name, manager_id FROM employees WHERE manager_id IS NULL UNION ALL SELECT e.id, e.name, e.manager_id FROM employees e JOIN subordinates s ON e.manager_id = s.id) SELECT * FROM subordinates. CTEs make complex queries more maintainable.

**#. What are recursive CTEs and when do you use them?**

Recursive CTE references itself, useful for hierarchical or graph data. Structure: anchor member (base case) UNION ALL recursive member (references CTE). Example for employee hierarchy: WITH RECURSIVE org_chart AS (SELECT id, name, manager_id, 1 as level FROM employees WHERE manager_id IS NULL UNION ALL SELECT e.id, e.name, e.manager_id, o.level + 1 FROM employees e JOIN org_chart o ON e.manager_id = o.id) SELECT * FROM org_chart ORDER BY level. Anchor gets top-level managers, recursive part adds their subordinates. Use for: org charts, bill of materials, category trees, graph traversal, path finding. Include recursion termination condition to avoid infinite loops. Some databases limit recursion depth. Recursive CTEs are powerful for hierarchical queries that would otherwise require multiple queries or application logic.

**#. Explain PIVOT and UNPIVOT operations.**

PIVOT rotates rows into columns - transforms row values into column names. Useful for reporting. Example: sales data by product and month. PIVOT creates one column per month. Syntax varies by database. SQL Server: SELECT * FROM (SELECT product, month, sales FROM sales_data) src PIVOT (SUM(sales) FOR month IN ([Jan], [Feb], [Mar])) piv. Result: one row per product with Jan, Feb, Mar columns. UNPIVOT is reverse - converts columns to rows. Example: columns Jan, Feb, Mar become rows. Not all databases support PIVOT/UNPIVOT directly. Can achieve with CASE: SELECT product, SUM(CASE WHEN month='Jan' THEN sales END) as Jan, SUM(CASE WHEN month='Feb' THEN sales END) as Feb FROM sales_data GROUP BY product.

**#. What are database views and materialized views?**

**View** is a virtual table based on a query - doesn't store data, executes query when accessed. CREATE VIEW high_earners AS SELECT * FROM employees WHERE salary > 100000. Use like table: SELECT * FROM high_earners. Benefits: simplify complex queries, abstract database structure, security (limit visible data), reusability. Updatable views (in some cases) allow INSERT/UPDATE/DELETE. **Materialized view** stores query results physically - data is cached. Must be refreshed to see updates: REFRESH MATERIALIZED VIEW mv_name. Much faster than regular view for expensive queries because data is pre-computed. Use for: reports, aggregations, complex joins. Tradeoff: staleness vs performance. Regular views show current data, materialized views show snapshot. Choose based on whether you need real-time data or can tolerate lag.

**#. Explain database transactions and ACID properties.**

Transaction is a unit of work - multiple operations treated as one atomic unit. ACID properties: **Atomicity** - all operations succeed or all fail (no partial transactions). **Consistency** - transaction takes database from one valid state to another (constraints maintained). **Isolation** - concurrent transactions don't interfere (appear to execute serially). **Durability** - committed changes are permanent, survive crashes. Transaction commands: BEGIN/START TRANSACTION, COMMIT (save changes), ROLLBACK (undo changes), SAVEPOINT (partial rollback point). Example: bank transfer - deduct from account A, add to account B. If any step fails, rollback both. Atomicity ensures money isn't lost. Transactions are essential for data integrity in multi-step operations.

**#. What are transaction isolation levels?**

Isolation levels control visibility of changes between concurrent transactions, trading performance for consistency. Four levels: **READ UNCOMMITTED** (lowest) - dirty reads possible (see uncommitted changes). **READ COMMITTED** - only see committed changes, but non-repeatable reads possible (same query returns different results if data changed). **REPEATABLE READ** - same query returns same results within transaction, but phantom reads possible (new rows appear). **SERIALIZABLE** (highest) - complete isolation, transactions appear serial, no anomalies but lowest concurrency. Example: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ. Default varies by database (PostgreSQL: Read Committed, MySQL InnoDB: Repeatable Read). Higher isolation prevents anomalies but reduces concurrency. Choose based on consistency requirements vs performance needs.

**#. Explain the N+1 query problem in SQL.**

N+1 problem occurs when loading a collection with relationships. First query loads N parent records. Then for each parent, another query loads related child records - N additional queries. Total: 1 + N queries. Example: load 100 orders, then for each order, query order items - 101 queries. Very inefficient. Solution: use JOIN to load everything in one query: SELECT o.*, oi.* FROM orders o LEFT JOIN order_items oi ON o.id = oi.order_id. Now all data in one query. In ORMs like Hibernate: use JOIN FETCH in queries or configure eager loading appropriately. Alternative: batch loading (load all order_items for all orders in one query). N+1 is a common performance issue. Always watch for repeated similar queries. Fix with JOINs or batching.

## SQL Practical & Best Practices

**#. How do you find duplicate rows in a table?**

Use GROUP BY with HAVING COUNT(*) > 1. Example: SELECT email, COUNT(*) FROM users GROUP BY email HAVING COUNT(*) > 1 finds duplicate emails. To see all details of duplicates: SELECT * FROM users WHERE email IN (SELECT email FROM users GROUP BY email HAVING COUNT(*) > 1). To find duplicates on multiple columns: GROUP BY col1, col2, col3. With window functions: SELECT * FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY email ORDER BY id) as rn FROM users) WHERE rn > 1. To delete duplicates keeping one: DELETE FROM users WHERE id NOT IN (SELECT MIN(id) FROM users GROUP BY email) or use ROW_NUMBER with CTE. Finding and handling duplicates is common data quality task.

**#. How do you find the second highest salary?**

Several approaches. With LIMIT/OFFSET: SELECT DISTINCT salary FROM employees ORDER BY salary DESC LIMIT 1 OFFSET 1. With subquery: SELECT MAX(salary) FROM employees WHERE salary < (SELECT MAX(salary) FROM employees). With window function: SELECT * FROM (SELECT DISTINCT salary, DENSE_RANK() OVER(ORDER BY salary DESC) as rank FROM employees) WHERE rank = 2. For nth highest, adjust offset or rank. Use DISTINCT to avoid counting duplicate salaries as different ranks. DENSE_RANK vs RANK: if two people have highest salary, DENSE_RANK makes next one second, RANK makes it third. Choose based on requirements. This pattern applies to any "nth largest/smallest" query.

**#. How do you optimize a slow SQL query?**

Steps to optimize: 1) Use EXPLAIN to see execution plan. 2) Check if indexes are used - add missing indexes on WHERE, JOIN, ORDER BY columns. 3) Avoid SELECT * - select only needed columns. 4) Break complex queries into smaller ones or use CTEs. 5) Check for N+1 problems - fix with JOINs. 6) Use appropriate JOIN types - sometimes EXISTS is faster than JOIN. 7) Filter early - move WHERE conditions before JOINs when possible. 8) Avoid functions on indexed columns in WHERE - WHERE YEAR(date)=2024 prevents index use, use date >= '2024-01-01' AND date < '2025-01-01'. 9) Update statistics - ANALYZE TABLE. 10) Consider denormalization for read-heavy workloads. 11) Add covering indexes. 12) Use LIMIT for large result sets. 13) Cache results at application level. Optimization is iterative - measure impact of each change.

**#. What are SQL best practices?**

Key practices: Use parameterized queries (prevent SQL injection). Use meaningful names for tables/columns. Include primary keys on all tables. Use appropriate data types. Normalize to avoid redundancy (usually 3NF), denormalize for performance when needed. Index foreign keys and frequently queried columns. Avoid SELECT *, specify columns. Use transactions for multi-step operations. Handle NULL appropriately. Use constraints for data integrity. Don't store calculated values (store base values, calculate on query). Use standard SQL when possible (portability). Comment complex queries. Use schema/object naming conventions. Avoid NOLOCK/dirty reads unless necessary. Monitor and optimize slow queries. Regular backups. Security: least privilege access, encrypt sensitive data. Version control for schema changes.

**#. How do you prevent SQL injection?**

SQL injection is when malicious SQL code is inserted through user input. Prevention: **1) Use parameterized queries/prepared statements** - NEVER concatenate user input into SQL. Bad: "SELECT * FROM users WHERE email='" + userInput + "'". Good: PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE email=?"); ps.setString(1, userInput). **2) Use ORM frameworks** properly (JPA, Hibernate) - they use parameterized queries. **3) Validate input** - whitelist allowed characters, reject suspicious input. **4) Escape special characters** if you must build dynamic SQL. **5) Least privilege** - database user should have minimal permissions needed. **6) Use stored procedures** with parameters. **7) Never display raw database errors** to users (reveals structure). Parameterized queries are the primary defense - they treat input as data, not code. Never trust user input.
