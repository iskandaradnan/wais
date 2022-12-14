USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngAssetContractorandVendor_GetByAssetId]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngAssetContractorandVendor_GetByAssetId
Description			: To Get the details for ContractorandVendor using the asset id
Authors				: Dhilip V
Date				: 24-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngAssetContractorandVendor_GetByAssetId] @pAssetId=84,@pPageIndex=1,@pPageSize=5
SELECT * FROM EngContractOutRegister
SELECT * FROM EngContractOutRegisterDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngAssetContractorandVendor_GetByAssetId]                           

  @pAssetId			INT,
  @pPageIndex		INT		=	NULL,
  @pPageSize		INT		=	NULL

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	INT

	SET @pPageIndex = (@pPageIndex + 1)

	IF(ISNULL(@pAssetId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngAsset									AS	Asset				WITH(NOLOCK)
			INNER JOIN	MstCustomer						AS 	Customer			WITH(NOLOCK)	ON Asset.CustomerId					= Customer.CustomerId
			INNER JOIN	MstLocationFacility				AS 	Facility			WITH(NOLOCK)	ON Asset.FacilityId					= Facility.FacilityId
			INNER JOIN	EngContractOutRegisterDet		AS 	ContractOutRegDet	WITH(NOLOCK)	ON Asset.AssetId					= ContractOutRegDet.AssetId
			INNER JOIN	EngContractOutRegister			AS 	ContractOutReg		WITH(NOLOCK)	ON ContractOutRegDet.ContractId		= ContractOutReg.ContractId
			INNER JOIN  MstContractorandVendor			AS	MstContractor		WITH(NOLOCK)	ON ContractOutReg.ContractorId		= MstContractor.ContractorId
			LEFT JOIN  FMLovMst							AS	LovContractorType	WITH(NOLOCK)	ON ContractOutRegDet.ContractType	= LovContractorType.LovId
			LEFT JOIN  FMLovMst							AS	LovStatus			WITH(NOLOCK)	ON ContractOutReg.Status			= LovStatus.LovId
	WHERE	ContractOutRegDet.AssetId = @pAssetId 

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)


    SELECT	ContractOutReg.ContractId,
			Asset.AssetId,
			Facility.FacilityName,
			ContractOutReg.ContractNo,
			MstContractor.ContractorName,
			LovContractorType.FieldValue,
			ContractOutReg.ContractStartDate,
			ContractOutReg.ContractEndDate,
			LovStatus.FieldValue					AS	Status,
			ContractOutRegDet.ContractValue,
			@TotalRecords							AS TotalRecords,
			@pTotalPageCalc							AS TotalPageCalc,
			ContractOutRegDet.ContractType			AS ContractTypeId,
			LovContractorType.FieldValue			AS ContractorType
	FROM	EngAsset									AS	Asset				WITH(NOLOCK)
			INNER JOIN	MstCustomer						AS 	Customer			WITH(NOLOCK)	ON Asset.CustomerId					= Customer.CustomerId
			INNER JOIN	MstLocationFacility				AS 	Facility			WITH(NOLOCK)	ON Asset.FacilityId					= Facility.FacilityId
			INNER JOIN	EngContractOutRegisterDet		AS 	ContractOutRegDet	WITH(NOLOCK)	ON Asset.AssetId					= ContractOutRegDet.AssetId
			INNER JOIN	EngContractOutRegister			AS 	ContractOutReg		WITH(NOLOCK)	ON ContractOutRegDet.ContractId		= ContractOutReg.ContractId
			INNER JOIN  MstContractorandVendor			AS	MstContractor		WITH(NOLOCK)	ON ContractOutReg.ContractorId		= MstContractor.ContractorId
			LEFT JOIN  FMLovMst							AS	LovContractorType	WITH(NOLOCK)	ON ContractOutRegDet.ContractType	= LovContractorType.LovId
			LEFT JOIN  FMLovMst							AS	LovStatus			WITH(NOLOCK)	ON ContractOutReg.Status			= LovStatus.LovId
	WHERE	ContractOutRegDet.AssetId = @pAssetId 
	ORDER BY ContractOutRegDet.ModifiedDate DESC
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
