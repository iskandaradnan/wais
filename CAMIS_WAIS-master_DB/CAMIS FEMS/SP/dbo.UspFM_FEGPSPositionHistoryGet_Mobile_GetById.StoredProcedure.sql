USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_FEGPSPositionHistoryGet_Mobile_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoAssesmentTxn_GetById
Description			: To Get the data from table EngMwoAssesmentTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_FEGPSPositionHistoryGet_Mobile_GetById] @pUserRegistrationId=32,@pStartDate='2018-07-13 08:33:31.440',@pEndDate='2018-07-13 15:33:31.440'
SELECT GETDATE()
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_FEGPSPositionHistoryGet_Mobile_GetById]                           


@pUserRegistrationId INT,
@pStartDate date,
@pEndDate date


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	SELECT A.UserRegistrationId,B.StaffName,A.DateTime,A.Latitude,A.Longitude
	FROM FEGPSPositionHistory A INNER JOIN UMUserRegistration B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE cast (A.DateTime as date) >= cast (@pStartDate as date)
	AND cast (A.DateTime as date) <= cast (@pEndDate  as date)
	
	AND A.UserRegistrationId =  @pUserRegistrationId



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
