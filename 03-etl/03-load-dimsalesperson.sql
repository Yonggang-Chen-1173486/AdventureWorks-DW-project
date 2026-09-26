USE AdventureWorksDW;
GO

DELETE FROM DimSalesPerson;
GO

INSERT INTO DimSalesPerson (
    SalesPersonID,
    SalesPersonName,
    TerritoryID,
    valid_from,
    valid_to,
    is_current
)
SELECT 
    sp.BusinessEntityID,
    p.FirstName + ' ' + p.LastName,
    sp.TerritoryID,
    GETDATE(),           -- 当前时间作为生效时间
    '9999-12-31',        -- 表示当前记录永不过期
    1                    -- 当前版本标记为 1
FROM AdventureWorks2019.Sales.SalesPerson sp
JOIN AdventureWorks2019.Person.Person p 
    ON sp.BusinessEntityID = p.BusinessEntityID;
GO

-- 验证
SELECT 
    SalesPersonKey,
    SalesPersonID,
    SalesPersonName,
    TerritoryID,
    is_current
FROM DimSalesPerson
ORDER BY SalesPersonID;
GO