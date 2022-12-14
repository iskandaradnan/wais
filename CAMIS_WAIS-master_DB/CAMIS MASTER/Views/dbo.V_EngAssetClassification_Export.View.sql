USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngAssetClassification_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_EngAssetClassification_Export]
AS

SELECT		a.AssetClassificationId,
			a.AssetClassificationCode,
			a.AssetClassificationDescription,
				
		    a.Remarks,
			CASE WHEN a.Active=1 THEN 'Active'
				 ELSE 'Inactive' 
			END [Status],
			a.Active,
			a.ModifiedDateUTC
			FROM EngAssetClassification	a	WITH(NOLOCK)
			INNER JOIN MstService b on a.ServiceId=b.ServiceId
GO
