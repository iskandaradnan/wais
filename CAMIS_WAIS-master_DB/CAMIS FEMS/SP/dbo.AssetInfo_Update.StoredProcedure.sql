USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[AssetInfo_Update]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[AssetInfo_Update]
(
	@UserId        AS INT,
	@AssetInfoTypeId As int,
	@AssetInfoType As int,
	@AssetInfoValue As varchar(500)
)	
AS 

--select * from EngAssetStandardizationManufacturer

-- Exec [AssetInfo_Update] 1,5,'SAMSUNG'

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: UpdateUserRole
--DESCRIPTION		: SAVE RECORD IN UMUSERROLE TABLE 
--AUTHORS			: BIJU NB
--DATE				: 19-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 19-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

	if(@AssetInfoType = 5)

			UPDATE A SET A.Manufacturer = @AssetInfoValue, A.ModifiedBy = @UserId, A.ModifiedDate = GETDATE(),A.ModifiedDateUTC = GETUTCDATE()
			 FROM EngAssetStandardizationManufacturer A 
			 WHERE A.ManufacturerId = @AssetInfoTypeId
	
    		SELECT ManufacturerId AS AssetInfoId, [Timestamp] FROM EngAssetStandardizationManufacturer WHERE ManufacturerId = @AssetInfoTypeId

	if(@AssetInfoType = 6)

			UPDATE A SET A.Make = @AssetInfoValue, A.ModifiedBy = @UserId, A.ModifiedDate = GETDATE(),A.ModifiedDateUTC = GETUTCDATE()
			 FROM EngAssetStandardizationMake A 
			 WHERE A.MakeId = @AssetInfoTypeId
	
    		SELECT MakeId AS AssetInfoId, [Timestamp] FROM EngAssetStandardizationMake WHERE MakeId = @AssetInfoTypeId

	if(@AssetInfoType = 7)

			UPDATE A SET A.Brand = @AssetInfoValue, A.ModifiedBy = @UserId, A.ModifiedDate = GETDATE(),A.ModifiedDateUTC = GETUTCDATE()
			 FROM EngAssetStandardizationBrand A 
			 WHERE A.BrandId = @AssetInfoTypeId
	
    		SELECT BrandId AS AssetInfoId, [Timestamp] FROM EngAssetStandardizationBrand WHERE BrandId = @AssetInfoTypeId

	if(@AssetInfoType = 8)

			UPDATE A SET A.Model = @AssetInfoValue, A.ModifiedBy = @UserId, A.ModifiedDate = GETDATE(),A.ModifiedDateUTC = GETUTCDATE()
			 FROM EngAssetStandardizationModel A 
			 WHERE A.ModelId = @AssetInfoTypeId
	
    		SELECT ModelId AS AssetInfoId, [Timestamp] FROM EngAssetStandardizationModel WHERE ModelId = @AssetInfoTypeId

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
