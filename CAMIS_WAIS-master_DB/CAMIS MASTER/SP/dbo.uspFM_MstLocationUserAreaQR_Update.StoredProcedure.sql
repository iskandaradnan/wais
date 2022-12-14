USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstLocationUserAreaQR_Update]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstLocationUserAreaQR_Update
Description			: Update the generated QR Code for existing User Area.
Authors				: DHILIP V
Date				: 03-August-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_MstLocationUserAreaQR_Update] @pUserAreaId=1,@pQRCode=NULL

SELECT QRCode,* FROM MstLocationUserArea WHERE UserAreaId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/


CREATE PROCEDURE  [dbo].[uspFM_MstLocationUserAreaQR_Update]
		
			@pUserAreaId		INT,
			@pQRCode		VARBINARY(MAX)	
AS                                              

BEGIN TRY


-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

-- Default Values


-- Execution


		UPDATE MstLocationUserArea SET QRCode	=	@pQRCode
		WHERE	UserAreaId	=	@pUserAreaId

		SELECT	UserAreaId,
				[Timestamp]
		FROM	MstLocationUserArea
		WHERE	UserAreaId =	@pUserAreaId
 


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
