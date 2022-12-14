USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMUserRegistrationLoc_Fetch]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UMUserRegistrationLoc_Fetch
Description			: Get the location details based on User Registration Id.
Authors				: Balaji M S
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_UMUserRegistrationLoc_Fetch  @pUserRegistrationId=69

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UMUserRegistrationLoc_Fetch]
	
	@pUserRegistrationId					INT
		
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

--//-- Insert the Data to Customer details table
	CREATE TABLE  #CustomerDetail (CustomerId int,CustomerName nvarchar(200) )

	INSERT INTO #CustomerDetail (CustomerId,CustomerName)
	SELECT  
			Customer.CustomerId							AS CustomerId,				
			Customer.CustomerName						AS CustomerName
	FROM	UMUserRegistration							AS UserRegistration
			INNER JOIN UMUserLocationMstDet				AS UserLocation					ON	UserRegistration.UserRegistrationId	= UserLocation.UserRegistrationId
			INNER JOIN MstLocationFacility				AS Facility						ON	UserLocation.FacilityId				= Facility.FacilityId
			INNER JOIN MstCustomer						AS Customer						ON	Facility.CustomerId					= Customer.CustomerId
	WHERE	UserRegistration.UserRegistrationId=@pUserRegistrationId
			AND(Customer.ActiveToDate IS NULL OR cast(Customer.ActiveToDate as date) >= cast(GETDATE() as date))
			--AND(ISNULL(Customer.ActiveToDate,'')>= GETDATE())
	GROUP BY Customer.CustomerId,Customer.CustomerName
	

	SELECT CustomerId AS LovId,CustomerName AS FieldValue,0 AS IsDefault FROM #CustomerDetail ORDER BY CustomerName

	--//-- Insert the Data to Facility details table
	CREATE TABLE  #FacilityDetail (FacilityId int,FacilityName nvarchar(200) )

	INSERT INTO #FacilityDetail(FacilityId,FacilityName)
	SELECT  
				LocationFacility.FacilityId					AS FacilityId,				
				LocationFacility.FacilityName				AS FacilityName
	FROM		UMUserRegistration							AS UserRegistration
				INNER JOIN UMUserLocationMstDet				AS UserLocation					ON	UserRegistration.UserRegistrationId	= UserLocation.UserRegistrationId
				INNER JOIN MstLocationFacility				AS LocationFacility				ON	UserLocation.FacilityId				= LocationFacility.FacilityId
				INNER JOIN MstCustomer						AS Customer						ON	Customer.CustomerId					= UserLocation.CustomerId 
															
	WHERE		UserRegistration.UserRegistrationId=@pUserRegistrationId 
				AND(LocationFacility.ActiveTo IS NULL OR LocationFacility.ActiveTo>= GETDATE())
				AND Customer.CustomerId IN (SELECT  CustomerId FROM #CustomerDetail)
	ORDER BY	LocationFacility.FacilityName

	SELECT FacilityId AS LovId,FacilityName AS FieldValue,0 AS IsDefault FROM #FacilityDetail ORDER BY FacilityName

		--IF @mTRANSCOUNT = 0
  --      BEGIN
  --          COMMIT TRANSACTION
  --      END 
		--ELSE ROLLBACK TRAN


END TRY

BEGIN CATCH

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           ROLLBACK TRAN
 --       END

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
