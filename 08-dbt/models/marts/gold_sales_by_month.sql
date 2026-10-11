{{ config(
    materialized='table',
    schema='gold'
) }}

SELECT
    d.Year,
    d.Month,
    d.MonthName,
    SUM(f.LineTotal)                AS total_sales,
    COUNT(DISTINCT f.SalesOrderID)  AS order_count,
    SUM(f.OrderQty)                 AS total_quantity
FROM {{ source('adventureworks', 'FactSales') }} f
INNER JOIN {{ source('adventureworks', 'DimDate') }} d
    ON f.DateKey = d.DateKey
GROUP BY
    d.Year,
    d.Month,
    d.MonthName