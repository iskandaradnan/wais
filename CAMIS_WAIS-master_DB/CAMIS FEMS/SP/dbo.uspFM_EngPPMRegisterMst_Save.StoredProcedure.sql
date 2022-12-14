USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngPPMRegisterMst_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetTypeCode_Save
Description			: Insert/update the typecode details
Authors				: Dhilip V
Date				: 19-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @EngAssetTypeCode					[dbo].[udt_EngAssetTypeCode]
INSERT INTO @EngAssetTypeCode (AssetTypeCodeId,ServiceId,AssetClassificationId,AssetTypeCode,AssetTypeDescription,RiskRatingLovId,EquipmentFunctionCatagoryLovId
,IsLicenceAndCertificateApplicable,ExpectedLifeSpan,QAPAssetTypeB1,QAPServiceAvailabilityB2,QAPUptimeTargetPerc,EffectiveFrom,EffectiveFromUTC,TRPILessThan5YrsPerc
,TRPI5to10YrsPerc,TRPIGreaterThan10YrsPerc,UserId) 
VALUES (	6,2,1,'BE301','bems 201',          115,116,0,     5,0,1,     20,'2018-03-20 13:23:42.203','2018-03-20 13:23:42.203',1,2,3,   1) 

DECLARE @EngAssetTypeCodeFlag				[dbo].[udt_EngAssetTypeCodeFlag]
INSERT INTO @EngAssetTypeCodeFlag (AssetTypeCodeId,MaintenanceFlag,UserId) 
VALUES (	NULL,94,1) 

DECLARE @EngAssetTypeCodeAddSpecification	[dbo].[udt_EngAssetTypeCodeAddSpecification]
INSERT INTO @EngAssetTypeCodeAddSpecification (AssetTypeCodeId,SpecificationType,SpecificationUnit,UserId) 
VALUES (	NULL,120,118,1) 

DECLARE @EngAssetTypeCodeVariationRate		[dbo].[udt_EngAssetTypeCodeVariationRate]   
INSERT INTO @EngAssetTypeCodeVariationRate (AssetTypeCodeId,TypeCodeParameterId,VariationRate,EffectiveFromDate,EffectiveFromDateUTC,UserId) 
VALUES (	NULL,1,'50','2018-03-20 13:23:42.203','2018-03-20 13:23:42.203',1) 

EXEC [uspFM_EngAssetTypeCode_Save] @EngAssetTypeCode=@EngAssetTypeCode
,@EngAssetTypeCodeFlag=@EngAssetTypeCodeFlag,@EngAssetTypeCodeAddSpecification=@EngAssetTypeCodeAddSpecification,
@EngAssetTypeCodeVariationRate=@EngAssetTypeCodeVariationRate, @pAssetTypeCodeId=6,@pTimestamp='0x0000000000005D81'


SELECT * FROM EngAssetTypeCode
SELECT * FROM EngAssetTypeCodeFlag
SELECT * FROM EngAssetTypeCodeAddSpecification
SELECT * FROM EngAssetTypeCodeVariationRate

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngPPMRegisterMst_Save]
		@pFMDocument						[dbo].[udt_FMDocument]		 READONLY,
	    @pDocumentId						INT							=	NULL,
		@pPPMId				            	INT							=	NULL,
        @pServiceId				            INT							=	NULL,
        @pAssetTypeCodeId				    INT							=	NULL,
        @pStandardTaskDetId				    INT							=	NULL,
        @pPPMChecklistNo				    Nvarchar(200)				=	NULL,

        @pManufacturerId				    INT							=	NULL,
		@pModelId							INT							=	NULL,
        @pPPMFrequency				        INT							=	NULL,
        @pPPMHours				            Numeric(15,2)				=	NULL,
        @pBemsTaskCode						nvarchar(400)			    =	NULL,
	    @pActive							bit			   ,
	    @pVersion						    Numeric(15,2)				=	NULL,
	    @pEffectiveDate						Datetime			        =	NULL,
		@pUploadDate						Datetime			       =	NULL,
		@pTimestamp			 				VARBINARY(200)				=	NULL,		
	    @pGuId							    Nvarchar(200)				=	NULL,
        @pUserId			   	           INT							=	NULL

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
		
	DECLARE @Table1 TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT




