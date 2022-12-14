USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_KPIReportsandRecordTxn_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------












CREATE VIEW [dbo].[V_KPIReportsandRecordTxn_Export]

AS

	SELECT	ReportsandRecordTxn.ReportsandRecordTxnId,

			ReportsandRecordTxn.Month AS MonthId,

			MonthId.Month			  AS MonthName,
			
	  	    ReportsandRecordTxn.Year as YearName,

			Facility.FacilityId,

			Facility.CustomerId,

			Facility.FacilityCode,

			Facility.FacilityName,

			ReportsandRecordTxnDet.ReportsandRecordTxnDetId,

			ReportsandRecordTxnDet.ReportName,

			CASE WHEN ReportsandRecordTxnDet.Submitted =1 THEN 'YES' ELSE 'NO' END AS Submitted,

			CASE WHEN ReportsandRecordTxnDet.Verified =1 THEN 'YES' ELSE 'NO' END AS Verified,

			ReportsandRecordTxnDet.Remarks,

			ReportsandRecordTxn.ModifiedDateUTC,
			CASE WHEN ISNULL(ReportsandRecordTxn.Submitted,0)=0 AND ISNULL(ReportsandRecordTxn.Verified,0)=0 THEN '' ELSE
			CASE WHEN ReportsandRecordTxn.Submitted =1 AND ISNULL(ReportsandRecordTxn.Verified,0)=0 THEN 'Submitted' ELSE
			CASE WHEN ReportsandRecordTxn.Submitted =1 AND ReportsandRecordTxn.Verified =1 THEN 'Verified' ELSE '' END END END AS StatusName
			

	FROM			KPIReportsandRecordTxn					AS		ReportsandRecordTxn					WITH(NOLOCK) 

	INNER JOIN		MstLocationFacility						AS      Facility							WITH(NOLOCK)	ON ReportsandRecordTxn.FacilityId	= Facility.FacilityId

	INNER JOIN		KPIReportsandRecordTxnDet				AS      ReportsandRecordTxnDet				WITH(NOLOCK)	ON ReportsandRecordTxn.ReportsandRecordTxnId	= ReportsandRecordTxnDet.ReportsandRecordTxnId

	INNER JOIN		FMTimeMonth								AS      MonthId								WITH(NOLOCK)	ON ReportsandRecordTxn.Month	= MonthId.MonthId
GO
