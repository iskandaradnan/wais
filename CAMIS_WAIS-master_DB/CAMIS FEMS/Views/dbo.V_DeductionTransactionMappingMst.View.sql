USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_DeductionTransactionMappingMst]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_DeductionTransactionMappingMst]
AS
	SELECT	DedTxnMapping.DedTxnMappingId,
			DedTxnMapping.CustomerId,
			Customer.CustomerName,
			DedTxnMapping.FacilityId,			
			Facility.FacilityName,
			Service.ServiceKey		AS	Service,
			DATENAME( MONTH , DATEADD( MONTH , DedTxnMapping.Month , -1 ) )	AS MonthName,
			DedTxnMapping.Year,
			DedIndDet.IndicatorNo,
			DedTxnMapping.IsAdjustmentSaved,
			DedTxnMapping.ModifiedDateUTC
	FROM	DeductionTransactionMappingMst					AS	DedTxnMapping		WITH(NOLOCK)
			INNER JOIN MstCustomer							AS	Customer			WITH(NOLOCK)	ON	DedTxnMapping.CustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility			WITH(NOLOCK)	ON	DedTxnMapping.FacilityId		=	Facility.FacilityId
			INNER JOIN MstService							AS	Service			WITH(NOLOCK)	ON	DedTxnMapping.ServiceId		=	Service.ServiceId
			INNER JOIN MstDedIndicatorDet					AS	DedIndDet			WITH(NOLOCK)	ON	DedTxnMapping.IndicatorDetId		=	DedIndDet.IndicatorDetId
			--INNER JOIN DeductionTransactionMappingMstDet	AS	DedTxnMappingDet	WITH(NOLOCK)	ON	DedTxnMapping.DedTxnMappingId		=	DedTxnMappingDet.DedTxnMappingId
GO
