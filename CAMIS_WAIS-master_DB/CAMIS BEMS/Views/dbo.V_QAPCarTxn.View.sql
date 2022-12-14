USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_QAPCarTxn]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_QAPCarTxn]
AS
    SELECT	Car.CarId,
			Car.CustomerId,
			Car.FacilityId,
			Car.ServiceId,
			Car.CARDate,
			Car.CARNumber,
			Car.QAPIndicatorId,
			QAPInd.IndicatorCode,
			Car.ProblemStatement,
			Car.Status,
			LovStatus.FieldValue			AS	StatusValue,
			CASE	WHEN IsAutoCar=1 THEN 'Auto Generation CAR'
					ELSE 'Manual CAR'
			END		AS	CARGeneration,
			Car.ModifiedDateUTC,
			Car.CARStatus,
			ISNULL(LovCARStatus.FieldValue,'')	AS CARStatusValue,--,
			--EngMWO.MaintenanceWorkNo AS WorkOrderNo,
			Assignee.StaffName as Assignee
		--	QCCode.QcCode 
	FROM	QAPCarTxn						AS	Car					WITH(NOLOCK)
			INNER JOIN MstQAPIndicator		AS	QAPInd				WITH(NOLOCK) ON Car.QAPIndicatorId	=	QAPInd.QAPIndicatorId
			LEFT JOIN EngAsset				AS	Asset				WITH(NOLOCK) ON Car.AssetId			=	Asset.AssetId
			LEFT JOIN FMLovMst				AS	LovStatus			WITH(NOLOCK) ON Car.Status			=	LovStatus.LovId
			LEFT JOIN FMLovMst				AS	LovCARStatus		WITH(NOLOCK) ON Car.CARStatus		=	LovCARStatus.LovId
			--left JOIN QapB1AdditionalInformationTxn as QapB1Additional  WITH(NOLOCK) ON QapB1Additional.CarId		=	Car.CarId
			--left JOIN EngMaintenanceWorkOrderTxn	AS	EngMWO		WITH(NOLOCK) ON QapB1Additional.WorkOrderId = EngMWO.WorkOrderId
			LEFT JOIN UMUserRegistration			AS	Assignee	WITH(NOLOCK) ON Car.AssignedUserId		=	Assignee.UserRegistrationId
		--	LEFT JOIN EngMwoCompletionInfoTxn		AS	MwoCompletionInfo	WITH(NOLOCK) ON MwoCompletionInfo.WorkOrderId		=	EngMWO.WorkOrderId			
		--	LEFT  JOIN  MstQAPQualityCause				AS  CauseCode			WITH(NOLOCK)	ON QapB1Additional.CauseCodeId				=	CauseCode.QualityCauseId
		--	LEFT  JOIN  MstQAPQualityCauseDet			AS  QcCode				WITH(NOLOCK)	ON QapB1Additional.QCCodeId					=	QcCode.QualityCauseDetId
GO
