USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMUserRegistration_Email_DuplicateCheck]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UMUserRegistration_Email_DuplicateCheck
Description			: Asset Duplicate check
Authors				: Dhilip V
Date				: 19-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
Declare @IsDuplicate BIT 
Exec [uspFM_UMUserRegistration_Email_DuplicateCheck] @pUserRegistrationId=0, @pEmail='nbbiju@gmail.com',@IsDuplicate=@IsDuplicate OUT
SELECT @IsDuplicate

SELECT * FROM UMUserRegistration
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_UMUserRegistration_Email_DuplicateCheck]

	@pUserRegistrationId INT,
	@pEmail NVARCHAR(100),
	@IsDuplicate BIT OUTPUT

	
AS 

BEGIN TRY

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	SET @IsDuplicate = 1;
	DECLARE @Cnt INT;

	IF (@pUserRegistrationId = 0)
	SELECT @Cnt = COUNT(1) FROM UMUserRegistration WHERE Email = @pEmail
	ELSE
	SELECT @Cnt = COUNT(1) FROM UMUserRegistration WHERE Email = @pEmail AND UserRegistrationId <> @pUserRegistrationId

	IF (@Cnt = 0) SET @IsDuplicate = 0;
	ELSE SET @IsDuplicate = 1;
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
GO
