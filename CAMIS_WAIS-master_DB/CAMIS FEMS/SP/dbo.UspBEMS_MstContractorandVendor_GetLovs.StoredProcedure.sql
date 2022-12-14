USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspBEMS_MstContractorandVendor_GetLovs]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UspBEMS_MstContractorandVendor_GetLovs]
	
AS 

-- Exec [GetUserRoleLovs] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: UspBEMS_MstContractorandVendor_GetLovs
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
	
	SELECT LovId,  0 IsDefault, FieldValue FROM FmLovMst WHERE LovKey = 'StatusValue' ORDER BY FieldValue
	--SELECT LovId, FieldValue FROM FmLovMst WHERE LovKey = 'StatusValue' ORDER BY FieldValue
	   	SELECT	AssetClassificationId			AS LovId, 0 IsDefault,
					AssetClassificationDescription				AS FieldValue ,
					Active
			FROM	EngAssetClassification WITH(NOLOCK)
			WHERE	Active = 1 

		SELECT	LovId			AS LovId,0 IsDefault,
				FieldValue		AS FieldValue ,
				IsDefault
		FROM	FMLovMst WITH(NOLOCK)
		WHERE	Active = 1 and LovKey='NationalityValue'

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
