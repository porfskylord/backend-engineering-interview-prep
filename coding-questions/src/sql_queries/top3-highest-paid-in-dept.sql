CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Salary INT,
    DeptID INT
);

INSERT INTO Employee (EmpID, EmpName, Salary, DeptID) VALUES
-- HR (DeptID = 1)
(1, 'John',   50000, 1),
(2, 'Alice',  60000, 1),
(3, 'Bob',    55000, 1),
(4, 'Carol',  65000, 1),
(5, 'David',  70000, 1),

-- IT (DeptID = 2)
(6, 'Emma',   80000, 2),
(7, 'Frank',  75000, 2),
(8, 'Grace',  90000, 2),
(9, 'Henry',  85000, 2),
(10, 'Ivy',   70000, 2),

-- Sales (DeptID = 3)
(11, 'Jack',  40000, 3),
(12, 'Kate',  45000, 3),
(13, 'Leo',   50000, 3),
(14, 'Mia',   48000, 3);


select deptid, empname, salary, ranker from  (select deptid, empname, salary, ROW_NUMBER() over (PARTITION by deptid order by salary desc) as ranker from employee e) x where x.ranker <= 3;