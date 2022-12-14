USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngPlannerTxn_Save_Backup]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngPlannerTxn_Save
Description			: If Planner already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_EngPlannerTxn_Save @pUserId=2,	@pPlannerId=null,@CustomerId=1,@FacilityId=1,@ServiceId=2,@WorkGroupId=1,@TypeOfPlanner=27,@Year=2018,@UserAreaId=3,
@AssigneeCompanyStaffId=24,@FacilityStaffId=26,@AssetClassificationId=1,@AssetTypeCodeId=4,@AssetId=2,@StandardTaskDetId=26,
@WarrantyType=80,@ContactNo='01654910',@EngineerStaffId=null,@ScheduleType=27,@Month='654',@Date='4565',@Week='5564',@Day='454',
@Status=1,@WorkOrderType=83

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

create PROCEDURE  [dbo].[uspFM_EngPlannerTxn_Save_Backup]

			@pUserId						INT				=	NULL,
			@pPlannerId						INT				=	NULL,
			@CustomerId						INT,
			@FacilityId						INT,
			@ServiceId						INT,
			@WorkGroupId					INT,
			@TypeOfPlanner					INT,
			@Year							INT,
			@UserAreaId						INT				=   NULL,	
			@AssigneeCompanyStaffId			INT				=	NULL,
			@FacilityStaffId				INT				=	NULL,
			@AssetClassificationId			INT				=	NULL,	
			@AssetTypeCodeId				INT				=	NULL,
			@AssetId						INT				=	NULL,
			@StandardTaskDetId				INT				=	NULL,
			@WarrantyType					INT				=	NULL,
			@ContactNo						NVARCHAR(100)	=	NULL,
			@EngineerStaffId				INT				=	NULL,
			@ScheduleType					INT				=	NULL,
			@Month							NVARCHAR(200)	=	NULL,
			@Date							NVARCHAR(200)	=	NULL,
			@Week							NVARCHAR(200)	=	NULL,
			@Day							NVARCHAR(200)	=	NULL,
			@Status							INT				=	NULL,
			@WorkOrderType					INT				=	NULL			


AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

	IF OBJECT_ID(N'tempdb..#PlannerTxn') IS NOT NULL
	BEGIN
	  DROP TABLE #PlannerTxn
	END

	CREATE TABLE #PlannerTxn (		PlannerId		INT NULL,
									CustomerId		INT NULL,
									FacilityId		INT NULL,
									WorkGroupId		INT NULL,
									AssetId			INT NULL,
									UserAreaId		INT NULL,
									ScheduleType	INT NULL,
									Year			INT NULL,
									Month			NVARCHAR(100) NULL,
									Date			NVARCHAR(100) NULL,
									Week			NVARCHAR(100) NULL,
									Day				NVARCHAR(100) NULL,
									PlannerDate		DATETIME NULL,
									CreatedBy		INT NULL,
									CreatedDate		DATETIME NULL,
									CreatedDateUTC	DATETIME NULL,
									ModifiedBy		INT NULL,
									ModifiedDate	DATETIME NULL,
									ModifiedDateUTC	DATETIME NULL,
								)
-- Default Values


-- Execution

     IF(ISNULL(@pPlannerId,0)= 0 OR @pPlannerId='')

	  BEGIN
	          INSERT INTO EngPlannerTxn(
													CustomerId,
													FacilityId,
													ServiceId,
													WorkGroupId,
													TypeOfPlanner,
													Year,
													UserAreaId,
													AssigneeCompanyUserId,
													FacilityUserId,
													AssetClassificationId,
													AssetTypeCodeId,
													AssetId,
													StandardTaskDetId,
													WarrantyType,
													ContactNo,
													EngineerUserId,
													ScheduleType,
													Month,
													Date,
													Week,
													Day,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													Status,
													WorkOrderType                                
                           )OUTPUT INSERTED.PlannerId INTO @Table
			  VALUES								(

													@CustomerId,
													@FacilityId,
													@ServiceId,
													@WorkGroupId,
													@TypeOfPlanner,
													@Year,
													@UserAreaId,
													@AssigneeCompanyStaffId,
													@FacilityStaffId,
													@AssetClassificationId,
													@AssetTypeCodeId,
													@AssetId,
													@StandardTaskDetId,
													@WarrantyType,
													@ContactNo,
													@EngineerStaffId,
													@ScheduleType,
													@Month,
													@Date,
													@Week,
													@Day,
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													@Status,
													@WorkOrderType
													)
			

			   	   SELECT				PlannerId,
										[Timestamp]
				   FROM					EngPlannerTxn
				   WHERE				PlannerId IN (SELECT ID FROM @Table)

			INSERT INTO #PlannerTxn (	PlannerId,
										CustomerId,
										FacilityId,
										WorkGroupId,
										Year,
										UserAreaId,
										AssetId,
										ScheduleType,
										Month,
										Date,
										Week,
										Day,
										CreatedBy,
										CreatedDate,
										CreatedDateUTC,
										ModifiedBy,
										ModifiedDate,
										ModifiedDateUTC
									)
				
					SELECT	DISTINCT PlannerId,
							CustomerId,
							FacilityId,
							WorkGroupId,
							Year,
							UserAreaId,
							AssetId,
							ScheduleType,
							Month,
							Date,
							Week,
							Day,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
					FROM	EngPlannerTxn
					WHERE	PlannerId IN (SELECT ID FROM @Table)
	
		END
  ELSE
	  BEGIN

				UPDATE EngPlannerTxn SET 

									CustomerId									= @CustomerId,				
									FacilityId									= @FacilityId,				
									ServiceId									= @ServiceId,				
									WorkGroupId									= @WorkGroupId,				
									TypeOfPlanner								= @TypeOfPlanner,			
									Year										= @Year,					
									UserAreaId									= @UserAreaId,				
									AssigneeCompanyUserId						= @AssigneeCompanyStaffId,	
									FacilityUserId								= @FacilityStaffId,			
									AssetClassificationId						= @AssetClassificationId,	
									AssetTypeCodeId								= @AssetTypeCodeId,			
									AssetId										= @AssetId,					
									StandardTaskDetId							= @StandardTaskDetId,		
									WarrantyType								= @WarrantyType,			
									ContactNo									= @ContactNo,				
									EngineerUserId								= @EngineerStaffId,			
									ScheduleType								= @ScheduleType,			
									Month										= @Month,					
									Date										= @Date,					
									Week										= @Week,					
									Day											= @Day,						
									ModifiedBy									= @pUserId,
									ModifiedDate								= GETDATE(),
									ModifiedDateUTC								= GETUTCDATE(),
									Status										= @Status,
									WorkOrderType								= @WorkOrderType
									OUTPUT INSERTED.PlannerId INTO @Table
			   WHERE PlannerId=@pPlannerId

			   	  SELECT				PlannerId,
										[Timestamp]
				   FROM					EngPlannerTxn
				   WHERE				PlannerId IN (SELECT ID FROM @Table)


			INSERT INTO #PlannerTxn (	PlannerId,
										CustomerId,
										FacilityId,
										WorkGroupId,
										Year,
										UserAreaId,
										AssetId,
										ScheduleType,
										Month,
										Date,
										Week,
										Day,
										CreatedBy,
										CreatedDate,
										CreatedDateUTC,
										ModifiedBy,
										ModifiedDate,
										ModifiedDateUTC
									)
				
					SELECT	DISTINCT PlannerId,
							CustomerId,
							FacilityId,
							WorkGroupId,
							Year,
							UserAreaId,
							AssetId,
							ScheduleType,
							Month,
							Date,
							Week,
							Day,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
					FROM	EngPlannerTxn
					WHERE	PlannerId = @pPlannerId

			
        END   

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           COMMIT TRANSACTION
 --       END   


