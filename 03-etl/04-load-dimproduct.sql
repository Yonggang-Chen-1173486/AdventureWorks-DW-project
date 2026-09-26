USE AdventureWorksDW;
GO

DELETE FROM DimProduct;
GO

INSERT INTO DimProduct (
    ProductID,
    ProductName,
    ProductNumber,
    SubcategoryName,
    CategoryName,
    ListPrice,
    StandardCost,
    Color,
    Size,
    valid_from,
    valid_to,
    is_current
)
SELECT 
    p.ProductID,
    p.Name,
    p.ProductNumber,
    ps.Name,                -- 可能为 NULL
    pc.Name,                -- 可能为 NULL
    p.ListPrice,
    p.StandardCost,
    p.Color,                -- 可能为 NULL
    p.Size,                 -- 可能为 NULL
    GETDATE(),
    '9999-12-31',
    1
FROM AdventureWorks2019.Production.Product p
LEFT JOIN AdventureWorks2019.Production.ProductSubcategory ps 
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN AdventureWorks2019.Production.ProductCategory pc 
    ON ps.ProductCategoryID = pc.ProductCategoryID;
GO

-- 验证总行数
SELECT COUNT(*) AS TotalProducts FROM DimProduct;
-- 期望：504

-- 验证类别分布
SELECT 
    ISNULL(CategoryName, '(No Category)') AS CategoryName,
    COUNT(*) AS ProductCount
FROM DimProduct
GROUP BY CategoryName
ORDER BY ProductCount DESC;
GO