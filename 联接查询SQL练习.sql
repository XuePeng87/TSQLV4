-- 练习1-1
-- 练习内容：编写一个查询，为每个雇员生成5个副本
-- 涉及的表：HR.Employees, dbo.Nums
-- 输出的列：empid, firstname, lastname, n
-- 正确结果：45行
SELECT E.empid, E.firstname, E.lastname, N.n 
FROM dbo.Nums AS N 
	CROSS JOIN HR.Employees AS E 
WHERE N.n < 6 ORDER BY N.n, E.empid;

-- 练习1-2
-- 练习内容：编写一个查询，每个雇员返回一行，并且日期在2015年6月12日到2015年6月16日范围内
-- 涉及的表：HR.Employees, dbo.Nums
-- 输出的列：empid, dt
-- 正确结果：45行
SELECT E.empid, DATEADD(day, N.n - 1, '20150612') AS dt  
FROM HR.Employees AS E 
	CROSS JOIN dbo.Nums N 
WHERE N <= DATEDIFF(day, '20150612', '20150616') + 1
ORDER BY E.empid, dt;

-- 练习2
-- 练习内容：返回美国客户，并为每个客户返回订单总数和总数量
-- 涉及的表：Sales.Customers, Sales.Orders, Sales.OrderDetails
-- 输出的列：custid, numorders, totalqty
-- 正确结果：13行
SELECT C.custid, COUNT(DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty 
FROM Sales.Customers C 
	JOIN Sales.Orders O ON O.custid = C.custid 
	JOIN Sales.OrderDetails OD ON OD.orderid = O.orderid 
WHERE C.country = N'USA' 
GROUP BY C.custid; 

-- 练习3
-- 练习内容：返回客户及其订单，包括没有下订单的客户
-- 涉及的表：Sales.Customers, Sales.Orders
-- 输出的列：custid, companyname, orderid, orderdate
-- 正确结果：832行
SELECT C.custid, C.companyname, O.orderid, O.orderdate  
FROM Sales.Customers C 
	LEFT OUTER JOIN Sales.Orders O ON O.custid = C.custid;

-- 练习4
-- 练习内容：返回没有下订单的客户
-- 涉及的表：Sales.Customers, Sales.Orders
-- 输出的列：custid, companyname
-- 正确结果：2行
SELECT C.custid, C.companyname 
FROM Sales.Customers C 
	LEFT OUTER JOIN Sales.Orders O ON O.custid = C.custid
WHERE O.orderid IS NULL;

-- 练习5
-- 练习内容：返回2015年2月12日下订单的客户，以及他们的订单
-- 涉及的表：Sales.Customers, Sales.Orders
-- 输出的列：custid, companyname, orderid, orderdate
-- 正确结果：2行
SELECT C.custid, C.companyname, O.orderid, O.orderdate  
FROM Sales.Customers C 
	LEFT OUTER JOIN Sales.Orders O ON O.custid = C.custid
WHERE O.orderdate = '20150212'

-- 练习6
-- 练习内容：返回2015年2月12日下订单的客户，以及他们的订单。此外，还返回这一天没有下订单的客户
-- 涉及的表：Sales.Customers, Sales.Orders
-- 输出的列：custid, companyname, orderid, orderdate
-- 正确结果：91行
SELECT C.custid, C.companyname, O.orderid, O.orderdate  
FROM Sales.Customers C 
	LEFT OUTER JOIN Sales.Orders O ON O.custid = C.custid AND O.orderdate = '20150212'

-- 练习7
-- 练习内容：返回所有客户与，并基于客户在2015年2月12日是否有订单为其返回Yes/No值
-- 涉及的表：Sales.Customers, Sales.Orders
-- 输出的列：custid, companyname, HasOrderOn20150212
-- 正确结果：91行
SELECT C.custid, C.companyname, 
	CASE WHEN O.orderid IS NULL THEN 'No'
	ELSE 'Yes' END AS HasOrderOn20150212
FROM Sales.Customers C 
	LEFT OUTER JOIN Sales.Orders O ON O.custid = C.custid AND O.orderdate = '20150212'