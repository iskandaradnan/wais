USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_Mobile_GetById]    Script Date: 20-09-2021 16:56:52 ******/
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
EXEC [uspFM_CRMRequest_Mobile_GetById] @pCRMRequestId='28,29',@pUserId=NULL,@pPageIndex=1,@pPageSize=20

SELECT * FROM CRMRequest
SELECT * FROM CRMRequestDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequest_Mobile_GetById]                           
  --@pUserId							INT	=	NULL,
  @pCRMRequestId					NVARCHAR(1000)--,
  --@pPageIndex						INT,
  --@pPageSize						INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--DECLARE	  @TotalRecords		INT
	--DECLARE   @pTotalPage		NUMERIC(24,2)
	--DECLARE   @pTotalPageCalc	INT

	IF(ISNULL(@pCRMRequestId,'') = '') RETURN


    SELECT	Request.CRMRequestId							AS CRMRequestId,
			Request.CustomerId								AS CustomerId,
			Request.FacilityId								AS FacilityId,
			Request.ServiceId								AS ServiceId,
			ServiceKey.ServiceKey							AS ServiceKey,
			Request.RequestNo								AS RequestNo,
			Request.RequestDateTime							AS RequestDateTime,
			Request.RequestDateTimeUTC						AS RequestDateTimeUTC,
			Request.RequestStatus							AS RequestStatus,
			RequestStatus.FieldValue						AS RequestStatusName,
			Request.RequestDescription						AS RequestDescription,
			Request.TypeOfRequest							AS TypeOfRequest,
			TypeOfRequest.FieldValue						AS TypeOfRequestName,
			Request.Remarks									AS Remarks,
			Request.IsWorkOrder								AS IsWorkorderGen,
			Request.ManufacturerId,
			Manufacturer.Manufacturer,
			Request.ModelId,
			Model.Model,
			Request.UserAreaId,
			UserArea.UserAreaCode,
			UserArea.UserAreaName,
			Request.UserLocationId,
			UserLocation.UserLocationCode,
			UserLocation.UserLocationName,
			Request.Timestamp,
			StatusValue,
			--UserRole.UMUserRoleId,
			--UserRole.Name AS UMUserRoleName,
			Request.GuId,
			Request.MobileGuid,
			Request.Targetdate,
			Request.RequestedPerson,
			RequestedPerson.StaffName as RequestedPersonName,
			Request.AssigneeId,
			AssigneeId.StaffName as AssigneeIdName
	FROM	CRMRequest										AS Request				WITH(NOLOCK)
			INNER JOIN	MstService							AS ServiceKey			WITH(NOLOCK)	ON Request.ServiceId			= ServiceKey.ServiceId
			INNER JOIN	FMLovMst							AS RequestStatus		WITH(NOLOCK)	ON Request.RequestStatus		= RequestStatus.LovId
			INNER JOIN	FMLovMst							AS TypeOfRequest		WITH(NOLOCK)	ON Request.TypeOfRequest		= TypeOfRequest.LovId
			LEFT JOIN	EngAssetStandardizationManufacturer	AS Manufacturer			WITH(NOLOCK)	ON Request.ManufacturerId		= Manufacturer.ManufacturerId
			LEFT JOIN	EngAssetStandardizationModel		AS Model				WITH(NOLOCK)	ON Request.ModelId				= Model.ModelId
			LEFT JOIN	MstLocationUserArea					AS UserArea				WITH(NOLOCK)	ON Request.UserAreaId			= UserArea.UserAreaId
			LEFT JOIN	MstLocationUserLocation				AS UserLocation			WITH(NOLOCK)	ON Request.UserLocationId		= UserLocation.UserLocationId
			LEFT JOIN	UMUserRegistration					AS RequestedPerson		WITH(NOLOCK)	ON Request.RequestedPerson		= RequestedPerson.UserRegistrationId
			LEFT JOIN	UMUserRegistration					AS AssigneeId			WITH(NOLOCK)	ON Request.AssigneeId			= AssigneeId.UserRegistrationId
			--INNER JOIN UMUserLocationMstDet					AS LocationMstDet		WITH(NOLOCK)	ON Request.FacilityId			= LocationMstDet.FacilityId
			--INNER JOIN UMUserRole							AS UserRole				WITH(NOLOCK)	ON LocationMstDet.UserRoleId	= UserRole.UMUserRoleId
			
	WHERE	Request.CRMRequestId IN  (SELECT ITEM FROM dbo.[SplitString] (@pCRMRequestId,',')) 
	ORDER BY Request.ModifiedDate ASC

	SELECT	ReqDet.CRMRequestDetId,
			ReqDet.CRMRequestId,
			ReqDet.AssetId,
			Asset.AssetNo,
			Asset.AssetDescription,
			Asset.SoftwareKey,
			Asset.SoftwareVersion,
			Asset.SerialNo,
			ReqDet.ModifiedDate
	FROM	CRMRequest Req 
			INNER JOIN CRMRequestDet	AS	ReqDet	WITH(NOLOCK)	ON Req.CRMRequestId	=	ReqDet.CRMRequestId
			INNER JOIN EngAsset			AS	Asset	WITH(NOLOCK)	ON ReqDet.AssetId	=	Asset.AssetId
	WHERE	Req.CRMRequestId	 IN  (SELECT ITEM FROM dbo.[SplitString] (@pCRMRequestId,',')) 

	


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
