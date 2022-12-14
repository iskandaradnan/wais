USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERApplicationTxn_Save]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_BERApplicationTxn_Save
Description			: If BER ApplicationTxn already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_BERApplicationTxn_Save] @pApplicationId=0,@pUserId=2,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pBERno='BER002',@pAssetId=1,@pCRMRequestId=NULL,@pFreqDamSincPurchased=24,
@pTotalCostImprovement=50,@pMajorBreakdown='Repair',@pHealthySafetyHazards='Repair',@pEstRepcostToExpensive=50,@pRepairEstimate=2.5,@pValueAfterRepair=5.20,@pEstDurUsgAfterRepair=5.63,
@pNotReliable='jogojog',@pStatutoryRequirements='Active',@pOtherObservations='No',@pApplicantStaffId=null,@pBERStatus=1,@pBER2TechnicalCondition=null,@pBER2RepairedWell='Active',
@pBER2SafeReliable=50,@pBER2EstimateLifeTime=12,@pBER2Syor=21,@pBER2Remarks='Completed',@pTBER2StillLifeSpan=1,@pBIL='Rsrt',@pBER1Remarks='completed',@pParentApplicationId=1,
@pApprovedDate='2018-05-09 12:07:24.283',@pApprovedDateUTC='2018-05-09 12:07:24.283',@pIsRenewal=1,@pIsRenewalExclude=1,@pRenewalStatus=1,@pRenewalOthers='Others',
@pJustificationForCertificates='Certificates',@pApplicationDate='2018-05-09 12:07:24.283',@pRejectedBERReferenceId=null,@pBER2TechnicalConditionOthers='others',
@pBER2SafeReliableOthers='Others',@pBER2EstimateLifeTimeOthers='Others',@pBERStage=2,@pCircumstanceOthers='NA',@pExaminationFirstResultOthers='NA',@pEstimatedRepairCost=50

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_BERApplicationTxn_Save]

			@pApplicationId							INT				=	NULL,
			@pUserId								INT				=	NULL,
			@pCustomerId							INT				=	NULL,
			@pFacilityId							INT				=	NULL,
			@pServiceId								INT				=	NULL,
			@pBERno									NVARCHAR(200)	=	NULL,
			@pAssetId								INT				=	NULL,

			
			@pEstRepcostToExpensive					bit	=	NULL,
			@pRepairEstimate						NUMERIC(24,2)	=	NULL,
			@pValueAfterRepair						NUMERIC(24,2)	=	NULL,
			@pEstDurUsgAfterRepair					NUMERIC(24,2)	=	NULL,
			@pNotReliable							bit	=	NULL,
			@pStatutoryRequirements					bit	=	NULL,
			@pOtherObservations						NVARCHAR(1000)	=	NULL,
			@pApplicantStaffId						INT				=	NULL,
			@pBERStatus								INT				=	NULL,
			@pBER2TechnicalCondition				NVARCHAR(1500)	=	NULL,
			@pBER2RepairedWell						NVARCHAR(1500)	=	NULL,
			@pBER2SafeReliable						NVARCHAR(1500)	=	NULL,
			@pBER2EstimateLifeTime					NVARCHAR(1500)	=	NULL,
			@pBER2Syor								varchar(250)	=	NULL,
			@pBER2Remarks							NVARCHAR(1000)	=	NULL,
			@pTBER2StillLifeSpan					BIT				=	NULL,
			@pBIL									NVARCHAR(1500)	=	NULL,
			@pBER1Remarks							NVARCHAR(1000)	=	NULL,
			@pParentApplicationId					INT				=	NULL,
			@pApprovedDate							DATETIME		=	NULL,
			@pApprovedDateUTC						DATETIME		=	NULL,
			
			@pJustificationForCertificates			NVARCHAR(1000)	=	NULL,
			@pApplicationDate						DATE			=	NULL,
			@pRejectedBERReferenceId				INT				=	NULL,
			@pBER2TechnicalConditionOthers			NVARCHAR(1000)	=	NULL,
			@pBER2SafeReliableOthers				NVARCHAR(1000)	=	NULL,
			@pBER2EstimateLifeTimeOthers			NVARCHAR(1000)	=	NULL,
			@pBERStage								INT				=	NULL,
			@pCircumstanceOthers					NVARCHAR(1000)	=	NULL,
			@pExaminationFirstResultOthers			NVARCHAR(1500)	=	NULL,
			@pEstimatedRepairCost					NUMERIC(24,2)	=	NULL,
			@pTimestamp								VARBINARY(200)	=	NULL,
			@pCurrentValue							NUMERIC(24,2)	=	NULL,
			@pRequestorStaffId						INT				=	NULL,
			@pCurrentValueRemarks					NVARCHAR(1000)	=	NULL,
			@pObsolescence							Bit=	NULL, 
			@pCannotRepair							Bit= Null ,
			@pCurrentRepairCost						NUMERIC(24,2)	=	NULL
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

	IF(@pApplicationId = NULL OR @pApplicationId =0)

	BEGIN

	     DECLARE @CNTASSETNOEXISTING INT
		 if(@pBERStage =1 )
		 begin
		  set @CNTASSETNOEXISTING= (select count(1) from BERApplicationTxn where AssetId=@pAssetId and BERStage =1 and BERStatus not in (210))
		 end 
		 else if(@pBERStage = 2)
		 begin 
		   set @CNTASSETNOEXISTING= (select count(1) from BERApplicationTxn where AssetId=@pAssetId and BERStage =2 and BERStatus not in (210))
		 end 
	     
		--  DECLARE @CNTASSETNOEXISTING INT = (SELECT COUNT(AssetId) FROM BERApplicationTxn WHERE AssetId=@pAssetId AND ((BERStage=1 and  BERStatus <> 210) or (BERStage =1 and BERStatus = 206)   or (BERStage=2 and  BERStatus <> 210) )      )
		  IF(@CNTASSETNOEXISTING = 0 ) 
		  BEGIN
				DECLARE @mAssetStartServiceDate DATETIME
				SELECT @mAssetStartServiceDate = ServiceStartDate FROM EngAsset WHERE AssetId =	@pAssetId

				IF (@mAssetStartServiceDate <= @pApplicationDate)

				BEGIN

	               DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT
	               SET @mMonth	=	MONTH(@pApplicationDate)
	               SET @mYear	=	YEAR(@pApplicationDate)
	               EXEC [uspFM_GenerateDocumentNumber] @pFlag='BERApplicationTxn',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='BER',@pModuleName=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT
	               SELECT @pBERno=@pOutParam

	          INSERT INTO BERApplicationTxn(
													CustomerId,
													FacilityId,
													ServiceId,
													BERno,
													AssetId,
												
													
													EstRepcostToExpensive,
													RepairEstimate,
													ValueAfterRepair,
													EstDurUsgAfterRepair,
													NotReliable,
													StatutoryRequirements,
													OtherObservations,
													ApplicantUserId,
													BERStatus,
													BER2TechnicalCondition,
													BER2RepairedWell,
													BER2SafeReliable,
													BER2EstimateLifeTime,
													BER2Syor,
													BER2Remarks,
													TBER2StillLifeSpan,
													BIL,
													BER1Remarks,
													ParentApplicationId,
													ApprovedDate,
													ApprovedDateUTC,
													
													JustificationForCertificates,
													ApplicationDate,
													RejectedBERReferenceId,
													BER2TechnicalConditionOthers,
													BER2SafeReliableOthers,
													BER2EstimateLifeTimeOthers,
													BERStage,
													CircumstanceOthers,
													ExaminationFirstResultOthers,
													EstimatedRepairCost,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC, 
													CurrentValue,
													RequestorUserId,
													Obsolescence,
													CurrentRepairCost,
													CannotRepair
                                                                                                           
                           )OUTPUT INSERTED.ApplicationId INTO @Table
			  VALUES								(
													@pCustomerId,					
													@pFacilityId,					
													@pServiceId,					
													@pBERno,							
													@pAssetId,						
												--	@pCRMRequestId,					
													--@pFreqDamSincPurchased,			
													--@pTotalCostImprovement,				
													@pEstRepcostToExpensive,		
													@pRepairEstimate,				
													@pValueAfterRepair,				
													@pEstDurUsgAfterRepair,			
													@pNotReliable,					
													@pStatutoryRequirements,			
													@pOtherObservations,				
													@pApplicantStaffId,				
													@pBERStatus,						
													@pBER2TechnicalCondition,		
													@pBER2RepairedWell,				
													@pBER2SafeReliable,				
													@pBER2EstimateLifeTime,			
													@pBER2Syor,						
													@pBER2Remarks,					
													@pTBER2StillLifeSpan,			
													@pBIL,							
													@pBER1Remarks,					
													@pParentApplicationId,			
													@pApprovedDate,					
													@pApprovedDateUTC,				
																	
													@pJustificationForCertificates,	
													@pApplicationDate,				
													@pRejectedBERReferenceId,		
													@pBER2TechnicalConditionOthers,	
													@pBER2SafeReliableOthers,		
													@pBER2EstimateLifeTimeOthers,	
													@pBERStage,						
													@pCircumstanceOthers,			
													@pExaminationFirstResultOthers,	
													@pEstimatedRepairCost,			
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													@pCurrentValue,
													@pRequestorStaffId,
													@pObsolescence,
													@pCurrentRepairCost,
													@pCannotRepair
													)

				 DECLARE @PRIMARYAPPLICATIONID INT=(  SELECT ApplicationId FROM BERApplicationTxn WHERE	ApplicationId IN (SELECT ID FROM @Table))

				 -- BER1 MARKS HISTORY 
				 IF(@pBER1Remarks IS NOT NULL AND @pBER1Remarks <> '' AND @pBERStage = 1 )
				 BEGIN 
					 INSERT INTO BERApplicationRemarksHistoryTxn
					   (					   
                             CustomerId
                            ,FacilityId
                            ,ServiceId
                            ,ApplicationId
                            ,Remarks
                            ,CreatedBy
                            ,CreatedDate
                            ,CreatedDateUTC
                            ,ModifiedBy
                            ,ModifiedDate
                            ,ModifiedDateUTC             			   
					   )

					   VALUES (@pCustomerId,@pFacilityId,@pServiceId, @PRIMARYAPPLICATIONID, @pBER1Remarks, @pUserId, GETDATE(), GETDATE(), @pUserId, GETDATE(), GETDATE())

				 END 
				  -- BER2 MARKS HISTORY 
			      IF(@pBER2Remarks IS NOT NULL AND @pBER2Remarks <> '' AND @pBERStage = 2 )
				 BEGIN 
					 INSERT INTO BERApplicationRemarksHistoryTxn
					   (					   
                             CustomerId
                            ,FacilityId
                            ,ServiceId
                            ,ApplicationId
                            ,Remarks
                            ,CreatedBy
                            ,CreatedDate
                            ,CreatedDateUTC
                            ,ModifiedBy
                            ,ModifiedDate
                            ,ModifiedDateUTC             			   
					   )

					   VALUES (@pCustomerId,@pFacilityId,@pServiceId, @PRIMARYAPPLICATIONID, @pBER2Remarks, @pUserId, GETDATE(), GETDATE(), @pUserId, GETDATE(), GETDATE())

				 END 
					  
                  
				 IF(@pBERStage = 2 )
				 BEGIN 
				           INSERT INTO BerCurrentValueHistoryTxnDet (
                               ApplicationId
                              ,CurrentValue
                              ,Remarks
                              ,CreatedBy
                              ,CreatedDate
                              ,CreatedDateUTC
                              ,ModifiedBy
                              ,ModifiedDate
                              ,ModifiedDateUTC
                     
                             )
							  VALUES (@PRIMARYAPPLICATIONID, @pCurrentValue, @pCurrentValueRemarks, @pUserId, GETDATE(), GETDATE(), @pUserId, GETDATE(), GETDATE())
				 END 



			   	   SELECT				ApplicationId,
										BERno,
										ber.[Timestamp],
										'' ErrorMessage,
										userreg.Email EngineerEmail,
										ber.CreatedBy EngineerId
																			
				   FROM					BERApplicationTxn ber 
				   inner join  UMUserRegistration userreg on  userreg.UserRegistrationId = ber.CreatedBy

				   WHERE				ApplicationId IN (SELECT ID FROM @Table)
			
			END
			ELSE
				BEGIN
					 SELECT	0 AS ApplicationId,
					        '' AS BERno, 
							NULL AS [Timestamp],'' EngineerEmail, 0 as EngineerId, 
							'Application Date should be greater than or equal to Asset Service Start Date' ErrorMessage,
							NULL as GuId
				END

		    END 
			ELSE
			BEGIN
					 SELECT				0 AS ApplicationId, 0 as EngineerId, 
					                    '' AS BERno, 
										NULL AS [Timestamp],'' EngineerEmail,
										'Asset No is already existing' ErrorMessage,
										NULL as GuId
			END 
  END
  ELSE
	  BEGIN

			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp 
			FROM	BERApplicationTxn 
			WHERE	ApplicationId	=	@pApplicationId

			IF (@mTimestamp=@pTimestamp)

			BEGIN

