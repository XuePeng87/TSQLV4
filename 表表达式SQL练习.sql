-- 练习1
-- 练习内容：返回每个雇员在orderdate列中的最大值
-- 涉及的表：Sales.Orders
-- 输出的列：empid, maxorderdate
-- 正确结果：9行
SELECT empid, MAX(orderdate) AS maxorderdate 
FROM Sales.Orders GROUP BY empid;

-- 练习1-2
-- 练习内容：编写一个派生表和Orders表之间的连接查询，返回每个雇员最大订单日期的订单
-- 涉及的表：Sales.Orders
-- 输出的列：empid, maxorderdate
-- 正确结果：10行
SELECT O1.empid, O2.maxorderdate, O1.orderid, O1.custid FROM Sales.Orders O1
JOIN 
(SELECT empid, MAX(orderdate) AS maxorderdate FROM Sales.Orders GROUP BY empid) AS O2 
ON O1.empid = O2.empid AND O1.orderdate = O2.maxorderdate;

-- 练习2-1
-- 练习内容：编写一个查询，计算按orderdate、orderid排序的每个订单的行号
-- 涉及的表：Sales.Orders
-- 输出的列：orderid, orderdate, custid, empid, rownum
-- 正确结果：830行
SELECT orderid, orderdate, custid, empid, 
ROW_NUMBER() OVER(ORDER BY orderdate, orderid) AS rownum 
FROM Sales.Orders ORDER BY orderdate, orderid;

-- 练习2-2
-- 练习内容：使用CTE，返回行号11至20的行
-- 涉及的表：Sales.Orders
-- 输出的列：orderid, orderdate, custid, empid, rownum
-- 正确结果：10行
WITH O AS 
(
	SELECT orderid, orderdate, custid, empid, 
	ROW_NUMBER() OVER(ORDER BY orderdate, orderid) AS rownum 
	FROM Sales.Orders
)
SELECT * FROM O WHERE rownum BETWEEN 11 AND 20
ORDER BY orderdate, orderid;

-- 练习3
-- 练习内容：使用CTE，递归返回领导Zoya Dolgopyatova(ID=9)的管理链
-- 涉及的表：HR.Employees
-- 输出的列：empid, mgrid, firstname, lastname
-- 正确结果：4行
WITH EmpsCTE AS 
(
	SELECT empid, mgrid, firstname, lastname 
	FROM HR.Employees WHERE empid = 9 

	UNION ALL

	SELECT P.empid, P.mgrid, P.firstname, P.lastname 
	FROM EmpsCTE AS C  
	JOIN HR.Employees AS P 
	ON C.mgrid = P.empid
) 
SELECT empid, mgrid, firstname, lastname FROM EmpsCTE;

-- 练习4-1
-- 练习内容：创建一个视图，返回每位雇员每年的总销售量
-- 涉及的表：Sales.Orders, Sales.OrderDetails
-- 输出的列：empid, orderyear, qty
-- 正确结果：27行
IF OBJECT_ID('Sales.VEmpOrders') IS NOT NULL
	DROP VIEW Sales.VEmpOrders
GO
CREATE VIEW Sales.VEmpOrders
AS
SELECT empid, YEAR(orderdate) AS orderyear, SUM(qty) AS qty FROM Sales.Orders O JOIN Sales.OrderDetails D ON O.orderid = D.orderid
GROUP BY empid, YEAR(orderdate);
GO

-- 练习4-2
-- 练习内容：编写一个查询，返回每个雇员截至到当前年（包含当前年）的总销量
-- 涉及的表：Sales.VEmpOrders
-- 输出的列：empid, orderyear, qty, runqty
-- 正确结果：27行
SELECT empid, orderyear, qty, 
(SELECT SUM(qty) FROM Sales.VEmpOrders V2 WHERE V2.empid = V1.empid AND V2.orderyear <= V1.orderyear) AS runqty 
FROM Sales.VEmpOrders V1

-- 练习5-1
-- 练习内容：创建一个内嵌函数，接受供应商ID和一个数量。返回这个供应商指定数量的最高的单价产品
-- 涉及的表：Production.Products
-- 输出的列：productid, productname, unitprice
-- 正确结果：2行
IF OBJECT_ID('Production.TopProducts') IS NOT NULL 
	DROP FUNCTION Production.TopProducts;
GO
CREATE FUNCTION Production.TopProducts 
(@supid AS INT, @n AS INT) 
RETURNS TABLE 
AS
RETURN 
SELECT TOP(@n) productid, productname, unitprice 
FROM Production.Products 
WHERE supplierid = @supid 
ORDER BY unitprice DESC;

SELECT * FROM Production.TopProducts(5, 2);

-- 练习5-2
-- 练习内容：使用CROSS APPLY运算符，为每个供应商返回两个最昂贵的产品
-- 涉及的表：Production.TopProducts, Production.Suppliers 
-- 输出的列：supplierid, companyname, productid, productname, unitprice
-- 正确结果：55行
SELECT S.supplierid, S.companyname, P.productid, P.productname, P.unitprice
From Production.Suppliers AS S 
CROSS APPLY 
Production.TopProducts(S.supplierid, 2) AS P;