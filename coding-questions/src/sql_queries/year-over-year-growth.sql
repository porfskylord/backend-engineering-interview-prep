CREATE TABLE Sales (
    Year INT PRIMARY KEY,
    TotalSales NUMERIC(10,2)
);

INSERT INTO Sales (Year, TotalSales) VALUES
(2019, 100000),
(2020, 120000),
(2021, 150000),
(2022, 130000),
(2023, 170000);


select year,totalsales,lag(totalsales) over (order by year) as previous_year_sales,round(
(((totalsales - lag(totalsales) over (order by year)) * 100) / lag(totalsales) over (order by year))
,2) as growth from sales