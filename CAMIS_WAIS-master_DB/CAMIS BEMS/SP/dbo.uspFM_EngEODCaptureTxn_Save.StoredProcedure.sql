USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODCaptureTxn_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODCaptureTxn_Save
Description			: QAPIndicator Insert/update
Authors				: Dhilip V
Date				: 02-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @EngEODCaptureTxnDet		[dbo].[udt_EngEODCaptureTxnDet]
INSERT INTO @EngEODCaptureTxnDet (CaptureDetId,CustomerId,FacilityId,ServiceId,CaptureId,AssetTypeCodeId,ParameterMappingDetId,ParamterValue,Minimum,Maximum,ActualValue,Status) 
VALUES 
(0,1,2,2,NULL,1,2,'PM','10','15','10',1)
EXEC [uspFM_EngEODCaptureTxn_Save] @EngEODCaptureTxnDet=@EngEODCaptureTxnDet,@pCaptureId=0,@pCustomerId=1,@pFacilityId=2,@pServiceId=2,@pCaptureDocumentNo='C101',
@pRecordDate='2018-01-01',@pAssetClassificationId=1,@pCategorySystemDetId=NULL,@pCaptureStatusLovId=1,@pAssetId=1,@pUserAreaId=1,@pUserLocationId=1,@pUserId=1
SELECT * FROM EngEODCaptureTxn
SELECT * FROM EngEODCaptureTxnDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngEODCaptureTxn_Save]
	@EngEODCaptureTxnDet		[dbo].[udt_EngEODCaptureTxnDet]	READONLY,
	@pCaptureId						INT,
	@pCustomerId					INT,
	@pFacilityId					INT,
	@pServiceId						INT,
	@pCaptureDocumentNo				NVARCHAR(50)		=	NULL,
	@pRecordDate					DATETIME,
	@pAssetClassificationId				INT					=	NULL,
	@pAssetTypeCodeId				INT,
	--@pCategorySystemDetId			INT					=	NULL,
	@pCaptureStatusLovId			INT					=	NULL,
	@pAssetId						INT,
	@pUserAreaId					INT					=	NULL,
	@pUserLocationId				INT					=	NULL,
	@pUserId						INT,
	@pTimestamp						VARBINARY(200)		=	NULL,
	@pNextCaptureDate				DATETIME =	NULL
				
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE	@pRecordDateUTC DATETIME
	DECLARE @mMonth INT,@mYear INT
	SELECT	@mMonth =	DATEPART(MM,@pRecordDate)
	SELECT	@mYear  =	DATEPART(YYYY,@pRecordDate)
-- Default Values

	SET @pRecordDateUTC			= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pRecordDate)

-- Execution

    IF(ISNULL(@pCaptureId,0)= 0 OR @pCaptureId='')
	  BEGIN

DECLARE @pOutParam NVARCHAR(50) 
	  EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngEODCaptureTxn',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='ER',@pModuleName='BEMS',@pService=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam output
