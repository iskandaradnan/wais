USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODParameterMappingDet_GetByCategorySystemId]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODParameterMappingDet_GetByCategorySystemId
Description			: To Get the data from table MstQAPIndicator using the Primary Key id
Authors				: Dhilip V
Date				: 03-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngEODParameterMappingDet_GetByCategorySystemId] @pAssetTypeCodeId=11,@pRecordDate=null,@pAssetClassificationId=1
select * from EngEODParameterMappingDet


-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngEODParameterMappingDet_GetByCategorySystemId]                           
	
	--@pServiceId				INT,
	@pRecordDate			DATETIME =null,
	@pAssetTypeCodeId		INT,
	@pAssetClassificationId	INT,
	@pUserRegistrationId    INT,
	@pAssetId			    INT =null
	
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @pEmailId NVARCHAR(100)

	SET @pEmailId = (SELECT Email FROM UMUserRegistration WHERE UserRegistrationId = @pUserRegistrationId)


    SELECT	EODParameterDet.ParameterMappingDetId,
			EODParameterDet.Parameter,
			EODParameterDet.Standard,
			EODParameterDet.UOMId,
			UOMVal.UnitOfMeasurement,
			EODParameterDet.DataTypeLovId,
			LovDataType.FieldValue				AS	DataType,
			EODParameterDet.DataValue,
			EODParameterDet.Minimum,
			EODParameterDet.Maximum,
			EODParameter.FrequencyLovId,
			Frequency.FieldValue as Frequency,
			@pEmailId AS Email
	INTO	#TempEODParameter
	FROM	EngEODParameterMappingDet								AS EODParameterDet	WITH(NOLOCK)
			INNER JOIN EngEODParameterMapping						AS EODParameter		WITH(NOLOCK)	ON EODParameterDet.ParameterMappingId	= EODParameter.ParameterMappingId
			INNER JOIN FMUOM										AS UOMVal				WITH(NOLOCK)	ON EODParameterDet.UOMId			= UOMVal.UOMId
			INNER JOIN MstService									AS Service			WITH(NOLOCK)	ON EODParameter.ServiceId				= Service.ServiceId
			INNER JOIN FMLovMst										AS LovDataType		WITH(NOLOCK)	ON EODParameterDet.DataTypeLovId		= LovDataType.LovId
			LEFT  JOIN  FMLovMst									AS Frequency		WITH(NOLOCK)	on EODParameter.FrequencyLovId			= Frequency.LovId

	WHERE	((ISNULL(@pAssetTypeCodeId,'')='' )		OR (ISNULL(@pAssetTypeCodeId,'') <> '' AND EODParameter.AssetTypeCodeId =   @pAssetTypeCodeId ))
			AND ((ISNULL(@pAssetClassificationId,'')='' )		OR (ISNULL(@pAssetClassificationId,'') <> '' AND EODParameter.AssetClassificationId =   @pAssetClassificationId ))
			AND ((ISNULL(@pRecordDate,'') = '' )	OR (ISNULL(@pRecordDate,'') <> '' AND ( EODParameterDet.EffectiveFrom <= @pRecordDate )))
			--AND ((ISNULL(@pRecordDate,'') = '' OR ISNULL(EODParameterDet.EffectiveTo,'') = '1900-01-01' )	OR (ISNULL(@pRecordDate,'') <> '' AND (  CAST(EODParameterDet.EffectiveTo AS DATE) >= CAST(@pRecordDate AS DATE) )))
			AND EODParameterDet.StatusId = 1 
			and exists (select 1 from engasset e
			where assetid=@pAssetId and e.Model  =  EODParameter.ModelId  and e.AssetTypeCodeId=EODParameter.AssetTypeCodeId)
			
	ORDER BY EODParameterDet.ModifiedDateUTC DESC

	IF EXISTS (SELECT 1 FROM #TempEODParameter)
		BEGIN
			SELECT * FROM #TempEODParameter
		END
	--ELSE
	--	BEGIN
	--		SELECT 'EOD Parameters not defined for the Category System Name'
	--	END

END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		THROW;

END CATCH
GO
