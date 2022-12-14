USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTrainingScheduleTxn_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngLicenseandCertificateTxn_Save
Description			: If License and Certificate Update already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @EngTrainingScheduleTxnDet AS [dbo].[udt_EngTrainingScheduleTxnDet]
 insert into  @EngTrainingScheduleTxnDet(TrainingScheduleDetId,CustomerId,FacilityId,ServiceId,ParticipantsUserId,UserAreaId,Remarks)VALUES
(0,'1','1','2','1','1','BBB'),
(0,'1','1','2','1','1','AAA')


EXEC [uspFM_EngTrainingScheduleTxn_Save] @EngTrainingScheduleTxnDet,
@pTrainingScheduleId=0,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pTrainingScheduleNo='aaa',@pTrainingDescription='AAA',@pTrainingType=1,@pPlannedDate='2018-06-06 17:41:09.623',
@pPlannedDateUTC='2018-06-06 17:41:09.623',@pYear=2018,@pQuarter=1,@pTrainingModule='SDF',@pMinimumNoOfParticipants=10,@pActualDate='2018-06-06 17:41:09.623',
@pActualDateUTC='2018-06-06 17:41:09.623',@pTrainingStatus=1,@pTrainerSource=10,@pTrainerStaffExperience=3,@pTotalParticipants=20,@pVenue='SG',
@pTrainingRescheduleDate='2018-06-06 17:41:09.623',@pTrainingRescheduleDateUTC='2018-06-06 17:41:09.623',@pOverallEffectiveness=10.5,
@pRemarks='AAAA',@pTrainerUserId=NULL,@pTrainerUserName='AAA',@pDesignation='AAA',@pUserId=1

DECLARE @EngTrainingScheduleTxnDet AS [dbo].[udt_EngTrainingScheduleTxnDet]
-- insert into  @EngTrainingScheduleTxnDet(TrainingScheduleDetId,CustomerId,FacilityId,ServiceId,ParticipantsUserId,UserAreaId,Remarks)VALUES
--(1,'1','1','2','1','1','BBB'),
--(2,'1','1','2','1','1','AAA')


EXEC [uspFM_EngTrainingScheduleTxn_Save] @EngTrainingScheduleTxnDet,
@pTrainingScheduleId=0,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pTrainingScheduleNo='aaa',@pTrainingDescription='AAA',@pTrainingType=1,@pPlannedDate='2018-06-06 17:41:09.623',
@pPlannedDateUTC='2018-06-06 17:41:09.623',@pYear=2018,@pQuarter=1,@pTrainingModule='SDF',@pMinimumNoOfParticipants=10,@pActualDate='2018-06-06 17:41:09.623',
@pActualDateUTC='2018-06-06 17:41:09.623',@pTrainingStatus=1,@pTrainerSource=10,@pTrainerStaffExperience=3,@pTotalParticipants=20,@pVenue='SG',
@pTrainingRescheduleDate='2018-06-06 17:41:09.623',@pTrainingRescheduleDateUTC='2018-06-06 17:41:09.623',@pOverallEffectiveness=10.5,
@pRemarks='AAAA',@pTrainerUserId=NULL,@pTrainerUserName=NULL,@pDesignation=NULL,@pUserId=1

DECLARE @EngTrainingScheduleTxnDet AS [dbo].[udt_EngTrainingScheduleTxnDet]
 insert into  @EngTrainingScheduleTxnDet(TrainingScheduleDetId,CustomerId,FacilityId,ServiceId,ParticipantsUserId,UserAreaId,Remarks)VALUES
(1,'1','1','2','1','1','BBB'),
(2,'1','1','2','1','1','AAA')


EXEC [uspFM_EngTrainingScheduleTxn_Save] @EngTrainingScheduleTxnDet,
@pTrainingScheduleId=1,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pTrainingScheduleNo='aaa',@pTrainingDescription='AAA',@pTrainingType=1,@pPlannedDate='2018-06-06 17:41:09.623',
@pPlannedDateUTC='2018-06-06 17:41:09.623',@pYear=2018,@pQuarter=1,@pTrainingModule='SDF',@pMinimumNoOfParticipants=10,@pActualDate=NULL,
@pActualDateUTC=NULL,@pTrainingStatus=NULL,@pTrainerSource=NULL,@pTrainerStaffExperience=NULL,@pTotalParticipants=NULL,@pVenue=NULL,
@pTrainingRescheduleDate=NULL,@pTrainingRescheduleDateUTC=NULL,@pOverallEffectiveness=NULL,@pRemarks=NULL,@pTrainerUserId=NULL,@pTrainerUserName=NULL,@pDesignation=NULL,@pUserId=1

