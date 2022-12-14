USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODParameterMapping_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODParameterMapping_Save
Description			: QAPIndicator Insert/update
Authors				: Dhilip V
Date				: 01-May-2018
-----------------------------------------------------------------------------------------------------------
select * from FMLovMst
Unit Test:
DECLARE @EngEODParameterMappingDet [dbo].[udt_EngEODParameterMappingDet]
INSERT INTO @EngEODParameterMappingDet (ParameterMappingDetId,ParameterMappingId,Parameter,Standard,UOMId,DataTypeLovId,DataValue,Minimum,Maximum,FrequencyLovId,
EffectiveFrom,EffectiveFromUTC,EffectiveTo,EffectiveToUTC,Remarks) VALUES 
(2,2,'Param','0.1','4',176,'12345678','10','15',181,'2018-01-01','2018-01-01',null,null,null)
EXEC [uspFM_EngEODParameterMapping_Save] @EngEODParameterMappingDet=@EngEODParameterMappingDet,@pParameterMappingId=2,@pCustomerId=1,@pFacilityId=2,
@pServiceId=2,@pCategorySystemId=1,@pManufacturerId=1,@pModelId=1,@pUserId=1,@pTimestamp=null
SELECT * FROM EngEODParameterMapping
SELECT * FROM EngEODParameterMappingDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngEODParameterMapping_Save]
	@EngEODParameterMappingDet		[dbo].[udt_EngEODParameterMappingDet]	READONLY,
	@pParameterMappingId			INT,
	@pCustomerId					INT,
	@pFacilityId					INT,
	@pServiceId						INT,
	@pAssetClassificationId			INT,
	@pAssetTypeCodeId				INT,
	@pManufacturerId				INT,
	@pModelId						INT,
	@pUserId						INT,
	@pTimestamp						VARBINARY(200)		=	NULL,
	@pFrequencyLovId				INT	=	NULL
				
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

-- Default Values

-- Execution

DECLARE @CNT INT=0 
DECLARE @DuplicateCount INT
			SET		@DuplicateCount=(SELECT  COUNT(*) FROM @EngEODParameterMappingDet GROUP BY Parameter HAVING COUNT(*) > 1)



IF EXISTS(SELECT 1 FROM EngEODParameterMapping WITH(NOLOCK) WHERE AssetClassificationId = @pAssetClassificationId AND AssetTypeCodeId = @PAssetTypeCodeId AND ModelId = @pModelId AND ManufacturerId=@pManufacturerId AND (@pParameterMappingId=0 OR @pParameterMappingId=''))
BEGIN
SELECT		0 As ParameterMappingId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			'Selected Asset Classification, Asset Type Code, Model combination already added/exist' AS ErrorMessage
RETURN

END

ELSE IF (@DuplicateCount>0)
BEGIN
SELECT		0 As ParameterMappingId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			'Parameter should be unique' AS ErrorMessage
RETURN

END

