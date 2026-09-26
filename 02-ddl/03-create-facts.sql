
CREATE TABLE FactSales (
    SalesKey            INT IDENTITY(1,1) PRIMARY KEY,
    -- 外键
    DateKey             INT             NOT NULL,
    CustomerKey         INT             NOT NULL,
    ProductKey          INT             NOT NULL,
    SalesPersonKey      INT             NULL,
    TerritoryKey        INT             NULL,
    -- 退化维度
    SalesOrderID        INT             NOT NULL,
    SalesOrderDetailID  INT             NOT NULL,
    -- 度量值
    OrderQty            INT             NOT NULL,
    UnitPrice           MONEY           NOT NULL,
    UnitPriceDiscount   MONEY           NOT NULL,
    LineTotal           MONEY           NOT NULL,
    -- 约束
    CONSTRAINT FK_FactSales_DimDate         FOREIGN KEY (DateKey)        REFERENCES DimDate(DateKey),
    CONSTRAINT FK_FactSales_DimCustomer     FOREIGN KEY (CustomerKey)    REFERENCES DimCustomer(CustomerKey),
    CONSTRAINT FK_FactSales_DimProduct      FOREIGN KEY (ProductKey)     REFERENCES DimProduct(ProductKey),
    CONSTRAINT FK_FactSales_DimSalesPerson  FOREIGN KEY (SalesPersonKey) REFERENCES DimSalesPerson(SalesPersonKey),
    CONSTRAINT FK_FactSales_DimTerritory    FOREIGN KEY (TerritoryKey)   REFERENCES DimTerritory(TerritoryKey)
);
GO

CREATE TABLE FactOrderHeader (
    OrderHeaderKey      INT IDENTITY(1,1) PRIMARY KEY,
    -- 外键
    DateKey             INT             NOT NULL,
    CustomerKey         INT             NOT NULL,
    SalesPersonKey      INT             NULL,
    TerritoryKey        INT             NULL,
    -- 退化维度
    SalesOrderID        INT             NOT NULL,
    -- 度量值
    TaxAmt              MONEY           NOT NULL,
    Freight             MONEY           NOT NULL,
    TotalDue            MONEY           NOT NULL,
    -- 约束
    CONSTRAINT FK_FactOrderHeader_DimDate        FOREIGN KEY (DateKey)        REFERENCES DimDate(DateKey),
    CONSTRAINT FK_FactOrderHeader_DimCustomer    FOREIGN KEY (CustomerKey)    REFERENCES DimCustomer(CustomerKey),
    CONSTRAINT FK_FactOrderHeader_DimSalesPerson FOREIGN KEY (SalesPersonKey) REFERENCES DimSalesPerson(SalesPersonKey),
    CONSTRAINT FK_FactOrderHeader_DimTerritory   FOREIGN KEY (TerritoryKey)   REFERENCES DimTerritory(TerritoryKey)
);
GO