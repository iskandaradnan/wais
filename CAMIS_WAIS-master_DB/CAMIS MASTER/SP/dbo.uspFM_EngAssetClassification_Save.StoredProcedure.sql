USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetClassification_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetSupplierWarranty_Save
Description			: If staff already exists then update else insert.
Authors				: Balaji M S
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetClassification_Save  @pAssetClassificationId='2',@pServiceId=1,@pAssetClassificationCode='AAA',@pAssetClassificationDescription='Eqp',@pRemarks='Equipment',@pCreatedBy='2',
@pModifiedBy='2',@pActive='1',@pBuiltIn='1'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetClassification_Save]
	
	@pAssetClassificationId					INT,
	@pServiceId								INT,
	@pAssetClassificationCode				NVARCHAR(50),
	@pAssetClassificationDescription		NVARCHAR(200),
	@pRemarks								NVARCHAR(1000),
	@pCreatedBy								INT,
	@pModifiedBy							INT,
	@pActive								INT				=	1,
	@pBuiltIn								INT				=	1

	
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
 

	IF EXISTS (SELECT 1 FROM EngAssetClassification WITH(NOLOCK) WHERE AssetClassificationId=@pAssetClassificationId)

		BEGIN
			UPDATE EngAssetClassification SET														
							ServiceId									=@pServiceId,
							AssetClassificationCode						=@pAssetClassificationCode,
							AssetClassificationDescription				=@pAssetClassificationDescription,
							Remarks										=@pRemarks,									
							Active										=@pActive,							
							ModifiedBy									=@pModifiedBy,
							ModifiedDate								=GETDATE(),
							ModifiedDateUTC								=GETUTCDATE()
					WHERE	AssetClassificationId=@pAssetClassificationId
		END

	ELSE

		BEGIN
			INSERT INTO EngAssetClassification(

								ServiceId,
								AssetClassificationCode,
								AssetClassificationDescription,
								Remarks,
								CreatedBy,
								CreatedDate,
								CreatedDateUTC,
								ModifiedBy,
								ModifiedDate,
								ModifiedDateUTC,								
								Active,
								BuiltIn
							
							
							)	OUTPUT INSERTED.AssetClassificationId INTO @Table
							VALUES
							(
							 @pServiceId,
							 @pAssetClassificationCode,
							 @pAssetClassificationDescription,
							 @pRemarks,
							 @pCreatedBy,
							 GETDATE(),
							 GETUTCDATE(),
							 @pModifiedBy,
							 GETDATE(),
							 GETUTCDATE(),
							 @pActive,
							 @pBuiltIn
							)
		END

		SELECT	AssetClassificationId,
				[Timestamp]
		FROM	EngAssetClassification
		WHERE	AssetClassificationId IN (SELECT ID FROM @Table)

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
		   )

END CATCH
GO
