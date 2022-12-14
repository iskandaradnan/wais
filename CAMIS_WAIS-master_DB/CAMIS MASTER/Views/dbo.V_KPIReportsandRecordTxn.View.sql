USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_KPIReportsandRecordTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------












CREATE VIEW [dbo].[V_KPIReportsandRecordTxn]

AS

	SELECT	ReportsandRecord.ReportsandRecordTxnId,

			ReportsandRecord.Month AS MonthId,

			MonthId.Month			  AS MonthName,
			
	  	    ReportsandRecord.Year as  YearName,

			ReportsandRecord.ModifiedDateUTC,

			CASE WHEN ISNULL(ReportsandRecord.Submitted,0)=0 AND ISNULL(ReportsandRecord.Verified,0)=0 THEN '' ELSE
			CASE WHEN ReportsandRecord.Submitted =1 AND ISNULL(ReportsandRecord.Verified,0)=0 THEN 'Submitted' ELSE
			CASE WHEN ReportsandRecord.Submitted =1 AND ReportsandRecord.Verified =1 THEN 'Verified' ELSE '' END END END AS StatusName,
			ReportsandRecord.FacilityId 

	FROM			KPIReportsandRecordTxn					AS		ReportsandRecord	WITH(NOLOCK) 

	INNER JOIN		FMTimeMonth								AS      MonthId				WITH(NOLOCK)	ON ReportsandRecord.Month	= MonthId.MonthId
GO