--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.EngAssetTypeCode


	IF(ISNULL(@pPPMId,0)=0 OR @pPPMId='')
		
	BEGIN

	  	   DECLARE @Cnt INT;
		   DECLARE @CntCombination INT;


			SELECT	@Cnt = COUNT(1) FROM   EngPPMRegisterMst 	WHERE	 BemsTaskCode =@pBemsTaskCode and Active=1

			SELECT	@CntCombination = COUNT(1) FROM   EngPPMRegisterMst 	WHERE	 AssetTypeCodeId =@pAssetTypeCodeId AND ModelId=@pModelId 
			                         AND ManufacturerId=@pManufacturerId AND PPMFrequency=@pPPMFrequency  and Active=1
		IF (@Cnt = 0 AND @CntCombination =0) 
			
		BEGIN


				DECLARE @AssetTypeCode NVARCHAR(50)
	             SELECT  @AssetTypeCode= PPM.BemsTaskCode
	              FROM	EngAssetTypeCode  AS TypeCode WITH(NOLOCK) 
			      INNER JOIN EngPPMRegisterMst AS PPM WITH(NOLOCK) ON TypeCode.AssetTypeCodeId	=	PPM.AssetTypeCodeId
	              WHERE	PPM.AssetTypeCodeId	=1 --IN	(SELECT AssetTypeCodeId FROM @EngPPMRegisterMstType WHERE ISNULL(PPMId,0)=0)
	            GROUP BY PPM.BemsTaskCode


				INSERT INTO EngPPMRegisterMst
							(	
								
							
                                 ServiceId
                                ,AssetTypeCodeId
                                ,StandardTaskDetId
                                ,PPMChecklistNo
                                ,ManufacturerId

                                ,ModelId
                                ,PPMFrequency
                                ,PPMHours
                                ,BemsTaskCode
                                ,CreatedBy
                                ,CreatedDate
                                ,CreatedDateUTC
                                ,ModifiedBy
                                ,ModifiedDate
                                ,ModifiedDateUTC
                             
                   			)	OUTPUT INSERTED.PPMId INTO @Table
					VALUES	(
					
					         @pServiceId,
							 @pAssetTypeCodeId,
							 @pStandardTaskDetId,
							 (SELECT 'KKM/BEMS/' +  ISNULL(CAST(MAX(RIGHT(PPMChecklistNo,4)) + 1 AS NVARCHAR(50)),1000) FROM EngPPMRegisterMst where PPMChecklistNo like 'KKM/BEMS/%') ,
							 @pManufacturerId,

							 @pModelId,
							 @pPPMFrequency,
							 @pPPMHours,
						   isnull ( substring ( @AssetTypeCode,1,len(@AssetTypeCode)-6) + right('000000'+ cast((select max(RIGHT(@AssetTypeCode,6))+1 from EngPPMRegisterMst  where AssetTypeCodeId= @pAssetTypeCodeId) as nvarchar(20) ),6 ) ,
					          (select top 1 AssetTypeCode+'-'+'000001' FROM EngAssetTypeCode  TypeCode WHERE AssetTypeCodeId=TypeCode.AssetTypeCodeId ) ) 

		
							 ,@pUserId
							 ,GETDATE()
							 ,GETDATE()
							  ,@pUserId
							 ,GETDATE()
							 ,GETDATE()
					
					)						
				
				   SET @PrimaryKeyId  = (SELECT ID FROM @Table)
				  	INSERT INTO FMDocument(	GuId,
									CustomerId,
									FacilityId,
									DocumentNo,
									DocumentTitle,
									DocumentDescription,
									DocumentCategory,
									DocumentCategoryOthers,
									DocumentExtension,
									MajorVersion,
									MinorVersion,
									FileType,
									FileName,
									FilePath,
									ScreenId,
									Remarks,
									UploadedBy,
									UploadedDate,
									UploadedDateUTC,
									ModifiedBy,
									ModifiedDate,
									ModifiedDateUTC
								)	OUTPUT INSERTED.DocumentId INTO @Table1
								SELECT	GuId,
										CustomerId,
										FacilityId,
										DocumentNo,
										DocumentTitle,
										DocumentDescription,
										DocumentCategory,
										DocumentCategoryOthers,
										DocumentExtension,
										MajorVersion,
										MinorVersion,
										FileType,
										FileName,
										FilePath,
										ScreenId,
										Remarks,
										UserId,
										GETDATE(),
										GETUTCDATE(),
										UserId,
										GETDATE(),
										GETUTCDATE()
								FROM	@pFMDocument	udtDoc
								WHERE	ISNULL(udtDoc.DocumentId,0)=0

				declare @tempDocumentId int = (	SELECT	DocumentId FROM	FMDocument WITH(NOLOCK) WHERE	DocumentId IN (SELECT ID FROM @Table1))
			 



				INSERT INTO EngPPMRegisterHistoryMst
								(	
                                    PPMId
                                   ,DocumentId
                                   ,Version
                                   ,EffectiveDate
                                   ,UploadDate
                                 
                                   ,CreatedBy
                                   ,CreatedDate
                                   ,CreatedDateUTC
                                   ,ModifiedBy
                                   ,ModifiedDate
                                   ,ModifiedDateUTC                                  
                                   ,GuId
								)

				Values(			@PrimaryKeyId,
								@tempDocumentId,
								@pVersion,				
								@pEffectiveDate,			
								@pUploadDate,
							    @pUserId
							    ,GETDATE()
							   ,GETDATE()
							   ,@pUserId
							  ,GETDATE()
							  ,GETDATE()
							  ,@pGuId
							 )




			

				SELECT	PPMId,
						[Timestamp],
						'' ErrorMsg 
				FROM	EngPPMRegisterMst
				WHERE	PPMId IN (SELECT ID FROM @Table)

		END
		ELSE IF(@CntCombination > 0) 
		BEGIN
		      SELECT	0		AS	PPMId,
						NULL	AS	[Timestamp],
						'Combination Already Exists' ErrorMsg 
				
		END	
		ELSE 
		BEGIN
		      SELECT	0		AS	PPMId,
						NULL	AS	[Timestamp],
						'Task Code Already Exists' ErrorMsg 
				
		 END	
   END

   ELSE 
