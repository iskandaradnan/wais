USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UserRegistrationCountDetails_GetById]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_CRMRequest_GetById
Description			: To Get the data from table CRMRequest using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_UserRegistrationCountDetails_GetById] @pUserRegistrationId=41

SELECT * FROM CRMRequest
SELECT * FROM CRMRequestDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UserRegistrationCountDetails_GetById]                           
  --@pUserId							INT	=	NULL,
  @pUserRegistrationId					INT--,
  --@pPageIndex						INT,
  --@pPageSize						INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--DECLARE	  @TotalRecords		INT
	--DECLARE   @pTotalPage		NUMERIC(24,2)
	--DECLARE   @pTotalPageCalc	INT

	IF(ISNULL(@pUserRegistrationId,0) = 0) RETURN


	DECLARE @pCustomerCount INT
	DECLARE @pFacilityCount INT
	DECLARE @pCustomerId	INT
	DECLARE @pFacilityId	INT

	SET @pCustomerCount = (SELECT  COUNT(DISTINCT B.CustomerId) FROM UMUserLocationMstDet 
	A INNER JOIN MstLocationFacility B ON A.FacilityId = B.FacilityId WHERE A.UserRegistrationId = @pUserRegistrationId)
	SET @pFacilityCount = (SELECT  COUNT(DISTINCT A.FacilityId) FROM UMUserLocationMstDet 
	A INNER JOIN MstLocationFacility B ON A.FacilityId = B.FacilityId WHERE CAST(ISNULL(B.ActiveTo,GETDATE()+1) AS DATE)>CAST(GETDATE() AS DATE) AND A.UserRegistrationId = @pUserRegistrationId)

    
	IF(@pCustomerCount = 1 AND @pFacilityCount = 1) 
	BEGIN
	SET @pCustomerId = (SELECT  DISTINCT B.CustomerId FROM UMUserLocationMstDet 
	A INNER JOIN MstLocationFacility B ON A.FacilityId = B.FacilityId WHERE A.UserRegistrationId = @pUserRegistrationId)
	SET @pFacilityId = (SELECT  DISTINCT A.FacilityId FROM UMUserLocationMstDet 
	A INNER JOIN MstLocationFacility B ON A.FacilityId = B.FacilityId WHERE CAST(ISNULL(B.ActiveTo,GETDATE()+1) AS DATE)>CAST(GETDATE() AS DATE) AND A.UserRegistrationId = @pUserRegistrationId)
	SELECT @pUserRegistrationId AS UserRegistrationId, 'FALSE' AS Result,@pCustomerId AS CustomerId,@pFacilityId AS FacilityId
	END

	IF(@pCustomerCount = 1 AND @pFacilityCount > 1) 
	BEGIN
	SELECT @pUserRegistrationId AS UserRegistrationId, 'TRUE' AS Result,0 AS CustomerId,0 AS FacilityId
	END

	IF(@pCustomerCount > 1 AND @pFacilityCount > 1) 
	BEGIN
	SELECT @pUserRegistrationId AS UserRegistrationId, 'TRUE' AS Result,0 AS CustomerId,0 AS FacilityId
	END
	IF(@pCustomerCount =0 AND @pFacilityCount =0) 
	BEGIN
	SELECT @pUserRegistrationId AS UserRegistrationId, 'FALSE' AS Result
	END	

	IF(@pCustomerCount = 1 AND @pFacilityCount = 0) 
	BEGIN
	SELECT @pUserRegistrationId AS UserRegistrationId, 'FALSE' AS Result,0 AS CustomerId,0 AS FacilityId
	END

END TRY

BEGIN CATCH
THROW;
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
