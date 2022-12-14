USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[GetLocations]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetLocations]
(
	@Id INT,
	@UserRegistrationId INT
)
	
AS 

-- Exec [GetLocations] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetLocations
--DESCRIPTION		: GET USER LOCATIONS FOR THE GIVEN CUSTOMER
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
	
	SELECT DISTINCT A.FacilityId LovId, FacilityName FieldValue,
	0 AS IsDefault  FROM MstLocationFacility A
	JOIN UMUserLocationMstDet B ON A.FacilityId = B.FacilityId
	JOIN UMUserRegistration C ON B.UserRegistrationId = C.UserRegistrationId
	WHERE	A.CustomerId = @Id AND C.UserRegistrationId = @UserRegistrationId
			AND (ActiveTo IS NULL OR cast(ActiveTo as date) >= cast(GETDATE() as date))
	ORDER BY FacilityName 
	
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
