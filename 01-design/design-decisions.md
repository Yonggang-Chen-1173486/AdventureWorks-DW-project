# Design Decisions

## Source System
AdventureWorks2019 OLTP (SQL Server)

## Target
AdventureWorksDW (SQL Server)

## Modelling Approach
Star Schema (Constellation) with two fact tables

## Grain Definition
- **FactSales**: Order line level (121,317 rows)
- **FactOrderHeader**: Order header level (31,465 rows)

## Fact Tables

### FactSales
- **Grain**: One row per order line
- **Measures**: OrderQty, UnitPrice, UnitPriceDiscount, LineTotal
- **Foreign Keys**: DateKey, CustomerKey, ProductKey, SalesPersonKey, TerritoryKey
- **Degenerate Dimensions**: SalesOrderID, SalesOrderDetailID

### FactOrderHeader
- **Grain**: One row per order
- **Measures**: TaxAmt, Freight, TotalDue
- **Foreign Keys**: DateKey, CustomerKey, SalesPersonKey, TerritoryKey
- **Degenerate Dimensions**: SalesOrderID

**Note**: TaxAmt and Freight are order-header-level measures.
They cannot be stored at the line level without allocation logic.
Hence a separate fact table.

## Dimension Tables

| Dimension | Rows | SCD Type | Notes |
|-----------|:---:|:---:|-------|
| DimDate | 1,461 | N/A | Generated, 2011-2014 |
| DimTerritory | 10 | Type 1 | Static |
| DimSalesPerson | 17 | Type 1 | Includes NULL TerritoryID |
| DimProduct | 504 | Type 2 | Snowflake → Star (3 tables merged) |
| DimCustomer | 19,820 | Type 2 | Individual + Store unified |

## Key Design Decisions

### 1. Two Fact Tables (Constellation Schema)
TaxAmt and Freight are order-level, not line-level.
Storing them in a line-level fact would cause double-counting.
Separate fact table keeps both grains clean.

### 2. SCD Type 2 for DimCustomer and DimProduct
Customer addresses and product prices change over time.
Type 2 allows historical analysis.

### 3. Snowflake → Star for DimProduct
Product → Subcategory → Category is a 3-level hierarchy.
Merged into one DimProduct table to avoid multi-table joins at query time.

### 4. Customer Type Handling
635 customers have both PersonID and StoreID (B2B employees).
Classified as Individual (PersonID takes priority) to avoid double-counting.
Final: 19,119 Individual + 701 Store = 19,820.

### 5. NULL Handling
- SalesPersonKey in facts allows NULL (60,398 line items, 27,659 orders)
- This is expected — most orders have no assigned salesperson.

## Validation
- Row counts match OLTP exactly
- LineTotal sums match OLTP
- Annual sales totals match OLTP
- All foreign keys resolved (no unexpected NULLs)