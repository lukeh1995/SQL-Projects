SELECT
	YEAR(fs.OrderDate) AS SalesYear,
	ROUND(SUM(fs.SalesAmount), 2) AS TotalSales
FROM
	FactInternetSales fs
GROUP BY
	YEAR(fs.OrderDate)
ORDER BY
	SalesYear;
