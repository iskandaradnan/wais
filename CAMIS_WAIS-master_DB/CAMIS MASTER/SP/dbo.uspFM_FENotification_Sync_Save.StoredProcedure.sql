USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FENotification_Sync_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetSupplierWarranty_Save
Description			: If User Area Code already exists then update else insert.
Authors				: Dhilip V
Date				: 06-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_FENotification_Sync_Save @pUserId=1,@pStartDateTime='2018-06-02 00:08:00.793',@pEndDateTime='2018-06-02 23:08:00.793',@pSyncWithMobile=1
SELECT * FROM FENotification
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_FENotification_Sync_Save]

	@pUserId			INT,
	@pInRecord nvarchar(1000) = null
		
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
 

		UPDATE	 FENotification SET SyncWithMobile	=	1,
									ModifiedBy		=	@pUserId,
									ModifiedDate	=	GETDATE(),
									ModifiedDateUTC	=	GETUTCDATE()
								OUTPUT INSERTED.NotificationId INTO @Table
				WHERE	( ISNULL(CreatedBy,0)	=	@pUserId OR ISNULL(ModifiedBy,0)	= @pUserId )
						AND FENotification.NotificationId  IN  (SELECT Item FROM dbo.SplitString(@pInRecord,',')) 

		DELETE FROM QueueWebtoMobile  WHERE QueueWebtoMobile.Tableprimaryid IN  (SELECT Item FROM dbo.SplitString(@pInRecord,','))  
						AND QueueWebtoMobile.TableName='FENotification'

		SELECT	NotificationId,
				[Timestamp]
		FROM	FENotification
		WHERE	NotificationId IN (SELECT ID FROM @Table)
		

	

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
