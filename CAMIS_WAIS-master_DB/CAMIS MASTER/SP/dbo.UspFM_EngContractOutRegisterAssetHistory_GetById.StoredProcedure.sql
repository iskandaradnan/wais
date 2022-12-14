USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngContractOutRegisterAssetHistory_GetById]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngContractOutRegisterAssetHistory_GetById
Description			: To Get the data from table EngContractOutRegisterHistory using the Primary Key id
Authors				: Dhilip V
Date				: 21-Aug-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngContractOutRegisterAssetHistory_GetById] @pContractId=61,@pPageIndex=1,@pPageSize=5,@pContractHistoryId=38

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngContractOutRegisterAssetHistory_GetById]                           

  @pContractId				INT,
  @pContractHistoryId		INT,
  @pPageIndex				INT,
  @pPageSize				INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	NUMERIC(24,2)

	IF(ISNULL(@pContractId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngContractOutRegister								AS ContractOutRegister			WITH(NOLOCK)
			INNER JOIN  EngContractOutRegisterHistory			AS ContractOutRegisterHistory	WITH(NOLOCK)	ON ContractOutRegister.ContractId				= ContractOutRegisterHistory.ContractId
			INNER JOIN  EngContractOutRegisterAssetHistory		AS AssetHistory					WITH(NOLOCK)	ON ContractOutRegisterHistory.ContractHistoryId	= AssetHistory.ContractHistoryId
			LEFT JOIN	EngAsset								AS Asset						WITH(NOLOCK)	ON AssetHistory.AssetId							= Asset.AssetId
			LEFT JOIN	FMLovMst								AS ContractType					WITH(NOLOCK)	ON AssetHistory.ContractType					= ContractType.LovId
	WHERE	ContractOutRegister.ContractId = @pContractId 
			AND AssetHistory.ContractHistoryId = @pContractHistoryId 

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)


    SELECT	ContractOutRegister.ContractId			AS ContractId,
			AssetHistory.ContractDetHistoryId,
			AssetHistory.ContractHistoryId			AS ContractHistoryId,
			AssetHistory.AssetId,
			Asset.AssetNo							AS AssetNo,
			Asset.AssetDescription					AS AssetDescription,
			AssetHistory.ContractType				AS ContractType,
			ContractType.FieldValue					AS ContractTypeName,
			AssetHistory.ContractValue				AS ContractValue,
			@TotalRecords							AS TotalRecords,
			@pTotalPageCalc							AS TotalPageCalc,
			ContractOutRegister.GuId
	FROM	EngContractOutRegister								AS ContractOutRegister			WITH(NOLOCK)
			INNER JOIN  EngContractOutRegisterHistory			AS ContractOutRegisterHistory	WITH(NOLOCK)	ON ContractOutRegister.ContractId				= ContractOutRegisterHistory.ContractId
			INNER JOIN  EngContractOutRegisterAssetHistory		AS AssetHistory					WITH(NOLOCK)	ON ContractOutRegisterHistory.ContractHistoryId	= AssetHistory.ContractHistoryId
			LEFT JOIN	EngAsset								AS Asset						WITH(NOLOCK)	ON AssetHistory.AssetId							= Asset.AssetId
			LEFT JOIN	FMLovMst								AS ContractType					WITH(NOLOCK)	ON AssetHistory.ContractType					= ContractType.LovId
	WHERE	ContractOutRegister.ContractId = @pContractId 
			AND AssetHistory.ContractHistoryId = @pContractHistoryId 
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
