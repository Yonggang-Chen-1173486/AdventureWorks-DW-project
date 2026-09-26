USE AdventureWorksDW;
GO

-- 用 DELETE 代替 TRUNCATE
DELETE FROM DimDate;
GO

DECLARE @StartDate DATE = '2011-01-01';
DECLARE @EndDate   DATE = '2014-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO DimDate (
        DateKey, FullDate, Year, Quarter, Month, MonthName,
        Week, DayOfMonth, DayOfWeek, DayName, IsWeekend
    )
    VALUES (
        CAST(CONVERT(VARCHAR(8), @StartDate, 112) AS INT),
        @StartDate,
        YEAR(@StartDate),
        DATEPART(QUARTER, @StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DATEPART(WEEK, @StartDate),
        DAY(@StartDate),
        DATEPART(WEEKDAY, @StartDate),
        DATENAME(WEEKDAY, @StartDate),
        CASE WHEN DATEPART(WEEKDAY, @StartDate) IN (1, 7) THEN 1 ELSE 0 END
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO

-- 验证
SELECT COUNT(*) AS TotalDays, MIN(FullDate) AS FirstDate, MAX(FullDate) AS LastDate
FROM DimDate;
GO