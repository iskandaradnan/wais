USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspBEMS_EngAssetTypeCodeStandardTasks_GetLovs]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[UspBEMS_EngAssetTypeCodeStandardTasks_GetLovs]
	
AS 

-- Exec [GetUserRoleLovs] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: UspBEMS_MstContractorandVendor_GetLovs
--DESCRIPTION		: GET LOV VALUES FOR USERROLE 
--AUTHORS			: Saiarj A 
--DATE				:  4-April-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--Saiarj A           : 4-April-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
		
	

--	select ServiceId LovId , ServiceKey  FieldValue  from MstService order by ServiceId 

	select  LovId, FieldValue  from FMLovMst where LovKey='StatusValue' order by LovId

	select  WorkGroupId, WorkGroupCode, WorkGroupDescription     from EngAssetWorkGroup where ServiceId=2 and WorkGroupCode='W2'
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
