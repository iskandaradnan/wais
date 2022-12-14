USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODCaptureTxn_GetById]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODCaptureTxn_GetById
Description			: To Get the data from table MstQAPIndicator using the Primary Key id
Authors				: Dhilip V
Date				: 05-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngEODCaptureTxn_GetById] @pCaptureId=176
select * from EngEODCaptureTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngEODCaptureTxn_GetById]                           

  @pCaptureId	INT
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	DECLARE @mEmailId NVARCHAR(100)
	DECLARE @mUserRegistrationId NVARCHAR(100)

	SET @mUserRegistrationId = (SELECT CreatedBy FROM EngEODCaptureTxn WHERE CaptureId = @pCaptureId)
	SET @mEmailId = (SELECT Email FROM UMUserRegistration WHERE UserRegistrationId = @mUserRegistrationId)

--- Header table
    SELECT	EODCapture.CaptureId,
			EODCapture.CustomerId,
			EODCapture.CaptureDocumentNo,
			EODCapture.ServiceId,
			ServiceKey.ServiceKey,
			EODCapture.RecordDate,
			EODCapture.AssetClassificationId,
			Classification.AssetClassificationCode AS AssetClassification,
			EODCapture.AssetId,
			Asset.AssetNo,
			Asset.AssetDescription,
			EODCapture.UserAreaId,
			Area.UserAreaCode,
			Area.UserAreaName,			
			EODCapture.UserLocationId,
			Location.UserLocationCode,
			Location.UserLocationName,
			EODCapture.AssetTypeCodeId,
			TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			EODCapture.Timestamp,
			EODCapture.GuId,
			--FORMAT(NextCaptureDate,'dd-MMM-yyyy') AS NextCaptureDate,
			NextCaptureDate,
			CASE WHEN CAST(NextCaptureDate AS DATE)<GETDATE() THEN 0 ELSE 1 END AS IsExpiry,
			@mEmailId AS EmailId,
			f.Frequency

	FROM	EngEODCaptureTxn								AS EODCapture	WITH(NOLOCK)
			INNER JOIN EngAssetClassification				AS Classification WITH(NOLOCK)	ON EODCapture.AssetClassificationId	= Classification.AssetClassificationId
			INNER JOIN EngAsset								AS Asset		WITH(NOLOCK)	ON EODCapture.AssetId			= Asset.AssetId
			INNER JOIN MstLocationUserArea AS Area WITH(NOLOCK)	ON EODCapture.UserAreaId			= Area.UserAreaId
			INNER JOIN MstLocationUserLocation AS Location WITH(NOLOCK)	ON EODCapture.UserLocationId			= Location.UserLocationId
			INNER JOIN EngAssetTypeCode AS TypeCode WITH(NOLOCK)	ON EODCapture.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
			
			INNER JOIN MstCustomer							AS Customer		WITH(NOLOCK)	ON EODCapture.CustomerId			= Customer.CustomerId
			INNER JOIN MstLocationFacility					AS Facility		WITH(NOLOCK)	ON EODCapture.FacilityId			= Facility.FacilityId
			INNER JOIN MstService			 				AS ServiceKey	WITH(NOLOCK)	ON EODCapture.ServiceId			= ServiceKey.ServiceId
			outer apply (select top 1 d.FieldValue  as Frequency from  EngEODCaptureTxndet a join EngEODParameterMappingDet  b  on a.ParameterMappingDetId=b.ParameterMappingDetId
						 join EngEODParameterMapping  c  on b.ParameterMappingId=c.ParameterMappingId
						 join FMLovMst  d on c.FrequencyLovId=d.LovId
			where a.CaptureId = EODCapture.CaptureId) f

	WHERE	EODCapture.CaptureId = @pCaptureId
	ORDER BY EODCapture.ModifiedDateUTC DESC
	
	
	
--- Detail Grid
	SELECT	
			EODCaptureDet.CaptureDetId,
			EODCaptureDet.CaptureId,			
			EODCaptureDet.ParameterMappingDetId,
			EODCaptureDet.ParamterValue,
			EODCaptureDet.Standard,
			EODCaptureDet.Minimum,
			EODCaptureDet.Maximum,
			EODParamMapping.DataTypeLovId,
			LovDataType.FieldValue AS DataType,
			EODParamMapping.DataValue,
			EODCaptureDet.ActualValue,
			EODCaptureDet.Status,
			EODCaptureDet.UOMId,
			UOM.UnitOfMeasurement
	FROM	EngEODCaptureTxn								AS EODCapture		WITH(NOLOCK)
			INNER JOIN EngEODCaptureTxnDet					AS EODCaptureDet	WITH(NOLOCK)	ON EODCapture.CaptureId					= EODCaptureDet.CaptureId
			INNER JOIN EngEODParameterMappingDet			AS EODParamMapping	WITH(NOLOCK)	ON EODCaptureDet.ParameterMappingDetId  = EODParamMapping.ParameterMappingDetId
			INNER JOIN FMLovMst								AS LovDataType		WITH(NOLOCK)	ON EODParamMapping.DataTypeLovId		= LovDataType.LovId
			LEFT JOIN FMUOM									AS UOM				WITH(NOLOCK)	ON EODCaptureDet.UOMId					= UOM.UOMId
	WHERE	EODCaptureDet.CaptureId = @pCaptureId
	ORDER BY EODCapture.ModifiedDateUTC DESC


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
