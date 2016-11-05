-- ��ϰ1
-- ��ϰ���ݣ���дһ����ѯ������Orders���п��Բ鵽�Ļ���һ������ж�����
-- �漰�ı�Sales.Orders
-- ������У�orderid, orderdate, custid, empid
-- ��ȷ�����4��
SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders 
WHERE orderdate = (
	SELECT MAX(orderdate) FROM Sales.Orders
);

-- ��ϰ2
-- ��ϰ���ݣ���дһ����ѯ�����ض����������Ŀͻ������ж�����ע�⣬��һ�����ϵĿͻ����ܾ�����ͬ�����Ķ���
-- �漰�ı�Sales.Orders
-- ������У�custid, orderid, orderdate, empid
-- ��ȷ�����31��
SELECT custid, orderid, orderdate, empid 
FROM Sales.Orders 
WHERE custid = 
(
	SELECT TOP 1 WITH TIES custid FROM Sales.Orders GROUP BY custid ORDER BY COUNT(*) DESC
);

-- ��ϰ3
-- ��ϰ���ݣ���дһ����ѯ��������2016��5��1�ջ�֮��û���¶����Ĺ�Ա��
-- �漰�ı�HR.Employees, Sales.Orders
-- ������У�empid, firstname, lastname
-- ��ȷ�����4��
SELECT empid, firstname, lastname 
FROM HR.Employees E 
WHERE E.empid NOT IN (
	SELECT O.empid FROM Sales.Orders AS O 
	WHERE O.orderdate >= '20160501'
);

-- ��ϰ4
-- ��ϰ���ݣ���дһ����ѯ�������пͻ�����û�й�Ա�Ĺ���
-- �漰�ı�Sales.Customers, HR.Employees
-- ������У�country
-- ��ȷ�����19��
SELECT DISTINCT country FROM Sales.Customers
WHERE country NOT IN (
	SELECT country FROM HR.Employees
);

-- ��ϰ5
-- ��ϰ���ݣ���дһ����ѯ������ÿ���ͻ�����һ������ж���
-- �漰�ı�Sales.Orders
-- ������У�custid, orderid, orderdate, empid
-- ��ȷ�����90��
SELECT O1.custid, O1.orderid, O1.orderdate, O1.empid 
FROM Sales.Orders AS O1 WHERE O1.orderdate = (
	SELECT MAX(O2.orderdate) FROM Sales.Orders AS O2 
	WHERE O2.custid = O1.custid
);

-- ��ϰ6
-- ��ϰ���ݣ���дһ����ѯ������2015���¹�����������2016��û���¶����Ŀͻ�
-- �漰�ı�Sales.Customers, Sales.Orders
-- ������У�custid, companyname
-- ��ȷ�����7��
SELECT custid, companyname FROM Sales.Customers AS C 
WHERE EXISTS (
	SELECT * FROM Sales.Orders AS O1 
	WHERE orderdate BETWEEN '20150101' AND '20151231' AND O1.custid = C.custid 
) AND NOT EXISTS (
	SELECT * FROM Sales.Orders AS O2 
	WHERE orderdate BETWEEN '20160101' AND '20161231' AND O2.custid = C.custid 
);

-- ��ϰ7
-- ��ϰ���ݣ���дһ����ѯ�����ض����˲�Ʒ12�Ŀͻ�
-- �漰�ı�Sales.Customers, Sales.Orders, Sale.OrderDetails
-- ������У�custid, companyname
-- ��ȷ�����12��
SELECT custid, companyname 
FROM Sales.Customers WHERE custid IN (
	SELECT custid FROM Sales.Orders WHERE orderid IN (
		SELECT orderid 
		FROM Sales.OrderDetails 
		WHERE productid = 12
	)
);

-- ��ϰ8
-- ��ϰ���ݣ���дһ����ѯ������ÿ���ͻ������¶ȵĲɹ�����
-- �漰�ı�Sales.CustOrders
-- ������У�custid, ordermonth, qty
-- ��ȷ�����636��
SELECT custid, ordermonth, qty, (
	SELECT SUM(qty) FROM Sales.CustOrders AS O2 
	WHERE O2.custid = O1.custid
	AND O2.ordermonth <= O1.ordermonth
)  AS runqty 
FROM Sales.CustOrders AS O1;