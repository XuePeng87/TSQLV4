-- ��ϰ1-1
-- ��ϰ���ݣ���дһ����ѯ��Ϊÿ����Ա����5������
-- �漰�ı�HR.Employees, dbo.Nums
-- ������У�empid, firstname, lastname, n
-- ��ȷ�����45��
SELECT E.empid, E.firstname, E.lastname, N.n 
FROM dbo.Nums AS N 
	CROSS JOIN HR.Employees AS E 
WHERE N.n < 6 ORDER BY N.n, E.empid;

-- ��ϰ1-2
-- ��ϰ���ݣ���дһ����ѯ��ÿ����Ա����һ�У�����������2015��6��12�յ�2015��6��16�շ�Χ��
-- �漰�ı�HR.Employees, dbo.Nums
-- ������У�empid, dt
-- ��ȷ�����45��
SELECT E.empid, DATEADD(day, N.n - 1, '20150612') AS dt  
FROM HR.Employees AS E 
	CROSS JOIN dbo.Nums N 
WHERE N <= DATEDIFF(day, '20150612', '20150616') + 1
ORDER BY E.empid, dt;

-- ��ϰ2
-- ��ϰ���ݣ����������ͻ�����Ϊÿ���ͻ����ض���������������
-- �漰�ı�Sales.Customers, Sales.Orders, Sales.OrderDetails
-- ������У�custid, numorders, totalqty
-- ��ȷ�����13��
SELECT C.custid, COUNT(DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty 
FROM Sales.Customers C 
	JOIN Sales.Orders O ON O.custid = C.custid 
	JOIN Sales.OrderDetails OD ON OD.orderid = O.orderid 
WHERE C.country = N'USA' 
GROUP BY C.custid; 

-- ��ϰ3
-- ��ϰ���ݣ����ؿͻ����䶩��������û���¶����Ŀͻ�
-- �漰�ı�Sales.Customers, Sales.Orders
-- ������У�custid, companyname, orderid, orderdate
-- ��ȷ�����832��
SELECT C.custid, C.companyname, O.orderid, O.orderdate  
FROM Sales.Customers C 
	LEFT OUTER JOIN Sales.Orders O ON O.custid = C.custid;

-- ��ϰ4
-- ��ϰ���ݣ�����û���¶����Ŀͻ�
-- �漰�ı�Sales.Customers, Sales.Orders
-- ������У�custid, companyname
-- ��ȷ�����2��
SELECT C.custid, C.companyname 
FROM Sales.Customers C 
	LEFT OUTER JOIN Sales.Orders O ON O.custid = C.custid
WHERE O.orderid IS NULL;

-- ��ϰ5
-- ��ϰ���ݣ�����2015��2��12���¶����Ŀͻ����Լ����ǵĶ���
-- �漰�ı�Sales.Customers, Sales.Orders
-- ������У�custid, companyname, orderid, orderdate
-- ��ȷ�����2��
SELECT C.custid, C.companyname, O.orderid, O.orderdate  
FROM Sales.Customers C 
	LEFT OUTER JOIN Sales.Orders O ON O.custid = C.custid
WHERE O.orderdate = '20150212'

-- ��ϰ6
-- ��ϰ���ݣ�����2015��2��12���¶����Ŀͻ����Լ����ǵĶ��������⣬��������һ��û���¶����Ŀͻ�
-- �漰�ı�Sales.Customers, Sales.Orders
-- ������У�custid, companyname, orderid, orderdate
-- ��ȷ�����91��
SELECT C.custid, C.companyname, O.orderid, O.orderdate  
FROM Sales.Customers C 
	LEFT OUTER JOIN Sales.Orders O ON O.custid = C.custid AND O.orderdate = '20150212'

-- ��ϰ7
-- ��ϰ���ݣ��������пͻ��룬�����ڿͻ���2015��2��12���Ƿ��ж���Ϊ�䷵��Yes/Noֵ
-- �漰�ı�Sales.Customers, Sales.Orders
-- ������У�custid, companyname, HasOrderOn20150212
-- ��ȷ�����91��
SELECT C.custid, C.companyname, 
	CASE WHEN O.orderid IS NULL THEN 'No'
	ELSE 'Yes' END AS HasOrderOn20150212
FROM Sales.Customers C 
	LEFT OUTER JOIN Sales.Orders O ON O.custid = C.custid AND O.orderdate = '20150212'