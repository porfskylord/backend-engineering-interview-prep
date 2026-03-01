CREATE TABLE Numbers (
    ID INT PRIMARY KEY
);

INSERT INTO Numbers (ID) VALUES
(1),
(2),
(3),
(5),
(6),
(9),
(10);


select * from (select id, LAG(id) over (ORDER BY id), id - LAG(id) over (ORDER BY id) as gap  from numbers) x where gap > 1


