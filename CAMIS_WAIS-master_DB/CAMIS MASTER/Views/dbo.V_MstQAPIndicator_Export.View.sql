USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_MstQAPIndicator_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_MstQAPIndicator_Export]
AS
	SELECT	QAPInd.QAPIndicatorId,
			IndicatorCode as IndicatorNumber,
			IndicatorDescription,
			QAPInd.IndicatorStandard,
			QAPInd.ModifiedDateUTC
	FROM	MstQAPIndicator				AS	QAPInd		WITH(NOLOCK)
			INNER JOIN MstService		AS	Service		WITH(NOLOCK)	ON QAPInd.ServiceId		=	Service.ServiceId
GO