--- CURRENT VALUE HISTORY 
			DECLARE @CURRENTVALUECHANGED INT =(SELECT COUNT(1) FROM BERApplicationTxn WHERE ApplicationId= @pApplicationId AND CurrentValue = @pCurrentValue AND BERStage=2) 

			IF(@CURRENTVALUECHANGED = 0 and @pBERStage = 2)
			BEGIN
			     INSERT INTO BerCurrentValueHistoryTxnDet (
                              ApplicationId
                              ,CurrentValue
                              ,Remarks
                              ,CreatedBy
                              ,CreatedDate
                              ,CreatedDateUTC
                              ,ModifiedBy
                              ,ModifiedDate
                              ,ModifiedDateUTC
                     
                             )
				 VALUES (@pApplicationId, @pCurrentValue, @pCurrentValueRemarks, @pUserId, GETDATE(), GETDATE(), @pUserId, GETDATE(), GETDATE())
			END



			-- APPLICATION HISTORY

			DECLARE @STATUScHANGED INT = (SELECT COUNT(1) FROM BERApplicationTxn WHERE BERStatus= @pBERStatus AND ApplicationId=@pApplicationId)
			IF(@STATUScHANGED = 0)
			BEGIN

			      -- SUBMITTED
			   
				       INSERT INTO BERApplicationHistoryTxn
					   (
					   
                           CustomerId
                           ,FacilityId
                           ,ServiceId
                           ,ApplicationId
                           ,Status                        
                           ,CreatedBy
                           ,CreatedDate
                           ,CreatedDateUTC
                           ,ModifiedBy
                           ,ModifiedDate
                           ,ModifiedDateUTC
                       
					   )
					  SELECT CustomerId, FacilityId, ServiceId, ApplicationId, BERStatus,CreatedBy, CreatedDate, CreatedDateUTC, ModifiedBy, ModifiedDate, ModifiedDateUTC  FROM BERApplicationTxn
					  WHERE ApplicationId=@pApplicationId		       
					 
			   			   
			END 
			

			UPDATE BERApplicationTxn SET 												
							
												
									EstRepcostToExpensive						= @pEstRepcostToExpensive,		
									RepairEstimate								= @pRepairEstimate,				
									ValueAfterRepair							= @pValueAfterRepair,				
									EstDurUsgAfterRepair						= @pEstDurUsgAfterRepair,			
									NotReliable									= @pNotReliable,					
									StatutoryRequirements						= @pStatutoryRequirements,		
									OtherObservations							= @pOtherObservations,			
									ApplicantUserId								= @pApplicantStaffId,				
									BERStatus									= @pBERStatus,					
									BER2TechnicalCondition						= @pBER2TechnicalCondition,		
									BER2RepairedWell							= @pBER2RepairedWell,				
									BER2SafeReliable							= @pBER2SafeReliable,				
									BER2EstimateLifeTime						= @pBER2EstimateLifeTime,			
									BER2Syor									= @pBER2Syor,						
									BER2Remarks									= @pBER2Remarks,					
									TBER2StillLifeSpan							= @pTBER2StillLifeSpan,			
									BIL											= @pBIL,							
									BER1Remarks									= @pBER1Remarks,					
									--ParentApplicationId							= @pParentApplicationId,			
									ApprovedDate								= @pApprovedDate,					
									ApprovedDateUTC								= @pApprovedDateUTC,				
											
									JustificationForCertificates				= @pJustificationForCertificates,	
								--	ApplicationDate								= @pApplicationDate,				
								--	RejectedBERReferenceId						= @pRejectedBERReferenceId,		
									BER2TechnicalConditionOthers				= @pBER2TechnicalConditionOthers,	
									BER2SafeReliableOthers						= @pBER2SafeReliableOthers,		
									BER2EstimateLifeTimeOthers					= @pBER2EstimateLifeTimeOthers,	
									BERStage									= @pBERStage,						
									CircumstanceOthers							= @pCircumstanceOthers,			
									ExaminationFirstResultOthers				= @pExaminationFirstResultOthers,	
									EstimatedRepairCost							= @pEstimatedRepairCost,			
									ModifiedBy									= @pUserId,						
									ModifiedDate								= GETDATE(), 
									ModifiedDateUTC								= GETUTCDATE(),
									CurrentValue                                =@pCurrentValue,
									RequestorUserId								=@pRequestorStaffId,
									Obsolescence						     	=@pObsolescence,
									CurrentRepairCost							= @pCurrentRepairCost,
									CannotRepair								=@pCannotRepair
									OUTPUT INSERTED.ApplicationId INTO @Table
			  WHERE ApplicationId=@pApplicationId

