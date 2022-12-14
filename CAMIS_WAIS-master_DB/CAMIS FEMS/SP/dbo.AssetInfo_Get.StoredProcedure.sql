USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[AssetInfo_Get]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[AssetInfo_Get]
(
	@AssetInfoTypeId INT,
	@AssetInfoType INT
)
	
AS 

-- Exec [GetUserRole] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetUserRole
--DESCRIPTION		: GET USER ROLE FOR THE GIVEN ID
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
	
    		SELECT ManufacturerId AS AssetInfoId, Manufacturer AS AssetInfoValue, [Timestamp] FROM EngAssetStandardizationManufacturer WHERE ManufacturerId = @AssetInfoTypeId

	if(@AssetInfoType = 6)
	
    		SELECT MakeId AS AssetInfoId, Make AS AssetInfoValue, [Timestamp] FROM EngAssetStandardizationMake WHERE MakeId = @AssetInfoTypeId

	if(@AssetInfoType = 7)
	
    		SELECT BrandId AS AssetInfoId, Brand AS AssetInfoValue, [Timestamp] FROM EngAssetStandardizationBrand WHERE BrandId = @AssetInfoTypeId

	if(@AssetInfoType = 8)
	
    		SELECT ModelId AS AssetInfoId, Model AS AssetInfoValue, [Timestamp] FROM EngAssetStandardizationModel WHERE ModelId = @AssetInfoTypeId
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
