USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_UMUserRegistration_Mobile_GetGPSUser]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_PorteringTransaction_GetById
Description			: To Get the data from table PorteringTransaction using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_UMUserRegistration_Mobile_GetGPSUser] 33,'2018-07-04 04:40:56.713' 
select * from FEGPSPositionHistory
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_UMUserRegistration_Mobile_GetGPSUser]                           

			@pUserRegistrationId int,
			@PDatetime datetime

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	


	SELECT	UserRegistration.UserRegistrationId					AS UserRegistrationId,
			UserRegistration.UserName							AS UserName,
			DateTime											AS DateTime,
			GPS.Latitude										AS Latitude,
			GPS.Longitude										AS Longitude
	FROM	UMUserRegistration									AS UserRegistration
	INNER JOIN FEGPSPositionHistory								AS GPS					ON UserRegistration.UserRegistrationId		= gps.UserRegistrationId
	WHERE GPS.UserRegistrationId = @pUserRegistrationId AND GPS.DateTime BETWEEN DATEADD(HOUR,-10,@PDatetime) AND @PDatetime 
	ORDER BY UserRegistration.ModifiedDate ASC


	
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
