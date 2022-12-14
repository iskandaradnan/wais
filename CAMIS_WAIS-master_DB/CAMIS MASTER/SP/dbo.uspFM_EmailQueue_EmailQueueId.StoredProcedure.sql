USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EmailQueue_EmailQueueId]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EmailQueue_EmailQueueId
Description			: Datetime updation for send and fail emails
Authors				: DHILIP V
Date				: 27-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EmailQueue_EmailQueueId] @pStatus=1,@pPriority=NULL,@pRetrieveEmail=10

SELECT * FROM EmailQueue
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/


CREATE PROCEDURE  [dbo].[uspFM_EmailQueue_EmailQueueId]

	@pStatus		INT			=	NULL,
	@pSentOn		DATETIME	=	NULL,
	@pFailedOn		DATETIME	=	NULL,
	@pFailCount		INT			=	NULL,
	@pFlag			INT			=	NULL,
	@pEmailQueueId	INT

AS                                              

BEGIN TRY



-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @EmailQTable TABLE (ID INT)

-- Default Values
	IF (ISNULL(@pFailCount,'') = '')
	SET @pFailCount=0

-- Execution

	IF(@pFlag=3)	-- Success

		BEGIN
			UPDATE EmailQueue	SET Status			=	3,
									SentOn			=	@pSentOn,
									ModifiedDate	=	GETDATE()
			WHERE EmailQueueId	=	@pEmailQueueId
		END

	ELSE IF(@pFlag=2)		-- Failed

		BEGIN
			UPDATE EmailQueue	SET	Status			=	2,
									FailedOn		=	@pFailedOn,
									FailCount		=	ISNULL(@pFailCount,0),
									ModifiedDate	=	GETDATE()
			WHERE EmailQueueId	=	@pEmailQueueId
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
