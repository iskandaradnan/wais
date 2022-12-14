USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngWarrantyManagementTxnDefect_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngWarrantyManagementTxnDefect_GetById
Description			: To Get the data from table EngDefectDetailsTxn using the Asset Register id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngWarrantyManagementTxnDefect_GetById] @pWarrantyMgmtId=14,@pPageIndex=1,@pPageSize=5,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngWarrantyManagementTxnDefect_GetById]                           
  @pUserId			INT	=	NULL,
  @pWarrantyMgmtId	INT,
  @pPageIndex		INT,
  @pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	NUMERIC(24,2)

	IF(ISNULL(@pWarrantyMgmtId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngWarrantyManagementTxn							AS WarrantyManagement		WITH(NOLOCK)
			INNER  JOIN	EngDefectDetailsTxn						AS DefectDetails			WITH(NOLOCK) on WarrantyManagement.AssetId		= DefectDetails.AssetId
			INNER  JOIN  EngDefectDetailsTxnDet					AS DefectDetailsDet			WITH(NOLOCK) on DefectDetails.DefectId			= DefectDetailsDet.DefectId
	WHERE	WarrantyManagement.WarrantyMgmtId = @pWarrantyMgmtId  

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)


    SELECT	WarrantyManagement.WarrantyMgmtId					AS WarrantyMgmtId,
			WarrantyManagement.WarrantyNo						AS WarrantyNo,
			DefectDetails.DefectDate							AS DefectDate,
			DefectDetailsDet.DefectDetails						AS DefectDetails,
			DefectDetailsDet.StartDate							AS StartDate,
			DefectDetailsDet.StartDateUTC						AS StartDateUTC,
	CASE	WHEN DefectDetailsDet.CompletionDate IS NOT NULL THEN 1
	ELSE	0
	END															AS IsCompleted,
			DefectDetailsDet.CompletionDate						AS CompletionDate,
			DefectDetailsDet.CompletionDateUTC					AS CompletionDateUTC,
			DefectDetailsDet.ActionTaken						AS ActionTaken,
			@TotalRecords										AS TotalRecords,
			@pTotalPageCalc										AS TotalPageCalc
	FROM	EngWarrantyManagementTxn							AS WarrantyManagement		WITH(NOLOCK)
			INNER  JOIN	EngDefectDetailsTxn						AS DefectDetails			WITH(NOLOCK) on WarrantyManagement.AssetId		= DefectDetails.AssetId
			INNER  JOIN  EngDefectDetailsTxnDet					AS DefectDetailsDet			WITH(NOLOCK) on DefectDetails.DefectId			= DefectDetailsDet.DefectId
	WHERE	WarrantyManagement.WarrantyMgmtId = @pWarrantyMgmtId 
	ORDER BY WarrantyManagement.ModifiedDate ASC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY



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
