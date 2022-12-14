USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UserRegistration_UserCheck]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UserRegistration_UserCheck
Description			: Asset Duplicate check
Authors				: Dhilip V
Date				: 11-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
Declare @IsInvalid BIT 
Exec [uspFM_UserRegistration_UserCheck] @pUserName='superadmin',@IsInvalid=@IsInvalid OUT
SELECT @IsInvalid

SELECT * FROM UMUserRegistration
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_UserRegistration_UserCheck]

	@pUserName NVARCHAR(100),
	@IsInvalid BIT OUTPUT

	
AS 

BEGIN TRY

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	SET @IsInvalid = 1;
	DECLARE @Cnt INT;


	SELECT @Cnt = COUNT(1) FROM UMUserRegistration WHERE UserName = @pUserName

	IF (@Cnt = 0) 
		SET @IsInvalid = 1;
	ELSE 
		SET @IsInvalid = 0;
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
GO
