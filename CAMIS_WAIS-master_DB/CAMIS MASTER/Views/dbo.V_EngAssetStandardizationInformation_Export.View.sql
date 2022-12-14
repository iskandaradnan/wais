USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngAssetStandardizationInformation_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_EngAssetStandardizationInformation_Export]
AS

	SELECT	AssetStand.AssetInfoId,
			AssetStand.AssetInfoTypeName,
			AssetStand.AssetInfoValue,
			CASE WHEN AssetStand.Active=1 THEN 'Active'
				 WHEN AssetStand.Active=1 THEN 'Inactive'
			END									AS	StatusValue,
			AssetStand.ModifiedDateUTC			
			FROM	(
						SELECT	ManufacturerId AS AssetInfoId,
								'Manufacturer' AS AssetInfoTypeName,
								Manufacturer AS AssetInfoValue,
								ModifiedDateUTC,
								Active
						FROM	EngAssetStandardizationManufacturer
						UNION
						SELECT	ModelId,
								'Model' AS AssetInfoTypeName,
								Model,
								ModifiedDateUTC,
								Active
						FROM EngAssetStandardizationModel
					)	AS AssetStand
GO
