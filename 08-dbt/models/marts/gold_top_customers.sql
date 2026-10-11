{{ config(
    materialized='table',
    schema='gold'
) }}

SELECT
    c.CustomerID,
    c.CustomerName,
    c.Country,
    c.CustomerType,
    SUM(f.LineTotal)                AS total_sales,
    COUNT(DISTINCT f.SalesOrderID)  AS order_count,
    RANK() OVER (ORDER BY SUM(f.LineTotal) DESC) AS sales_rank
FROM {{ source('adventureworks', 'FactSales') }} f
INNER JOIN {{ source('adventureworks', 'DimCustomer') }} c
    ON f.CustomerKey = c.CustomerKey
GROUP BY
    c.CustomerID,
    c.CustomerName,
    c.Country,
    c.CustomerType