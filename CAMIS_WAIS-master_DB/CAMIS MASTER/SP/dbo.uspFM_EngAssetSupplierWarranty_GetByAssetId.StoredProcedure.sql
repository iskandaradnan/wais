USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetSupplierWarranty_GetByAssetId]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetSupplierWarranty_GetByAssetId
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 03-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetSupplierWarranty_GetByAssetId  @pAssetId=95,@pPageIndex=1,@pPageSize=5
SELECT * FROM EngAssetSupplierWarranty
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetSupplierWarranty_GetByAssetId]                           
  @pAssetId					INT,
  --@pLovIdSupplierCategory	INT,
  @pPageIndex				INT,
  @pPageSize				INT
AS                                                     

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	Declare	@pLovIdSupplierCategoryMainSupplier		INT	=	13
	Declare	@pLovIdSupplierCategoryLAR				INT =	14
	Declare	@pLovIdSupplierCategoryThirdParty		INT =	15
	DECLARE @TotalRecords INT
-- Default Values
	

-- Execution


	IF(ISNULL(@pAssetId,0) = 0) RETURN
	
	--	1	Main Supplier

	DECLARE @Cnt INT =0

	SELECT @Cnt = COUNT(*) FROM EngAsset	A 
	INNER JOIN EngTestingandCommissioningTxnDet B ON A.TestingandCommissioningDetId = B.TestingandCommissioningDetId
	INNER JOIN EngTestingandCommissioningTxn	C ON B.TestingandCommissioningId	= C.TestingandCommissioningId
	WHERE A.AssetId	= @pAssetId AND C.ContractorId IS NOT NULL

	IF (ISNULL(@Cnt,0)=0)
	
	BEGIN

		SELECT	@TotalRecords	=	COUNT(*)
 		FROM	EngAssetSupplierWarranty				AS	SupplierWarranty	WITH(NOLOCK)
				INNER JOIN	EngAsset					AS	Asset				WITH(NOLOCK)	ON Asset.AssetId					=	SupplierWarranty.AssetId
				INNER JOIN	MstContractorandVendor		AS	MstContractor		WITH(NOLOCK)	ON SupplierWarranty.ContractorId	=	MstContractor.ContractorId
				OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
							FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
							WHERE MstContractor.ContractorId	=	ContractorDet.ContractorId) AS 	CContactInfo
				INNER JOIN	FMLovMst					AS	LovCategory			WITH(NOLOCK)	ON SupplierWarranty.Category		=	LovCategory.LovId
		WHERE	SupplierWarranty.AssetId		=	@pAssetId
				AND SupplierWarranty.Category	=	@pLovIdSupplierCategoryMainSupplier
print 'a'
		SELECT	top 1 
		  --      Asset.CustomerId						AS	CustomerId,	
				--Asset.FacilityId						AS	FacilityId,
				--SupplierWarranty.SupplierWarrantyId		AS	SupplierWarrantyId,
				--SupplierWarranty.Category				AS	CategoryLovId,
				--LovCategory.FieldValue					AS	CategoryLovName,
				--MstContractor.ContractorId				AS	ContractorId,
				--MstContractor.SSMRegistrationCode		AS	SSMRegistrationCode,
				MstContractor.ContractorName			AS	ContractorName,
				CContactInfo.ContactPerson				AS	ContactPerson,
				CContactInfo.ContactNo					AS	TelephoneNo,
				CContactInfo.Email						AS	Email,
				MstContractor.FaxNo						AS	FaxNo
				--MstContractor.[Address]					AS	[Address],
				--@TotalRecords							AS TotalRecords
 		FROM	EngAssetSupplierWarranty						AS	SupplierWarranty	WITH(NOLOCK)
				INNER JOIN	EngAsset							AS	Asset				WITH(NOLOCK)	ON Asset.AssetId					=	SupplierWarranty.AssetId
				INNER JOIN	MstContractorandVendor				AS	MstContractor		WITH(NOLOCK)	ON SupplierWarranty.ContractorId	=	MstContractor.ContractorId
				OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
							FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
							WHERE MstContractor.ContractorId	=	ContractorDet.ContractorId) AS 	CContactInfo
				INNER JOIN	FMLovMst							AS	LovCategory			WITH(NOLOCK)	ON SupplierWarranty.Category		=	LovCategory.LovId
		WHERE	SupplierWarranty.AssetId		=	@pAssetId
				AND SupplierWarranty.Category	=	@pLovIdSupplierCategoryMainSupplier
		ORDER BY	SupplierWarranty.ModifiedDate ASC
		
	
	END

	ELSE
	BEGIN
		SELECT	@TotalRecords	=	COUNT(*)
		FROM	EngAsset	AS Asset 
				INNER JOIN EngTestingandCommissioningTxnDet		AS	TandCDet			WITH(NOLOCK)	ON Asset.TestingandCommissioningDetId	=	TandCDet.TestingandCommissioningDetId
				INNER JOIN EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)	ON TandCDet.TestingandCommissioningId	=	TandC.TestingandCommissioningId
				INNER JOIN	MstContractorandVendor				AS	MstContractor		WITH(NOLOCK)	ON TandC.ContractorId					=	MstContractor.ContractorId
				OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
							FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
							WHERE MstContractor.ContractorId	=	ContractorDet.ContractorId) AS 	CContactInfo
		WHERE	Asset.AssetId		=	@pAssetId
