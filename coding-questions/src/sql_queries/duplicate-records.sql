CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100),
    City VARCHAR(50)
);

INSERT INTO Customers (CustomerID, Name, Email, City) VALUES
(1, 'John',  'john@gmail.com',  'New York'),
(2, 'Alice', 'alice@gmail.com', 'Chicago'),
(3, 'Bob',   'bob@gmail.com',   'Dallas'),
(4, 'John',  'john@gmail.com',  'New York'),   -- duplicate
(5, 'David', 'david@gmail.com', 'Seattle'),
(6, 'Alice', 'alice@gmail.com', 'Chicago'),    -- duplicate
(7, 'Emma',  'emma@gmail.com',  'Boston');

select Name, Email, City from customers group by Name, Email, City HAVING count(*) > 1;