CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    JoinDate DATE
);

INSERT INTO Employee (EmpID, EmpName, JoinDate) VALUES
(1, 'John',   CURRENT_DATE - INTERVAL '10 days'),
(2, 'Alice',  CURRENT_DATE - INTERVAL '25 days'),
(3, 'Bob',    CURRENT_DATE - INTERVAL '40 days'),
(4, 'Carol',  CURRENT_DATE - INTERVAL '5 days'),
(5, 'David',  CURRENT_DATE - INTERVAL '60 days');

select * from employee where joindate >= CURRENT_DATE - INTERVAL '30 days;