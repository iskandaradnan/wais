USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Get_MasterServices_byUserAreaId]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Get_MasterServices_byUserAreaId]
(
	@UserAreaID INT
)
	
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
	
	--Gets service coloums of the Selected Block
	SELECT UserAreaid LovId, UserAreaName FieldValue, 0  IsDefault,MstServices_Mapping_Area.BEMS,MstServices_Mapping_Area.FEMS,MstServices_Mapping_Area.FEMS,FacilityId
FROM MstLocationUserArea
LEFT JOIN MstServices_Mapping_Area
ON MstLocationUserArea.UserAreaid = MstServices_Mapping_Area.Master_Area_ID WHERE MstLocationUserArea.UserAreaid = @UserAreaID ORDER BY MstLocationUserArea.UserAreaName 

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
