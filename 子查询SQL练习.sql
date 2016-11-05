-- 练习1
-- 练习内容：编写一个查询，返回Orders表中可以查到的活动最后一天的所有订单。
-- 涉及的表：Sales.Orders
-- 输出的列：orderid, orderdate, custid, empid
-- 正确结果：4行
SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders 
WHERE orderdate = (
	SELECT MAX(orderdate) FROM Sales.Orders
);

-- 练习2
-- 练习内容：编写一个查询，返回订单数量最多的客户的所有订单。注意，在一个以上的客户可能具有相同数量的订单
-- 涉及的表：Sales.Orders
-- 输出的列：custid, orderid, orderdate, empid
-- 正确结果：31行
SELECT custid, orderid, orderdate, empid 
FROM Sales.Orders 
WHERE custid = 
(
	SELECT TOP 1 WITH TIES custid FROM Sales.Orders GROUP BY custid ORDER BY COUNT(*) DESC
);

-- 练习3
-- 练习内容：编写一个查询，返回在2016年5月1日或之后没有下订单的雇员。
-- 涉及的表：HR.Employees, Sales.Orders
-- 输出的列：empid, firstname, lastname
-- 正确结果：4行
SELECT empid, firstname, lastname 
FROM HR.Employees E 
WHERE E.empid NOT IN (
	SELECT O.empid FROM Sales.Orders AS O 
	WHERE O.orderdate >= '20160501'
);

-- 练习4
-- 练习内容：编写一个查询，返回有客户但是没有雇员的国家
-- 涉及的表：Sales.Customers, HR.Employees
-- 输出的列：country
-- 正确结果：19行
SELECT DISTINCT country FROM Sales.Customers
WHERE country NOT IN (
	SELECT country FROM HR.Employees
);

-- 练习5
-- 练习内容：编写一个查询，返回每个客户活动最后一天的所有订单
-- 涉及的表：Sales.Orders
-- 输出的列：custid, orderid, orderdate, empid
-- 正确结果：90行
SELECT O1.custid, O1.orderid, O1.orderdate, O1.empid 
FROM Sales.Orders AS O1 WHERE O1.orderdate = (
	SELECT MAX(O2.orderdate) FROM Sales.Orders AS O2 
	WHERE O2.custid = O1.custid
);

-- 练习6
-- 练习内容：编写一个查询，返回2015年下过订单，但是2016年没有下订单的客户
-- 涉及的表：Sales.Customers, Sales.Orders
-- 输出的列：custid, companyname
-- 正确结果：7行
SELECT custid, companyname FROM Sales.Customers AS C 
WHERE EXISTS (
	SELECT * FROM Sales.Orders AS O1 
	WHERE orderdate BETWEEN '20150101' AND '20151231' AND O1.custid = C.custid 
) AND NOT EXISTS (
	SELECT * FROM Sales.Orders AS O2 
	WHERE orderdate BETWEEN '20160101' AND '20161231' AND O2.custid = C.custid 
);

-- 练习7
-- 练习内容：编写一个查询，返回订购了产品12的客户
-- 涉及的表：Sales.Customers, Sales.Orders, Sale.OrderDetails
-- 输出的列：custid, companyname
-- 正确结果：12行
SELECT custid, companyname 
FROM Sales.Customers WHERE custid IN (
	SELECT custid FROM Sales.Orders WHERE orderid IN (
		SELECT orderid 
		FROM Sales.OrderDetails 
		WHERE productid = 12
	)
);

-- 练习8
-- 练习内容：编写一个查询，计算每个客户及其月度的采购总量
-- 涉及的表：Sales.CustOrders
-- 输出的列：custid, ordermonth, qty
-- 正确结果：636行
SELECT custid, ordermonth, qty, (
	SELECT SUM(qty) FROM Sales.CustOrders AS O2 
	WHERE O2.custid = O1.custid
	AND O2.ordermonth <= O1.ordermonth
)  AS runqty 
FROM Sales.CustOrders AS O1;