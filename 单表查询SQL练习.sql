-- 练习1
-- 练习内容：编写一个对Sales.Orders表的查询，返回2015年6月的订单
-- 涉及的表：Sales.Orders
-- 输入的列：orderid, orderdate, custid, empid
-- 正确结果：30行
SELECT orderid, orderdate, custid, empid  
FROM Sales.Orders 
WHERE orderdate BETWEEN '20150601' AND '20150630';

SELECT orderid, orderdate, custid, empid  
FROM Sales.Orders 
WHERE orderdate >= '20150601' AND orderdate < '20150701';

-- 练习2
-- 练习内容：编写一个对Sales.Orders表的查询，返回每月最后一天的订单
-- 涉及的表：Sales.Orders
-- 输入的列：orderid, orderdate, custid, empid
-- 正确结果：26行
SELECT orderid, orderdate, custid, empid  
FROM Sales.Orders 
WHERE orderdate = EOMONTH(orderdate);

SELECT orderid, orderdate, custid, empid  
FROM Sales.Orders 
WHERE orderdate = DATEADD(MONTH, DATEDIFF(month, '20101231', orderdate), '20101231');

-- 练习3
-- 练习内容：编写一个对HR.Employees表的查询，返回姓氏包含字母"e"两次及以上次数的雇员
-- 涉及的表：HR.Employees
-- 输出的列：empid, firstname, lastname
-- 正确结果：2行
SELECT empid, firstname, lastname 
FROM HR.Employees 
WHERE lastname LIKE '%e%e%';

-- 练习4
-- 练习内容：编写一个对Sales.OrderDetails表的查询，返回总价(qty*unitprice)大于10000的订单，按总价排序
-- 涉及的表：Sales.OrderDetails
-- 输出的列：orderid, totalvalue
-- 正确结果：14行
SELECT orderid, SUM(qty*unitprice) AS totalvalue 
FROM Sales.OrderDetails 
GROUP BY orderid 
HAVING SUM(qty * unitprice) > 10000 
ORDER BY totalvalue;

-- 练习5
-- 练习内容：编写一个对Sales.Orders表的查询，返回2015年中平均运费最高的3个国家
-- 涉及的表：Sales.Orders
-- 输出的列：shipcountry, avgfreight
-- 正确结果：3行
SELECT TOP 3 shipcountry, AVG(freight) AS avgfreight 
FROM Sales.Orders 
WHERE orderdate >= '20150101' AND orderdate < '20160101' 
GROUP BY shipcountry 
ORDER BY avgfreight DESC;

SELECT shipcountry, AVG(freight) AS avgfreight 
FROM Sales.Orders 
WHERE orderdate >= '20150101' AND orderdate < '20160101' 
GROUP BY shipcountry 
ORDER BY avgfreight DESC 
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

-- 练习6
-- 练习内容：编写一个对Sales.Orders表的查询，分别对每个客户的订单按订单日期排序（使用订单ID作为决胜属性），计算订单编号
-- 涉及的表：Sales.Orders
-- 输出的列：custid, orderdate, orderid, rownum
-- 正确结果：830行
SELECT custid, orderdate, orderid, 
	ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rownum 
FROM Sales.Orders 
ORDER BY custid, rownum;

-- 练习7
-- 练习内容：使用HR.Employees表，根据称谓推测每个雇员的性别。"Ms."和"Mrs."返回"Female"，"Mr."返回"Male"，所有其他情况返回"Unknown"
-- 涉及的表：HR.Employees
-- 输出的列：empid, firstname, lastname, titleofcourtesy, gender 
-- 正确结果：9行
SELECT empid, firstname, lastname, titleofcourtesy, 
	CASE  
		WHEN titleofcourtesy ='Ms.' THEN 'Female' 
		WHEN titleofcourtesy = 'Mrs.' THEN 'Female' 
		WHEN titleofcourtesy = 'Mr.' THEN 'Male' 
		ELSE 'Unknown' 
	END AS gender 
FROM HR.Employees;

SELECT empid, firstname, lastname, titleofcourtesy, 
	CASE  
		WHEN titleofcourtesy IN ('Ms.', 'Mrs.') THEN 'Female' 
		WHEN titleofcourtesy = 'Mr.' THEN 'Male' 
		ELSE 'Unknown' 
	END AS gender 
FROM HR.Employees; 

-- 练习8
-- 练习内容：编写一个对Sales.Customers表的查询，返回客户的ID和地区。按地区排序输出行，具有NULL标记的行最后进行排序。
-- 涉及的表：Sales.Customers
-- 输出的列：custid, region
-- 正确结果：91行
SELECT custid, region 
FROM Sales.Customers 
ORDER BY 
	CASE WHEN region IS NULL THEN 1 ELSE 0 END, region;