DECLARE @EngTrainingScheduleTxnDet AS [dbo].[udt_EngTrainingScheduleTxnDet]
DECLARE @EngTrainingScheduleUserAreaHistory AS [dbo].[udt_EngTrainingScheduleUserAreaHistory]
 insert into  @EngTrainingScheduleTxnDet(TrainingScheduleDetId,CustomerId,FacilityId,ServiceId,ParticipantsUserId,UserAreaId,Remarks)VALUES
(0,'1','1','2','1','1','BBB'),
(0,'1','1','2','1','1','AAA')

INSERT INTO @EngTrainingScheduleUserAreaHistory(TrainingScheduleAreaId,UserAreaId,Remarks,UserId)VALUES
(0,1,'AAA',1),
(0,3,'AAA',1)
EXEC [uspFM_EngTrainingScheduleTxn_Save] @EngTrainingScheduleTxnDet,@EngTrainingScheduleUserAreaHistory,
@pTrainingScheduleId=0,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pTrainingScheduleNo='aaa',@pTrainingDescription='AAA',@pTrainingType=1,@pPlannedDate='2018-06-06 17:41:09.623',
@pPlannedDateUTC='2018-06-06 17:41:09.623',@pYear=2018,@pQuarter=1,@pTrainingModule='SDF',@pMinimumNoOfParticipants=10,@pActualDate=NULL,
@pActualDateUTC=NULL,@pTrainingStatus=NULL,@pTrainerSource=NULL,@pTrainerStaffExperience=NULL,@pTotalParticipants=NULL,@pVenue=NULL,
@pTrainingRescheduleDate=NULL,@pTrainingRescheduleDateUTC=NULL,@pOverallEffectiveness=NULL,@pRemarks=NULL,@pTrainerUserId=NULL,@pTrainerUserName=NULL,@pDesignation=NULL,@pUserId=1,
@pIsConfirmed=0,@pEmail='ABU@GMAIL.COM',@pNotificationDate='2018-04-01 00:00:00.000'

select * from EngTrainingScheduleTxn
select * from EngTrainingScheduleTxnDet
select * from EngTrainingScheduleUserAreaHistory
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngTrainingScheduleTxn_Save]
		
		@EngTrainingScheduleTxnDet			[dbo].[udt_EngTrainingScheduleTxnDet]   READONLY,
		@EngTrainingScheduleUserAreaHistory	[dbo].[udt_EngTrainingScheduleUserAreaHistory]   READONLY,
		@pTrainingScheduleId			INT				= NULL,
		@pCustomerId					INT				= NULL,
		@pFacilityId					INT				= NULL,
		@pServiceId						INT				= NULL,
		@pTrainingScheduleNo			NVARCHAR(100)	= NULL,
		@pTrainingDescription			NVARCHAR(500)	= NULL,
		@pTrainingType					INT				= NULL,
		@pPlannedDate					DATETIME		= NULL,
		@pPlannedDateUTC				DATETIME		= NULL,
		@pYear							INT				= NULL,
		@pQuarter						INT				= NULL,
		@pTrainingModule				NVARCHAR(200)	= NULL,
		@pMinimumNoOfParticipants		INT				= NULL,
		@pActualDate					DATETIME		= NULL,
		@pActualDateUTC					DATETIME		= NULL,
		@pTrainingStatus				INT				= NULL,
		@pTrainerSource					INT				= NULL,
		@pTrainerStaffExperience		INT				= NULL,
		@pTotalParticipants				INT				= NULL,
		@pVenue							NVARCHAR(400)	= NULL,
		@pTrainingRescheduleDate		DATETIME		= NULL,
		@pTrainingRescheduleDateUTC		DATETIME		= NULL,
		@pOverallEffectiveness			NUMERIC(24,2)	= NULL,
		@pRemarks						NVARCHAR(1000)	= NULL,
		@pTrainerUserId					INT				= NULL,
		@pTrainerUserName				NVARCHAR(400)	= NULL,
		@pDesignation					NVARCHAR(400)	= NULL,
		@pUserId						INT				= NULL,
		@pTimestamp						VARBINARY(200)	= NULL,
		@pIsConfirmed					BIT				= NULL,
		@pEmail							NVARCHAR(100)	= NULL,
		@pNotificationDate				DATETIME		= NULL

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE	@mMonth	 INT
	DECLARE	@mYear	 INT

	IF (ISNULL(@pIsConfirmed,'') ='')
		BEGIN
			SET @pIsConfirmed = 0
		END


	IF (@pTrainingType <>255)
		BEGIN
			SET @mMonth = MONTH(@pPlannedDate)
			SET @mYear = YEAR(@pPlannedDate)
		END
	ELSE
		BEGIN
			SET @mMonth = MONTH(@pActualDate)
			SET @mYear = YEAR(@pActualDate)
			SET @pYear	=YEAR(@pActualDate)
		END


