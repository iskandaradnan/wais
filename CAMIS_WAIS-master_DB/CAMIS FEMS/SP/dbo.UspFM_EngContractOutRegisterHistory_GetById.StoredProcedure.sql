USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngContractOutRegisterHistory_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngContractOutRegisterHistory_GetById
Description			: To Get the data from table EngContractOutRegisterHistory using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngContractOutRegisterHistory_GetById] @pContractId=11,@pPageIndex=1,@pPageSize=5,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngContractOutRegisterHistory_GetById]                           
  @pUserId			INT	=	NULL,
  @pContractId		INT,
  @pPageIndex		INT,
  @pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	NUMERIC(24,2)

	IF(ISNULL(@pContractId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngContractOutRegister								AS ContractOutRegister			WITH(NOLOCK)
			INNER JOIN  EngContractOutRegisterHistory			AS ContractOutRegisterHistory	WITH(NOLOCK)			on ContractOutRegister.ContractId		= ContractOutRegisterHistory.ContractId
	WHERE	ContractOutRegister.ContractId = @pContractId  

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)


    SELECT	ContractOutRegister.ContractId						AS ContractId,
			ContractOutRegisterHistory.ContractHistoryId		AS ContractHistoryId,
			ContractOutRegisterHistory.CustomerId				AS CustomerId,
			ContractOutRegisterHistory.FacilityId				AS FacilityId,
			ContractOutRegisterHistory.ContractStartDate		AS ContractStartDate,
			ContractOutRegisterHistory.ContractEndDate			AS ContractEndDate,
			ContractOutRegisterHistory.ContractNo				AS ContractNo,
			ContractOutRegisterHistory.AssetId,
			Asset.AssetNo										AS AssetNo,
			Asset.AssetDescription								AS AssetDescription,
			ContractOutRegisterHistory.ContractType				AS ContractType,
			ContractType.FieldValue								AS ContractTypeName,
			ContractOutRegisterHistory.ContractValue			AS ContractValue,
			@TotalRecords										AS TotalRecords,
			@pTotalPageCalc										AS TotalPageCalc,
			ContractOutRegister.GuId
	FROM	EngContractOutRegister								AS ContractOutRegister			WITH(NOLOCK)
			INNER JOIN  EngContractOutRegisterHistory			AS ContractOutRegisterHistory	WITH(NOLOCK)	ON ContractOutRegister.ContractId			= ContractOutRegisterHistory.ContractId
			LEFT JOIN	EngAsset								AS Asset						WITH(NOLOCK)	ON ContractOutRegisterHistory.AssetId		= Asset.AssetId
			LEFT JOIN	FMLovMst								AS ContractType					WITH(NOLOCK)	ON ContractOutRegisterHistory.ContractType	= ContractType.LovId
	WHERE	ContractOutRegister.ContractId = @pContractId 
	ORDER BY ContractOutRegister.ModifiedDate ASC
--	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY



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
