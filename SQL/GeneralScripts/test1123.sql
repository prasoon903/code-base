--CREATE TABLE X (A INT)
--CREATE TABLE Y (B INT)


--INSERT INTO X 
--SELECT 1 UNION ALL
--SELECT 1 UNION ALL
--SELECT NULL UNION ALL
--SELECT NULL

--INSERT INTO Y 
--SELECT 1 UNION ALL
--SELECT 1 UNION ALL
--SELECT 1 UNION ALL
--SELECT NULL

SELECT * FROM X
SELECT * FROM Y

--select count(*) from X inner join Y on X.A=Y.B

--select count(*) from X Left join Y on X.A=Y.B

select * from X Left join Y on X.A=Y.B

select * from X inner join Y on X.A=Y.B

