USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_UMUserRegistrationUPChecking_GetById]    Script Date: 20-09-2021 17:05:52 ******/
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
EXEC [UspFM_UMUserRegistrationUPChecking_GetById] @pUserRegistrationId=1,@pPassword='lg7J6YCogK2HOSZQzjkKwUMkYcgG6WY61wXJhiHbsa9YQN3c6e1h1ysjzG4='
select * from UMUserShifts
select * from UMUserShiftsDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_UMUserRegistrationUPChecking_GetById]                           

  @pUserRegistrationId		INT,
  @pPassword				NVARCHAR(max)


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	IF(ISNULL(@pUserRegistrationId,0) = 0) RETURN


	IF EXISTS (SELECT 1 FROM UMUserRegistration WHERE UserRegistrationId = @pUserRegistrationId AND [Password] = @pPassword)

	BEGIN

	SELECT CAST(1 AS BIT) AS RESULT

	END

	ELSE

	BEGIN

	SELECT CAST(0 AS BIT) AS RESULT

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
		   )

END CATCH
GO
