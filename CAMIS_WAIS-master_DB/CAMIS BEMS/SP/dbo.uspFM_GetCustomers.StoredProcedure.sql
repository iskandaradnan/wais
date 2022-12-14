USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetCustomers]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspFM_GetCustomers]
(
	@UserRegistrationId INT
)
	
AS 

-- Exec [uspFM_GetCustomers]  1

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: uspFM_GetCustomers
--DESCRIPTION		: GET CUSTOMERS FOR THE GIVEN USER
--AUTHORS			: BIJU NB
--DATE				: 20-March-2018
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
	
	SELECT DISTINCT C.CustomerId AS LovId, CustomerName as FieldValue, 0 AS IsDefault FROM UMUserLocationMstDet A
	JOIN MstLocationFacility B ON A.FacilityId = B.FacilityId
	JOIN MstCustomer C ON B.CustomerId = C.CustomerId
	WHERE UserRegistrationId = @UserRegistrationId
	ORDER BY CustomerName
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
