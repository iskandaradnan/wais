USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstDedIndicator]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_MstDedIndicator]
AS
	SELECT		IndicatorMst.IndicatorId,
				IndicatorDet.IndicatorNo,
				IndicatorDet.IndicatorName,
				IndicatorDet.IndicatorDesc,
				IndicatorDet.Frequency,
				LovFrequency.FieldValue			AS	FrequencyName,
				ServiceKey AS ServiceName,
				IndicatorDet.ModifiedDateUTC
	FROM		MstDedIndicator					AS IndicatorMst WITH(NOLOCK)
				INNER JOIN MstDedIndicatorDet	AS IndicatorDet WITH(NOLOCK) ON IndicatorMst.IndicatorId = IndicatorDet.IndicatorId
				INNER JOIN FMLovMst				AS LovFrequency WITH(NOLOCK) ON IndicatorDet.Frequency	 = LovFrequency.LovId
				INNER JOIN MstService			AS Service		WITH(NOLOCK) ON IndicatorMst.ServiceId	 = Service.ServiceId
	WHERE		IndicatorMst.Active =1
GO
