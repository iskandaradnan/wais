USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_NotificationTemplate_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_NotificationTemplate_GetById
Description			: Get the Notification Template
Authors				: Dhilip V
Date				: 12-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_NotificationTemplate_GetById @pNotificationTemplateId=1

SELECT * FROM NotificationTemplate
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_NotificationTemplate_GetById]

	@pNotificationTemplateId			[INT]

AS 


BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

	DECLARE @Table TABLE (ID INT)

	SELECT	NotificationTemplateId,
			Name,
			Definition,
			TypeId,
			IsActive,
			Subject,
			ServiceId,
			AllowCustomToIds,
			AllowCustomCcIds,
			LeastEntityLevel,
			IsConfigurable,
			Timestamp
	FROM	NotificationTemplate
	WHERE	NotificationTemplateId	=	@pNotificationTemplateId

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW;

END CATCH
SET NOCOUNT OFF
END
GO
