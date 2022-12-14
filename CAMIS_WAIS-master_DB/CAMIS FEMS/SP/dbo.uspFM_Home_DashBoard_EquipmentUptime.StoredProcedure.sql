USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_EquipmentUptime]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_Home_DashBoard_EquipmentUptime
Description			: Get the Home DashBoard Asset
Authors				: Balaji M S
Date				: 10-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_Home_DashBoard_EquipmentUptime  @pFacilityId=2,@pStartDateMonth=5,@pEndDateMonth=7,@pStartDateYear=2018,@pEndDateYear=2018
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_EquipmentUptime]    
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

	IF OBJECT_ID('#TempTableCount') IS NOT NULL
	DROP TABLE #TempTableCount

	CREATE TABLE #TempTableCount (ID INT , CODE NVARCHAR(100) ,NAME NVARCHAR(100) , COUNTVALUE INT DEFAULT 0,PERVALUE NUMERIC(24,2) DEFAULT 0)

	INSERT INTO #TempTableCount(ID,CODE,NAME,COUNTVALUE)

	SELECT AssetClassificationId,AssetClassificationCode,AssetClassificationDescription,0 AS COUNTVALUE FROM EngAssetClassification


-- General

	
	UPDATE #TempTableCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM EngAsset A 
	 	WHERE A.AssetStatusLovId = 1  AND A.FacilityId = @pFacilityId 
			  AND A.AssetClassification =1
		   ),0) WHERE ID=1 AND NAME='General'

--Dialysis
	UPDATE #TempTableCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM EngAsset A 
	 	WHERE A.AssetStatusLovId = 1  AND A.FacilityId = @pFacilityId 
			  AND A.AssetClassification =2
		   ),0) WHERE ID=2 AND NAME='Dialysis'

--Lab
	UPDATE #TempTableCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM EngAsset A 
	 	WHERE A.AssetStatusLovId = 1  AND A.FacilityId = @pFacilityId 
			  AND A.AssetClassification =3
		   ),0) WHERE ID=3 AND NAME='Lab'

--Life Support
	UPDATE #TempTableCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM EngAsset A 
	 	WHERE A.AssetStatusLovId = 1  AND A.FacilityId = @pFacilityId 
			  AND A.AssetClassification =4
		   ),0) WHERE ID=4 AND NAME='Life Support'

--Radiology
	UPDATE #TempTableCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM EngAsset A 
	 	WHERE A.AssetStatusLovId = 1  AND A.FacilityId = @pFacilityId 
			  AND A.AssetClassification =5
		   ),0) WHERE ID=5 AND NAME='Radiology'

--Standard Category
	UPDATE #TempTableCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM EngAsset A 
	 	WHERE A.AssetStatusLovId = 1  AND A.FacilityId = @pFacilityId 
			  AND A.AssetClassification =6
		   ),0) WHERE ID=6 AND NAME='Standard Category'

	
		DECLARE @mSumofValue NUMERIC(24,2) 
	SET @mSumofValue = (SELECT SUM(COUNTVALUE) FROM #TempTableCount)

	UPDATE #TempTableCount SET PERVALUE = IIF(@mSumofValue=0,0,(CAST(COUNTVALUE AS numeric(24,2)) /@mSumofValue) * 100.00)
	
	
	
	SELECT * FROM #TempTableCount


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
