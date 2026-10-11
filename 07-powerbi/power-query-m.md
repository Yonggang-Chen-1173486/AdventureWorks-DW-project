# Power Query M Code

All transformations were performed in Power Query, sourcing directly from the AdventureWorks2019 OLTP database.

---

## FactSales

Combines SalesOrderDetail (order line) with FactSalesHeader (order header) via merge on SalesOrderID.

    let
        Source = SalesOrderDetail,
        #"Removed Other Columns" = Table.SelectColumns(Source,{"SalesOrderID", "SalesOrderDetailID", "ProductID", "OrderQty", "UnitPrice", "UnitPriceDiscount", "LineTotal"}),
        #"Changed Type" = Table.TransformColumnTypes(#"Removed Other Columns",{{"OrderQty", Int64.Type}, {"UnitPriceDiscount", type number}, {"UnitPrice", type number}}),
        #"Merged Queries" = Table.NestedJoin(#"Changed Type", {"SalesOrderID"}, FactSalesHeader, {"SalesOrderID"}, "FactSalesHeader", JoinKind.Inner),
        #"Expanded FactSalesHeader" = Table.ExpandTableColumn(#"Merged Queries", "FactSalesHeader", {"OrderDate", "CustomerID", "SalesPersonID", "TerritoryID", "SubTotal", "TaxAmt", "Freight", "TotalDue"}, {"FactSalesHeader.OrderDate", "FactSalesHeader.CustomerID", "FactSalesHeader.SalesPersonID", "FactSalesHeader.TerritoryID", "FactSalesHeader.SubTotal", "FactSalesHeader.TaxAmt", "FactSalesHeader.Freight", "FactSalesHeader.TotalDue"}),
        #"Renamed Columns" = Table.RenameColumns(#"Expanded FactSalesHeader",{{"FactSalesHeader.OrderDate", "OrderDate"}, {"FactSalesHeader.CustomerID", "CustomerID"}, {"FactSalesHeader.SalesPersonID", "SalesPersonID"}, {"FactSalesHeader.TerritoryID", "TerritoryID"}, {"FactSalesHeader.SubTotal", "SubTotal"}, {"FactSalesHeader.TaxAmt", "TaxAmt"}, {"FactSalesHeader.Freight", "Freight"}, {"FactSalesHeader.TotalDue", "TotalDue"}})
    in
        #"Renamed Columns"

---

## DimProduct

Snowflake-to-star flattening. Merges Product with ProductSubcategory and ProductCategory into a single flat table.

    let
        Source = Product,
        #"Removed Other Columns" = Table.SelectColumns(Source,{"ProductID", "Name", "ProductNumber", "ProductSubcategoryID", "ListPrice", "Size", "StandardCost", "Color"}),
        #"Merged Queries" = Table.NestedJoin(#"Removed Other Columns", {"ProductSubcategoryID"}, ProductSubcategory, {"ProductSubcategoryID"}, "Production ProductSubcategory", JoinKind.LeftOuter),
        #"Expanded Production ProductSubcategory" = Table.ExpandTableColumn(#"Merged Queries", "Production ProductSubcategory", {"ProductCategoryID", "Name"}, {"Production ProductSubcategory.ProductCategoryID", "Production ProductSubcategory.Name"}),
        #"Renamed Columns" = Table.RenameColumns(#"Expanded Production ProductSubcategory",{{"Production ProductSubcategory.Name", "Production ProductSubcategory.SubcategoryName"}}),
        #"Merged Queries1" = Table.NestedJoin(#"Renamed Columns", {"Production ProductSubcategory.ProductCategoryID"}, ProductCategory, {"ProductCategoryID"}, "Production ProductCategory", JoinKind.LeftOuter),
        #"Expanded Production ProductCategory" = Table.ExpandTableColumn(#"Merged Queries1", "Production ProductCategory", {"Name"}, {"Production ProductCategory.Name"}),
        #"Renamed Columns1" = Table.RenameColumns(#"Expanded Production ProductCategory",{{"Production ProductCategory.Name", "Production ProductCategory.CategoryName"}}),
        #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns1",{"Production ProductSubcategory.ProductCategoryID"}),
        #"Renamed Columns2" = Table.RenameColumns(#"Removed Columns",{{"Production ProductSubcategory.SubcategoryName", "SubcategoryName"}, {"Production ProductCategory.CategoryName", "CategoryName"}})
    in
        #"Renamed Columns2"

