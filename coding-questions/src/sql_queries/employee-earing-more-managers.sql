CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Salary INT,
    ManagerID INT
);

INSERT INTO Employee (EmpID, EmpName, Salary, ManagerID) VALUES
(1, 'Robert', 90000, NULL),   -- CEO (no manager)
(2, 'John',   60000, 1),
(3, 'Alice',  75000, 1),
(4, 'Bob',    50000, 2),
(5, 'Carol',  65000, 2),
(6, 'David',  80000, 3);

select e.empname,e.salary,m.empname manger,m.salary msalary from employee e left join employee m on m.empid = e.managerid where e.salary > m.salary;