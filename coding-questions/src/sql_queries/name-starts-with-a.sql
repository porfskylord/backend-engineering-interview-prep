CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50)
);

INSERT INTO Employee (EmpID, EmpName) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Anita'),
(4, 'Carol'),
(5, 'Andrew'),
(6, 'David');

select * from employee where empname ilike 'A%';