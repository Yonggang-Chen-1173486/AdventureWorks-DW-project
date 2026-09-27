# AdventureWorks Data Warehouse Project

An end-to-end data warehouse project built on AdventureWorks OLTP, 
covering design, ETL, star schema modelling, and cloud migration.

## Project Scope

- **Source**: AdventureWorks2019 OLTP (SQL Server)
- **Target**: AdventureWorksDW (SQL Server → Azure)
- **Modelling**: Star Schema with two fact tables (Constellation Schema)
- **SCD Strategy**: Type 2 for DimCustomer and DimProduct

## Repository Structure

| Folder | Purpose |
|--------|---------|
| `01-design/` | ERD, design decisions, grain definitions |
| `02-ddl/` | CREATE TABLE scripts for all DW objects |
| `03-etl/` | T-SQL scripts for loading dimensions and facts |
| `04-azure/` | ADF pipelines and Databricks PySpark notebooks |
| `05-validation/` | Reconciliation and data quality queries |
| `06-docs/` | Data dictionary and lessons learned |

## Design Summary

- **FactSales** (grain: order line) — measures: OrderQty, UnitPrice, LineTotal
- **FactOrderHeader** (grain: order) — measures: TaxAmt, Freight, TotalDue
- **Dimensions**: DimDate, DimCustomer, DimProduct, DimSalesPerson, DimTerritory

## Key Design Decisions

- **Two fact tables (Constellation Schema)**: TaxAmt and Freight are order-level, 
  not line-level. Storing them in a line-level fact would cause double-counting.
- **SCD Type 2 for DimCustomer and DimProduct**: Customer addresses and product 
  prices change over time; Type 2 allows historical analysis.
- **Snowflake → Star for DimProduct**: Product → Subcategory → Category (3 levels) 
  merged into one table to avoid multi-table joins at query time.
- **Customer Type Handling**: 635 customers have both PersonID and StoreID (B2B 
  employees). Classified as Individual to avoid double-counting.
  Final: 19,119 Individual + 701 Store = 19,820.

For full details, see [06-docs/design-decisions.md](06-docs/design-decisions.md).

## Status

- [x] OLTP data exploration
- [x] Star schema design
- [x] DDL for all tables
- [x] Dimension loading (5 dimensions)
- [x] Fact loading (2 fact tables)
- [x] Data validation (reconciliation passed)
- [x] Azure migration - Stage 4.1 (DimDate)
- [ ] Power BI report

## Author

Yonggang Chen (Eddie)  
GitHub: [@Yonggang-Chen-1173486](https://github.com/Yonggang-Chen-1173486)