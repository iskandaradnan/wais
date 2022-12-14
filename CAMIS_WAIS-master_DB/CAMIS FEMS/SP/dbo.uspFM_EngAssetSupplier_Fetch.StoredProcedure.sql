USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetSupplier_Fetch]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetSupplier_Fetch
Description			: Get the Supplier details for the Asset 
Authors				: Dhilip V
Date				: 30-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetSupplier_Fetch  @pLovIdSupplierCategory=14,@pAssetId=1,@pFacilityId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetSupplier_Fetch]                           
  
  @pLovIdSupplierCategory	INT,
  @pAssetId					INT,
  @pFacilityId				INT


AS                                                     

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
-- Default Values
	

-- Execution



	if @pLovIdSupplierCategory = 13 
	begin
	
	DECLARE @Cnt INT =0

	SELECT @Cnt = COUNT(*) FROM EngAsset	A 
	INNER JOIN EngTestingandCommissioningTxnDet B ON A.TestingandCommissioningDetId = B.TestingandCommissioningDetId
	INNER JOIN EngTestingandCommissioningTxn	C ON B.TestingandCommissioningId	= C.TestingandCommissioningId
	WHERE A.AssetId	= @pAssetId AND C.ContractorId IS NOT NULL

		IF (ISNULL(@Cnt,0)=0)
	
		BEGIN
		SELECT	MstContractor.ContractorId		AS	LovId, 0  IsDefault,
				--LovCategory.FieldValue					AS	CategoryLovName,
				--MstContractor.SSMRegistrationCode		AS	SSMRegistrationCode,
				MstContractor.ContractorName			AS	FieldValue
 		FROM	EngAssetSupplierWarranty				AS	SupplierWarranty	WITH(NOLOCK)
				INNER JOIN	EngAsset					AS	Asset				WITH(NOLOCK)	ON Asset.AssetId					=	SupplierWarranty.AssetId
				INNER JOIN	MstContractorandVendor		AS	MstContractor		WITH(NOLOCK)	ON SupplierWarranty.ContractorId	=	MstContractor.ContractorId
				INNER JOIN	FMLovMst					AS	LovCategory			WITH(NOLOCK)	ON SupplierWarranty.Category		=	LovCategory.LovId
		WHERE	SupplierWarranty.Category	=	@pLovIdSupplierCategory	
				AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
				AND Asset.AssetId	=	@pAssetId
		END
		ELSE
		BEGIN
				SELECT	MstContractor.ContractorId		AS	LovId,
						0  IsDefault,
						MstContractor.ContractorName			AS	FieldValue
					FROM	EngAsset	AS Asset 
							INNER JOIN EngTestingandCommissioningTxnDet		AS	TandCDet			WITH(NOLOCK)	ON Asset.TestingandCommissioningDetId	=	TandCDet.TestingandCommissioningDetId
							INNER JOIN EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)	ON TandCDet.TestingandCommissioningId	=	TandC.TestingandCommissioningId
							INNER JOIN	MstContractorandVendor				AS	MstContractor		WITH(NOLOCK)	ON TandC.ContractorId					=	MstContractor.ContractorId
							OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
										FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
										WHERE MstContractor.ContractorId	=	ContractorDet.ContractorId) AS 	CContactInfo
					WHERE	Asset.AssetId		=	@pAssetId

					ORDER BY	Asset.ModifiedDate ASC
				
		END
	END
	ELSE
	BEGIN
	SELECT	MstContractor.ContractorId		AS	LovId, 0  IsDefault,
				--LovCategory.FieldValue					AS	CategoryLovName,
				--MstContractor.SSMRegistrationCode		AS	SSMRegistrationCode,
				MstContractor.ContractorName			AS	FieldValue
 		FROM	EngAssetSupplierWarranty				AS	SupplierWarranty	WITH(NOLOCK)
				INNER JOIN	EngAsset					AS	Asset				WITH(NOLOCK)	ON Asset.AssetId					=	SupplierWarranty.AssetId
				INNER JOIN	MstContractorandVendor		AS	MstContractor		WITH(NOLOCK)	ON SupplierWarranty.ContractorId	=	MstContractor.ContractorId
				INNER JOIN	FMLovMst					AS	LovCategory			WITH(NOLOCK)	ON SupplierWarranty.Category		=	LovCategory.LovId
		WHERE	SupplierWarranty.Category	=	@pLovIdSupplierCategory	
				AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
				AND Asset.AssetId	=	@pAssetId
	END

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