-------------- Make asset inactive if ber2 is approved -------------------------------------------------------------------

               IF(@pBERStage = 2 AND @pBERStatus= 206 )
			   BEGIN
					UPDATE EngAsset 
						SET Active= 0 
					WHERE AssetId=@pAssetId		
			   END
----------------------------------------------------------------------------------------------------------------------------

-- APPLICATION REMARKS HISTORY 
			  IF(@pBERStage = 1 )
			  BEGIN 
				  INSERT INTO BERApplicationRemarksHistoryTxn
					   (					   
                             CustomerId
                            ,FacilityId
                            ,ServiceId
                            ,ApplicationId
                            ,Remarks
                            ,CreatedBy
                            ,CreatedDate
                            ,CreatedDateUTC
                            ,ModifiedBy
                            ,ModifiedDate
                            ,ModifiedDateUTC
             			   
					   )
					   SELECT CustomerId, FacilityId, ServiceId, ApplicationId,BER1Remarks,CreatedBy, CreatedDate, CreatedDateUTC, ModifiedBy, ModifiedDate, ModifiedDateUTC  
					   FROM BERApplicationTxn 
					   WHERE ApplicationId=@pApplicationId AND BER1Remarks <> '' AND BER1Remarks IS NOT NULL
			  END 
			  ELSE
			  BEGIN
					INSERT INTO BERApplicationRemarksHistoryTxn
					   (					   
                             CustomerId
                            ,FacilityId
                            ,ServiceId
                            ,ApplicationId
                            ,Remarks
                            ,CreatedBy
                            ,CreatedDate
                            ,CreatedDateUTC
                            ,ModifiedBy
                            ,ModifiedDate
                            ,ModifiedDateUTC
             			   
					   )
					   SELECT CustomerId, FacilityId, ServiceId, ApplicationId,BER2Remarks,CreatedBy, CreatedDate, CreatedDateUTC, ModifiedBy, ModifiedDate, ModifiedDateUTC  
					   FROM BERApplicationTxn 
					   WHERE ApplicationId=@pApplicationId AND BER2Remarks <> '' AND BER2Remarks IS NOT NULL 
			  END 
			     
				
				   SELECT				ApplicationId,ber.createdby EngineerId,
										ber.[Timestamp],
										BERno,
										'' ErrorMessage, userreg.Email EngineerEmail	,
										ber.GuId
				   FROM					BERApplicationTxn ber
				   inner join  UMUserRegistration userreg on  userreg.UserRegistrationId = ber.CreatedBy
				   WHERE				ApplicationId IN (SELECT ID FROM @Table)
	  

			   
END
		ELSE
			BEGIN
				   SELECT				ApplicationId, CreatedBy EngineerId,
										[Timestamp],
										'' BERno, '' EngineerEmail,
										'Record Modified. Please Re-Select' ErrorMessage,
										GuId
				   FROM					BERApplicationTxn
				   WHERE				ApplicationId = @pApplicationId		  
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
