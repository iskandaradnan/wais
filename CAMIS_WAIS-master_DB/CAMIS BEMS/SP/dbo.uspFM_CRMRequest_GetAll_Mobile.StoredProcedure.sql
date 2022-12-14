USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_GetAll_Mobile]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_CRMRequest_GetAll
Description			: Get the all CRMRequests.
Authors				: Dhilip V
Date				: 20-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_CRMRequest_GetAll_Mobile  @pFacilityId=1


-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_CRMRequest_GetAll_Mobile]
@pFacilityId  int null
	

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



SELECT top 10	CRMRequestId,
					RequestNo,
					RequestDateTime,
					TypeOfRequestVal ,
					RequestStatusValue AS RequestStatusValue,
					IsWorkOrder,
					ModifiedDateUTC,
					ReqStaffId,
					ReqStaff,
					Model,
					Manufacturer,
					GuId,
					RequestStatus
				
			FROM [V_CRMRequest]
			WHERE 			FacilityId = @pFacilityId order by ModifiedDateUTC desc
 
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
