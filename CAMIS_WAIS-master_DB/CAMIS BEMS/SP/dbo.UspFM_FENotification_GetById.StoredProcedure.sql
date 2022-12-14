USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_FENotification_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [UspFM_FENotification_GetById]
Description			: To Get the data from table FENotification using the Primary Key id
Authors				: karthick Rajendran
Date				: 02-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_FENotification_GetById] @pUserId=1,@pNotificationId='73,59'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_FENotification_GetById]                           
  @pUserId			INT	=	NULL,
  @pNotificationId	nvarchar(1000) = null

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT	FENotification.NotificationId							AS NotificationId,
			FENotification.NotificationAlerts						AS NotificationAlerts,
			FENotification.Remarks									AS Remarks,
			FENotification.SyncWithMobile							AS SyncWithMobile,
			FENotification.UserId									AS UserRegistrationId,			
			FENotification.CreatedDate								AS CreatedDate,
			FENotification.ScreenName								AS ScreenName,
			FENotification.DocumentId								AS DocumentId,
			FENotification.SingleRecord								AS SingleRecord
	FROM	FENotification											AS FENotification			WITH(NOLOCK)			
			INNER JOIN UMUserRegistration							AS UserRegistration			WITH(NOLOCK)		ON FENotification.UserId	= UserRegistration.UserRegistrationId			
	WHERE	FENotification.UserId = @pUserId  and FENotification.SyncWithMobile = 0
			and 
			FENotification.NotificationId in (select Item from dbo.[SplitString] (@pNotificationId,','))   
	

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