---

## DimCustomer

Merges Customer with Person (for name), SalesTerritory (for territory name), and CountryRegion (for country). Derives CustomerType from PersonID.

    let
        Source = Customer,
        #"Removed Other Columns" = Table.SelectColumns(Source,{"CustomerID", "PersonID", "StoreID", "TerritoryID"}),
        #"Merged Queries" = Table.NestedJoin(#"Removed Other Columns", {"PersonID"}, Person, {"BusinessEntityID"}, "Person Person", JoinKind.LeftOuter),
        #"Expanded Person Person" = Table.ExpandTableColumn(#"Merged Queries", "Person Person", {"FirstName", "LastName"}, {"Person Person.FirstName", "Person Person.LastName"}),
        #"Renamed Columns" = Table.RenameColumns(#"Expanded Person Person",{{"Person Person.FirstName", "FirstName"}, {"Person Person.LastName", "LastName"}}),
        #"Added Custom" = Table.AddColumn(#"Renamed Columns", "CustomerName", each [FirstName] & " " & [LastName]),
        #"Merged Queries1" = Table.NestedJoin(#"Added Custom", {"TerritoryID"}, SalesTerritory, {"TerritoryID"}, "SalesTerritory", JoinKind.LeftOuter),
        #"Expanded SalesTerritory" = Table.ExpandTableColumn(#"Merged Queries1", "SalesTerritory", {"Name", "CountryRegionCode"}, {"Name", "CountryRegionCode"}),
        #"Merged Queries2" = Table.NestedJoin(#"Expanded SalesTerritory", {"CountryRegionCode"}, CountryRegion, {"CountryRegionCode"}, "CountryRegion", JoinKind.LeftOuter),
        #"Expanded CountryRegion" = Table.ExpandTableColumn(#"Merged Queries2", "CountryRegion", {"Name"}, {"Name.1"}),
        #"Renamed Columns1" = Table.RenameColumns(#"Expanded CountryRegion",{{"Name.1", "Country"}, {"Name", "TerritoryName"}}),
        #"Added Custom1" = Table.AddColumn(#"Renamed Columns1", "CustomerType", each if [PersonID] <> null then "Individual" else "Store"),
        #"Removed Columns" = Table.RemoveColumns(#"Added Custom1",{"PersonID", "StoreID", "TerritoryID", "CountryRegionCode"})
    in
        #"Removed Columns"

---

## DimDate

Generated in Power Query. Covers 2011-01-01 to 2014-12-31.

    let
        StartDate = #date(2011, 1, 1),
        EndDate = #date(2014, 12, 31),
        DayCount = Duration.Days(EndDate - StartDate) + 1,
        DateList = List.Dates(StartDate, DayCount, #duration(1, 0, 0, 0)),
        DateTable = Table.FromList(DateList, Splitter.SplitByNothing(), {"FullDate"}),
        ChangedType = Table.TransformColumnTypes(DateTable, {{"FullDate", type date}}),
        AddYear = Table.AddColumn(ChangedType, "Year", each Date.Year([FullDate]), Int64.Type),
        AddQuarter = Table.AddColumn(AddYear, "Quarter", each Date.QuarterOfYear([FullDate]), Int64.Type),
        AddMonth = Table.AddColumn(AddQuarter, "Month", each Date.Month([FullDate]), Int64.Type),
        AddMonthName = Table.AddColumn(AddMonth, "MonthName", each Date.ToText([FullDate], "MMMM"), type text),
        AddDay = Table.AddColumn(AddMonthName, "Day", each Date.Day([FullDate]), Int64.Type),
        AddDayName = Table.AddColumn(AddDay, "DayName", each Date.ToText([FullDate], "dddd"), type text)
    in
        AddDayName

---

## Notes

| Technique | Where used |
|-----------|-----------|
| Reference queries | All source tables kept intact; cleaned versions built separately |
| Nested join and expand | Used to combine tables without writing custom SQL |
| Left outer joins | Used for dimensions where some rows have no match (e.g. products with no subcategory) |
| Custom columns | Derived CustomerName and CustomerType |
| Generated table | DimDate built entirely in M |