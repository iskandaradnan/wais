USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[GetUserRegistrationLovs]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetUserRegistrationLovs]
	
AS 

-- Exec [GetUserRegistrationLovs] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetUserRegistrationLovs
--DESCRIPTION		: GET LOV VALUES FOR USER REGISTRATION 
--AUTHORS			: BIJU NB
--DATE				: 12-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 21-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	SELECT LovId, FieldValue FROM FmLovMst WHERE LovKey = 'CommonGender' ORDER BY FieldValue
	select UserTypeId LovId, Name FieldValue from UMUserType ORDER BY Name
	SELECT LovId, FieldValue FROM FmLovMst WHERE LovKey = 'StatusValue' ORDER BY FieldValue
	SELECT CustomerId LovId, CustomerName FieldValue FROM MstCustomer ORDER BY CustomerName
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
