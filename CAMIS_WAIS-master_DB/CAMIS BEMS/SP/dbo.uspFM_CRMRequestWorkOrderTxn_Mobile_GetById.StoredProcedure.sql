USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequestWorkOrderTxn_Mobile_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_CRMRequestWorkOrderTxn_GetById
Description			: Get the CRM Request WorkOrder by passing the primary id
Authors				: Dhilip V
Date				: 23-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_CRMRequestWorkOrderTxn_Mobile_GetById]  @pCRMRequestWOId='134,135'
select * from CRMRequestWorkOrderTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequestWorkOrderTxn_Mobile_GetById]    
                       
  @pCRMRequestWOId		NVARCHAR(1000)

AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution


	IF(ISNULL(@pCRMRequestWOId,'') = '') RETURN

    SELECT	CRMWO.CRMRequestWOId,
			CRMWO.CustomerId,
			CRMWO.FacilityId,
			CRMWO.ServiceId,
			CRMWO.CRMWorkOrderNo,
			CRMWO.CRMWorkOrderDateTime,
			CRMWO.CRMWorkOrderDateTimeUTC,
			CRMWO.Status					AS	StatusId,
			LovStatus.FieldValue			AS	Status,
			CRMWO.Description,
			CRMWO.TypeOfRequest				AS	TypeOfRequestId,
			LovReqType.FieldValue			AS	TypeOfRequest,
			CRMWO.CRMRequestId,
			CRM.RequestNo,
			CRMWO.AssetId,
			Asset.AssetNo,
			Asset.AssetDescription,
			CRMWO.ManufacturerId,
			Manufacturer.Manufacturer,
			CRMWO.ModelId,
			Model.Model,
			CRMWO.AssignedUserId			AS	[AssignedStaffId],
			Staff.StaffName					AS	AssignedStaffName,
			CRMWO.Remarks,
			IsReqTypeReferenced,
			Completion.CRMAssesmentId,
			Completion.CRMCompletionInfoId,
			CRMWO.UserAreaId,
			UserArea.UserAreaCode,
			UserArea.UserAreaName,
			CRMWO.UserLocationId,
			UserLocation.UserLocationCode,
			UserLocation.UserLocationName,
			CRMWO.[Timestamp]               AS [Timestamp],
			CRMWO.GuId,
			CRMWO.MasterGuid,
			CRM.MobileGuid
 	FROM	CRMRequestWorkOrderTxn								AS CRMWO			WITH(NOLOCK)
			LEFT JOIN  CRMRequest								AS	CRM				WITH(NOLOCK)	ON CRMWO.CRMRequestId		=	CRM.CRMRequestId
			LEFT JOIN  EngAsset									AS	Asset			WITH(NOLOCK)	ON CRMWO.AssetId			=	Asset.AssetId
			LEFT JOIN  EngAssetStandardizationManufacturer		AS	Manufacturer	WITH(NOLOCK)	ON CRMWO.ManufacturerId		=	Manufacturer.ManufacturerId
			LEFT JOIN  EngAssetStandardizationModel				AS	Model			WITH(NOLOCK)	ON CRMWO.ModelId			=	Model.ModelId
			LEFT JOIN  UMUserRegistration						AS	Staff			WITH(NOLOCK)	ON CRMWO.AssignedUserId		=	Staff.UserRegistrationId
			INNER JOIN  FMLovMst								AS	LovStatus		WITH(NOLOCK)	ON CRMWO.Status				=	LovStatus.LovId
			INNER JOIN  FMLovMst								AS	LovReqType		WITH(NOLOCK)	ON CRMWO.TypeOfRequest		=	LovReqType.LovId
			LEFT JOIN  MstLocationUserArea						AS	UserArea		WITH(NOLOCK)	ON CRMWO.UserAreaId			=	UserArea.UserAreaId	
			LEFT JOIN  MstLocationUserLocation					AS	UserLocation	WITH(NOLOCK)	ON CRMWO.UserLocationId		=	UserLocation.UserLocationId	
			OUTER APPLY (SELECT CASE WHEN COUNT(1)>0 THEN 1 
					ELSE 0 END AS IsReqTypeReferenced FROM CRMRequestAssessment CRMASS WHERE CRMWO.CRMRequestWOId	=	CRMASS.CRMRequestWOId) AS IsReqTypeReferenced
			OUTER APPLY (SELECT CRMAssesmentId,CRMCompletionInfoId 
						FROM CRMRequestAssessment	CRMAss
						LEFT JOIN CRMRequestCompletionInfo	CRMComp ON CRMAss.CRMRequestWOId = CRMComp.CRMRequestWOId
						WHERE CRMAss.CRMRequestWOId	=	CRMWO.CRMRequestWOId) AS Completion
	WHERE	CRMWO.CRMRequestWOId  IN  (SELECT ITEM FROM dbo.[SplitString] (@pCRMRequestWOId,','))


END TRY

BEGIN CATCH
THROW
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
