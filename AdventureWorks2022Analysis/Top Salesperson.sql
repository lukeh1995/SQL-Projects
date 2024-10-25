SELECT TOP 5
    e.FirstName + ' ' + e.LastName AS SalesPerson,
    ROUND(SUM(fs.SalesAmount), 2) AS TotalSales
FROM 
    FactResellerSales fs
JOIN 
    DimEmployee e ON fs.EmployeeKey = e.EmployeeKey
GROUP BY 
    e.FirstName, e.LastName
ORDER BY 
    TotalSales DESC;
