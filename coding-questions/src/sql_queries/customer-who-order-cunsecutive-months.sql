CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);
INSERT INTO Customers (CustomerID, CustomerName) VALUES
(1, 'John'),
(2, 'Alice'),
(3, 'Bob');

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(101, 1, '2024-01-10'),
(102, 1, '2024-02-15'),   -- consecutive month (Jan → Feb)
(103, 1, '2024-04-05'),

(104, 2, '2024-03-12'),
(105, 2, '2024-05-20'),

(106, 3, '2024-06-01'),
(107, 3, '2024-07-09');   -- consecutive month (Jun → Jul)


select x.customername from (select c.customername,DATE_TRUNC('month', o.orderdate) order_months, lag(DATE_TRUNC('month', o.orderdate)) over (PARTITION by o.customerid order by DATE_TRUNC('month', o.orderdate)) as prev_order from customers c inner join orders o on o.customerid = c.customerid) x where x.order_months = prev_order + INTERVAL '1 month';