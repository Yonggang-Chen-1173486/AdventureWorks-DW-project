USE AdventureWorksDW;
GO

DELETE FROM FactOrderHeader;
GO

INSERT INTO FactOrderHeader (
    DateKey, CustomerKey, SalesPersonKey, TerritoryKey,
    SalesOrderID,
    TaxAmt, Freight, TotalDue
)
SELECT 
    -- 代理键查找
    CAST(CONVERT(VARCHAR(8), soh.OrderDate, 112) AS INT)  AS DateKey,
    dc.CustomerKey                                        AS CustomerKey,
    dsp.SalesPersonKey                                    AS SalesPersonKey,
    dt.TerritoryKey                                       AS TerritoryKey,
    -- 退化维度
    soh.SalesOrderID,
    -- 度量值
    soh.TaxAmt,
    soh.Freight,
    soh.TotalDue
FROM AdventureWorks2019.Sales.SalesOrderHeader soh
-- 代理键查找（全部用 LEFT JOIN）
LEFT JOIN DimCustomer dc 
    ON dc.CustomerID = soh.CustomerID AND dc.is_current = 1
LEFT JOIN DimSalesPerson dsp 
    ON dsp.SalesPersonID = soh.SalesPersonID AND dsp.is_current = 1
LEFT JOIN DimTerritory dt 
    ON dt.TerritoryID = soh.TerritoryID;
GO