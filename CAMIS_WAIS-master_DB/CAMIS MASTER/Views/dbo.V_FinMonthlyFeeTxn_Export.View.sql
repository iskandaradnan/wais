USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_FinMonthlyFeeTxn_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_FinMonthlyFeeTxn_Export]
AS
	SELECT	MonthlyFee.MonthlyFeeId,
			MonthlyFee.CustomerId,
			Customer.CustomerName,
			MonthlyFee.FacilityId,
			Facility.FacilityName,
			MonthlyFee.Year,
			TimeMonth.Month,
			MonthlyFeeDet.BemsMSF	AS	 MSF,
			MonthlyFeeDet.BemsCF	AS	 [AmendmentFee],
			MonthlyFeeDet.TotalFee,
			MonthlyFee.ModifiedDateUTC
	FROM	FinMonthlyFeeTxn					AS	MonthlyFee		WITH(NOLOCK) 
			INNER JOIN FinMonthlyFeeTxnDet		AS	MonthlyFeeDet	WITH(NOLOCK)	ON	MonthlyFee.MonthlyFeeId	=	MonthlyFeeDet.MonthlyFeeId
			INNER JOIN MstCustomer				AS	Customer		WITH(NOLOCK)	ON	MonthlyFee.CustomerId	=	Customer.CustomerId
			INNER JOIN MstLocationFacility		AS	Facility		WITH(NOLOCK)	ON	MonthlyFee.FacilityId	=	Facility.FacilityId
			LEFT JOIN	FMTimeMonth				AS	TimeMonth		WITH(NOLOCK)	ON	MonthlyFeeDet.Month		=	TimeMonth.MonthId
GO
