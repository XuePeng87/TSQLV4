-- ��ϰ1
-- ��ϰ���ݣ���дһ����Sales.Orders��Ĳ�ѯ������2015��6�µĶ���
-- �漰�ı�Sales.Orders
-- ������У�orderid, orderdate, custid, empid
-- ��ȷ�����30��
SELECT orderid, orderdate, custid, empid  
FROM Sales.Orders 
WHERE orderdate BETWEEN '20150601' AND '20150630';

SELECT orderid, orderdate, custid, empid  
FROM Sales.Orders 
WHERE orderdate >= '20150601' AND orderdate < '20150701';

-- ��ϰ2
-- ��ϰ���ݣ���дһ����Sales.Orders��Ĳ�ѯ������ÿ�����һ��Ķ���
-- �漰�ı�Sales.Orders
-- ������У�orderid, orderdate, custid, empid
-- ��ȷ�����26��
SELECT orderid, orderdate, custid, empid  
FROM Sales.Orders 
WHERE orderdate = EOMONTH(orderdate);

SELECT orderid, orderdate, custid, empid  
FROM Sales.Orders 
WHERE orderdate = DATEADD(MONTH, DATEDIFF(month, '20101231', orderdate), '20101231');

-- ��ϰ3
-- ��ϰ���ݣ���дһ����HR.Employees��Ĳ�ѯ���������ϰ�����ĸ"e"���μ����ϴ����Ĺ�Ա
-- �漰�ı�HR.Employees
-- ������У�empid, firstname, lastname
-- ��ȷ�����2��
SELECT empid, firstname, lastname 
FROM HR.Employees 
WHERE lastname LIKE '%e%e%';

-- ��ϰ4
-- ��ϰ���ݣ���дһ����Sales.OrderDetails��Ĳ�ѯ�������ܼ�(qty*unitprice)����10000�Ķ��������ܼ�����
-- �漰�ı�Sales.OrderDetails
-- ������У�orderid, totalvalue
-- ��ȷ�����14��
SELECT orderid, SUM(qty*unitprice) AS totalvalue 
FROM Sales.OrderDetails 
GROUP BY orderid 
HAVING SUM(qty * unitprice) > 10000 
ORDER BY totalvalue;

-- ��ϰ5
-- ��ϰ���ݣ���дһ����Sales.Orders��Ĳ�ѯ������2015����ƽ���˷���ߵ�3������
-- �漰�ı�Sales.Orders
-- ������У�shipcountry, avgfreight
-- ��ȷ�����3��
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

-- ��ϰ6
-- ��ϰ���ݣ���дһ����Sales.Orders��Ĳ�ѯ���ֱ��ÿ���ͻ��Ķ�����������������ʹ�ö���ID��Ϊ��ʤ���ԣ������㶩�����
-- �漰�ı�Sales.Orders
-- ������У�custid, orderdate, orderid, rownum
-- ��ȷ�����830��
SELECT custid, orderdate, orderid, 
	ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rownum 
FROM Sales.Orders 
ORDER BY custid, rownum;

-- ��ϰ7
-- ��ϰ���ݣ�ʹ��HR.Employees�����ݳ�ν�Ʋ�ÿ����Ա���Ա�"Ms."��"Mrs."����"Female"��"Mr."����"Male"�����������������"Unknown"
-- �漰�ı�HR.Employees
-- ������У�empid, firstname, lastname, titleofcourtesy, gender 
-- ��ȷ�����9��
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

-- ��ϰ8
-- ��ϰ���ݣ���дһ����Sales.Customers��Ĳ�ѯ�����ؿͻ���ID�͵�������������������У�����NULL��ǵ�������������
-- �漰�ı�Sales.Customers
-- ������У�custid, region
-- ��ȷ�����91��
SELECT custid, region 
FROM Sales.Customers 
ORDER BY 
	CASE WHEN region IS NULL THEN 1 ELSE 0 END, region;

