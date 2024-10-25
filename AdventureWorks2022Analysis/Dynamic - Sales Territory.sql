DECLARE @Region NVARCHAR(50) = 'Australia';

DECLARE @sql NVARCHAR(MAX);
SET @sql = '
SELECT 
    st.SalesTerritoryRegion, 
    SUM(fs.SalesAmount) AS TotalSales
FROM 
    FactInternetSales fs
JOIN 
    DimSalesTerritory st ON fs.SalesTerritoryKey = st.SalesTerritoryKey
WHERE 
    st.SalesTerritoryRegion IS NOT NULL
    AND UPPER(LTRIM(RTRIM(st.SalesTerritoryRegion))) = UPPER(@Region)
GROUP BY 
    st.SalesTerritoryRegion;';

EXEC sp_executesql 
    @sql, 
    N'@Region NVARCHAR(50)', 
    @Region = @Region;
