USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetTypeCode_Search_by_master_ID]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE [dbo].[uspFM_EngAssetTypeCode_Search_by_master_ID]
(
	@pEngAssetTypeCode_ID INT
)
	
AS 

-- Exec [GetUserRole] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetUserRole
--DESCRIPTION		: GET USER ROLE FOR THE GIVEN ID
--AUTHORS			: ADV NB
--DATE				: 20-March-2019
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
	
	 SELECT *
  FROM [dbo].[EngAssetClassification]
	 WHERE AssetClassificationId=@pEngAssetTypeCode_ID
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
