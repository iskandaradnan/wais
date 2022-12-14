USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_AssetListCategory]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_Home_DashBoard_WorkOrder]
Description			: Get the Home DashBoard WorkOrder
Authors				: Balaji M S
Date				: 10-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_Home_DashBoard_AssetListCategory]  @pFacilityId=1,@pStartDateMonth=1,@pEndDateMonth=8,@pStartDateYear=2018,@pEndDateYear=2018,@pUserId=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_AssetListCategory]    
		@pFacilityId			INT,
		@pStartDateMonth		INT   ,
		@pEndDateMonth			INT	  ,
		@pStartDateYear			INT	  ,
		@pEndDateYear			INT	  ,
		@pUserId				INT   = NULL

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
		CREATE TABLE #TempTableCount (ID INT ,NAME NVARCHAR(200) , COUNTVALUE INT DEFAULT 0,PERVALUE NUMERIC(24,2) DEFAULT 0)

		INSERT INTO #TempTableCount(ID,NAME,COUNTVALUE) VALUES (1,'In-House',0)
		INSERT INTO #TempTableCount(ID,NAME,COUNTVALUE) VALUES (2,'Warranty Management',0)
		INSERT INTO #TempTableCount(ID,NAME,COUNTVALUE) VALUES (3,'Contract Out Register',0)

-- Work Order


	create table #tmpAssetlist   ( sno int identity(1,1) ,AssetId int,AssetType int)

	insert into #tmpAssetlist 
	SELECT DISTINCT a.AssetId,3 as AssetType FROM EngAsset A INNER JOIN EngContractOutRegisterDet B ON A.AssetId = B.AssetId 
	INNER JOIN EngContractOutRegister C ON B.ContractId = C.ContractId 
	WHERE  MONTH(C.ContractEndDate) BETWEEN @pStartDateMonth AND @pEndDateMonth
	AND YEAR(C.ContractEndDate) BETWEEN @pStartDateYear AND @pEndDateYear
	AND CAST(c.ContractEndDate AS DATE) > = CAST(GETDATE() AS DATE)
	AND A.FacilityId = @pFacilityId AND AssetStatusLovId = 1
	and isnull(a.IsLoaner,0)=0

	insert into #tmpAssetlist 
	SELECT DISTINCT AssetId,2 as AssetType FROM EngAsset e WHERE CAST(WarrantyEndDate AS DATE) > = CAST(GETDATE() AS DATE)
	and isnull(e.IsLoaner,0)=0
	AND FacilityId = @pFacilityId AND AssetId not in (SELECT DISTINCT B.AssetId FROM EngAsset A INNER JOIN EngContractOutRegisterDet B ON A.AssetId = B.AssetId 
	INNER JOIN EngContractOutRegister C ON B.ContractId = C.ContractId 
	WHERE  MONTH(C.ContractEndDate) BETWEEN @pStartDateMonth AND @pEndDateMonth
	AND YEAR(C.ContractEndDate) BETWEEN @pStartDateYear AND @pEndDateYear
	AND CAST(c.ContractEndDate AS DATE) > = CAST(GETDATE() AS DATE)
	AND A.FacilityId = @pFacilityId AND AssetStatusLovId = 1
		and isnull(a.IsLoaner,0)=0
	)



	UPDATE #TempTableCount SET COUNTVALUE =( SELECT DISTINCT COUNT(AssetId) FROM EngAsset e WHERE  AssetStatusLovId = 1 AND
	FacilityId = @pFacilityId AND isnull(e.IsLoaner,0)=0 AND  AssetId IN  (SELECT DISTINCT B.AssetId FROM EngAsset A INNER JOIN EngContractOutRegisterDet B ON A.AssetId = B.AssetId 
	INNER JOIN EngContractOutRegister C ON B.ContractId = C.ContractId 
	WHERE  MONTH(C.ContractEndDate) BETWEEN @pStartDateMonth AND @pEndDateMonth
	AND YEAR(C.ContractEndDate) BETWEEN @pStartDateYear AND @pEndDateYear
	AND CAST(c.ContractEndDate AS DATE) > = CAST(GETDATE() AS DATE)
	AND A.FacilityId = @pFacilityId
	AND isnull(a.IsLoaner,0)=0
	)	
	) WHERE ID =3 


	UPDATE #TempTableCount SET COUNTVALUE =( SELECT DISTINCT COUNT(AssetId) FROM EngAsset e WHERE   AssetStatusLovId = 1 AND CAST(WarrantyEndDate AS DATE) > = CAST(GETDATE() AS DATE)
	AND FacilityId = @pFacilityId AND isnull(e.IsLoaner,0)=0 AND AssetId not in (SELECT DISTINCT B.AssetId FROM EngAsset A INNER JOIN EngContractOutRegisterDet B ON A.AssetId = B.AssetId 
	INNER JOIN EngContractOutRegister C ON B.ContractId = C.ContractId 
	WHERE  MONTH(C.ContractEndDate) BETWEEN @pStartDateMonth AND @pEndDateMonth
	AND YEAR(C.ContractEndDate) BETWEEN @pStartDateYear AND @pEndDateYear
	AND CAST(c.ContractEndDate AS DATE) > = CAST(GETDATE() AS DATE)
	AND A.FacilityId = @pFacilityId
	and isnull(a.IsLoaner,0)=0
	)
	) WHERE ID =2 
	
	
	--UPDATE #TempTableCount SET COUNTVALUE =( SELECT COUNT(*) FROM EngAsset A INNER JOIN EngContractOutRegisterDet B ON A.AssetId = B.AssetId 
	--INNER JOIN EngContractOutRegister C ON B.ContractId = C.ContractId 
	--WHERE  MONTH(C.ContractEndDate) BETWEEN @pStartDateMonth AND @pEndDateMonth
	--AND YEAR(C.ContractEndDate) BETWEEN @pStartDateYear AND @pEndDateYear
	--AND A.FacilityId = @pFacilityId) WHERE ID =3 

	UPDATE #TempTableCount SET COUNTVALUE =( SELECT COUNT(*) FROM EngAsset A 
	WHERE  AssetId NOT IN  (SELECT ISNULL(AssetId,0) FROM #tmpAssetlist)
	AND A.FacilityId = @pFacilityId  
	AND  isnull(a.IsLoaner,0)=0
	AND AssetStatusLovId = 1) WHERE ID =1
	

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
