CREATE PROCEDURE dbo.sp_SalesByRegion2022
    @Region NVARCHAR(50)
AS
BEGIN
    SELECT 
        st.SalesTerritoryRegion AS Region,
        SUM(fs.SalesAmount) AS TotalSales
    FROM 
        FactInternetSales fs
    JOIN 
        DimSalesTerritory st ON fs.SalesTerritoryKey = st.SalesTerritoryKey
    WHERE 
        st.SalesTerritoryRegion = @Region
    GROUP BY 
        st.SalesTerritoryRegion;
END;