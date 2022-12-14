USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetTypeCode_Delete]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetTypeCode_Delete
Description			: Delete the assetno in asset screen
Authors				: Dhilip V
Date				: 20-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetTypeCode_Delete  @pAssetTypeCodeId=2

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetTypeCode_Delete]                           
	@pAssetTypeCodeId	INT	
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Execution
	
	--1) EngAssetTypeCodeAddSpecification
		DELETE FROM  EngAssetTypeCodeAddSpecification WHERE AssetTypeCodeId	= @pAssetTypeCodeId

	--2) EngAssetTypeCodeFlag
		DELETE FROM  EngAssetTypeCodeFlag WHERE AssetTypeCodeId	= @pAssetTypeCodeId

	--3) EngAssetTypeCodeVariationRate
		DELETE FROM  EngAssetTypeCodeVariationRate WHERE AssetTypeCodeId	= @pAssetTypeCodeId

	--4) EngAssetTypeCode
		DELETE FROM  EngAssetTypeCode WHERE AssetTypeCodeId	= @pAssetTypeCodeId

	SELECT ''	AS ErrorMessage

	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   


END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

	SELECT 'This record can''t be deleted as it is referenced by another screen'	AS ErrorMessage

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
