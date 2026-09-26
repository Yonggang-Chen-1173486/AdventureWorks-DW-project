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

## Status

- [x] OLTP data exploration
- [x] Star schema design
- [x] DDL for all tables
- [ ] Dimension loading
- [ ] Fact loading
- [ ] Data validation
- [ ] Azure migration
- [ ] Power BI report

## Author

Yonggang Chen (Eddie)  
GitHub: [@Yonggang-Chen-1173486](https://github.com/Yonggang-Chen-1173486)