ELSE
BEGIN
    IF(ISNULL(@pParameterMappingId,0)= 0 OR @pParameterMappingId='')
	BEGIN

	SELECT @CNT = COUNT(1)	FROM EngEODParameterMapping
							WHERE	Active						=	1
									AND ServiceId				=	@pServiceId
									AND AssetClassificationId	=	@pAssetClassificationId
									AND ManufacturerId			=	@pManufacturerId
									AND ModelId					=	@pModelId
	
	IF (@CNT=0)

	  BEGIN
	          INSERT INTO EngEODParameterMapping (	CustomerId,
													FacilityId,
													ServiceId,
													AssetClassificationId,
													ManufacturerId,
													ModelId,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													AssetTypeCodeId,
													FrequencyLovId			                                                                                                           
												)OUTPUT INSERTED.ParameterMappingId INTO @Table
			  VALUES						(	@pCustomerId,
												@pFacilityId,
												@pServiceId,
												@pAssetClassificationId,
												@pManufacturerId,
												@pModelId,
												@pUserId,
												GETDATE(),
												GETUTCDATE(),
												@pUserId,
												GETDATE(),
												GETUTCDATE(),
												@pAssetTypeCodeId,
												@pFrequencyLovId
											)


			DECLARE @mPrimaryId INT;
			SELECT @mPrimaryId	=	ParameterMappingId from EngEODParameterMapping WHERE	ParameterMappingId IN (SELECT ID FROM @Table)

	        INSERT INTO EngEODParameterMappingDet(	ParameterMappingId,
													Parameter,
													Standard,
													UOMId,
													DataTypeLovId,
													DataValue,
													Minimum,
													Maximum,
													FrequencyLovId,
													EffectiveFrom,
													EffectiveFromUTC,
													EffectiveTo,
													EffectiveToUTC,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													StatusId							                                                                                                           
											)
									SELECT	@mPrimaryId,
											Parameter,
											Standard,
											UOMId,
											DataTypeLovId,
											DataValue,
											Minimum,
											Maximum,
											FrequencyLovId,
											EffectiveFrom,
											EffectiveFromUTC,
											EffectiveTo,
											EffectiveToUTC,
											Remarks,
											@pUserId,
											GETDATE(),
											GETUTCDATE(),
											@pUserId,
											GETDATE(),
											GETUTCDATE(),
											StatusId
									FROM	@EngEODParameterMappingDet
									WHERE	ISNULL(ParameterMappingDetId,0)= 0



			   	   SELECT				ParameterMappingId,
										[Timestamp],
										'' as ErrorMessage
				   FROM					EngEODParameterMapping
				   WHERE				ParameterMappingId IN (SELECT ID FROM @Table)
	
		END
	ELSE
	BEGIN
	  SELECT ParameterMappingId,Timestamp, 'Selected Asset Classification, Asset Type Code, Model combination already added/exist' AS ErrorMessage
	  FROM EngEODParameterMapping
						WHERE	Active						=	1
								AND ServiceId				=	@pServiceId
								AND AssetClassificationId	=	@pAssetClassificationId
								AND ManufacturerId			=	@pManufacturerId
								AND ModelId					=	@pModelId
	END
	END
  ELSE
	  BEGIN

			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp FROM	EngEODParameterMapping 
			WHERE	ParameterMappingId	=	@pParameterMappingId

			IF (@mTimestamp= @pTimestamp)

			BEGIN

				UPDATE EngEODParameterMapping SET	CustomerId				=	@pCustomerId,
													FacilityId				=	@pFacilityId,
													ServiceId				=	@pServiceId,
													AssetClassificationId	=	@pAssetClassificationId,
													ManufacturerId			=	@pManufacturerId,
													ModelId					=	@pModelId,
													AssetTypeCodeId			=	@pAssetTypeCodeId,
													ModifiedBy				=	@pUserId,
													ModifiedDate			=	GETDATE(),
													ModifiedDateUTC			=	GETUTCDATE(),
													FrequencyLovId			=	@pFrequencyLovId
													OUTPUT INSERTED.ParameterMappingId INTO @Table
				WHERE ParameterMappingId =   @pParameterMappingId

				UPDATE EODParameterDet SET	EODParameterDet.ParameterMappingId		= udtEODParameterDet.ParameterMappingId,
											EODParameterDet.Parameter				= udtEODParameterDet.Parameter,
											EODParameterDet.Standard				= udtEODParameterDet.Standard,
											EODParameterDet.UOMId					= udtEODParameterDet.UOMId,
											EODParameterDet.DataTypeLovId			= udtEODParameterDet.DataTypeLovId,
											EODParameterDet.DataValue				= udtEODParameterDet.DataValue,
											EODParameterDet.Minimum					= udtEODParameterDet.Minimum,
											EODParameterDet.Maximum					= udtEODParameterDet.Maximum,
											EODParameterDet.FrequencyLovId			= udtEODParameterDet.FrequencyLovId,
											EODParameterDet.EffectiveFrom			= udtEODParameterDet.EffectiveFrom,
											EODParameterDet.EffectiveFromUTC		= udtEODParameterDet.EffectiveFromUTC,
											EODParameterDet.EffectiveTo				= udtEODParameterDet.EffectiveTo,
											EODParameterDet.EffectiveToUTC			= udtEODParameterDet.EffectiveToUTC,
											EODParameterDet.Remarks					= udtEODParameterDet.Remarks,
											EODParameterDet.ModifiedBy				= @pUserId,
											EODParameterDet.ModifiedDate			= GETDATE(),
											EODParameterDet.ModifiedDateUTC			= GETUTCDATE(),
											EODParameterDet.StatusId				= udtEODParameterDet.StatusId
				FROM	EngEODParameterMappingDet				AS	EODParameterDet
						INNER JOIN @EngEODParameterMappingDet	AS	udtEODParameterDet	ON	EODParameterDet.ParameterMappingDetId	=	udtEODParameterDet.ParameterMappingDetId
				WHERE	ISNULL(udtEODParameterDet.ParameterMappingDetId,0)> 0

				INSERT INTO EngEODParameterMappingDet(	ParameterMappingId,
													Parameter,
													Standard,
													UOMId,
													DataTypeLovId,
													DataValue,
													Minimum,
													Maximum,
													FrequencyLovId,
													EffectiveFrom,
													EffectiveFromUTC,
													EffectiveTo,
													EffectiveToUTC,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													StatusId						                                                                                                           
											)
									SELECT	@pParameterMappingId,
											Parameter,
											Standard,
											UOMId,
											DataTypeLovId,
											DataValue,
											Minimum,
											Maximum,
											FrequencyLovId,
											EffectiveFrom,
											EffectiveFromUTC,
											EffectiveTo,
											EffectiveToUTC,
											Remarks,
											@pUserId,
											GETDATE(),
											GETUTCDATE(),
											@pUserId,
											GETDATE(),
											GETUTCDATE(),
											StatusId
									FROM	@EngEODParameterMappingDet
									WHERE	ISNULL(ParameterMappingDetId,0)= 0

			   	SELECT	ParameterMappingId,
						[Timestamp],
						'' ErrorMessage
				FROM	EngEODParameterMapping
				WHERE	ParameterMappingId =@pParameterMappingId

	END
	ELSE
		BEGIN
				SELECT	ParameterMappingId,
						[Timestamp],
						'Record Modified. Please Re-Select' ErrorMessage
				FROM	EngEODParameterMapping
				WHERE	ParameterMappingId = @pParameterMappingId
		END

	END
END	
	

	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   


END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

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
