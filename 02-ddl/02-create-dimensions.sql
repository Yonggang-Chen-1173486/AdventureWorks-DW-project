CREATE TABLE DimDate (
    DateKey         INT             NOT NULL PRIMARY KEY,  -- 格式：YYYYMMDD
    FullDate        DATE            NOT NULL,
    Year            INT             NOT NULL,
    Quarter         INT             NOT NULL,
    Month           INT             NOT NULL,
    MonthName       NVARCHAR(20)    NOT NULL,
    Week            INT             NOT NULL,
    DayOfMonth      INT             NOT NULL,
    DayOfWeek       INT             NOT NULL,
    DayName         NVARCHAR(20)    NOT NULL,
    IsWeekend       BIT             NOT NULL
);
GO

CREATE TABLE DimProduct (
    ProductKey          INT IDENTITY(1,1) PRIMARY KEY,  -- 代理键
    ProductID           INT             NOT NULL,        -- 业务键
    ProductName         NVARCHAR(100)   NOT NULL,
    ProductNumber       NVARCHAR(50)    NOT NULL,
    SubcategoryName     NVARCHAR(50)    NULL,
    CategoryName        NVARCHAR(50)    NULL,
    ListPrice           MONEY           NOT NULL,
    StandardCost        MONEY           NOT NULL,
    Color               NVARCHAR(20)    NULL,
    Size                NVARCHAR(10)    NULL,
    -- SCD Type 2 审计字段
    valid_from          DATETIME        NOT NULL,
    valid_to            DATETIME        NOT NULL,
    is_current          BIT             NOT NULL
);
GO

CREATE TABLE DimCustomer (
    CustomerKey     INT IDENTITY(1,1) PRIMARY KEY,  -- 代理键
    CustomerID      INT             NOT NULL,        -- 业务键
    CustomerType    NVARCHAR(20)    NOT NULL,        -- 'Individual' 或 'Store'
    CustomerName    NVARCHAR(100)   NULL,
    City            NVARCHAR(50)    NULL,
    StateProvince   NVARCHAR(50)    NULL,
    Country         NVARCHAR(50)    NULL,
    -- SCD Type 2 审计字段
    valid_from      DATETIME        NOT NULL,
    valid_to        DATETIME        NOT NULL,
    is_current      BIT             NOT NULL
);
GO

CREATE TABLE DimSalesPerson (
    SalesPersonKey  INT IDENTITY(1,1) PRIMARY KEY,
    SalesPersonID   INT             NOT NULL,
    SalesPersonName NVARCHAR(100)   NULL,
    TerritoryID     INT             NULL,
    valid_from      DATETIME        NOT NULL,
    valid_to        DATETIME        NOT NULL,
    is_current      BIT             NOT NULL
);
GO

CREATE TABLE DimTerritory (
    TerritoryKey        INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID         INT             NOT NULL,
    TerritoryName       NVARCHAR(50)    NOT NULL,
    CountryRegionCode   NVARCHAR(10)    NOT NULL,
    GroupName           NVARCHAR(50)    NULL
);
GO
