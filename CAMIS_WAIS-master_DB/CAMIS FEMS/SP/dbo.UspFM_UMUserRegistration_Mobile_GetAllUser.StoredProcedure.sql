USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_UMUserRegistration_Mobile_GetAllUser]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_PorteringTransaction_GetById
Description			: To Get the data from table PorteringTransaction using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_UMUserRegistration_Mobile_GetAllUser] 
select * from FEGPSPositionHistory
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_UMUserRegistration_Mobile_GetAllUser] 

 @pFacilityId  int  null                         

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	


	SELECT	UserRegistration.UserRegistrationId					AS UserRegistrationId,
			UserRegistration.StaffName							AS UserName,
			UserRegistration.UserDesignationId,
			Designation
	FROM	UMUserRegistration									AS UserRegistration
	INNER JOIN	UMUserLocationMstDet	AS	UserLoc		WITH(NOLOCK) ON UserRegistration.UserRegistrationId	=	UserLoc.UserRegistrationId
	lEFT JOIN UserDesignation	AS	UserDesig		WITH(NOLOCK) ON UserDesig.UserDesignationId	=	UserRegistration.UserDesignationId
	WHERE   UserRegistration.UserTypeId IN (2,3)
	and   UserLoc.FacilityId = @pFacilityId
	ORDER BY UserRegistration.ModifiedDate ASC


	

	
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
