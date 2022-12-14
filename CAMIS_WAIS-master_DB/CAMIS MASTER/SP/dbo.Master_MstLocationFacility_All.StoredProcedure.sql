USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Master_MstLocationFacility_All]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[Master_MstLocationFacility_All]
(
	@Master_FacilityID       AS INT,
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
--AUTHORS			: Vijay
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

			UPDATE A SET A.BEMS_ID = @Module_ID
			 FROM MstLocationFacility_Mapping A 
			 WHERE A.FacilityId = @Master_FacilityID 
	
    		

	if(@Module_Type = 1)

			UPDATE A SET A.FEMS_ID = @Module_ID
			 FROM MstLocationFacility_Mapping A 
			 WHERE A.FacilityId = @Master_FacilityID 

	if(@Module_Type = 3)

			UPDATE A SET A.CLS_ID = @Module_ID
			 FROM MstLocationFacility_Mapping A 
			 WHERE A.FacilityId = @Master_FacilityID 

	

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
