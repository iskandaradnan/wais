USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Master_Updae_EngAssetTypeCode_AssetTypeCodeId_mappingTo_SeviceDB]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[Master_Updae_EngAssetTypeCode_AssetTypeCodeId_mappingTo_SeviceDB]
(
	@EngAssetClass       AS INT,
	@Master_AssetTypeCodeId As int
	
	
)	
AS 

--select * from EngAssetStandardizationManufacturer

-- Exec [AssetInfo_Update] 1,5,'SAMSUNG'

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: UpdateUserRole
--DESCRIPTION		: SAVE RECORD IN UMUSERROLE TABLE 
--AUTHORS			:deepak
--DATE				: 25-sep-2019
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--deepak vijay          : 25-sep-2019 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

	  
	  UPDATE A SET A.AssetTypeCodeId_mappingTo_SeviceDB = @EngAssetClass
			 FROM [EngAssetTypeCode] A 
			 WHERE A.AssetTypeCodeId = @Master_AssetTypeCodeId 
	

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
