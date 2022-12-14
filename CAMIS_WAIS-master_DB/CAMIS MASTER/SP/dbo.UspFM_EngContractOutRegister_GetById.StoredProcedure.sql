USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngContractOutRegister_GetById]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngContractOutRegister_GetById
Description			: To Get the data from table EngStockUpdateRegisterTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngContractOutRegister_GetById] @pContractId=10,@pPageIndex=1,@pPageSize=5,@pUserId=1
SELECT * FROM EngContractOutRegister
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngContractOutRegister_GetById]                           
  @pUserId			INT	=	NULL,
  @pContractId		INT,
  @pPageIndex		INT,
  @pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	INT

	IF(ISNULL(@pContractId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngContractOutRegister								AS ContractOutRegister		WITH(NOLOCK)
			INNER JOIN  EngContractOutRegisterDet				AS ContractOutRegisterDet	WITH(NOLOCK)			on ContractOutRegister.ContractId		= ContractOutRegisterDet.ContractId
			INNER JOIN  MstContractorandVendor					AS ContractorandVendor		WITH(NOLOCK)			on ContractOutRegister.ContractorId		= ContractorandVendor.ContractorId
			INNER JOIN	MstService								AS ServiceKey				WITH(NOLOCK)			on ContractOutRegister.ServiceId		= ServiceKey.ServiceId
			INNER JOIN	FMLovMst								AS ContractorType			WITH(NOLOCK)			on ContractorandVendor.ContractorType	= ContractorType.LovId
			INNER JOIN	EngAsset								AS Asset					WITH(NOLOCK)			on ContractOutRegisterDet.AssetId		= Asset.AssetId
			INNER JOIN	FMLovMst								AS ContractType				WITH(NOLOCK)			on ContractOutRegisterDet.ContractType	= ContractType.LovId

	WHERE	ContractOutRegister.ContractId = @pContractId   

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPageCalc = CEILING(@pTotalPage)


    SELECT	ContractOutRegister.ContractId						AS ContractId,
			ContractOutRegister.CustomerId						AS CustomerId,
			ContractOutRegister.FacilityId						AS FacilityId,
			ContractOutRegister.ServiceId						AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKey,
			ContractOutRegister.ContractNo						AS ContractNo,
			ContractOutRegister.ContractorId					AS ContractorId,
			ContractorandVendor.SSMRegistrationCode				AS ContractorCode,
			ContractorandVendor.ContractorName					AS ContractorName,
			ContractorandVendor.ContractorType					AS ContractorType,
			ContractorType.FieldValue							AS ContractorTypeName,
			ContactInfo.Name									AS ContactPerson,
			ContactInfo.Designation								AS Designation,
			ContactInfo.ContactNo								AS ContactNo,
			ContractorandVendor.FaxNo							AS FaxNo,
			ContactInfo.Email									AS Email,
			ContractOutRegister.ContractStartDate				AS ContractStartDate,
			ContractOutRegister.ContractEndDate					AS ContractEndDate,
			ContractOutRegister.AResponsiblePerson				AS AResponsiblePerson,
			ContractOutRegister.APersonDesignation				AS APersonDesignation,
			ContractOutRegister.AContactNumber					AS AContactNumber,
			ContractOutRegister.AFaxNo							AS AFaxNo,
			ContractOutRegister.ScopeofWork						AS ScopeofWork,
			ContractOutRegister.Remarks							AS Remarks,
			ContractOutRegister.Status							AS Status,
			(SELECT SUM(ContractValue) FROM EngContractOutRegisterDet WHERE ContractId = @pContractId
			GROUP BY ContractId)								AS ContractSumValue,
			ContractOutRegisterDet.ContractDetId				AS ContractDetId,
			ContractOutRegisterDet.AssetId						AS AssetId,
			Asset.AssetNo										AS AssetNo,
			Asset.AssetDescription								AS AssetDescription,
			ContractOutRegisterDet.ContractType					AS ContractType,
			ContractType.FieldValue								AS ContractTypeName,
			ContractOutRegisterDet.ContractValue				AS ContractValue,
			ContractOutRegister.IsRenewedPreviously				AS IsRenewedPreviously,
			@TotalRecords										AS TotalRecords,
			@pTotalPageCalc										AS TotalPageCalc,
			ContractOutRegister.GuId,
			ContractOutRegister.NotificationForInspection
	FROM	EngContractOutRegister								AS ContractOutRegister		WITH(NOLOCK)
			INNER JOIN  EngContractOutRegisterDet				AS ContractOutRegisterDet	WITH(NOLOCK)			ON ContractOutRegister.ContractId		= ContractOutRegisterDet.ContractId
			INNER JOIN  MstContractorandVendor					AS ContractorandVendor		WITH(NOLOCK)			ON ContractOutRegister.ContractorId		= ContractorandVendor.ContractorId
			INNER JOIN	MstService								AS ServiceKey				WITH(NOLOCK)			ON ContractOutRegister.ServiceId		= ServiceKey.ServiceId
			INNER JOIN	FMLovMst								AS ContractorType			WITH(NOLOCK)			ON ContractorandVendor.ContractorType	= ContractorType.LovId
			INNER JOIN	EngAsset								AS Asset					WITH(NOLOCK)			ON ContractOutRegisterDet.AssetId		= Asset.AssetId
			INNER JOIN	FMLovMst								AS ContractType				WITH(NOLOCK)			ON ContractOutRegisterDet.ContractType	= ContractType.LovId
			OUTER APPLY (SELECT TOP 1 ContractorId,ContactNo,Name,Designation,Email FROM MstContractorandVendorContactInfo dET WHERE ContractorandVendor.ContractorId=dET.ContractorId) AS ContactInfo


	WHERE	ContractOutRegister.ContractId = @pContractId 
	ORDER BY ContractOutRegister.ModifiedDate ASC
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
