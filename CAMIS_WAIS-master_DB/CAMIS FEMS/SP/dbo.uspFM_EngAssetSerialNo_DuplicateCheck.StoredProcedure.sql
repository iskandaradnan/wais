USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetSerialNo_DuplicateCheck]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetSerialNo_DuplicateCheck
Description			: Asset - SerialNo Duplicate check
Authors				: Dhilip V
Date				: 16-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
Declare @IsDuplicate BIT 
Exec [uspFM_EngAssetSerialNo_DuplicateCheck] @pAssetId=0, @pSerialNo='sasadasd',@IsDuplicate=@IsDuplicate OUT
SELECT @IsDuplicate

SELECT SerialNo,* FROM EngAsset
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_EngAssetSerialNo_DuplicateCheck]

	@pAssetId INT,
	@pSerialNo NVARCHAR(100),
	@IsDuplicate BIT OUTPUT

	
AS 

BEGIN TRY

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	SET @IsDuplicate = 1;
	DECLARE @Cnt INT;

	IF (@pAssetId = 0)
	SELECT @Cnt = COUNT(1) FROM EngAsset WHERE SerialNo = @pSerialNo
	ELSE
	SELECT @Cnt = COUNT(1) FROM EngAsset WHERE SerialNo = @pSerialNo AND AssetId <> @pAssetId

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