-------------------------------------------------------------------- UPDATE STATEMENT ----------------------------------------------------

------1.EngAssetTypeCode

			

		BEGIN
		 

			DECLARE @mTimestamp varbinary(200);

			SELECT	@mTimestamp = [Timestamp] 
			FROM	EngPPMRegisterMst 
			WHERE	PPMId	=	@pPPMId

			IF (@mTimestamp = @pTimestamp )
			
			BEGIN
	
	   UPDATE  PPMRegister	SET			 
								
								PPMRegister.StandardTaskDetId = @pStandardTaskDetId,
							
								PPMRegister.ManufacturerId	  = @pManufacturerId	 ,
								PPMRegister.ModelId			  = @pModelId			 ,
								PPMRegister.PPMFrequency	  = @pPPMFrequency	,
								PPMRegister.PPMHours		  = @pPPMHours		,
								
								PPMRegister.ModifiedBy		  = @pUserId	,	 
								PPMRegister.ModifiedDate	  = GETDATE(), 
								PPMRegister.ModifiedDateUTC	  = GETUTCDATE() 
							
				FROM	EngPPMRegisterMst PPMRegister 
					
				WHERE	PPMRegister.PPMId=@pPPMId


				
				  	INSERT INTO FMDocument(	GuId,
									CustomerId,
									FacilityId,
									DocumentNo,
									DocumentTitle,
									DocumentDescription,
									DocumentCategory,
									DocumentCategoryOthers,
									DocumentExtension,
									MajorVersion,
									MinorVersion,
									FileType,
									FileName,
									FilePath,
									ScreenId,
									Remarks,
									UploadedBy,
									UploadedDate,
									UploadedDateUTC,
									ModifiedBy,
									ModifiedDate,
									ModifiedDateUTC
								)	OUTPUT INSERTED.DocumentId INTO @Table1
								SELECT	GuId,
										CustomerId,
										FacilityId,
										DocumentNo,
										DocumentTitle,
										DocumentDescription,
										DocumentCategory,
										DocumentCategoryOthers,
										DocumentExtension,
										MajorVersion,
										MinorVersion,
										FileType,
										FileName,
										FilePath,
										ScreenId,
										Remarks,
										UserId,
										GETDATE(),
										GETUTCDATE(),
										UserId,
										GETDATE(),
										GETUTCDATE()
								FROM	@pFMDocument	udtDoc
								WHERE	ISNULL(udtDoc.DocumentId,0)=0

				declare @tempDocumentId1 int = (	SELECT	DocumentId FROM	FMDocument WITH(NOLOCK) WHERE	DocumentId IN (SELECT top 1 ID FROM @Table1))
			 
	
	           
				INSERT INTO EngPPMRegisterHistoryMst
								(	
                                    PPMId
                                   ,DocumentId
                                   ,Version
                                   ,EffectiveDate
                                   ,UploadDate
                                 
                                   ,CreatedBy
                                   ,CreatedDate
                                   ,CreatedDateUTC
                                   ,ModifiedBy
                                   ,ModifiedDate
                                   ,ModifiedDateUTC                                  
                                   ,GuId
								)

				Values(			@pPPMId,
								@tempDocumentId1,
								@pVersion,				
								@pEffectiveDate,			
								@pUploadDate,
							    @pUserId
							    ,GETDATE()
							    ,GETDATE()
							    ,@pUserId
							   ,GETDATE()
							   ,GETDATE()
							   ,@pGuId
							 )



				SELECT	PPMId,
						[Timestamp],
						'' ErrorMsg
				FROM	EngPPMRegisterMst
				WHERE	PPMId  =@pPPMId

		END
		ELSE
			BEGIN
				SELECT	PPMId,
						[Timestamp],
						'Record Modified. Please Re-Select' AS ErrorMsg
				FROM	EngPPMRegisterMst
				WHERE	PPMId =@pPPMId
			END
		END


	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
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
