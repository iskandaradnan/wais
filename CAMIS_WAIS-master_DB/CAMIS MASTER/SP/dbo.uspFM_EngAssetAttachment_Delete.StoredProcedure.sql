USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetAttachment_Delete]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetAttachment_Delete
Description			: To Delete Attachment for Asset
Authors				: Dhilip V
Date				: 21-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_EngAssetAttachment_Delete  @pAttachmentId	= '1,2'

SELECT * FROM EngAssetAttachment
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetAttachment_Delete]
                         
	@pAttachmentId	NVARCHAR(100)

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @Table TABLE (ID INT)
-- Execution


	INSERT INTO @Table (ID)
	SELECT DocumentId FROM EngAssetAttachment WHERE AttachmentId	 IN (SELECT ITEM FROM dbo.[SplitString] (@pAttachmentId,','))

	DELETE FROM EngAssetAttachment WHERE AttachmentId	 IN (SELECT ITEM FROM dbo.[SplitString] (@pAttachmentId,','))

	DELETE FROM FMDocument WHERE DocumentId IN (SELECT ID FROM @Table)


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
