USE AdventureWorksDW;
GO

INSERT INTO FactSales (
    DateKey, CustomerKey, ProductKey, SalesPersonKey, TerritoryKey,
    SalesOrderID, SalesOrderDetailID,
    OrderQty, UnitPrice, UnitPriceDiscount, LineTotal
)
SELECT 
    -- 代理键查找
    CAST(CONVERT(VARCHAR(8), soh.OrderDate, 112) AS INT)  AS DateKey,
    dc.CustomerKey                                        AS CustomerKey,
    dp.ProductKey                                         AS ProductKey,
    dsp.SalesPersonKey                                    AS SalesPersonKey,
    dt.TerritoryKey                                       AS TerritoryKey,
    -- 退化维度
    sod.SalesOrderID,
    sod.SalesOrderDetailID,
    -- 度量值
    sod.OrderQty,
    sod.UnitPrice,
    sod.UnitPriceDiscount,
    sod.LineTotal
FROM AdventureWorks2019.Sales.SalesOrderDetail sod
JOIN AdventureWorks2019.Sales.SalesOrderHeader soh 
    ON sod.SalesOrderID = soh.SalesOrderID
-- 代理键查找（全部用 LEFT JOIN，避免丢失事实行）
LEFT JOIN DimDate dc_date 
    ON dc_date.DateKey = CAST(CONVERT(VARCHAR(8), soh.OrderDate, 112) AS INT)
LEFT JOIN DimCustomer dc 
    ON dc.CustomerID = soh.CustomerID AND dc.is_current = 1
LEFT JOIN DimProduct dp 
    ON dp.ProductID = sod.ProductID AND dp.is_current = 1
LEFT JOIN DimSalesPerson dsp 
    ON dsp.SalesPersonID = soh.SalesPersonID AND dsp.is_current = 1
LEFT JOIN DimTerritory dt 
    ON dt.TerritoryID = soh.TerritoryID;
GO