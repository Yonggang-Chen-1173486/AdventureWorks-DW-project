USE AdventureWorks2019;
GO

SELECT 
    COUNT(*) AS TotalRows,
    COUNT(PersonID) AS PersonIDCount,
    COUNT(StoreID) AS StoreIDCount,
    SUM(CASE WHEN PersonID IS NOT NULL AND StoreID IS NOT NULL THEN 1 ELSE 0 END) AS BothPresent,
    SUM(CASE WHEN PersonID IS NULL AND StoreID IS NULL THEN 1 ELSE 0 END) AS BothNull
FROM Sales.Customer;

/*这个查询会告诉我们：

总行数

PersonID 非空的行数

StoreID 非空的行数

同时有 PersonID 和 StoreID 的行数（这就是问题所在！）

两个都为空的行数


指标	值	含义
总行数	19,820	全部客户
PersonID 非空	19,119	有个人信息的客户
StoreID 非空	1,336	有商店信息的客户
两者都非空	635	❗ 同时关联个人和商店的客户
两者都为空	0	没有异常行


正确做法： 按 PersonID 优先归类。所以：

Individual = 19,119（包括那 635 个）

Store = 701（纯商店）
*/

-- 总行数（应 = 19,820）
SELECT COUNT(*) AS Total FROM DimCustomer;

-- 按类型（应 = 19,119 / 701）
SELECT CustomerType, COUNT(*) AS Cnt 
FROM DimCustomer 
GROUP BY CustomerType;

-- 检查是否还有重复 CustomerID
SELECT CustomerID, COUNT(*) AS Cnt 
FROM DimCustomer 
GROUP BY CustomerID 
HAVING COUNT(*) > 1;
-- 应返回空