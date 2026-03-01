CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT
);


INSERT INTO Customers (CustomerID, CustomerName) VALUES
(1, 'John'),
(2, 'Alice'),
(3, 'Bob'),
(4, 'Carol'),
(5, 'David');

INSERT INTO Orders (OrderID, CustomerID) VALUES
(101, 1),
(102, 2),
(103, 1),
(104, 3);


select c.customername from customers c left join orders o on o.customerid = c.customerid where o.customerid is null