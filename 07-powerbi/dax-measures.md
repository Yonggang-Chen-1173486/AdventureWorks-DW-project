# DAX Measures

All measures are stored in the `_Measures` table for organisation.

---

## Basic Measures

### Total Sales

    Total Sales = SUM(FactSales[LineTotal])

Total revenue from all order lines.

---

### Total Orders

    Total Orders = DISTINCTCOUNT(FactSales[SalesOrderID])

Count of unique orders (order lines are aggregated to order level).

---

### Total Customers

    Total Customers = DISTINCTCOUNT(FactSales[CustomerID])

Count of unique customers who placed at least one order.

---

### Avg Order Value

    Avg Order Value = DIVIDE([Total Sales], [Total Orders])

Average revenue per order. Uses DIVIDE to handle division by zero safely.

---

## Time Intelligence Measures

### Sales LY

    Sales LY =
    CALCULATE(
        [Total Sales],
        SAMEPERIODLASTYEAR(DimDate[FullDate])
    )

Total Sales for the same period in the previous year. Requires DimDate to be marked as a date table.

---

### YoY Growth %

    YoY Growth % =
    DIVIDE(
        [Total Sales] - [Sales LY],
        [Sales LY]
    )

Year-over-year growth rate. Returns blank when there is no prior-year data.

---

### Sales YTD

    Sales YTD =
    TOTALYTD(
        [Total Sales],
        DimDate[FullDate]
    )

Year-to-date cumulative sales.

---

### Sales MTD

    Sales MTD =
    TOTALMTD(
        [Total Sales],
        DimDate[FullDate]
    )

Month-to-date cumulative sales.

---

## Ranking Measures

### Product Rank

    Product Rank =
    RANKX(
        ALL(DimProduct[Name]),
        [Total Sales],
        ,
        DESC
    )

Ranks products by Total Sales, descending. ALL removes filter context so the ranking is across all products.

---

### Customer Rank

    Customer Rank =
    RANKX(
        ALL(DimCustomer[CustomerName]),
        [Total Sales],
        ,
        DESC
    )

Ranks customers by Total Sales, descending.

---

## Ratio Measures

### Sales % of Total

    Sales % of Total =
    DIVIDE(
        [Total Sales],
        CALCULATE([Total Sales], ALL(FactSales))
    )

Each row's contribution to the overall total. ALL(FactSales) removes all filters so the denominator is the grand total.

---

## Function Reference

| Function | Purpose |
|----------|---------|
| CALCULATE | Modifies filter context |
| DIVIDE | Safe division (handles zero and blank) |
| SAMEPERIODLASTYEAR | Shifts date context back one year |
| TOTALYTD / TOTALMTD | Cumulative totals from start of year or month |
| RANKX | Ranks items in a table by an expression |
| ALL | Removes filters from a table or column |