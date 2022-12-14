USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UserRegistration_UserEmailCheck]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UserRegistration_UserEmailCheck
Description			: Asset Duplicate check
Authors				: Dhilip V
Date				: 11-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
Declare @IsInvalidEmail BIT 
Exec [uspFM_UserRegistration_UserEmailCheck] @pEmail='34saed@gmail.com',@IsInvalidEmail=@IsInvalidEmail OUT
SELECT @IsInvalidEmail

SELECT * FROM UMUserRegistration
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_UserRegistration_UserEmailCheck]

	@pEmail NVARCHAR(100),
	@IsInvalidEmail BIT OUTPUT

	
AS 

BEGIN TRY

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	SET @IsInvalidEmail = 1;
	DECLARE @Cnt INT;


	SELECT @Cnt = COUNT(1) FROM UMUserRegistration WHERE ( Email IS NOT NULL AND LEN(Email)>4) AND Email = @pEmail

	IF (@Cnt = 0) 
		SET @IsInvalidEmail = 1;
	ELSE 
		SET @IsInvalidEmail = 0;
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
GO