print 'b'
		SELECT	Asset.CustomerId						AS	CustomerId,	
				Asset.FacilityId						AS	FacilityId,
				0										AS	SupplierWarrantyId,
				13										AS	CategoryLovId,
				'Main Supplier'							AS	CategoryLovName,
				MstContractor.ContractorId				AS	ContractorId,
				MstContractor.SSMRegistrationCode		AS	SSMRegistrationCode,
				MstContractor.ContractorName			AS	ContractorName,
				CContactInfo.ContactPerson						AS	ContactPerson,
				CContactInfo.ContactNo					AS	TelephoneNo,
				CContactInfo.Email						AS	Email,
				MstContractor.FaxNo						AS	FaxNo,
				MstContractor.[Address]					AS	[Address],
				@TotalRecords							AS TotalRecords
		FROM	EngAsset	AS Asset 
				INNER JOIN EngTestingandCommissioningTxnDet		AS	TandCDet			WITH(NOLOCK)	ON Asset.TestingandCommissioningDetId	=	TandCDet.TestingandCommissioningDetId
				INNER JOIN EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)	ON TandCDet.TestingandCommissioningId	=	TandC.TestingandCommissioningId
				INNER JOIN	MstContractorandVendor				AS	MstContractor		WITH(NOLOCK)	ON TandC.ContractorId					=	MstContractor.ContractorId
				OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
							FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
							WHERE MstContractor.ContractorId	=	ContractorDet.ContractorId) AS 	CContactInfo
		WHERE	Asset.AssetId		=	@pAssetId
		ORDER BY	Asset.ModifiedDate ASC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
	END
	--	2	LAR
	SELECT	@TotalRecords	=	COUNT(*)
 	FROM	EngAssetSupplierWarranty						AS	SupplierWarranty	WITH(NOLOCK)
			INNER JOIN	EngAsset							AS	Asset				WITH(NOLOCK)	ON Asset.AssetId					=	SupplierWarranty.AssetId
			INNER JOIN	MstContractorandVendor				AS	MstContractor		WITH(NOLOCK)	ON SupplierWarranty.ContractorId	=	MstContractor.ContractorId
				OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
							FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
							WHERE MstContractor.ContractorId	=	ContractorDet.ContractorId) AS 	CContactInfo
			INNER JOIN	FMLovMst							AS	LovCategory			WITH(NOLOCK)	ON SupplierWarranty.Category		=	LovCategory.LovId
	WHERE	SupplierWarranty.AssetId		=	@pAssetId
			AND SupplierWarranty.Category	=	@pLovIdSupplierCategoryLAR
