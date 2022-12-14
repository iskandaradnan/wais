USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMRole_GetByStatus]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UMRole_GetByStatus
Description			: Get the status for Role
Authors				: Dhilip V
Date				: 25-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
Declare @IsActive BIT 
EXEC uspFM_UMRole_GetByStatus  @pUserRoleId =1,@IsActive=@IsActive
SELECT @IsActive
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UMRole_GetByStatus]        
                   
  @pUserRoleId 		INT,
  @IsActive BIT OUTPUT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution

	SET @IsActive	=	0;
	DECLARE @Cnt INT	=	0;

	SET @Cnt = (SELECT COUNT(*) FROM UMUserRole WHERE Status	=	1 AND UMUserRoleId = @pUserRoleId)

	IF (@Cnt = 0) SET @IsActive = 0;
	ELSE SET @IsActive = 1;

	--SELECT * FROM UMUserRole
	--SELECT COUNT(*) FROM UMUserRole WHERE Status	=	1 AND UMUserRoleId = 1

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
