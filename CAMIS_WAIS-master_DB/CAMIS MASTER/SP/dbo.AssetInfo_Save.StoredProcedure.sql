USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[AssetInfo_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec [SaveUserRole] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: SaveUserRole
--DESCRIPTION		: SAVE RECORD IN UMUSERROLE TABLE 
--AUTHORS			: BIJU NB
--DATE				: 20-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 20-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/


CREATE PROCEDURE  [dbo].[AssetInfo_Save]                           

(
	@UserId        AS INT,
	@AssetInfoType As int,
	@AssetInfoValue As varchar(500)
)	     

AS      

BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	DECLARE @Table TABLE (ID INT)

	if(@AssetInfoType = 5)
	BEGIN

		IF EXISTS(SELECT 1 FROM EngAssetStandardizationManufacturer WHERE Manufacturer = @AssetInfoValue)

		BEGIN
		SELECT 0 AS AssetInfoId,
		CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
		'Manufacturer Name Should be Unique' AS ErrorMessage
		END
		
		ELSE
		BEGIN
			INSERT INTO EngAssetStandardizationManufacturer(
				 Manufacturer, CreatedBy, CreatedDate,	CreatedDateUTC, ModifiedBy, ModifiedDate, ModifiedDateUTC, Active) OUTPUT INSERTED.ManufacturerId INTO @Table

		    VALUES  (@AssetInfoValue, @UserId, getdate(),getutcdate(),@UserId,getdate(),getutcdate(),1)

	

    		SELECT ManufacturerId AS AssetInfoId, [Timestamp],'' AS ErrorMessage FROM EngAssetStandardizationManufacturer WHERE ManufacturerId IN (SELECT ID FROM @Table)
		END
	END
	if(@AssetInfoType = 6)

		BEGIN

		IF EXISTS(SELECT 1 FROM EngAssetStandardizationMake WHERE Make = @AssetInfoValue)

		BEGIN
		SELECT 0 AS AssetInfoId,
		CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
		'Make Name Should be Unique' AS ErrorMessage
		END
		
		ELSE
		BEGIN

			INSERT INTO EngAssetStandardizationMake (
				 Make, CreatedBy, CreatedDate,	CreatedDateUTC, ModifiedBy, ModifiedDate, ModifiedDateUTC, Active) OUTPUT INSERTED.MakeId INTO @Table

		    VALUES  (@AssetInfoValue, @UserId,  getdate(),getutcdate(),@UserId,getdate(),getutcdate(),1)

	

    		SELECT MakeId AS AssetInfoId, [Timestamp],'' AS ErrorMessage FROM EngAssetStandardizationMake WHERE MakeId IN (SELECT ID FROM @Table)
		END
	END
	if(@AssetInfoType = 7)

		BEGIN

		IF EXISTS(SELECT 1 FROM EngAssetStandardizationBrand WHERE Brand = @AssetInfoValue)

		BEGIN
		SELECT 0 AS AssetInfoId,
		CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
		'Brand Name Should be Unique' AS ErrorMessage
		END
		
		ELSE
		BEGIN
			INSERT INTO EngAssetStandardizationBrand (
				 Brand, CreatedBy, CreatedDate,	CreatedDateUTC, ModifiedBy, ModifiedDate, ModifiedDateUTC, Active) OUTPUT INSERTED.BrandId INTO @Table

		    VALUES  (@AssetInfoValue, @UserId,  getdate(),getutcdate(),@UserId,getdate(),getutcdate(),1)

	

    		SELECT BrandId AS AssetInfoId, [Timestamp],'' AS ErrorMessage FROM EngAssetStandardizationBrand WHERE BrandId IN (SELECT ID FROM @Table)
		END
	END
	if(@AssetInfoType = 8)
		
		BEGIN

		IF EXISTS(SELECT 1 FROM EngAssetStandardizationModel WHERE Model = @AssetInfoValue)

		BEGIN
		SELECT 0 AS AssetInfoId,
		CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
		'Model Name Should be Unique' AS ErrorMessage
		END
		
		ELSE
		BEGIN
			INSERT INTO EngAssetStandardizationModel (
				 Model, CreatedBy, CreatedDate,	CreatedDateUTC, ModifiedBy, ModifiedDate, ModifiedDateUTC, Active) OUTPUT INSERTED.ModelId INTO @Table

		    VALUES  (@AssetInfoValue, @UserId,  getdate(),getutcdate(),@UserId,getdate(),getutcdate(),1)

	

    		SELECT ModelId AS AssetInfoId, [Timestamp],'' AS ErrorMessage FROM EngAssetStandardizationModel WHERE ModelId IN (SELECT ID FROM @Table)
		END
	END
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
