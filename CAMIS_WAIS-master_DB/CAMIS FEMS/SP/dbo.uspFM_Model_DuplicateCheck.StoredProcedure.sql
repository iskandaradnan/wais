USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Model_DuplicateCheck]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_Model_DuplicateCheck 
Description			: Asset Duplicate check
Authors				: Dhilip V
Date				: 04-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
Declare @IsDuplicate BIT 
Exec [uspFM_Model_DuplicateCheck] @pModelId=0, @pModel='Hero',@IsDuplicate=@IsDuplicate OUT
SELECT @IsDuplicate

SELECT * FROM EngAssetStandardizationModel
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_Model_DuplicateCheck]

	@pModelId INT,
	@pModel NVARCHAR(100),
	@IsDuplicate BIT OUTPUT

	
AS 

BEGIN TRY

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	SET @IsDuplicate = 1;
	DECLARE @Cnt INT;

	IF (@pModelId = 0)
	SELECT @Cnt = COUNT(1) FROM EngAssetStandardizationModel WHERE Model = @pModel
	ELSE
	SELECT @Cnt = COUNT(1) FROM EngAssetStandardizationModel WHERE Model = @pModel AND ModelId <> @pModelId

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