-- Default Values


-- Execution

    IF(ISNULL(@pTrainingScheduleId,0)=0 OR @pTrainingScheduleId='')

	BEGIN

	DECLARE @pOutParam NVARCHAR(50) 
	EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngTrainingScheduleTxn',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='BEMS',@pModuleName=NULL,@pService=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam output
	SELECT @pTrainingScheduleNo=@pOutParam

		   INSERT INTO EngTrainingScheduleTxn(		
													CustomerId,
													FacilityId,
													ServiceId,
													TrainingScheduleNo,
													TrainingDescription,
													TrainingType,
													PlannedDate,
													PlannedDateUTC,
													Year,
													Quarter,
													TrainingModule,
													MinimumNoOfParticipants,
													ActualDate,
													ActualDateUTC,
													TrainingStatus,
													TrainerSource,
													TrainerStaffExperience,
													TotalParticipants,
													Venue,
													TrainingRescheduleDate,
													TrainingRescheduleDateUTC,
													OverallEffectiveness,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													TrainerUserId,
													TrainerUserName,
													Designation,
													IsConfirmed,
													Email,
													NotificationDate
                           )OUTPUT INSERTED.TrainingScheduleId INTO @Table
			  VALUES								(
													@pCustomerId,
													@pFacilityId,
													@pServiceId,
													@pTrainingScheduleNo,
													@pTrainingDescription,
													@pTrainingType,
													@pPlannedDate,
													@pPlannedDateUTC,
													@pYear,
													@pQuarter,
													@pTrainingModule,
													@pMinimumNoOfParticipants,
													@pActualDate,
													@pActualDateUTC,
													@pTrainingStatus,
													@pTrainerSource,
													@pTrainerStaffExperience,
													@pTotalParticipants,
													@pVenue,
													@pTrainingRescheduleDate,
													@pTrainingRescheduleDateUTC,
													@pOverallEffectiveness,
													@pRemarks,
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													@pTrainerUserId,
													@pTrainerUserName,
													@pDesignation,
													@pIsConfirmed,
													@pEmail,
													@pNotificationDate
													)
			Declare @mPrimaryId int= (select TrainingScheduleId from EngTrainingScheduleTxn WHERE	TrainingScheduleId IN (SELECT ID FROM @Table))


			  INSERT INTO EngTrainingScheduleTxnDet(
													CustomerId,
													FacilityId,
													ServiceId,
													TrainingScheduleId,
													ParticipantsUserId,
													UserAreaId,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC
                                                    )
				   SELECT							
													CustomerId,
													FacilityId,			
													ServiceId,			
													@mPrimaryId,	
													ParticipantsUserId,	
													UserAreaId,			
													Remarks,			
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
				   FROM @EngTrainingScheduleTxnDet					AS EngTrainingScheduleType
				   WHERE	ISNULL(EngTrainingScheduleType.TrainingScheduleDetId,0)=0

					INSERT INTO EngTrainingScheduleUserAreaHistory (	TrainingScheduleId
																		,UserAreaId
																		,Remarks
																		,CreatedBy
																		,CreatedDate
																		,CreatedDateUTC
																		,ModifiedBy
																		,ModifiedDate
																		,ModifiedDateUTC
																	)
											SELECT	@mPrimaryId,
													UserAreaId,
													Remarks,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
				   FROM	@EngTrainingScheduleUserAreaHistory			AS AreaHistory
				   WHERE	ISNULL(AreaHistory.TrainingScheduleAreaId,0)=0

			   	   SELECT				TrainingScheduleId,
										[Timestamp],
										''	ErrorMessage,
										GuId
				   FROM					EngTrainingScheduleTxn
				   WHERE				TrainingScheduleId IN (SELECT ID FROM @Table)
	
		
		END

		
			
  ELSE

	  BEGIN
				DECLARE @mTimestamp varbinary(200);
				SELECT	@mTimestamp = Timestamp FROM	EngTrainingScheduleTxn 
				WHERE	TrainingScheduleId	=	@pTrainingScheduleId

				IF (@mTimestamp=@pTimestamp)
				
	BEGIN
				UPDATE EngTrainingScheduleTxn SET 
									
									CustomerId									=@pCustomerId,
									FacilityId									=@pFacilityId,
									ServiceId									=@pServiceId,
									TrainingScheduleNo							=@pTrainingScheduleNo,
									TrainingDescription							=@pTrainingDescription,
									TrainingType								=@pTrainingType,
									PlannedDate									=@pPlannedDate,
									PlannedDateUTC								=@pPlannedDateUTC,
									Year										=@pYear,
									Quarter										=@pQuarter,
									TrainingModule								=@pTrainingModule,
									MinimumNoOfParticipants						=@pMinimumNoOfParticipants,
									ActualDate									=@pActualDate,
									ActualDateUTC								=@pActualDateUTC,
									TrainingStatus								=@pTrainingStatus,
									TrainerSource								=@pTrainerSource,
									TrainerStaffExperience						=@pTrainerStaffExperience,
									TotalParticipants							=@pTotalParticipants,
									Venue										=@pVenue,
									TrainingRescheduleDate						=@pTrainingRescheduleDate,
									TrainingRescheduleDateUTC					=@pTrainingRescheduleDateUTC,
									OverallEffectiveness						=@pOverallEffectiveness,
									Remarks										=@pRemarks,
									TrainerUserId								=@pTrainerUserId,
									TrainerUserName								=@pTrainerUserName,
									Designation									=@pDesignation,
									ModifiedBy									= @pUserId,
									ModifiedDate								= GETDATE(),
									ModifiedDateUTC								= GETUTCDATE(),
									IsConfirmed									= @pIsConfirmed,
									Email										= @pEmail,
									NotificationDate							= @pNotificationDate
									OUTPUT INSERTED.TrainingScheduleId INTO @Table
			   WHERE TrainingScheduleId=@pTrainingScheduleId




			    UPDATE TrainingScheduleDet SET
									TrainingScheduleDet.CustomerId			= TrainingScheduleDetType.CustomerId,
									TrainingScheduleDet.FacilityId			= TrainingScheduleDetType.FacilityId,
									TrainingScheduleDet.ServiceId			= TrainingScheduleDetType.ServiceId,
									TrainingScheduleDet.ParticipantsUserId	= TrainingScheduleDetType.ParticipantsUserId,
									TrainingScheduleDet.UserAreaId			= TrainingScheduleDetType.UserAreaId,
									TrainingScheduleDet.Remarks				= TrainingScheduleDetType.Remarks,
									TrainingScheduleDet.ModifiedBy			= @pUserId,
									TrainingScheduleDet.ModifiedDate		= GETDATE(),
									TrainingScheduleDet.ModifiedDateUTC		= GETUTCDATE()			
									--OUTPUT INSERTED.StockUpdateDetId INTO @Table
					FROM	EngTrainingScheduleTxnDet						AS TrainingScheduleDet 
							INNER JOIN @EngTrainingScheduleTxnDet			AS TrainingScheduleDetType	ON TrainingScheduleDetType.TrainingScheduleDetId	=	TrainingScheduleDet.TrainingScheduleDetId
					WHERE ISNULL(TrainingScheduleDetType.TrainingScheduleDetId,0)>0


			    UPDATE AreaHistory SET	AreaHistory.UserAreaId			=	AreaHistoryType.UserAreaId,
										AreaHistory.Remarks				=	AreaHistoryType.Remarks,
										AreaHistory.ModifiedBy			= @pUserId,
										AreaHistory.ModifiedDate		= GETDATE(),
										AreaHistory.ModifiedDateUTC		= GETUTCDATE()			
									--OUTPUT INSERTED.StockUpdateDetId INTO @Table
					FROM	EngTrainingScheduleUserAreaHistory						AS AreaHistory 
							INNER JOIN @EngTrainingScheduleUserAreaHistory			AS AreaHistoryType	ON AreaHistory.TrainingScheduleAreaId	=	AreaHistoryType.TrainingScheduleAreaId
					WHERE ISNULL(AreaHistoryType.TrainingScheduleAreaId,0)>0
								
				   SELECT				TrainingScheduleId,
										[Timestamp],
										'' AS ErrorMessage,
										GuId
				   FROM					EngTrainingScheduleTxn
				   WHERE				TrainingScheduleId IN (SELECT ID FROM @Table)


				   -----------------------------------------------------Detail Table Extra Data Insertion-------------------------------------------------

			  INSERT INTO EngTrainingScheduleTxnDet(
													CustomerId,
													FacilityId,
													ServiceId,
													TrainingScheduleId,
													ParticipantsUserId,
													UserAreaId,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC
                                                    )
				   SELECT							
													CustomerId,
													FacilityId,			
													ServiceId,			
													@pTrainingScheduleId,	
													ParticipantsUserId,	
													UserAreaId,			
													Remarks,			
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
				   FROM @EngTrainingScheduleTxnDet					AS EngTrainingScheduleType
				   WHERE	ISNULL(EngTrainingScheduleType.TrainingScheduleDetId,0)=0

					INSERT INTO EngTrainingScheduleUserAreaHistory (	TrainingScheduleId
																		,UserAreaId
																		,Remarks
																		,CreatedBy
																		,CreatedDate
																		,CreatedDateUTC
																		,ModifiedBy
																		,ModifiedDate
																		,ModifiedDateUTC
																	)
											SELECT	@pTrainingScheduleId,
													UserAreaId,
													Remarks,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
				   FROM	@EngTrainingScheduleUserAreaHistory			AS AreaHistory
				   WHERE	ISNULL(AreaHistory.TrainingScheduleAreaId,0)=0

        END   
		
				ELSE
			BEGIN
				SELECT	TrainingScheduleId,
						TrainingScheduleNo,
						[Timestamp],							
						'Record Modified. Please Re-Select' AS ErrorMessage,
						GuId
				FROM	EngTrainingScheduleTxn
				WHERE	TrainingScheduleId =@pTrainingScheduleId
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


------------------------------------------------------------------------------------UDT Creation-------------------------------------------------------------------------

-----------------------------------------------------------------------------------UDT CREATION ---------------------------------------------------

--drop proc [uspFM_EngTrainingScheduleTxn_Save]
--drop type udt_EngTrainingScheduleUserAreaHistory
--DROP TYPE udt_EngTrainingScheduleTxnDet


--CREATE TYPE [dbo].[udt_EngTrainingScheduleUserAreaHistory] AS TABLE(
--	[TrainingScheduleAreaId] [int] NULL,
--	[UserAreaId] [int] NULL,
--	[Remarks] [nvarchar](500) NULL,
--	[UserId] [int] NULL
--)
--GO

--CREATE TYPE [dbo].[udt_EngTrainingScheduleTxnDet] AS TABLE(
--	[TrainingScheduleDetId] [int] NULL,
--	[CustomerId] [int] NULL,
--	[FacilityId] [int] NULL,
--	[ServiceId] [int] NULL,
--	[ParticipantsUserId] [int] NULL,
--	[UserAreaId] [int] NULL,
--	[Remarks] [nvarchar](1000) NULL
--)
--GO
GO
