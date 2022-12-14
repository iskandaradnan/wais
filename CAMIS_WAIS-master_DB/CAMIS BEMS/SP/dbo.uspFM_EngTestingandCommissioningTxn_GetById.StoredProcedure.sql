USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTestingandCommissioningTxn_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngTestingandCommissioningTxn_GetById
Description			: To Get the data from table EngTestingandCommissioningTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngTestingandCommissioningTxn_GetById] @pTestingandCommissioningId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details

Edit by : Pranay (for typeofservice and batchno) 24-10-2019
          Pranay (Designation) 24-01-2020
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngTestingandCommissioningTxn_GetById]
                     
  @pTestingandCommissioningId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT	TestingandCommissioning.TestingandCommissioningId					AS TestingandCommissioningId,
			TestingandCommissioning.CustomerId									AS CustomerId,
			TestingandCommissioning.FacilityId									AS FacilityId,
			TestingandCommissioning.ServiceId									AS ServiceId,
			ServiceKey.ServiceKey												AS ServiceKeyName,
			TestingandCommissioning.TandCDocumentNo								AS TandCDocumentNo,
			TestingandCommissioning.TandCDate									AS TandCDate,
			TestingandCommissioning.TandCDateUTC								AS TandCDateUTC,
			TestingandCommissioning.AssetTypeCodeId								AS AssetTypeCodeId,
			AssetTypeCode.AssetTypeCode											AS AssetTypeCode,
			AssetTypeCode.AssetTypeDescription									AS AssetTypeDescription,
			TestingandCommissioning.TandCStatus									AS TandCStatus,
			TandCStatus.FieldValue												AS TandCStatusName,
			TestingandCommissioning.TandCCompletedDate							AS TandCCompletedDate,
			TestingandCommissioning.TandCCompletedDateUTC						AS TandCCompletedDateUTC,
			TestingandCommissioning.HandoverDate								AS HandoverDate,
			TestingandCommissioning.HandoverDateUTC								AS HandoverDateUTC,
			TestingandCommissioning.PurchaseCost								AS PurchaseCost,
			TestingandCommissioning.PurchaseDate								AS PurchaseDate,
			TestingandCommissioning.PurchaseDateUTC								AS PurchaseDateUTC,
			TestingandCommissioning.ServiceStartDate							AS ServiceStartDate,
			TestingandCommissioning.ServiceStartDateUTC							AS ServiceStartDateUTC,
			TestingandCommissioning.ContractLPONo								AS ContractLPONo,
			TestingandCommissioning.VariationStatus								AS VariationStatus,
			VariationStatus.FieldValue											AS VariationStatusName,
			TestingandCommissioning.TypeOfService                               AS TypeOfService,
			TypeOfService.FieldValue                                            AS TypeOfService,
			TestingandCommissioning.BatchNo                                     AS BatchNo,
			BatchNo.FieldValue                                                  AS BatchNo,
			TestingandCommissioning.TandCContractorRepresentative				AS TandCContractorRepresentative,
			TestingandCommissioning.CustomerRepresentativeUserId				AS CustomerRepresentativeUserId,
			CustomerRepresentative.StaffName									AS CustomerRepresentativeName,
			TestingandCommissioning.FacilityRepresentativeUserId				AS FacilityRepresentativeUserId,
			FacilityRepresentative.StaffName									AS FacilityRepresentativeName,
			Designation                                                         As Designation,
			TestingandCommissioning.UserAreaId									AS UserAreaId,
			LocationUserArea.UserAreaCode										AS UserAreaCode,
			LocationUserArea.UserAreaName										AS UserAreaName,
			TestingandCommissioning.UserLocationId								AS UserLocationId,
			LocationUserLocation.UserLocationCode								AS UserLocationCode,
			LocationUserLocation.UserLocationName								AS UserLocationName,
			TestingandCommissioning.Remarks										AS Remarks,
			TestingandCommissioning.WarrantyDuration							AS WarrantyDuration,
			TestingandCommissioning.WarrantyStartDate							AS WarrantyStartDate,
			TestingandCommissioning.WarrantyStartDateUTC						AS WarrantyStartDateUTC,
			TestingandCommissioning.WarrantyEndDate								AS WarrantyEndDate,
			TestingandCommissioning.WarrantyEndDateUTC							AS WarrantyEndDateUTC,
			CASE
				WHEN TestingandCommissioning.WarrantyEndDate >=	GETDATE()	THEN '99'
				WHEN TestingandCommissioning.WarrantyEndDate <	GETDATE()	THEN '100'
				ELSE	NULL	
			END																	AS WarrantyStatus,
			TestingandCommissioning.MainSupplierCode							AS MainSupplierCode,
			TestingandCommissioning.MainSupplierName							AS MainSupplierName,
			TestingandCommissioning.ServiceEndDate								AS ServiceEndDate,
			TestingandCommissioning.ServiceEndDateUTC							AS ServiceEndDateUTC,
			TestingandCommissioningDet.AssetPreRegistrationNo					AS AssetPreRegistrationNo,
			TestingandCommissioning.Status										AS Status,
			TestingandCommissioning.VerifyRemarks								AS VerifyRemarks,
			TestingandCommissioning.ApprovalRemarks								AS ApprovalRemarks,
			TestingandCommissioning.RejectRemarks								AS RejectRemarks,
			--CASE WHEN TestingandCommissioning.Status = 290 THEN 'Approved'
			--	 WHEN TestingandCommissioning.Status = 291 THEN 'Rejected'
			--	 WHEN TestingandCommissioning.Status = 289 THEN 'Verified'
			--	 WHEN ISNULL(TestingandCommissioning.Status,0) = 286 THEN 'Submitted'
			--	 WHEN ISNULL(TestingandCommissioning.Status,0) = 287 THEN 'Cancelled'
			--END StatusName,

			LovActions.FieldValue												AS StatusName,
			TestingandCommissioning.[Timestamp]									AS [Timestamp],
			TestingandCommissioning.QRCode										AS	QRCode,
			TestingandCommissioning.AssetCategoryLovId,
			LovAssetCategory.FieldValue										AS	AssetCategoryName,
			Manufacturer.ManufacturerId											AS	ManufacturerId,
			Manufacturer.Manufacturer											AS	Manufacturer,
			Model.Model															AS	Model,
			Model.ModelId													    AS	ModelId,
			TestingandCommissioning.AssetNoOld									AS	AssetNoOld,
			TestingandCommissioning.SerialNo									AS	SerialNo,
			TestingandCommissioning.PONo										AS	PONo,

			RequiredCompletionDate,
			Level.LevelName,
			Block.BlockName,
			TestingandCommissioning.PurchaseOrderNo,
			TestingandCommissioning.[GuId]										AS GuId,
			TestingandCommissioning.Field1,
			TestingandCommissioning.Field2,
			TestingandCommissioning.Field3,
			TestingandCommissioning.Field4,
			TestingandCommissioning.Field5,
			TestingandCommissioning.Field6,
			TestingandCommissioning.Field7,
			TestingandCommissioning.Field8,
			TestingandCommissioning.Field9,
			TestingandCommissioning.Field10,
			TestingandCommissioning.ContractorId,
			Contractor.ContractorName,
			Contractor.SSMRegistrationCode AS ContractorCode,
			CAST(PreRegUsed.IsUsed AS  BIT) AS IsUsed,
			TestingandCommissioning.CRMRequestId		AS CRMRequestId,
			Request.RequestNo							AS RequestNo,
			TestingandCommissioning.RequestDate,
			TestingandCommissioning.RequestDateUTC
	FROM	EngTestingandCommissioningTxn										AS TestingandCommissioning		WITH(NOLOCK)
			LEFT JOIN  EngTestingandCommissioningTxnDet							AS TestingandCommissioningDet	WITH(NOLOCK)			on TestingandCommissioningDet.TestingandCommissioningId		= TestingandCommissioning.TestingandCommissioningId
			INNER JOIN	MstService												AS ServiceKey					WITH(NOLOCK)			on TestingandCommissioning.ServiceId						= ServiceKey.ServiceId
			LEFT  JOIN	EngAssetTypeCode										AS AssetTypeCode				WITH(NOLOCK)			on TestingandCommissioning.AssetTypeCodeId					= AssetTypeCode.AssetTypeCodeId
			LEFT JOIN	UMUserRegistration										AS CustomerRepresentative		WITH(NOLOCK)			on TestingandCommissioning.CustomerRepresentativeUserId		= CustomerRepresentative.UserRegistrationId
			LEFT JOIN	UMUserRegistration										AS FacilityRepresentative		WITH(NOLOCK)			on TestingandCommissioning.FacilityRepresentativeUserId		= FacilityRepresentative.UserRegistrationId
			LEFT  JOIN	MstLocationUserArea										AS LocationUserArea				WITH(NOLOCK)			on TestingandCommissioning.UserAreaId						= LocationUserArea.UserAreaId
			LEFT JOIN UserDesignation                                           AS Designation                  WITH(NOLOCK)            ON FacilityRepresentative.UserDesignationId                 = Designation.UserDesignationId						
			LEFT  JOIN	MstLocationUserLocation									AS LocationUserLocation			WITH(NOLOCK)			on TestingandCommissioning.UserLocationId					= LocationUserLocation.UserLocationId
			INNER JOIN	FMLovMst												AS TandCStatus					WITH(NOLOCK)			on TestingandCommissioning.TandCStatus						= TandCStatus.LovId
			LEFT JOIN	FMLovMst												AS VariationStatus				WITH(NOLOCK)			on TestingandCommissioning.VariationStatus					= VariationStatus.LovId
			LEFT JOIN	FMLovMst												AS LovActions					WITH(NOLOCK)			on TestingandCommissioning.Status							= LovActions.LovId
			LEFT JOIN	FMLovMst												AS LovAssetCategory				WITH(NOLOCK)			on TestingandCommissioning.AssetCategoryLovId				= LovAssetCategory.LovId
			LEFT  JOIN	EngAssetStandardizationManufacturer						AS Manufacturer					WITH(NOLOCK)			on TestingandCommissioning.ManufacturerId					= Manufacturer.ManufacturerId
			LEFT  JOIN	EngAssetStandardizationModel							AS Model						WITH(NOLOCK)			on TestingandCommissioning.ModelId							= Model.ModelId
			LEFT  JOIN	MstLocationLevel										AS Level						WITH(NOLOCK)			on LocationUserLocation.LevelId								= Level.LevelId
			LEFT  JOIN	MstLocationBlock										AS Block						WITH(NOLOCK)			on LocationUserLocation.BlockId								= Block.BlockId
			LEFT  JOIN	MstContractorandVendor									AS Contractor					WITH(NOLOCK)			on TestingandCommissioning.ContractorId						= Contractor.ContractorId
			LEFT  JOIN	CRMRequest												AS Request						WITH(NOLOCK)			on TestingandCommissioning.CRMRequestId						= Request.CRMRequestId
			LEFT JOIN FMLovMst                                                 AS TypeOfService                WITH(NOLOCK)            on TestingandCommissioning.TypeOfService	                =TypeOfService.LovId
			LEFT JOIN FMLovMst                                                 AS BatchNo                      WITH(NOLOCK)            on TestingandCommissioning.BatchNo                          =BatchNo.LovId 
			OUTER APPLY (	SELECT  CASE WHEN COUNT(1)>0 THEN 1 
									ELSE 0 END AS IsUsed
							FROM EngAsset AS A WHERE  A.TestingandCommissioningDetId=TestingandCommissioningDet.TestingandCommissioningDetId
						 ) PreRegUsed
	WHERE	TestingandCommissioning.TestingandCommissioningId = @pTestingandCommissioningId 
	ORDER BY TestingandCommissioning.ModifiedDate ASC

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
