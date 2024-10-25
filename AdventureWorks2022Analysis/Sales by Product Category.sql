SELECT 
    pc.ProductCategoryKey, 
    pc.EnglishProductCategoryName, 
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
    pc.ProductCategoryKey, pc.EnglishProductCategoryName
ORDER BY 
    TotalSales DESC;
