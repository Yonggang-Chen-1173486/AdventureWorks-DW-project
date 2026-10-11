{{ config(
    materialized='table',
    schema='gold'
) }}

SELECT
    t.TerritoryName,
    t.CountryRegionCode,
    t.GroupName,
    SUM(f.LineTotal)                AS total_sales,
    COUNT(DISTINCT f.SalesOrderID)  AS order_count,
    SUM(f.OrderQty)                 AS total_quantity
FROM {{ source('adventureworks', 'FactSales') }} f
INNER JOIN {{ source('adventureworks', 'DimTerritory') }} t
    ON f.TerritoryKey = t.TerritoryKey
GROUP BY
    t.TerritoryName,
    t.CountryRegionCode,
    t.GroupName
ORDER BY total_sales DESC