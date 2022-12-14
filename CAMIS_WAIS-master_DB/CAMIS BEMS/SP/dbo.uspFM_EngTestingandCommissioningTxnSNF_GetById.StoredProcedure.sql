USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTestingandCommissioningTxnSNF_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngTestingandCommissioningTxnSNF_GetById
Description			: To Get the data from table EngTestingandCommissioningTxnSNF using the Primary Key id
Authors				: DHILIP V
Date				: 05-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngTestingandCommissioningTxnSNF_GetById] @pAssetId=1
SELECT * FROM EngTestingandCommissioningTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngTestingandCommissioningTxnSNF_GetById]
                     
  @pAssetId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT	TestingandCommissioning.TestingandCommissioningId					AS TestingandCommissioningId,
			TestingandCommissioning.CustomerId									AS CustomerId,
			TestingandCommissioning.FacilityId									AS FacilityId,
			TestingandCommissioning.ServiceId									AS ServiceId,
			ServiceKey.ServiceKey												AS ServiceKeyName,
			TestingandCommissioning.TandCDocumentNo								AS SNFDocumentNo,
			TestingandCommissioning.TandCDate									AS TandCDate,
			Asset.AssetId,
			Asset.AssetNo,
			Asset.AssetDescription,
			TestingandCommissioning.PurchaseCost								AS PurchaseCost,
			TestingandCommissioning.PurchaseDate								AS PurchaseDate,
			TestingandCommissioning.ServiceStartDate							AS ServiceStartDate,
			TestingandCommissioning.ServiceEndDate								AS ServiceEndDate,
			TestingandCommissioning.VariationStatus								AS VariationStatus,
			VariationStatus.FieldValue											AS VariationStatusName,
			TestingandCommissioning.Remarks										AS Remarks,
			--TestingandCommissioningDet.AssetPreRegistrationNo					AS AssetPreRegistrationNo
			TestingandCommissioning.Timestamp									AS [Timestamp]
	FROM	EngTestingandCommissioningTxn										AS TestingandCommissioning		WITH(NOLOCK)
			INNER JOIN  EngAsset												AS Asset						WITH(NOLOCK)			on TestingandCommissioning.AssetId	= Asset.AssetId
			INNER JOIN	MstService												AS ServiceKey					WITH(NOLOCK)			on TestingandCommissioning.ServiceId						= ServiceKey.ServiceId
			LEFT JOIN	FMLovMst												AS VariationStatus				WITH(NOLOCK)			on TestingandCommissioning.VariationStatus					= VariationStatus.LovId
	WHERE	TestingandCommissioning.AssetId = @pAssetId
			AND IsSNF =1
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
