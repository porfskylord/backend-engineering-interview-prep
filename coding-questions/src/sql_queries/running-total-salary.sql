CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Salary INT
);
INSERT INTO Employee (EmpID, EmpName, Salary) VALUES
(1, 'John',   30000),
(2, 'Alice',  40000),
(3, 'Bob',    35000),
(4, 'Carol',  50000),
(5, 'David',  45000);


select EmpID, EmpName, Salary,sum(salary) over (order by empid) from employee order by empid;