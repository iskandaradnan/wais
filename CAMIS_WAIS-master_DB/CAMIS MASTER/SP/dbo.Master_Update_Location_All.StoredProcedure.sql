USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Master_Update_Location_All]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Master_Update_Location_All]
(
	@Master_LocationID       AS INT,
	@Module_ID As int,
	@Module_Type As int
	
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

	if(@Module_Type = 2)

			UPDATE A SET A.BEMS = @Module_ID
			 FROM MstServices_Mapping_Location A 
			 WHERE A.Master_Location_ID = @Master_LocationID 
	
    		

	if(@Module_Type = 1)

			UPDATE A SET A.FEMS = @Module_ID
			  FROM MstServices_Mapping_Location A 
			 WHERE A.Master_Location_ID = @Master_LocationID 

	if(@Module_Type = 3)

			UPDATE A SET A.CLS = @Module_ID
			  FROM MstServices_Mapping_Location A 
			 WHERE A.Master_Location_ID = @Master_LocationID  

	

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
