USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstQAPQualityCause_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_MstQAPQualityCause_Export]
AS
	SELECT	DISTINCT QAPQC.QualityCauseId,
			CauseCode,
			Description,
			QAPQCDet.QcCode,
			LovProbCode.FieldValue		AS	ProblemValue,
			QAPQCDet.Details,
			LovStatus.FieldValue		AS StatusValue,
			QAPQC.ModifiedDateUTC
	FROM	MstQAPQualityCause					AS	QAPQC			WITH(NOLOCK)
			INNER JOIN MstService				AS	Service			WITH(NOLOCK)	ON QAPQC.ServiceId			=	Service.ServiceId
			LEFT JOIN MstQAPQualityCauseDet		AS	QAPQCDet		WITH(NOLOCK)	ON QAPQC.QualityCauseId		=	QAPQCDet.QualityCauseId
			LEFT JOIN FMLovMst					AS	LovProbCode		WITH(NOLOCK)	ON QAPQCDet.ProblemCode		=	LovProbCode.LovId
			LEFT JOIN FMLovMst					AS	LovStatus		WITH(NOLOCK)	ON QAPQCDet.Status			=	LovStatus.LovId
GO
