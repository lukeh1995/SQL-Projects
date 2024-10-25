WITH SalesByProduct AS (
    SELECT
        p.ProductKey,
        pc.EnglishProductCategoryName,
        ps.EnglishProductSubcategoryName,
        p.EnglishProductName,
        SUM(fs.SalesAmount) AS TotalSales
    FROM
        FactInternetSales fs
    JOIN
        DimProduct p ON fs.ProductKey = p.ProductKey
    JOIN
        DimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
    JOIN
        DimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
    GROUP BY
        p.ProductKey, p.EnglishProductName, ps.EnglishProductSubcategoryName, pc.EnglishProductCategoryName
)
SELECT 
    EnglishProductCategoryName,
    EnglishProductSubcategoryName,
    EnglishProductName,
    TotalSales,
    RANK() OVER (PARTITION BY EnglishProductCategoryName ORDER BY TotalSales DESC) AS ProductRank
FROM 
    SalesByProduct
ORDER BY 
    EnglishProductCategoryName, ProductRank;
