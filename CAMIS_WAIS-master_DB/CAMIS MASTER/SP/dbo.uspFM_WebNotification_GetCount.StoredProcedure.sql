USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WebNotification_GetCount]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_WebNotification_GetCount
Description			: Web Notification alert
Authors				: Dhilip V
Date				: 24-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC [uspFM_WebNotification_GetCount] @pFacilityId=1,@pUserId=1

SELECT * FROM WebNotification
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_WebNotification_GetCount]

	@pFacilityId INT,
	@pUserId INT

AS                                              

BEGIN TRY


-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

-- Default Values


-- Execution

	SELECT COUNT(IsNew) NewCount FROM WebNotification
	WHERE	FacilityId	=	@pFacilityId
			AND UserId	=	@pUserId
			AND IsNew	=	1
	GROUP BY IsNew

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