print 'c'
    SELECT	Asset.CustomerId						AS	CustomerId,	
			Asset.FacilityId						AS	FacilityId,
			SupplierWarranty.SupplierWarrantyId		AS	SupplierWarrantyId,
			SupplierWarranty.Category				AS	CategoryLovId,
			LovCategory.FieldValue					AS	CategoryLovName,
			MstContractor.ContractorId				AS	ContractorId,
			MstContractor.SSMRegistrationCode		AS	SSMRegistrationCode,
			MstContractor.ContractorName			AS	ContractorName,
			CContactInfo.ContactPerson						AS	ContactPerson,
			CContactInfo.ContactNo					AS	TelephoneNo,
			CContactInfo.Email						AS	Email,
			MstContractor.FaxNo						AS	FaxNo,
			MstContractor.[Address]					AS	[Address],
			@TotalRecords							AS TotalRecords
 	FROM	EngAssetSupplierWarranty						AS	SupplierWarranty	WITH(NOLOCK)
			INNER JOIN	EngAsset							AS	Asset				WITH(NOLOCK)	ON Asset.AssetId					=	SupplierWarranty.AssetId
			INNER JOIN	MstContractorandVendor				AS	MstContractor		WITH(NOLOCK)	ON SupplierWarranty.ContractorId	=	MstContractor.ContractorId
			OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
							FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
							WHERE MstContractor.ContractorId	=	ContractorDet.ContractorId) AS 	CContactInfo
			INNER JOIN	FMLovMst							AS	LovCategory			WITH(NOLOCK)	ON SupplierWarranty.Category		=	LovCategory.LovId
	WHERE	SupplierWarranty.AssetId		=	@pAssetId
			AND SupplierWarranty.Category	=	@pLovIdSupplierCategoryLAR
	ORDER BY	SupplierWarranty.ModifiedDate ASC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

	--	3	Third Party
	SELECT	@TotalRecords	=	COUNT(*)
 	FROM	EngAssetSupplierWarranty						AS	SupplierWarranty	WITH(NOLOCK)
			INNER JOIN	EngAsset							AS	Asset				WITH(NOLOCK)	ON Asset.AssetId					=	SupplierWarranty.AssetId
			INNER JOIN	MstContractorandVendor				AS	MstContractor		WITH(NOLOCK)	ON SupplierWarranty.ContractorId	=	MstContractor.ContractorId
				OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
							FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
							WHERE MstContractor.ContractorId	=	ContractorDet.ContractorId) AS 	CContactInfo
			INNER JOIN	FMLovMst							AS	LovCategory			WITH(NOLOCK)	ON SupplierWarranty.Category		=	LovCategory.LovId
	WHERE	SupplierWarranty.AssetId		=	@pAssetId
			AND SupplierWarranty.Category	=	@pLovIdSupplierCategoryThirdParty

    SELECT	Asset.CustomerId						AS	CustomerId,	
			Asset.FacilityId						AS	FacilityId,
			SupplierWarranty.SupplierWarrantyId		AS	SupplierWarrantyId,
			SupplierWarranty.Category				AS	CategoryLovId,
			LovCategory.FieldValue					AS	CategoryLovName,
			MstContractor.ContractorId				AS	ContractorId,
			MstContractor.SSMRegistrationCode		AS	SSMRegistrationCode,
			MstContractor.ContractorName			AS	ContractorName,
			CContactInfo.ContactPerson						AS	ContactPerson,
			CContactInfo.ContactNo					AS	TelephoneNo,
			CContactInfo.Email						AS	Email,
			MstContractor.FaxNo						AS	FaxNo,
			MstContractor.[Address]					AS	[Address],
			@TotalRecords							AS TotalRecords
 	FROM	EngAssetSupplierWarranty						AS	SupplierWarranty	WITH(NOLOCK)
			INNER JOIN	EngAsset							AS	Asset				WITH(NOLOCK)	ON Asset.AssetId					=	SupplierWarranty.AssetId
			INNER JOIN	MstContractorandVendor				AS	MstContractor		WITH(NOLOCK)	ON SupplierWarranty.ContractorId	=	MstContractor.ContractorId
				OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
							FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
							WHERE MstContractor.ContractorId	=	ContractorDet.ContractorId) AS 	CContactInfo
			INNER JOIN	FMLovMst							AS	LovCategory			WITH(NOLOCK)	ON SupplierWarranty.Category		=	LovCategory.LovId
	WHERE	SupplierWarranty.AssetId		=	@pAssetId
			AND SupplierWarranty.Category	=	@pLovIdSupplierCategoryThirdParty
	ORDER BY	SupplierWarranty.ModifiedDate ASC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 



	SELECT	AssetId,
			WarrantyStartDate,
			WarrantyEndDate,
			WarrantyDuration,
			PurchaseCostRM
	FROM EngAsset 
	WHERE AssetId	=	@pAssetId

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
