USE AdventureWorksDW;
GO

-- 清空已有数据（因为 Fact 表还是空的，DELETE 不会冲突）
DELETE FROM DimTerritory;
GO

INSERT INTO DimTerritory (
    TerritoryID,
    TerritoryName,
    CountryRegionCode,
    GroupName
)
SELECT 
    TerritoryID,
    Name,
    CountryRegionCode,
    [Group]
FROM AdventureWorks2019.Sales.SalesTerritory;
GO

-- 验证
SELECT 
    TerritoryKey,
    TerritoryID,
    TerritoryName,
    CountryRegionCode,
    GroupName
FROM DimTerritory
ORDER BY TerritoryID;
GO  