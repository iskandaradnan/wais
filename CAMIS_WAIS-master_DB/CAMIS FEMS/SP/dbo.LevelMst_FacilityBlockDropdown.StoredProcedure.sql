USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LevelMst_FacilityBlockDropdown]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[LevelMst_FacilityBlockDropdown]

AS 

-- Exec [GetUserRoleLovs] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetUserRoleLovs
--DESCRIPTION		: GET LOV VALUES FOR USERROLE 
--AUTHORS			: BIJU NB
--DATE				: 12-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 15-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	select FacilityId LovId, FacilityName FieldValue from MstLocationFacility ORDER BY FacilityName
	--select BlockId LovId, BlockName FieldValue from MstLocationBlock ORDER BY BlockName
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
