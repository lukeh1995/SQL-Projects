WITH MonthlySales AS (
    SELECT 
        pc.EnglishProductCategoryName, 
        MONTH(fs.OrderDate) AS SalesMonth, 
        ROUND(SUM(fs.SalesAmount), 2) AS TotalSales
    FROM 
        FactInternetSales fs
    JOIN 
        DimProduct p ON fs.ProductKey = p.ProductKey
    JOIN 
        DimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
    JOIN 
        DimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
    GROUP BY 
        pc.EnglishProductCategoryName, MONTH(fs.OrderDate)
)
SELECT 
    EnglishProductCategoryName, 
    [1] AS January, 
    [2] AS February, 
    [3] AS March, 
    [4] AS April, 
    [5] AS May, 
    [6] AS June, 
    [7] AS July, 
    [8] AS August, 
    [9] AS September, 
    [10] AS October, 
    [11] AS November, 
    [12] AS December
FROM 
    MonthlySales
PIVOT (
    SUM(TotalSales) 
    FOR SalesMonth IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) AS MonthlySalesPivot;
