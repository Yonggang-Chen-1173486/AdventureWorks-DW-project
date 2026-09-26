USE AdventureWorksDW;
GO

-- 清空
DELETE FROM DimCustomer;
GO

-- ============================================
-- Part 1: 个人客户 (Individual)
-- 条件：PersonID IS NOT NULL（包括同时关联商店的 635 个客户）
-- ============================================
INSERT INTO DimCustomer (
    CustomerID, CustomerType, CustomerName,
    City, StateProvince, Country,
    valid_from, valid_to, is_current
)
SELECT 
    c.CustomerID,
    'Individual',
    p.FirstName + ' ' + p.LastName,
    a.City,
    sp.Name,
    cr.Name,
    GETDATE(),
    '9999-12-31',
    1
FROM AdventureWorks2019.Sales.Customer c
JOIN AdventureWorks2019.Person.Person p 
    ON c.PersonID = p.BusinessEntityID
LEFT JOIN AdventureWorks2019.Person.BusinessEntityAddress bea 
    ON c.PersonID = bea.BusinessEntityID
LEFT JOIN AdventureWorks2019.Person.AddressType at 
    ON bea.AddressTypeID = at.AddressTypeID 
    AND at.Name = 'Home'
LEFT JOIN AdventureWorks2019.Person.Address a 
    ON bea.AddressID = a.AddressID
LEFT JOIN AdventureWorks2019.Person.StateProvince sp 
    ON a.StateProvinceID = sp.StateProvinceID
LEFT JOIN AdventureWorks2019.Person.CountryRegion cr 
    ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE c.PersonID IS NOT NULL
  AND (at.Name = 'Home' OR bea.BusinessEntityID IS NULL);
GO

-- ============================================
-- Part 2: 商店客户 (Store)
-- 条件：PersonID IS NULL AND StoreID IS NOT NULL（纯商店客户，701 家）
-- ============================================
INSERT INTO DimCustomer (
    CustomerID, CustomerType, CustomerName,
    City, StateProvince, Country,
    valid_from, valid_to, is_current
)
SELECT 
    c.CustomerID,
    'Store',
    s.Name,
    a.City,
    sp.Name,
    cr.Name,
    GETDATE(),
    '9999-12-31',
    1
FROM AdventureWorks2019.Sales.Customer c
JOIN AdventureWorks2019.Sales.Store s 
    ON c.StoreID = s.BusinessEntityID
LEFT JOIN AdventureWorks2019.Person.BusinessEntityAddress bea 
    ON c.StoreID = bea.BusinessEntityID
LEFT JOIN AdventureWorks2019.Person.AddressType at 
    ON bea.AddressTypeID = at.AddressTypeID 
    AND at.Name = 'Main Office'
LEFT JOIN AdventureWorks2019.Person.Address a 
    ON bea.AddressID = a.AddressID
LEFT JOIN AdventureWorks2019.Person.StateProvince sp 
    ON a.StateProvinceID = sp.StateProvinceID
LEFT JOIN AdventureWorks2019.Person.CountryRegion cr 
    ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE c.PersonID IS NULL
  AND c.StoreID IS NOT NULL
  AND (at.Name = 'Main Office' OR bea.BusinessEntityID IS NULL);
GO