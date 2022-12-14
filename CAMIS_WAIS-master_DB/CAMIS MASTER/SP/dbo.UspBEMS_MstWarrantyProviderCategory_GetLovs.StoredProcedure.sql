USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspBEMS_MstWarrantyProviderCategory_GetLovs]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UspBEMS_MstWarrantyProviderCategory_GetLovs]
	
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
		
	SELECT LovId, FieldValue FROM FMLovMst WHERE LovKey='WarrantyCategoryValue' ORDER BY LovId
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
