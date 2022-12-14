USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_MstQAPQualityCause]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_MstQAPQualityCause]
AS
	SELECT	DISTINCT QAPQC.QualityCauseId,
			Service.ServiceKey			AS	Service,
			CauseCode,
			Description,
			QAPQCDet.QcCode,
			LovProbCode.FieldValue		AS	ProblemValue,
			LovStatus.FieldValue		AS StatusValue,
			QAPQC.Active,
			QAPQC.ModifiedDateUTC
	FROM	MstQAPQualityCause					AS	QAPQC			WITH(NOLOCK)
			INNER JOIN MstService				AS	Service			WITH(NOLOCK)	ON QAPQC.ServiceId			=	Service.ServiceId
			LEFT JOIN MstQAPQualityCauseDet		AS	QAPQCDet		WITH(NOLOCK)	ON QAPQC.QualityCauseId		=	QAPQCDet.QualityCauseId
			LEFT JOIN FMLovMst					AS	LovProbCode		WITH(NOLOCK)	ON QAPQCDet.ProblemCode		=	LovProbCode.LovId
			LEFT JOIN FMLovMst					AS	LovStatus		WITH(NOLOCK)	ON QAPQCDet.Status			=	LovStatus.LovId
GO
