USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngTrainingScheduleTxn]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_EngTrainingScheduleTxn]
AS
	SELECT	TrainingSchd.TrainingScheduleId,
			TrainingSchd.CustomerId,
			Customer.CustomerName,
			TrainingSchd.FacilityId,
			Facility.FacilityName,
			TrainingSchd.TrainingScheduleNo,
			TrainingSchd.TrainingModule AS Trainingmodule ,
			TrainingSchd.TrainingDescription,
			TrainingSchd.Year,
			LovQuarter.FieldValue AS	QuarterVal,
			TrainingSchd.PlannedDate,
			TrainingSchd.ActualDate,
			LovStatus.FieldValue AS	Status,
			TrainingSchd.ModifiedDateUTC
	FROM	EngTrainingScheduleTxn				AS TrainingSchd WITH(NOLOCK)
			INNER JOIN MstCustomer				AS	Customer		WITH(NOLOCK)	ON	TrainingSchd.CustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility		AS	Facility		WITH(NOLOCK)	ON	TrainingSchd.FacilityId		=	Facility.FacilityId
			LEFT JOIN FMLovMst					AS	LovQuarter		WITH(NOLOCK)	ON	TrainingSchd.Quarter		=	LovQuarter.LovId
			LEFT JOIN FMLovMst					AS	LovStatus		WITH(NOLOCK)	ON	TrainingSchd.TrainingStatus	=	LovStatus.LovId
GO
