# AdventureWorks Data Warehouse Project

An end-to-end data warehouse project built on AdventureWorks OLTP, covering design, ETL, star schema modelling, cloud migration, and Power BI reporting.

---

## Project Scope

- **Source**: AdventureWorks2019 OLTP (SQL Server)
- **Target**: AdventureWorksDW (SQL Server) + Azure Data Lake Storage Gen2
- **Modelling**: Star Schema (Constellation) with two fact tables
- **SCD Strategy**: Type 2 for DimCustomer and DimProduct
- **Architecture**: Medallion (Bronze, Silver, Gold)
- **Reporting**: Power BI with DAX, drill-down, and Row-Level Security

---

## Repository Structure

| Folder | Purpose |
|--------|---------|
| `01-design/` | ERD, design decisions, grain definitions |
| `02-ddl/` | CREATE TABLE scripts for all DW objects |
| `03-etl/` | T-SQL scripts for loading dimensions and facts |
| `04-azure/` | ADF pipelines and Databricks PySpark notebooks |
| `05-validation/` | Reconciliation and data quality queries |
| `06-docs/` | Data dictionary and lessons learned |
| `07-powerbi/` | Power BI report — semantic model, DAX measures, RLS, drill-down |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Source | SQL Server 2019 (AdventureWorks2019 OLTP) |
| Orchestration | Azure Data Factory (with Self-Hosted Integration Runtime) |
| Storage | Azure Data Lake Storage Gen2 (raw, curated, gold, logs) |
| Compute | Azure Databricks (Serverless, PySpark) |
| Storage Format | Parquet (raw) + Delta Lake (curated + gold) |
| Governance | Unity Catalog (Storage Credential + External Location) |
| Local DW | SQL Server (AdventureWorksDW) |
| Modelling | Star Schema (Constellation), SCD Type 2 |
| Reporting | Power BI (Power Query, DAX, RLS, drill-down) |

---

## Design Summary

- **FactSales** (grain: order line) — measures: OrderQty, UnitPrice, LineTotal
- **FactOrderHeader** (grain: order) — measures: TaxAmt, Freight, TotalDue
- **Dimensions**: DimDate, DimCustomer, DimProduct, DimSalesPerson, DimTerritory

For full details, see [01-design/](01-design/) and [06-docs/](06-docs/).

---

## Architecture Overview

The project follows a Medallion Architecture:

| Layer | Location | Format | Purpose |
|-------|----------|--------|---------|
| Bronze | ADLS `raw/` | Parquet | Raw data extracted by ADF from on-premises SQL Server |
| Silver | ADLS `curated/` | Delta Lake | Cleaned, joined, modelled dimensions and facts |
| Gold | ADLS `gold/` | Delta Lake | Aggregated business metrics for reporting and AI |

See [04-azure/](04-azure/) for ADF pipelines and Databricks notebooks.

---

## Key Achievements

- Designed and built a star schema (constellation) with 2 fact tables and 5 dimensions from AdventureWorks OLTP (60+ tables, 121K+ order lines), including SCD Type 2 for DimCustomer and DimProduct.
- Migrated the full ETL pipeline to Azure: ADF extracts 14 source tables to ADLS (raw zone); Databricks (PySpark) transforms into Delta Lake (curated and gold zones), applying multi-table joins, surrogate key lookups, and snowflake-to-star flattening.
- Implemented a complete Medallion Architecture (Bronze, Silver, Gold) with 4 aggregated Gold tables: SalesByMonth, SalesByCategory, TopCustomers, and TerritoryPerformance.
- Implemented SCD Type 2 using Delta Lake MERGE INTO, with valid_from / valid_to / is_current tracking; achieved 100% reconciliation of row counts and totals against the OLTP source.
- Configured Unity Catalog with Managed Identity for secure ADLS access, and set up a Self-Hosted Integration Runtime for on-premises SQL Server connectivity.
- Built an end-to-end Power BI report sourcing directly from OLTP — covering Power Query cleaning, star schema modelling, 11 DAX measures (time intelligence, ranking, ratio), date hierarchy drill-down, and Row-Level Security.

---

## Status

- [x] OLTP data exploration
- [x] Star schema design (Constellation with 2 fact tables)
- [x] DDL for all tables
- [x] Dimension loading (local SQL Server)
- [x] Fact loading (local SQL Server)
- [x] Data validation (reconciliation passed)
- [x] Azure migration (ADLS + ADF + Databricks)
- [x] PySpark transformations (Delta Lake, SCD Type 2)
- [x] Advanced PySpark (window functions, MERGE INTO, broadcast joins)
- [x] Gold layer (4 aggregated tables)
- [x] Complete Medallion Architecture (Bronze, Silver, Gold)
- [x] ADF Git integration
- [x] Power BI report (Power Query, DAX, RLS, drill-down)

---

## Author

Yonggang Chen (Eddie)
eddiechannz@gmail.com

GitHub: https://github.com/Yonggang-Chen-1173486