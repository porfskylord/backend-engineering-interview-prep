CREATE EXTENSION tablefunc;

CREATE TABLE Sales (
    Year INT,
    Quarter VARCHAR(10),
    Amount INT
);

INSERT INTO Sales (Year, Quarter, Amount) VALUES
(2024, 'Q1', 10000),
(2024, 'Q2', 15000),
(2024, 'Q3', 20000),
(2024, 'Q4', 25000),
(2025, 'Q1', 12000),
(2025, 'Q2', 18000);

select * from crosstab (
  'select year, quarter, amount from sales order by 1,2', 'select distinct quarter from sales order by 1'
) as ct (
year INT,
Q1 INT,
Q2 INT,
Q3 INT,
Q4 INT
);


