USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMUserRole_ReferredUserCheck]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UMUserRole_ReferredUserCheck
Description			: Asset Duplicate check
Authors				: Dhilip V
Date				: 19-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
Declare @IsReferenced BIT 
Exec [uspFM_UMUserRole_ReferredUserCheck] @pUMUserRoleId=13,@IsReferenced=@IsReferenced OUT
SELECT @IsReferenced

SELECT * FROM UMUserRegistration
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_UMUserRole_ReferredUserCheck]

	@pUMUserRoleId INT,
	@IsReferenced BIT OUTPUT

	
AS 

BEGIN TRY

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	
	SET @IsReferenced	=	0;
	DECLARE @Cnt INT	=	0;

	SELECT @Cnt = COUNT(1) FROM UMUserRole WHERE UMUserRoleId = @pUMUserRoleId
	AND UMUserRoleId IN (SELECT DISTINCT UserRoleId FROM UMUserLocationMstDet WHERE UMUserRoleId = @pUMUserRoleId)

	IF (@Cnt = 0) SET @IsReferenced = 0;
	ELSE SET @IsReferenced = 1;
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
GO
