USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstLocationUserLocationQR_Update]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstLocationUserLocationQR_Update
Description			: Update the generated QR Code for existing User Location.
Authors				: DHILIP V
Date				: 03-August-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_MstLocationUserLocationQR_Update] @pUserLocationId=1,@pQRCode=NULL

SELECT QRCode,* FROM MstLocationUserLocation WHERE UserLocationId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/


CREATE PROCEDURE  [dbo].[uspFM_MstLocationUserLocationQR_Update]
		
			@pUserLocationId		INT,
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

 

		UPDATE MstLocationUserLocation SET QRCode	=	@pQRCode
		WHERE	UserLocationId	=	@pUserLocationId

		SELECT	UserLocationId,
				[Timestamp]
		FROM	MstLocationUserLocation
		WHERE	UserLocationId =	@pUserLocationId

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
