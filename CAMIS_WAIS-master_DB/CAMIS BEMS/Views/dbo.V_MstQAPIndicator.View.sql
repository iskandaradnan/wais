USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstQAPIndicator]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_MstQAPIndicator]
AS
	SELECT	QAPInd.QAPIndicatorId,
			Service.ServiceKey			AS	Service,
			IndicatorCode				AS	IndicatorNumber,
			IndicatorDescription,
			QAPInd.ModifiedDateUTC
	FROM	MstQAPIndicator				AS	QAPInd		WITH(NOLOCK)
			INNER JOIN MstService		AS	Service		WITH(NOLOCK)	ON QAPInd.ServiceId		=	Service.ServiceId
GO
