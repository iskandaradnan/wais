USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMUserRegistrationCustomer_Fetch]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UMUserRegistrationCustomer_Fetch
Description			: Get the location details based on User Registration Id.
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_UMUserRegistrationCustomer_Fetch  @pUserRegistrationId=77

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UMUserRegistrationCustomer_Fetch]
	
	@pUserRegistrationId					INT,
	@pCustomerId							INT
	
AS                                              

BEGIN TRY
	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION
-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	


-- Default Values


-- Execution

	SELECT  
			Customer.CustomerId							AS LovId,				
			Customer.CustomerName						AS FieldValue,0 AS IsDefault
	FROM	UMUserRegistration							AS UserRegistration
			INNER JOIN UMUserLocationMstDet				AS UserLocation					ON	UserRegistration.UserRegistrationId	= UserLocation.UserRegistrationId
			INNER JOIN MstLocationFacility				AS Facility						ON	UserLocation.FacilityId				= Facility.Facilityid
			INNER JOIN MstCustomer						AS Customer						ON	Facility.CustomerId					= Customer.CustomerId
	WHERE UserRegistration.UserRegistrationId=@pUserRegistrationId
			AND(Customer.ActiveToDate IS NULL OR cast(Customer.ActiveToDate as date) >= cast(GETDATE() as date))
			--AND(ISNULL(Customer.ActiveToDate,'')>= GETDATE())
	GROUP BY Customer.CustomerId,Customer.CustomerName
	ORDER BY Customer.CustomerName

	SELECT	Facility.FacilityId					AS LovId,
					Facility.FacilityName				AS FieldValue ,0 AS IsDefault
	FROM	MstLocationFacility AS Facility WITH(NOLOCK)
					INNER JOIN UMUserLocationMstDet	AS UserFacility ON Facility.FacilityId	=	UserFacility.FacilityId
	WHERE	--Facility.Active = 1	AND
					(Facility.ActiveTo IS NULL OR Facility.ActiveTo>= GETDATE())
					--AND(ISNULL(Facility.ActiveTo,'')>= GETDATE())
					AND Facility.CustomerId				=	@pCustomerId
					AND UserFacility.UserRegistrationId	=	@pUserRegistrationId
	ORDER BY FacilityName ASC
	

	
END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
