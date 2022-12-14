USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_DeductionTransactionMappingMst_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_DeductionTransactionMappingMst_Export]
AS
	SELECT	DedTxnMapping.DedTxnMappingId,
			DedTxnMapping.CustomerId,
			Customer.CustomerName,
			DedTxnMapping.FacilityId,			
			Facility.FacilityName,
			Service.ServiceKey												AS	Service,
			DATENAME( MONTH , DATEADD( MONTH , DedTxnMapping.Month , -1 ) )	AS MonthName,
			DedTxnMapping.Year,
			DedIndDet.IndicatorNo,
			FORMAT(DedTxnMappingDet.Date,'dd-MMM-yyyy')						AS	Date,
			DocumentNo	AS	[WorkOrderNo.],
			AssetNo	AS [AssetNo.],
			AssetDescription,
			Details		AS	ScreenName,
			DemeritPoint					AS	GenerateDemeritPoint,
			FinalDemeritPoint,
			CASE WHEN ISNULL(IsValid,0) =0 THEN 	'No'
				 WHEN ISNULL(IsValid,0) =1 THEN 	'Yes'
			END								AS	IsValid,
			DisputedPendingResolution,
			DedTxnMappingDet.Remarks,
			DedTxnMappingDet.ModifiedDateUTC
	FROM	DeductionTransactionMappingMst					AS	DedTxnMapping		WITH(NOLOCK)
			INNER JOIN MstCustomer							AS	Customer			WITH(NOLOCK)	ON	DedTxnMapping.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility			WITH(NOLOCK)	ON	DedTxnMapping.FacilityId			=	Facility.FacilityId
			INNER JOIN MstService							AS	Service				WITH(NOLOCK)	ON	DedTxnMapping.ServiceId				=	Service.ServiceId
			INNER JOIN MstDedIndicatorDet					AS	DedIndDet			WITH(NOLOCK)	ON	DedTxnMapping.IndicatorDetId		=	DedIndDet.IndicatorDetId
			INNER JOIN DeductionTransactionMappingMstDet	AS	DedTxnMappingDet	WITH(NOLOCK)	ON	DedTxnMapping.DedTxnMappingId		=	DedTxnMappingDet.DedTxnMappingId
GO
