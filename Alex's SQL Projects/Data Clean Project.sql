

/*
		Show all data 
*/

	SELECT
	*
	FROM NashVilleHousing


/*
	 Standardize the Date format

*/

	ALTER TABLE NashVilleHousing
	ADD  Sale_Date date;


	UPDATE NashVilleHousing
	SET Sale_Date = FORMAT(SaleDate, 'yyyy-MM-d')

	--Another way--

	UPDATE NashVilleHousing
	SET Sale_Date = CONVERT(DATE,SaleDate)

	

/*
	Populated the Property Address

*/

	
	UPDATE a
	SET a.PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
	FROM NashVilleHousing a
		JOIN NashVilleHousing b
		ON a.ParcelID = b.ParcelID
		AND a.UniqueID <> b.UniqueID
	WHERE
		a.PropertyAddress IS NULL


	/*
	SELECT
		a.ParcelID, a.PropertyAddress,
		b.ParcelID , b.PropertyAddress,
		ISNULL (a.PropertyAddress, b.PropertyAddress)
	FROM NashVilleHousing a
		JOIN NashVilleHousing b
		ON a.ParcelID = b.ParcelID
		AND a.UniqueID <> b.UniqueID
	    WHERE a.PropertyAddress IS NULL
		*/


/*
	Separate the Property Address into the Individual columns (Address, City, State)
*/

	
	ALTER TABLE NashVilleHousing
	ADD Property_Address nvarchar (100)


	UPDATE NashVilleHousing
	SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)
					      --LEFT(PropertyAddress,CHARINDEX(',',PropertyAddress)-1)
	--another way--

	



	ALTER TABLE NashVilleHousing
	ADD Property_City nvarchar (100)
	

	UPDATE NashVilleHousing
	SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))



	
	/*

	Select
	PropertyAddress,
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
	--SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress) - CHARINDEX(',', PropertyAddress)) AS City
	FROM NashVilleHousing

	*/

	/*

	SELECT
		PropertyAddress,
		LEFT(PropertyAddress,CHARINDEX(',',PropertyAddress)-1)
	FROM NashVilleHousing

	*/
-----------------------------------------------------------
/*
	SELECT 

		PARSENAME(REPLACE( OwnerAddress,',','.'),3),
		PARSENAME(REPLACE( OwnerAddress,',','.'),2),
		PARSENAME(REPLACE( OwnerAddress,',','.'),1)
	FROM NashVilleHousing

*/


		
	ALTER TABLE NashVilleHousing
	ADD Owner_Address nvarchar (50)


	UPDATE NashVilleHousing
	SET Owner_Address = PARSENAME(REPLACE( OwnerAddress,',','.'),3)

	
	ALTER TABLE NashVilleHousing
	ADD Owner_City nvarchar (50)

	
	UPDATE NashVilleHousing
	SET Owner_City = PARSENAME(REPLACE( OwnerAddress,',','.'),2)


	
	ALTER TABLE NashVilleHousing
	ADD Owner_State nvarchar (50)


	
	UPDATE NashVilleHousing
	SET Owner_State = PARSENAME(REPLACE( OwnerAddress,',','.'),1)


/*
	Replace 'Y' and 'N' to 'Yes' and 'No' in 'SoldAsVacant' field
*/

	select 
		distinct(SoldAsVacant),
		COUNT(SoldAsVacant)
	from NashVilleHousing
	group by 
		SoldAsVacant
	order by 
		2


	UPDATE 	NashVilleHousing
	SET SoldAsVacant = CASE 
							WHEN SoldAsVacant = 'Y' THEN 'Yes'
							WHEN SoldAsVacant = 'N' THEN 'No'
							ELSE SoldAsVacant
						END


/*
	Remove all the duplicate data from the table
*/


	WITH ROW_CTE AS  (
		SELECT
			*,
			ROW_NUMBER() OVER 
				(PARTITION BY ParcelID,
							  Sale_Date,
							  LegalReference
							  ORDER BY
								UniqueID 
							) AS RN
		FROM NashVilleHousing)

	DELETE

	FROM ROW_CTE
	WHERE RN > 1





/*
	Delete the unnecessary columnn from the table
*/

	
	ALTER TABLE NashVilleHousing
	DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict

	SELECT * FROM NashVilleHousing