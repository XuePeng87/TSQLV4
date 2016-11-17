-- ��ϰ1
-- ��ϰ���ݣ�����ÿ����Ա��orderdate���е����ֵ
-- �漰�ı�Sales.Orders
-- ������У�empid, maxorderdate
-- ��ȷ�����9��
SELECT empid, MAX(orderdate) AS maxorderdate 
FROM Sales.Orders GROUP BY empid;

-- ��ϰ1-2
-- ��ϰ���ݣ���дһ���������Orders��֮������Ӳ�ѯ������ÿ����Ա��󶩵����ڵĶ���
-- �漰�ı�Sales.Orders
-- ������У�empid, maxorderdate
-- ��ȷ�����10��
SELECT O1.empid, O2.maxorderdate, O1.orderid, O1.custid FROM Sales.Orders O1
JOIN 
(SELECT empid, MAX(orderdate) AS maxorderdate FROM Sales.Orders GROUP BY empid) AS O2 
ON O1.empid = O2.empid AND O1.orderdate = O2.maxorderdate;

-- ��ϰ2-1
-- ��ϰ���ݣ���дһ����ѯ�����㰴orderdate��orderid�����ÿ���������к�
-- �漰�ı�Sales.Orders
-- ������У�orderid, orderdate, custid, empid, rownum
-- ��ȷ�����830��
SELECT orderid, orderdate, custid, empid, 
ROW_NUMBER() OVER(ORDER BY orderdate, orderid) AS rownum 
FROM Sales.Orders ORDER BY orderdate, orderid;

-- ��ϰ2-2
-- ��ϰ���ݣ�ʹ��CTE�������к�11��20����
-- �漰�ı�Sales.Orders
-- ������У�orderid, orderdate, custid, empid, rownum
-- ��ȷ�����10��
WITH O AS 
(
	SELECT orderid, orderdate, custid, empid, 
	ROW_NUMBER() OVER(ORDER BY orderdate, orderid) AS rownum 
	FROM Sales.Orders
)
SELECT * FROM O WHERE rownum BETWEEN 11 AND 20
ORDER BY orderdate, orderid;

-- ��ϰ3
-- ��ϰ���ݣ�ʹ��CTE���ݹ鷵���쵼Zoya Dolgopyatova(ID=9)�Ĺ�����
-- �漰�ı�HR.Employees
-- ������У�empid, mgrid, firstname, lastname
-- ��ȷ�����4��
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

-- ��ϰ4-1
-- ��ϰ���ݣ�����һ����ͼ������ÿλ��Աÿ�����������
-- �漰�ı�Sales.Orders, Sales.OrderDetails
-- ������У�empid, orderyear, qty
-- ��ȷ�����27��
IF OBJECT_ID('Sales.VEmpOrders') IS NOT NULL
	DROP VIEW Sales.VEmpOrders
GO
CREATE VIEW Sales.VEmpOrders
AS
SELECT empid, YEAR(orderdate) AS orderyear, SUM(qty) AS qty FROM Sales.Orders O JOIN Sales.OrderDetails D ON O.orderid = D.orderid
GROUP BY empid, YEAR(orderdate);
GO

-- ��ϰ4-2
-- ��ϰ���ݣ���дһ����ѯ������ÿ����Ա��������ǰ�꣨������ǰ�꣩��������
-- �漰�ı�Sales.VEmpOrders
-- ������У�empid, orderyear, qty, runqty
-- ��ȷ�����27��
SELECT empid, orderyear, qty, 
(SELECT SUM(qty) FROM Sales.VEmpOrders V2 WHERE V2.empid = V1.empid AND V2.orderyear <= V1.orderyear) AS runqty 
FROM Sales.VEmpOrders V1

-- ��ϰ5-1
-- ��ϰ���ݣ�����һ����Ƕ���������ܹ�Ӧ��ID��һ�����������������Ӧ��ָ����������ߵĵ��۲�Ʒ
-- �漰�ı�Production.Products
-- ������У�productid, productname, unitprice
-- ��ȷ�����2��
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

-- ��ϰ5-2
-- ��ϰ���ݣ�ʹ��CROSS APPLY�������Ϊÿ����Ӧ�̷����������Ĳ�Ʒ
-- �漰�ı�Production.TopProducts, Production.Suppliers 
-- ������У�supplierid, companyname, productid, productname, unitprice
-- ��ȷ�����55��
SELECT S.supplierid, S.companyname, P.productid, P.productname, P.unitprice
From Production.Suppliers AS S 
CROSS APPLY 
Production.TopProducts(S.supplierid, 2) AS P;