SELECT @pCaptureDocumentNo=@pOutParam

	          INSERT INTO EngEODCaptureTxn (	CustomerId,
												FacilityId,
												ServiceId,
												CaptureDocumentNo,
												RecordDate,
												RecordDateUTC,
												AssetClassificationId,
												--CategorySystemDetId,
												AssetTypeCodeId,
												CaptureStatusLovId,
												AssetId,
												UserAreaId,
												UserLocationId,
												CreatedBy,
												CreatedDate,
												CreatedDateUTC,
												ModifiedBy,
												ModifiedDate,
												ModifiedDateUTC,
												NextCaptureDate							                                                                                                           
											)OUTPUT INSERTED.CaptureId INTO @Table
			  VALUES						(	@pCustomerId,
												@pFacilityId,
												@pServiceId,
												@pCaptureDocumentNo,
												@pRecordDate,
												@pRecordDateUTC,
												@pAssetClassificationId,
												--@pCategorySystemDetId,
												@pAssetTypeCodeId,
												@pCaptureStatusLovId,
												@pAssetId,
												@pUserAreaId,
												@pUserLocationId,
												@pUserId,
												GETDATE(),
												GETUTCDATE(),
												@pUserId,
												GETDATE(),
												GETUTCDATE(),
												@pNextCaptureDate						
											)


			DECLARE @mPrimaryId INT;
			SELECT @mPrimaryId	=	CaptureId from EngEODCaptureTxn WHERE	CaptureId IN (SELECT ID FROM @Table)

	        INSERT INTO EngEODCaptureTxnDet(	CaptureId,
												CustomerId,
												FacilityId,
												ServiceId,
												--AssetTypeCodeId,
												ParameterMappingDetId,
												ParamterValue,
												Standard,
												Minimum,
												Maximum,
												ActualValue,
												Status,
												CreatedBy,
												CreatedDate,
												CreatedDateUTC,
												ModifiedBy,
												ModifiedDate,
												ModifiedDateUTC,
												UOMId							                                                                                                           
											)
									SELECT	@mPrimaryId,
											CustomerId,
											FacilityId,
											ServiceId,
											--AssetTypeCodeId,
											ParameterMappingDetId,
											ParamterValue,
											Standard,
											Minimum,
											Maximum,
											ActualValue,
											Status,
											@pUserId,
											GETDATE(),
											GETUTCDATE(),
											@pUserId,
											GETDATE(),
											GETUTCDATE(),
											UOMId
									FROM	@EngEODCaptureTxnDet
									WHERE	ISNULL(CaptureDetId,0)= 0



			   	   SELECT				CaptureId,
										[Timestamp],
										'' as ErrorMessage,
										CaptureDocumentNo,
										GuId
				   FROM					EngEODCaptureTxn
				   WHERE				CaptureId IN (SELECT ID FROM @Table)
	
		END
  ELSE
	  BEGIN

			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp FROM	EngEODCaptureTxn 
			WHERE	CaptureId	=	@pCaptureId

			IF (@mTimestamp= @pTimestamp)

			BEGIN

				UPDATE EngEODCaptureTxn SET	CustomerId				=	@pCustomerId,
											FacilityId				=	@pFacilityId,
											ServiceId				=	@pServiceId,
											--CaptureDocumentNo		=	@pCaptureDocumentNo,
											RecordDate				=	@pRecordDate,
											RecordDateUTC			=	@pRecordDateUTC,
											AssetClassificationId		=	@pAssetClassificationId,
											--CategorySystemDetId		=	@pCategorySystemDetId,
											AssetTypeCodeId			=	@pAssetTypeCodeId,
											CaptureStatusLovId		=	@pCaptureStatusLovId,
											AssetId					=	@pAssetId,
											UserAreaId				=	@pUserAreaId,
											UserLocationId			=	@pUserLocationId,
											ModifiedBy				=	@pUserId,
											ModifiedDate			=	GETDATE(),
											ModifiedDateUTC			=	GETUTCDATE(),
											NextCaptureDate			=	@pNextCaptureDate
											OUTPUT INSERTED.CaptureId INTO @Table
				WHERE CaptureId =   @pCaptureId

				UPDATE EODCaptureDet SET	EODCaptureDet.CustomerId				= udtEODCaptureDet.CustomerId,
											EODCaptureDet.FacilityId				= udtEODCaptureDet.FacilityId,
											EODCaptureDet.ServiceId					= udtEODCaptureDet.ServiceId,
											EODCaptureDet.CaptureId					= udtEODCaptureDet.CaptureId,
											--EODCaptureDet.AssetTypeCodeId			= udtEODCaptureDet.AssetTypeCodeId,
											EODCaptureDet.ParameterMappingDetId		= udtEODCaptureDet.ParameterMappingDetId,
											EODCaptureDet.ParamterValue				= udtEODCaptureDet.ParamterValue,
											EODCaptureDet.Standard					= udtEODCaptureDet.Standard,
											EODCaptureDet.Minimum					= udtEODCaptureDet.Minimum,
											EODCaptureDet.Maximum					= udtEODCaptureDet.Maximum,
											EODCaptureDet.ActualValue				= udtEODCaptureDet.ActualValue,
											EODCaptureDet.Status					= udtEODCaptureDet.Status,
											EODCaptureDet.ModifiedBy				= @pUserId,
											EODCaptureDet.ModifiedDate				= GETDATE(),
											EODCaptureDet.ModifiedDateUTC			= GETUTCDATE(),
											EODCaptureDet.UOMId						= udtEODCaptureDet.UOMId
				FROM	EngEODCaptureTxnDet				AS	EODCaptureDet
						INNER JOIN @EngEODCaptureTxnDet	AS	udtEODCaptureDet	ON	EODCaptureDet.CaptureDetId	=	udtEODCaptureDet.CaptureDetId
				WHERE	ISNULL(udtEODCaptureDet.CaptureDetId,0)> 0

			   	SELECT	CaptureId,
						[Timestamp],
						'' ErrorMessage,
						CaptureDocumentNo,
						GuId
				FROM	EngEODCaptureTxn
				WHERE	CaptureId =@pCaptureId

	END
	ELSE
		BEGIN
				SELECT	CaptureId,
						[Timestamp],
						'Record Modified. Please Re-Select' ErrorMessage,
						CaptureDocumentNo,
						GuId
				FROM	EngEODCaptureTxn
				WHERE	CaptureId = @pCaptureId
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
