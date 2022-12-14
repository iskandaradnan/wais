USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_AssetAge]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_Home_DashBoard_AssetAge
Description			: Get the Home DashBoard Asset Age
Authors				: Balaji M S
Date				: 10-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_Home_DashBoard_AssetAge]  @pFacilityId=2,@pStartDateMonth=5,@pEndDateMonth=5,@pStartDateYear=2017,@pEndDateYear=2017
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_AssetAge]    
		@pFacilityId			INT,
		@pStartDateMonth		INT   =	NULL,
		@pEndDateMonth			INT	  =	NULL,
		@pStartDateYear			INT	  =	NULL,
		@pEndDateYear			INT	  =	NULL

AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values

		--SET @pStartDateMonth = MONTH(GETDATE())
		--SET @pEndDateMonth	 = MONTH(GETDATE())
		--SET @pStartDateYear	 = YEAR(GETDATE())
		--SET @pEndDateYear	 = YEAR(GETDATE())

-- Execution
	

	IF OBJECT_ID('#TempTableAssetAgeCount') IS NOT NULL
	DROP TABLE #TempTableAssetAgeCount

	IF OBJECT_ID('#TempTableAssetValueCount') IS NOT NULL
	DROP TABLE #TempTableAssetValueCount


	CREATE TABLE #TempTableAssetAgeCount (AgeGroupId	INT,Group_asset_age		NVARCHAR(200),Asset_Age_From	NUMERIC(24,2),Asset_Age_To	NUMERIC(24,2),COUNTVALUE	INT)

	INSERT INTO #TempTableAssetAgeCount(AgeGroupId,Group_asset_age,Asset_Age_From,Asset_Age_To) 

	SELECT AgeGroupId,Group_asset_age,Asset_Age_From,Asset_Age_To FROM FMAssetAgeMst

	CREATE TABLE #TempTableAssetValueCount (ASSETID		INT,ASSETNO		NVARCHAR(500), ASSETAGECALC		NUMERIC(24,2))

	INSERT INTO #TempTableAssetValueCount (ASSETID,ASSETNO,ASSETAGECALC)
	SELECT AssetId,AssetNo,CAST(datediff(m,purchasedate,GETDATE())/12 as NUMERIC(24,2)) FROM EngAsset WHERE FacilityId = @pFacilityId

--Not Available
	--UPDATE #TempTableAssetAgeCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM #TempTableAssetValueCount A , #TempTableAssetAgeCount B
	-- 	WHERE ASSETAGECALC BETWEEN B.Asset_Age_From AND B.Asset_Age_To AND B.AgeGroupId =1 ),0) WHERE AgeGroupId=1 

--Less than 1 year
	UPDATE #TempTableAssetAgeCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM #TempTableAssetValueCount A , #TempTableAssetAgeCount B
	 	WHERE ASSETAGECALC BETWEEN B.Asset_Age_From AND B.Asset_Age_To AND B.AgeGroupId =2 ),0) WHERE AgeGroupId=2

--Between 1 to 5 years
	UPDATE #TempTableAssetAgeCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM #TempTableAssetValueCount A , #TempTableAssetAgeCount B
	 	WHERE ASSETAGECALC BETWEEN B.Asset_Age_From AND B.Asset_Age_To AND B.AgeGroupId =3 ),0) WHERE AgeGroupId=3

--Between 6 to 10 years
	UPDATE #TempTableAssetAgeCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM #TempTableAssetValueCount A , #TempTableAssetAgeCount B
	 	WHERE ASSETAGECALC BETWEEN B.Asset_Age_From AND B.Asset_Age_To AND B.AgeGroupId =4 ),0) WHERE AgeGroupId=4

--Between 11 to 15 years
	UPDATE #TempTableAssetAgeCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM #TempTableAssetValueCount A , #TempTableAssetAgeCount B
	 	WHERE ASSETAGECALC BETWEEN B.Asset_Age_From AND B.Asset_Age_To AND B.AgeGroupId =5 ),0) WHERE AgeGroupId=5

--Greater than 15 year
	UPDATE #TempTableAssetAgeCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM #TempTableAssetValueCount A , #TempTableAssetAgeCount B
	 	WHERE ASSETAGECALC BETWEEN B.Asset_Age_From AND B.Asset_Age_To AND B.AgeGroupId =6 ),0) WHERE AgeGroupId=6


	SELECT * FROM #TempTableAssetAgeCount


END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
