USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[AssetInfo_Delete]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[AssetInfo_Delete]
(
	@AssetInfoTypeId As int,
	@AssetInfoType As int
)
	
AS 

-- Exec [DeleteUserRole] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: DeleteUserRole
--DESCRIPTION		: DELETE USER ROLE
--AUTHORS			: BIJU NB
--DATE				: 20-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 20-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	if(@AssetInfoType = 5)
			DELETE EngAssetStandardizationManufacturer where ManufacturerId = @AssetInfoTypeId

	if(@AssetInfoType = 6)
			DELETE EngAssetStandardizationMake where MakeId = @AssetInfoTypeId

	if(@AssetInfoType = 7)
			DELETE EngAssetStandardizationBrand where BrandId = @AssetInfoTypeId

	if(@AssetInfoType = 8)
			DELETE EngAssetStandardizationModel where ModelId = @AssetInfoTypeId
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
