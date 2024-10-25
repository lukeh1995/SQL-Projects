WITH YearlySales AS (
    SELECT 
        YEAR(fs.OrderDate) AS SalesYear, 
        ROUND(SUM(fs.SalesAmount), 2) AS TotalSales
    FROM 
        FactInternetSales fs
    GROUP BY 
        YEAR(fs.OrderDate)
)
SELECT 
    SalesYear, 
    TotalSales,
    ROUND(LAG(TotalSales, 1) OVER (ORDER BY SalesYear), 2) AS PreviousYearSales,
    (TotalSales - LAG(TotalSales, 1) OVER (ORDER BY SalesYear)) / LAG(TotalSales, 1) OVER (ORDER BY SalesYear) * 100 AS YoYGrowth
FROM 
    YearlySales
ORDER BY 
    SalesYear;
