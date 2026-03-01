CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Salary INT
);
INSERT INTO Employee (EmpID, EmpName, Salary) VALUES
(1, 'John',   50000),
(2, 'Alice',  60000),
(3, 'Bob',    70000),
(4, 'Carol',  60000),  -- same as Alice
(5, 'David',  80000),
(6, 'Emma',   70000),  -- same as Bob
(7, 'Frank',  90000);


select distinct salary from (select salary,DENSE_RANK() over (order by salary desc) as rowno from employee) x where rowno = 2;





