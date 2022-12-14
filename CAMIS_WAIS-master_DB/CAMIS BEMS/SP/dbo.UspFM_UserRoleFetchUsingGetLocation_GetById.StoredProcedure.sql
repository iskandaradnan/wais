USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_UserRoleFetchUsingGetLocation_GetById]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_PorteringTransaction_GetById
Description			: To Get the data from table PorteringTransaction using the Primary Key id
Authors				: Ganesan S
Date				: 20-Sep-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_UserRoleFetchUsingGetLocation_GetById] @pCustomerId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_UserRoleFetchUsingGetLocation_GetById]                           
 -- @pUserId				INT	=	NULL,
  @pCustomerId			INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	
	DECLARE @mCustomerId INT
	DECLARE @mFacilityId INT,@mBlockId INT,@mLevelId INT
	DECLARE @mUserLocationId INT,@mUserAreaId INT

	IF(ISNULL(@pCustomerId,0) = 0) RETURN

	SELECT			UserFacility.FacilityId as LovId,
					UserFacility.CustomerId,
					UserFacility.FacilityName as FieldValue,
					0 AS IsDefault

	FROM		MstLocationFacility		AS UserFacility
	WHERE		UserFacility.CustomerId = @pCustomerId AND UserFacility.Active = 1
	ORDER BY	UserFacility.FacilityName ASC

	


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
