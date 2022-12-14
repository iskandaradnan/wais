USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_TandCConvertToAsset_GetById]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_TandCConvertToAsset_GetById
Description			: To Get the data from table EngTestingandCommissioningTxn using the Primary Key id
Authors				: Dhilip V
Date				: 10-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
declare @pErrorMessage nvarchar(1000)
EXEC [uspFM_TandCConvertToAsset_GetById] @pTestingandCommissioningId=195, @pErrorMessage = @pErrorMessage output
print @pErrorMessage
select * from EngTestingandCommissioningTxn
select * from EngTestingandCommissioningTxnDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_TandCConvertToAsset_GetById]
                     
  @pTestingandCommissioningId		INT,
  @pErrorMessage	NVARCHAR(200) OUTPUT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF EXISTS (SELECT A.TestingandCommissioningDetId 
				FROM EngAsset A 
					INNER JOIN EngTestingandCommissioningTxnDet B ON A.TestingandCommissioningDetId=B.TestingandCommissioningDetId 
				WHERE B.TestingandCommissioningId	= @pTestingandCommissioningId )
	BEGIN
		SET @pErrorMessage ='Asset Pre Registration No. already used'
	END
	ELSE
	BEGIN
		SELECT		TandCDet.TestingandCommissioningDetId,
					TandCDet.AssetPreRegistrationNo,
					CAST(TandC.TandCDate AS date)				AS	TandCDate,
					CAST(TandC.ServiceStartDate AS date)		AS	ServiceStartDate,
					CAST(TandC.PurchaseDate AS date)			AS	PurchaseDate,
					PurchaseCost,
					CAST(TandC.WarrantyStartDate AS date)		AS	WarrantyStartDate,				
					TandC.WarrantyDuration,					
					CAST(TandC.WarrantyEndDate AS date)			AS	WarrantyEndDate,
					TandC.MainSupplierName,
					CAST(CAST((DATEDIFF(m, TandC.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' + 
						CASE	WHEN DATEDIFF(m, TandC.PurchaseDate, GETDATE())%12 = 0 THEN '1' 
								ELSE cast((abs(DATEDIFF(m, TandC.PurchaseDate, GETDATE())%12)) 
						AS VARCHAR) END as NUMERIC(24,2))				AS AssetAge, 
					CAST(CAST((DATEDIFF(m, TandC.TandCDate, GETDATE())/12) AS VARCHAR) + '.' + 
						CASE	WHEN DATEDIFF(m, TandC.TandCDate, GETDATE())%12 = 0 THEN '1' 
								ELSE CAST((abs(DATEDIFF(m, TandC.TandCDate, GETDATE())%12)) 
						AS VARCHAR) END as NUMERIC(24,2))				AS YearsInService,
					TypeCode.AssetTypeCodeId,
					TypeCode.AssetTypeCode,
					TypeCode.AssetTypeDescription,

					case when exists (select MaintenanceFlag  from  EngAssetTypeCodeFlag F  where MaintenanceFlag=94 and F.AssetTypeCodeId=TypeCode.AssetTypeCodeId) then 
					99 else 100 end as PPM ,
					case when exists (select MaintenanceFlag  from  EngAssetTypeCodeFlag F  where MaintenanceFlag=95 and F.AssetTypeCodeId=TypeCode.AssetTypeCodeId) then 
					99 else 100 end as RI,
					case when exists (select MaintenanceFlag  from  EngAssetTypeCodeFlag F  where MaintenanceFlag=96 and F.AssetTypeCodeId=TypeCode.AssetTypeCodeId) then 
					99 else 100 end as Other  ,
					--TypeCodeFlag.PPM,
					--TypeCodeFlag.RI,
					--TypeCodeFlag.Other,
					Model.ModelId as Model,
					Model.Model as ModelName,
					Manufacturer.ManufacturerId as Manufacturer,
					Manufacturer.Manufacturer as ManufacturerName,
					TypeCode.AssetClassificationId,
					TandC.ServiceEndDate,
					TandC.PurchaseOrderNo,
					TandC.UserLocationId,
					UserLocation.UserLocationCode,
					UserLocation.UserLocationName,
					TandC.UserAreaId,
					UserArea.UserAreaCode,
					UserArea.UserAreaName,
					UserArea.UserAreaCode	AS CurrentAreaCode,
					UserArea.UserAreaName AS CurrentAreaName,
					Levels.LevelId,
					Levels.LevelCode,
					Levels.LevelName,
					Block.BlockId,
					Block.BlockCode,
					Block.BlockName,
					UserLocation.UserLocationId as InstalledLocationCodeId,
					UserLocation.UserLocationCode as InstalledLocationCode,
					UserLocation.UserLocationName as InstalledLocationName,
					TandC.SerialNo,
					TandC.AssetCategoryLovId,
					TypeCode.ExpectedLifeSpan
		FROM		EngTestingandCommissioningTxn				AS TandC	WITH(NOLOCK)
					INNER JOIN EngTestingandCommissioningTxnDet AS TandCDet WITH(NOLOCK)	ON	TandC.TestingandCommissioningId = TandCDet.TestingandCommissioningId
					LEFT JOIN EngAssetTypeCode					AS TypeCode WITH(NOLOCK)	ON	TandC.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN EngAssetStandardizationModel		AS Model	WITH(NOLOCK)	ON	TandC.ModelId					= Model.ModelId
					LEFT JOIN EngAssetStandardizationManufacturer	AS Manufacturer	WITH(NOLOCK)	ON	TandC.ManufacturerId	= Manufacturer.ManufacturerId
					LEFT JOIN MstLocationUserLocation			AS UserLocation 	WITH(NOLOCK)	ON	TandC.UserLocationId	= UserLocation.UserLocationId
					LEFT JOIN MstLocationUserArea				AS UserArea		 	WITH(NOLOCK)	ON	UserLocation.UserAreaId		= UserArea.UserAreaId
					LEFT JOIN MstLocationLevel					AS Levels		 	WITH(NOLOCK)	ON	UserArea.LevelId		= Levels.LevelId
					LEFT JOIN MstLocationBlock					AS Block		 	WITH(NOLOCK)	ON	Levels.BlockId			= Block.BlockId		
								
					--OUTER APPLY (SELECT	AssetTypeCodeId,
					--					AssetTypeCode,
					--					AssetTypeDescription,	
					--					MAX(PPM)					AS PPM,
					--					MAX(RI)						AS RI,
					--					MAX(Other)					AS Other
					--			FROM (	SELECT	AssetTypeCode.AssetTypeCodeId,
					--							AssetTypeCode.AssetTypeCode,
					--							AssetTypeCode.AssetTypeDescription,
					--							CASE WHEN ppm.FieldValue IS NOT NULL THEN 99 ELSE 100 END			AS PPM ,
					--							CASE WHEN ri.FieldValue IS NOT NULL THEN 99 ELSE 100 END			AS RI	,
					--							CASE WHEN Calibration.FieldValue IS NOT NULL THEN 99 ELSE 100 END	AS Other		
					--					FROM 	EngAssetTypeCode AssetTypeCode		
					--							INNER JOIN 	EngAssetTypeCodeFlag	AS CodeFlag			WITH(NOLOCK)	ON AssetTypeCode.AssetTypeCodeId		=	CodeFlag.AssetTypeCodeId
					--							LEFT JOIN 	EngAssetClassification	AS Classification	WITH(NOLOCK)	ON AssetTypeCode.AssetClassificationId	=	Classification.AssetClassificationId
					--							LEFT JOIN (select * from FMLovMst where LovId = 94) PPM on CodeFlag.MaintenanceFlag= PPM.LovId
					--							LEFT JOIN (select * from FMLovMst where LovId = 95) RI on CodeFlag.MaintenanceFlag= RI.LovId
					--							LEFT JOIN (select * from FMLovMst where LovId = 96) Calibration on CodeFlag.MaintenanceFlag= Calibration.LovId
					--					WHERE	AssetTypeCode.AssetTypeCodeId = TandC.AssetTypeCodeId
					--				) SUB GROUP BY Sub.AssetTypeCodeId,Sub.AssetTypeCode,Sub.AssetTypeDescription ) AS TypeCodeFlag
		WHERE		TandC.TestingandCommissioningId = @pTestingandCommissioningId 
					--AND ( ISNULL( Status,0) IN (290))
					--AND	TandC.TandCStatus =71
					--AND TandCDet.TestingandCommissioningDetId NOT IN (SELECT DISTINCT TestingandCommissioningDetId FROM EngAsset)

	END
END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
