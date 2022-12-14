USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UpdateFailEmail_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UpdateFailEmail_Save
Description			: Status update for email fail.
Authors				: DHILIP V
Date				: 27-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_UpdateFailEmail_Save] @pEmailFailTimeOut=10

SELECT * FROM EmailQueue
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/


CREATE PROCEDURE  [dbo].[uspFM_UpdateFailEmail_Save]

	@pEmailFailTimeOut	INT	

AS                                              

BEGIN TRY



-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @mEmailQueueTble TABLE (ID INT, EmailTemplateId INT)
-- Default Values


-- Execution



	DECLARE @Cnt INT;
			
			INSERT INTO @mEmailQueueTble (ID,EmailTemplateId)
			SELECT	EmailQueueId,EmailTemplateId FROM	EmailQueue WHERE Status=4 and GETDATE()	>= DATEADD(MINUTE,@pEmailFailTimeOut,ModifiedDate)

			SELECT	@Cnt = COUNT(1) FROM	@mEmailQueueTble


			IF (@Cnt = 0) 
			
			BEGIN

			  SELECT @Cnt

			END

			ELSE
			BEGIN

			  SELECT @Cnt

			  UPDATE EmailQueue SET Status=1 
									,ModifiedDate=GETDATE()
									,ModifiedDateUTC=GETUTCDATE()  
								OUTPUT INSERTED.EmailQueueId INTO @Table
								WHERE	EmailQueueId	IN	(SELECT ID FROM @mEmailQueueTble)


			END


END TRY

BEGIN CATCH



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
