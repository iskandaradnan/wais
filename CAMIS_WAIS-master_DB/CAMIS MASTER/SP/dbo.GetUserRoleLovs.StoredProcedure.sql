USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[GetUserRoleLovs]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[GetUserRoleLovs]
	
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
	
	select UserTypeId LovId, Name FieldValue,
	0 AS IsDefault
	from UMUserType ORDER BY Name

	SELECT LovId, FieldValue, 
	0 AS IsDefault 
	FROM FmLovMst WHERE LovKey = 'StatusValue' ORDER BY FieldValue
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
