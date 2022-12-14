USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_AssetQRCode_Report]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMaintenanceWorkOrderTxn_Save
Description			: If Maintenance Work Order already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXECUTE [uspFM_AssetQRCode_Report] @pFacilityId=1

select * from QRCodeAsset
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_AssetQRCode_Report]
	@pFacilityId INT = NULL	
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @mBatchId INT

	SELECT @mBatchId	=	MAX(cast(BatchGenerated as int))  FROM QRCodeAsset WHERE FacilityId	=	@pFacilityId


	SELECT	B.AssetNo +' '+'+'+' '+ CAST(B.GuId AS NVARCHAR(MAX)) AS SequenceNo,
			B.AssetNo,
			TypeCode.AssetTypeDescription AS AssetTypeDescription,
			D.FacilityName,
			B.QRCode,
			E.FieldValue	AS	ContractType
	FROM	QRCodeAsset A 
			INNER JOIN EngAsset B ON A.AssetId = B.AssetId
			INNER JOIN EngAssetTypeCode TypeCode ON TypeCode.AssetTypeCodeId=B.AssetTypeCodeId
			INNER JOIN MstLocationFacility D ON A.FacilityId = D.FacilityId
			INNER JOIN MstCustomer C ON C.CustomerId = b.CustomerId 
			LEFT JOIN FMLovMst E ON B.ContractType = E.LovId 
	WHERE	A.BatchGenerated	= @mBatchId
			AND  A.FacilityId	=	@pFacilityId
	ORDER BY A.QRCodeAssetId



	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
        END
		
END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
THROW;
END CATCH
GO
