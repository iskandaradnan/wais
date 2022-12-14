USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngTrainingScheduleTxn_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_EngTrainingScheduleTxn_Export]
AS
	SELECT	TrainingSchd.TrainingScheduleId,
			TrainingSchd.CustomerId,
			Customer.CustomerName,
			TrainingSchd.FacilityId,
			Facility.FacilityName,
			Facility.FacilityCode,
			'BEMS' AS	[Service],
			LovType.FieldValue AS	TrainingType,
			cast ( TrainingSchd.PlannedDate as date) as PlannedDate,
			--FORMAT(TrainingSchd.PlannedDate,'dd-MMM-yyyy') AS PlannedDate,
			TrainingSchd.Year,
			LovQuarter.FieldValue AS	QuarterVal,
			TrainingSchd.TrainingScheduleNo,			
			TrainingSchd.TrainingDescription,
			TrainingSchd.TrainingModule,
			TrainingSchd.MinimumNoOfParticipants,
			cast ( TrainingSchd.ActualDate as date) as ActualDate,
			--FORMAT(TrainingSchd.ActualDate,'dd-MMM-yyyy') AS ActualDate,
			LovStatus.FieldValue AS	Status,
			LovSource.FieldValue AS	TrainerSource,
			TrainingSchd.TrainerUserName			AS [Presenter(Trainer)],
			TrainingSchd.TrainerStaffExperience		AS [YearsOfExperience],
			TrainingSchd.Designation				AS [Designation],
			TrainingSchd.TotalParticipants			AS [TotalNo.OfParticipants],
			TrainingSchd.Venue,
			FORMAT(TrainingSchd.TrainingRescheduleDate,'dd-MMM-yyyy')		AS [TrainingRescheduleDate],
			TrainingSchd.OverallEffectiveness		AS [OverallEffectiveness(%)],
			TrainingSchd.Remarks,
			TrainingSchd.ModifiedDateUTC
	FROM	EngTrainingScheduleTxn				AS TrainingSchd WITH(NOLOCK)
			INNER JOIN MstCustomer				AS	Customer		WITH(NOLOCK)	ON	TrainingSchd.CustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility		AS	Facility		WITH(NOLOCK)	ON	TrainingSchd.FacilityId		=	Facility.FacilityId
			LEFT JOIN FMLovMst					AS	LovQuarter		WITH(NOLOCK)	ON	TrainingSchd.Quarter		=	LovQuarter.LovId
			LEFT JOIN FMLovMst					AS	LovStatus		WITH(NOLOCK)	ON	TrainingSchd.TrainingStatus	=	LovStatus.LovId
			LEFT JOIN FMLovMst					AS	LovType			WITH(NOLOCK)	ON	TrainingSchd.TrainingType	=	LovType.LovId
			LEFT JOIN FMLovMst					AS	LovSource		WITH(NOLOCK)	ON	TrainingSchd.TrainerSource	=	LovSource.LovId
			--LEFT JOIN UMUserRegistration		AS	UMUser			WITH(NOLOCK)	ON	TrainingSchd.TrainerUserId	=	UMUser.UserRegistrationId
GO
