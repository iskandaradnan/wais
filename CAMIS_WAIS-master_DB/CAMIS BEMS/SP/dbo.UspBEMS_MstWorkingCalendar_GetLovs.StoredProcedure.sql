USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspBEMS_MstWorkingCalendar_GetLovs]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UspBEMS_MstWorkingCalendar_GetLovs]
	
AS 

-- Exec [GetUserRoleLovs] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: UspBEMS_EngAssetClassification_GetLovs
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
	
	--SELECT LovId, FieldValue FROM FmLovMst WHERE LovKey = 'StatusValue' ORDER BY FieldValue
--	SELECT   ServiceId LovId, ServiceKey FieldValue FROM MstService  ORDER BY ServiceKey


	select MonthId LovId, [Month] as  FieldValue, 0 IsDefault  from FMTimeMonth 
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
