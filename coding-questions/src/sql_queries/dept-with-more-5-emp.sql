CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

INSERT INTO Department (DeptID, DeptName) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Sales');

INSERT INTO Employee (EmpID, EmpName, DeptID) VALUES
(1, 'John', 1),
(2, 'Alice', 1),
(3, 'Bob', 1),
(4, 'Carol', 1),
(5, 'David', 1),
(6, 'Emma', 1),      -- HR now has 6 employees

(7, 'Frank', 2),
(8, 'Grace', 2),
(9, 'Henry', 2),
(10, 'Ivy', 2),

(11, 'Jack', 3),
(12, 'Kate', 3);


select d.deptname from department d inner join employee e on e.deptid = d.deptid GROUP BY d.deptid HAVING count(*) > 5;