IF (@ScheduleType=78)	--Monthly-Date
	BEGIN

	DELETE FROM EngPlannerTxnDet WHERE PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)
	
	INSERT INTO EngPlannerTxnDet (	PlannerId,
									CustomerId,
									FacilityId,
									ScheduleType,
									Year,
									Month,
									Date,
									PlannerDate,
									CreatedBy,
									CreatedDate,
									CreatedDateUTC,
									ModifiedBy,
									ModifiedDate,
									ModifiedDateUTC
								)
		
				SELECT	DISTINCT PlannerId,
						CustomerId,
						FacilityId,
						ScheduleType,
						Year,
						splitMonth.Item AS Month,
						splitDate.Item AS Date,
						NULL AS PlannerDate,
						CreatedBy,
						CreatedDate,
						CreatedDateUTC,
						ModifiedBy,
						ModifiedDate,
						ModifiedDateUTC
				FROM #PlannerTxn
				OUTER APPLY SplitString(MONTH,',') splitMonth
				OUTER APPLY SplitString(DATE,',') splitDate
				--WHERE PlannerId=2

			SELECT * INTO #EngPlannerTxnDet FROM EngPlannerTxnDet  WHERE PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)

			UPDATE A SET A.PlannerDate =DATEFROMPARTS(B.Year,B.Month,B.Date)
			FROM EngPlannerTxnDet A INNER JOIN #EngPlannerTxnDet B ON A.PlannerDetId=B.PlannerDetId 
			WHERE A.PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)
			AND A.ScheduleType=78
	END


ELSE IF (@ScheduleType=79)

	BEGIN
	DELETE FROM EngPlannerTxnDet WHERE PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)

	INSERT INTO EngPlannerTxnDet (	PlannerId,
									CustomerId,
									FacilityId,
									ScheduleType,
									Year,
									Month,
									Week,
									Day,
									PlannerDate,
									CreatedBy,
									CreatedDate,
									CreatedDateUTC,
									ModifiedBy,
									ModifiedDate,
									ModifiedDateUTC
								)
		
				SELECT	DISTINCT PlannerId,
						CustomerId,
						FacilityId,
						ScheduleType,
						Year,
						splitMonth.Item AS Month,
						splitWeek.Item AS Week,
						splitDay.Item AS Day,
						NULL AS PlannerDate,
						CreatedBy,
						CreatedDate,
						CreatedDateUTC,
						ModifiedBy,
						ModifiedDate,
						ModifiedDateUTC
				FROM #PlannerTxn
				OUTER APPLY SplitString(MONTH,',') splitMonth
				OUTER APPLY SplitString(Week,',') splitWeek
				OUTER APPLY SplitString(Week,',') splitDay
				--WHERE PlannerId=2

			SELECT * INTO #EngPlannerTxnDet79 FROM EngPlannerTxnDet  WHERE PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)

			UPDATE A SET A.PlannerDate = DATEADD(DAY,CAST(A.[Day] as int)+1, DATEADD(WEEK, CAST(A.[Week] as int)-1, DATEFROMPARTS(A.YEAR,A.Month,1)) )
			--CAST((CAST(B.Month AS CHAR(2)))+ '/'+'01/' +cast(B.Year AS CHAR(4)) AS DATETIME) + ((B.Week * 7) - B.Day)
			FROM EngPlannerTxnDet A INNER JOIN #EngPlannerTxnDet79 B ON A.PlannerDetId=B.PlannerDetId 
			WHERE A.PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)
			AND A.ScheduleType=79	
	END

END TRY

BEGIN CATCH

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           ROLLBACK TRAN
 --       END

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
