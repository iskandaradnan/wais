USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetStandardization_Delete]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetStandardization_Delete
Description			: To Delete Asset Standardization details
Authors				: Dhilip V
Date				: 16-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_EngAssetStandardization_Delete  @pAssetStandardizationId	= 1
SELECT * FROM EngAssetStandardization
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetStandardization_Delete]   
                      
	@pAssetStandardizationId INT	
AS                                              

BEGIN TRY

DECLARE @AssetTypeCodeId INT, @ModelId INT, @ManufacturerId INT, @RecordCount INT

SELECT @AssetTypeCodeId = AssetTypeCodeId, @ModelId = ModelId, @ManufacturerId = ManufacturerId 
FROM EngAssetStandardization WHERE AssetStandardizationId	= @pAssetStandardizationId

SELECT @RecordCount = COUNT(1) FROM EngAssetPPMCheckList WHERE AssetTypeCodeId = @AssetTypeCodeId AND ModelId = @ModelId AND ManufacturerId = @ManufacturerId 



IF exists (select 1 from EngAsset  where AssetStandardizationId = @pAssetStandardizationId)
BEGIN
SELECT 'This record can''t be deleted as it is referenced by another screen'	AS ErrorMessage
END
ELSE  if exists (select 1 from EngEODParameterMapping WHERE AssetTypeCodeId = @AssetTypeCodeId AND ModelId = @ModelId AND ManufacturerId = @ManufacturerId)
BEGIN
SELECT 'This record can''t be deleted as it is referenced by another screen'	AS ErrorMessage
END
ELSE  if exists (select 1 from EngPPMRegisterMst WHERE AssetTypeCodeId = @AssetTypeCodeId AND ModelId = @ModelId AND ManufacturerId = @ManufacturerId)
BEGIN
SELECT 'This record can''t be deleted as it is referenced by another screen'	AS ErrorMessage
END
ELSE  if exists (select 1 from EngSpareParts WHERE AssetTypeCodeId = @AssetTypeCodeId AND ModelId = @ModelId AND ManufacturerId = @ManufacturerId)
BEGIN
SELECT 'This record can''t be deleted as it is referenced by another screen'	AS ErrorMessage
END
ELSE  if exists (select 1 from EngTestingandCommissioningTxn WHERE AssetTypeCodeId = @AssetTypeCodeId AND ModelId = @ModelId AND ManufacturerId = @ManufacturerId)
BEGIN
SELECT 'This record can''t be deleted as it is referenced by another screen'	AS ErrorMessage
END
ELSE
IF @RecordCount > 0
BEGIN 
SELECT 'This record can''t be deleted as it is referenced by another screen'	AS ErrorMessage
END 
ELSE
BEGIN
	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DELETE FROM EngAssetStandardization WHERE AssetStandardizationId	= @pAssetStandardizationId


	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   

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
