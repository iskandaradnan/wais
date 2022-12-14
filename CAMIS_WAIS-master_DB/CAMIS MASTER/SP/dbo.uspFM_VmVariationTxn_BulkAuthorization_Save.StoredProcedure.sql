USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VmVariationTxn_BulkAuthorization_Save]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_VmVariationTxn_BulkAuthorization_Save
Description			: Get the variation details for bulk authorization.
Authors				: Dhilip V
Date				: 26-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @VmVariationTxn [dbo].udt_VmVariationTxn
INSERT INTO @VmVariationTxn ([VariationId],	[SNFDocumentNo],[AssetId],[AuthorizedStatus],[UserId]) 
VALUES (1,'SNF101',1,1 ,1) 
EXEC uspFM_VmVariationTxn_BulkAuthorization_Save @VmVariationTxn
SELECT * FROM @VmVariationTxn 
SELECT AuthorizedStatus,IsMonthClosed,* FROM VmVariationTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_VmVariationTxn_BulkAuthorization_Save] 
                          
  @VmVariationTxn [dbo].udt_VmVariationTxn	READONLY

AS                                               

BEGIN TRY


	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

-- Default Values


-- Execution

	UPDATE Variation SET	Variation.AuthorizedStatus	=	udtVariation.AuthorizedStatus,
							Variation.IsMonthClosed		=	1,
							Variation.ModifiedBy		=	udtVariation.UserId,
							Variation.ModifiedDate		=	GETDATE(),
							Variation.ModifiedDateUTC	=	GETUTCDATE()
					FROM	VmVariationTxn					AS Variation	
							INNER JOIN @VmVariationTxn		AS udtVariation	ON	Variation.VariationId	=	udtVariation.VariationId	--AND	Variation.AssetId	=	udtVariation.AssetId

	UPDATE Asset SET		Asset.[Authorization]	=	199,
							Asset.ModifiedBy		=	udtVariation.UserId,
							Asset.ModifiedDate		=	GETDATE(),
							Asset.ModifiedDateUTC	=	GETUTCDATE()
					FROM	EngAsset						AS Asset	
							INNER JOIN @VmVariationTxn		AS udtVariation	ON	Asset.AssetId	=	udtVariation.AssetId



    
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
