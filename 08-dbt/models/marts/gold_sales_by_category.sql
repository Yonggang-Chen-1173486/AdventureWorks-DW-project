{{ config(
    materialized='table',
    schema='gold'
) }}

SELECT
    p.CategoryName,
    p.SubcategoryName,
    SUM(f.LineTotal)        AS total_sales,
    COUNT(DISTINCT f.SalesOrderID) AS order_count,
    SUM(f.OrderQty)         AS total_quantity
FROM {{ source('adventureworks', 'FactSales') }} f
LEFT JOIN {{ source('adventureworks', 'DimProduct') }} p
    ON f.ProductKey = p.ProductKey
GROUP BY
    p.CategoryName,
    p.SubcategoryName