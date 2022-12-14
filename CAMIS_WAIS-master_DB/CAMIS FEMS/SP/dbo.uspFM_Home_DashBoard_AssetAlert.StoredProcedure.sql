USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_AssetAlert]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_Home_DashBoard_Asset]
Description			: Get the Home DashBoard Asset
Authors				: Balaji M S
Date				: 10-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_Home_DashBoard_AssetAlert]  @pFacilityId=1,@pStartDateMonth=8,@pEndDateMonth=8,@pStartDateYear=2018,@pEndDateYear=2018
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_AssetAlert]    
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

	CREATE TABLE #TempTableCount (ID INT , NAME NVARCHAR(100) , COUNTVALUE INT DEFAULT 0,PERVALUE NUMERIC(24,2) DEFAULT 0)

	INSERT INTO #TempTableCount(ID,NAME)  VALUES (1,'Contract Out Register')
	INSERT INTO #TempTableCount(ID,NAME)  VALUES (2,'License and Certificate')
	INSERT INTO #TempTableCount(ID,NAME)  VALUES (3,'Warranty Asset')
-- Asset

	
	UPDATE #TempTableCount SET COUNTVALUE= ISNULL((SELECT COUNT(DISTINCT B.AssetId) FROM EngAsset A 
	INNER JOIN EngContractOutRegisterDet B ON A.AssetId = B.AssetId
	INNER JOIN EngContractOutRegister C ON C.ContractId = B.ContractId
	WHERE A.AssetStatusLovId = 1 
		 and isnull(a.IsLoaner,0)=0
		  AND A.FacilityId = @pFacilityId AND C.ContractEndDate >= GETDATE()
		  AND DATEDIFF(DD,GETDATE(),C.ContractEndDate) <= 30)	  
		 
		  ,0) WHERE ID=1


	UPDATE #TempTableCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM EngAsset A 
	INNER JOIN EngLicenseandCertificateTxnDet B ON A.AssetId = B.AssetId
	INNER JOIN EngLicenseandCertificateTxn C ON C.LicenseId = B.LicenseId
	WHERE A.AssetStatusLovId = 1 AND C.ExpireDate >= GETDATE()
			 and isnull(a.IsLoaner,0)=0
		  AND A.FacilityId = @pFacilityId
		  AND DATEDIFF(DD,GETDATE(),C.ExpireDate) <= 30),0) WHERE ID=2

	UPDATE #TempTableCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM EngAsset A 
	WHERE A.AssetStatusLovId = 1 
			and isnull(a.IsLoaner,0)=0
		  AND A.FacilityId = @pFacilityId AND  A.WarrantyEndDate >= GETDATE()
		  AND DATEDIFF(DD,GETDATE(),A.WarrantyEndDate) <= 30),0) WHERE ID=3
	
	
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
