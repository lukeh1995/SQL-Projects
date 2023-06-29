--Initial inspection of dataset
SELECT *
FROM [Luke Test DB].[dbo].[HousingData];

--Update SaleDate to type 'date'
ALTER TABLE HousingData
Add SaleDateConverted Date;

UPDATE HousingData
SET SaleDateConverted = CONVERT(date, SaleDate)

select SaleDateConverted 
FROM HousingData;

--Populate Property Address data based on equivalent ParcelID's using a SELF JOIN
SELECT * 
FROM HousingData
WHERE PropertyAddress is null
ORDER BY ParcelID;

--Use SELF JOIN to update NULL values in PropertyAddress column
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM HousingData a
JOIN HousingData b
ON a.ParcelID = b.ParcelID
AND a.[uniqueID] <> b.[uniqueID]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingData a
JOIN HousingData b
ON a.ParcelID = b.ParcelID
AND a.[uniqueID] <> b.[uniqueID]
WHERE a.PropertyAddress IS NULL;

--Approach 1: Seperate Address into Individual columns (Address, city, state) using SUBSTRINGS
SELECT PropertyAddress
FROM HousingData;

--Use -1 to remove comma from Position 1
SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM HousingData;

--Must require two new columns to seperate address based on above
ALTER TABLE HousingData
ADD PropertySplitAddress Nvarchar(255);
UPDATE HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE HousingData
ADD PropertySplitCity Nvarchar(255);
UPDATE HousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));

--Inspect to confirm output
SELECT PropertySplitAddress, PropertySplitCity
FROM HousingData;

--Approach 2: Using PARSENAME (Requires '.' periods, must change)

ALTER TABLE HousingData
ADD OwnerSplitAddress Nvarchar(255);
UPDATE HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3); 
ALTER TABLE HousingData
ADD OwnerSplitCity Nvarchar(255);
UPDATE HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);
ALTER TABLE HousingData
ADD OwnerSplitState Nvarchar(255);
UPDATE HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1); 


SELECT OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
FROM HousingData;

--Update values in SoldAsVacant field (incorrect/inconsistent values) using CASE
SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM HousingData
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM HousingData;

Update HousingData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END;

--Confirm update 
SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM HousingData
GROUP BY SoldAsVacant
ORDER BY 2;

--Remove Duplicate Entries
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) row_num
FROM HousingData
)
DELETE
FROM RowNumCTE
WHERE row_num > 1;

--Delete Unused Columns
ALTER TABLE HousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;
