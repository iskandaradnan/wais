USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_QAPCarTxn_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE VIEW [dbo].[V_QAPCarTxn_Export]
AS
    SELECT	Distinct Car.CarId,
			Car.CustomerId,
			Car.FacilityId,
			Car.ServiceId,
			Car.CARNumber,
			Car.CARDate,
			Car.QAPIndicatorId,
			QAPInd.IndicatorCode,
			CAR.FromDate,
			CAR.ToDate,
			--QAPCause.CauseCode,
			CARFollow.CARNumber as FollowupCAR,
			UserReg.StaffName,
			Car.ProblemStatement,
			CarHistory.RootCause,
			CarHistory.Solution,
			LovPriority.FieldValue  AS [Priority],
			LovStatus.FieldValue	AS	StatusValue,
			UserIssuer.StaffName    AS Issuer,
			CAR.CARTargetDate,
			CAR.VerifiedDate,
			UserVerified.StaffName  AS VerifiedBy,
			CarHistory.Remarks,
			CARDet.Activity,
			CARDet.StartDate,
			CARDet.TargetDate,
			CARDet.CompletedDate,
			LovResponsible.FieldValue as Responsibility,
			UserResponsible.StaffName as [ResponsiblePerson],
			Car.ModifiedDateUTC,
			CASE	WHEN Car.IsAutoCar=1 THEN 'Auto Generation CAR'
					ELSE 'Manual CAR'
			END		AS	CARGeneration,
			Car.CARStatus,
			ISNULL(LovCARStatus.FieldValue,'')	AS CARStatusValue,
			EngMWO.MaintenanceWorkNo AS WorkOrderNo,
			Assignee.StaffName as Assignee,
			QCCode.QcCode 
	FROM	QAPCarTxn						AS	Car					WITH(NOLOCK)
			INNER JOIN MstQAPIndicator		AS	QAPInd				WITH(NOLOCK) ON Car.QAPIndicatorId			=	QAPInd.QAPIndicatorId
			--INNER JOIN MstQAPQualityCause	AS	QAPCause			WITH(NOLOCK) ON Car.FailureSymptomId		=	QAPCause.QualityCauseId
			LEFT JOIN  QAPCarTxn			AS	CARFollow			WITH(NOLOCK) ON Car.CarId					=	CARFollow.FollowupCARId
			LEFT JOIN  UMUserRegistration	AS	UserReg				WITH(NOLOCK) ON Car.AssignedUserId			=	UserReg.UserRegistrationId
			LEFT JOIN EngAsset				AS	Asset				WITH(NOLOCK) ON Car.AssetId					=	Asset.AssetId
			LEFT JOIN FMLovMst				AS	LovStatus			WITH(NOLOCK) ON Car.Status					=	LovStatus.LovId
			LEFT JOIN FMLovMst				AS	LovPriority			WITH(NOLOCK) ON Car.PriorityLovId			=	LovPriority.LovId
			LEFT JOIN  UMUserRegistration	AS	UserIssuer			WITH(NOLOCK) ON Car.IssuerUserId			=	UserIssuer.UserRegistrationId
			LEFT JOIN  UMUserRegistration	AS	UserVerified		WITH(NOLOCK) ON Car.VerifiedBy				=	UserVerified.UserRegistrationId
			LEFT JOIN  QAPCarTxnDet			AS	CARDet				WITH(NOLOCK) ON Car.CarId					=	CARDet.CarId
			LEFT JOIN FMLovMst				AS	LovResponsible		WITH(NOLOCK) ON CarDet.ResponsibilityId		=	LovResponsible.LovId
			LEFT JOIN  UMUserRegistration	AS	UserResponsible		WITH(NOLOCK) ON CarDet.ResponsiblePersonUserId	=	UserResponsible.UserRegistrationId
			LEFT JOIN FMLovMst				AS	LovCARStatus		WITH(NOLOCK) ON Car.CARStatus				=	LovCARStatus.LovId
			LEFT JOIN QAPCarHistory			AS	CarHistory			WITH(NOLOCK) ON Car.CarId					=	CarHistory.CarId
			left JOIN QapB1AdditionalInformationTxn as QapB1Additional  WITH(NOLOCK) ON QapB1Additional.CarId		=	Car.CarId
			left JOIN EngMaintenanceWorkOrderTxn	AS	EngMWO		WITH(NOLOCK) ON QapB1Additional.WorkOrderId = EngMWO.WorkOrderId
			LEFT JOIN UMUserRegistration			AS	Assignee	WITH(NOLOCK) ON Car.AssignedUserId		=	Assignee.UserRegistrationId
			LEFT JOIN EngMwoCompletionInfoTxn		AS	MwoCompletionInfo	WITH(NOLOCK) ON MwoCompletionInfo.WorkOrderId		=	EngMWO.WorkOrderId			
			LEFT  JOIN  MstQAPQualityCause				AS  CauseCode			WITH(NOLOCK)	ON QapB1Additional.CauseCodeId				=	CauseCode.QualityCauseId
			LEFT  JOIN  MstQAPQualityCauseDet			AS  QcCode				WITH(NOLOCK)	ON QapB1Additional.QCCodeId					=	QcCode.QualityCauseDetId
GO
