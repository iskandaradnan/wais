USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Facility_GetByCustomerId]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_Facility_GetByCustomerId
Description			: Get all Facility by passing customerid
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_Facility_GetByCustomerId  @pCustomerId=1,@pUserRegistrationId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Facility_GetByCustomerId] 
                         
  @pCustomerId			INT,
  @pUserRegistrationId	INT
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution

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
