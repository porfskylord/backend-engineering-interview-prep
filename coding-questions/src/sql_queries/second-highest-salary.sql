CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary INT
);

INSERT INTO Employee (EmployeeID, Name, Salary) VALUES
(1, 'John', 50000),
(2, 'Alice', 60000),
(3, 'Bob', 70000),
(4, 'Carol', 60000),
(5, 'David', 80000);


select distinct salary from employee order by salary DESC LIMIT 1 OFFSET 1;

select distinct salary from (select salary,DENSE_RANK() over (order by salary desc) as rowno from employee) x where rowno = 2;