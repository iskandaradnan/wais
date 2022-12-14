USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_UserRoleFetchUsingGetCompany_GetById]    Script Date: 20-09-2021 17:05:52 ******/
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
EXEC [UspFM_UserRoleFetchUsingGetCompany_GetById] @pRoleId=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_UserRoleFetchUsingGetCompany_GetById]                           
 -- @pUserId				INT	=	NULL,
  @pRoleId			INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	
	DECLARE @mCustomerId INT
	DECLARE @mFacilityId INT,@mBlockId INT,@mLevelId INT
	DECLARE @mUserLocationId INT,@mUserAreaId INT

	IF(ISNULL(@pRoleId,0) = 0) RETURN

	SELECT DISTINCT	Customer.CustomerId as LovId,
			UserCustomer.UserRoleId,
			Customer.CustomerName as FieldValue,
			0 AS IsDefault

	FROM		UMUserLocationMstDet		AS UserCustomer
	INNER JOIN  MstCustomer                 AS Customer on Customer.CustomerId=UserCustomer.CustomerId
	WHERE	UserCustomer.UserRoleId = @pRoleId AND UserCustomer.Active = 1 AND Customer.Active=1
	ORDER BY Customer.CustomerName ASC

	


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
