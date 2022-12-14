USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMUserShifts_Save_1]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoCompletionInfoTxn_Save
Description			: If Maintenance Work Order Completion Info already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @pUMUserShiftsDet		[dbo].[udt_UMUserShiftsDet]
INSERT INTO @pUMUserShiftsDet (UserShiftDetId,LeaveFrom,LeaveTo,NoOfDays,Remarks,UserId) values
(28,'2018-07-17 00:00:00.000','2018-07-19 00:00:00.000',3.00,'DGFG',2),
(0,'2018-07-21 13:30:28.540','2018-07-21 13:30:28.540',1,'DGFG',2)
EXECUTE [uspFM_UMUserShifts_Save] @pUserShiftsId=40,@pCustomerId=1,@pFacilityId=1,@pUserRegistrationId=2,@pLunchTimeLovId=310,@pLeaveFrom=NULL,@pLeaveTo=NULL,
@pNoOfDays=NULL,@pRemarks=NULL,@pUserId=2

select * from UMUserShifts
select * from UMUserShiftsdET
SELECT 1 FROM UMUserShifts WHERE UserRegistrationId = 2
SELECT GETDATE()

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UMUserShifts_Save_1]
		
		@pUMUserShiftsDet					as				[udt_UMUserShiftsDet] READONLY,
		@pUserShiftsId						INT				= NULL,
		@pCustomerId						INT				= NULL,
		@pFacilityId						INT				= NULL,
		@pUserRegistrationId				INT				= NULL,
		@pLunchTimeLovId					INT				= NULL,
		@pLeaveFrom							DATETIME		= NULL,
		@pLeaveTo							DATETIME		= NULL,
		@pNoOfDays							NUMERIC(24,2)	= NULL,
		@pRemarks							NVARCHAR(1000)	= NULL,
		@pUserId							INT				= NULL,
		@pTimestamp							VARBINARY(200)	= NULL,
		@pShiftTimeLovId					INT				= NULL,
		@ShiftStartTime						nvarchar(10)	= Null,
		@ShiftStartTimeMin					nvarchar(10)	= Null,
		@ShiftEndTime						nvarchar(10)    = Null,
		@ShiftEndTimeMin					nvarchar(10)	=Null,
		@ShiftBreakStartTime				nvarchar(10) = Null,
		@ShiftBreakStartTimeMin				nvarchar(10) = NULL,
		@ShiftBreakEndTime					nvarchar(10) = Null,
		@ShiftBreakEndTimeMin				nvarchar(10) = Null

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT



--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.EngMwoCompletionInfoTxn

--IF ( @pUserShiftsId<>0)
--BEGIN
--DECLARE @UserShiftId INT
--SET @UserShiftId = (SELECT UserShiftsId FROM UMUserShifts WHERE UserRegistrationId = @pUserRegistrationId)
--IF EXISTS (SELECT 1 FROM UMUserShiftsDet A , @pUMUserShiftsDet B WHERE A.UserShiftsId = @UserShiftId AND CAST(A.LeaveFrom AS DATE) = CAST(B.LeaveFrom AS DATE) AND  CAST(A.LeaveTo AS DATE) = CAST(B.LeaveTo AS DATE))
--BEGIN
--		SELECT		0 As UserShiftsId,
--					0 as UserRegistrationId,
--					CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [Timestamp],
--					'Leave Already Applied for that day' AS ErrorMessage
--END
--END

select identity(int,1,1) SNO,* into #UMUserShiftsDet from @pUMUserShiftsDet



IF EXISTS (SELECT 1 FROM UMUserShifts WHERE UserRegistrationId = @pUserRegistrationId)  and (@pUserShiftsId  is NULL OR @pUserShiftsId =0)
begin 
 SELECT		0 As UserShiftsId,
					0 as UserRegistrationId,
					CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [Timestamp],
					'Leave Already Applied for that day' AS ErrorMessage
END
ELSE IF EXISTS (SELECT 1 FROM #UMUserShiftsDet A inner join  #UMUserShiftsDet B 
on ( CAST(a.leavefrom AS DATE) between CAST(b.leavefrom AS DATE) and CAST(b.leaveto AS DATE)   or CAST(a.LeaveTo AS DATE) between CAST(b.leavefrom AS DATE) and CAST(b.leaveto AS DATE)
or CAST(b.leavefrom AS DATE) between CAST(a.leavefrom AS DATE) and CAST(a.LeaveTo AS DATE)
or  CAST(b.leaveto AS DATE) between CAST(a.leavefrom AS DATE) and CAST(a.leaveto AS DATE)
 ) and a.sno<>b.sno
)
 begin 
 SELECT		0 As UserShiftsId,
					0 as UserRegistrationId,
					CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [Timestamp],
					'Leave Already Applied for that day' AS ErrorMessage
END

else IF EXISTS (SELECT 1 FROM UMUserShifts A INNER JOIN  UMUserShiftsDet B ON A.UserShiftsId=B.UserShiftsId
INNER JOIN @pUMUserShiftsDet C ON A.UserShiftsId=B.UserShiftsId  
WHERE A.UserRegistrationId = @pUserRegistrationId AND ( CAST(C.leavefrom AS DATE) between CAST(b.leavefrom AS DATE) and CAST(b.leaveto AS DATE)   or CAST(C.LeaveTo AS DATE) between CAST(b.leavefrom AS DATE) and CAST(b.leaveto AS DATE)
or CAST(b.leavefrom AS DATE) between CAST(C.leavefrom AS DATE) and CAST(C.LeaveTo AS DATE)
or  CAST(b.leaveto AS DATE) between CAST(C.leavefrom AS DATE) and CAST(C.leaveto AS DATE)
 ) AND C.UserShiftDetId=0)
BEGIN
		SELECT		0 As UserShiftsId,
					0 as UserRegistrationId,
					CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [Timestamp],
					'Leave Already Applied for that day' AS ErrorMessage

END

ELSE
BEGIN
			--IF NOT EXISTS(SELECT 1 FROM UMUserShifts WHERE UserRegistrationId = @pUserRegistrationId)
			--BEGIN
				IF(@pUserShiftsId  is NULL OR @pUserShiftsId =0)

				BEGIN
	
						INSERT INTO UMUserShifts
									(	
										CustomerId,
										FacilityId,
										UserRegistrationId,
										LunchTimeLovId,
										LeaveFrom,
										LeaveTo,
										NoOfDays,
										Remarks,
										CreatedBy,
										CreatedDate,
										CreatedDateUTC,
										ModifiedBy,
										ModifiedDate,
										ModifiedDateUTC,
										ShiftTimeLovId,						
										ShiftStartTime	,		
										ShiftStartTimeMin	,	
										ShiftEndTime	,		
										ShiftEndTimeMin	,	
										ShiftBreakStartTime,	
										ShiftBreakStartTimeMin	,
										ShiftBreakEndTime	,	
										ShiftBreakEndTimeMin	
									)	OUTPUT INSERTED.UserShiftsId INTO @Table							

						VALUES			
									(	
										@pCustomerId,
										@pFacilityId,
										@pUserRegistrationId,
										@pLunchTimeLovId,
										@pLeaveFrom,
										@pLeaveTo,
										@pNoOfDays,
										@pRemarks,
										@pUserId,			
										GETDATE(), 
										GETDATE(),
										@pUserId, 
										GETDATE(), 
										GETDATE(),
										@pShiftTimeLovId,
										@ShiftStartTime	,		
										@ShiftStartTimeMin	,	
										@ShiftEndTime	,		
										@ShiftEndTimeMin	,	
										@ShiftBreakStartTime,	
										@ShiftBreakStartTimeMin	,
										@ShiftBreakEndTime	,	
										@ShiftBreakEndTimeMin	
							
									)			

						SELECT	UserShiftsId,
								UserRegistrationId,
								[Timestamp],
								'' as ErrorMessage
						FROM	UMUserShifts
						WHERE	UserShiftsId IN (SELECT ID FROM @Table)

						SET @PrimaryKeyId  = (SELECT ID FROM @Table)


						INSERT INTO UMUserShiftsDet
									(
										UserShiftsId,
										LeaveFrom,
										LeaveTo,
										NoOfDays,
										Remarks,
										CreatedBy,
										CreatedDate,
										CreatedDateUTC,
										ModifiedBy,
										ModifiedDate,
										ModifiedDateUTC
							
									)

						SELECT			
										@PrimaryKeyId,
										LeaveFrom,
										LeaveTo,	
										NoOfDays,
										Remarks,		
										UserId,		
										GETDATE(),			
										GETUTCDATE(),
										UserId,			
										GETDATE(),			
										GETUTCDATE()
						FROM	@pUMUserShiftsDet
						WHERE   ISNULL(UserShiftDetId,0)=0

						SELECT UserShiftsId,MAX(LeaveFrom) AS LeaveFrom,MAX(LeaveTo) AS LeaveTo 
						INTO #TempLeaveDet 
						FROM UMUserShiftsDet WHERE UserShiftsId	=	@PrimaryKeyId
						GROUP BY UserShiftsId
	
				UPDATE UserShift	SET UserShift.LeaveFrom	=	UserShiftDet.LeaveFrom,
										UserShift.LeaveTo	=	UserShiftDet.LeaveTo
				FROM	UMUserShifts						AS	UserShift		WITH(NOLOCK)
						INNER JOIN #TempLeaveDet			AS	UserShiftDet	WITH(NOLOCK)	ON	UserShift.UserShiftsId			=	UserShiftDet.UserShiftsId	     

			END
		--END
ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.MwoCompletionInfo UPDATE

			

BEGIN

print 'a'
			--DECLARE @mTimestamp varbinary(200);
			--SELECT	@mTimestamp = Timestamp FROM	UMUserShifts 
			--WHERE	UserShiftsId	=	@pUserShiftsId
			
			--IF(@mTimestamp = @pTimestamp)
			--BEGIN
	    UPDATE  UserShifts	SET		
							UserShifts.CustomerId							= @pCustomerId,
							UserShifts.FacilityId							= @pFacilityId,
							UserShifts.UserRegistrationId					= @pUserRegistrationId,
							UserShifts.LunchTimeLovId						= @pLunchTimeLovId,
							UserShifts.LeaveFrom							= @pLeaveFrom,
							UserShifts.LeaveTo								= @pLeaveTo,
							UserShifts.NoOfDays								= @pNoOfDays,
							UserShifts.Remarks								= @pRemarks,
							UserShifts.ModifiedBy							= @pUserId,
							UserShifts.ModifiedDate							= GETDATE(),
							UserShifts.ModifiedDateUTC						= GETUTCDATE(),
							UserShifts.ShiftTimeLovId						= @pShiftTimeLovId,						
							UserShifts.ShiftStartTime						=@ShiftStartTime	,		
							UserShifts.ShiftStartTimeMin					=@ShiftStartTimeMin	,	
							UserShifts.ShiftEndTime							=@ShiftEndTime	,		
							UserShifts.ShiftEndTimeMin						=@ShiftEndTimeMin	,	
							UserShifts.ShiftBreakStartTime					=@ShiftBreakStartTime,	
							UserShifts.ShiftBreakStartTimeMin				=@ShiftBreakStartTimeMin	,
							UserShifts.ShiftBreakEndTime					=@ShiftBreakEndTime	,	
							UserShifts.ShiftBreakEndTimeMin					=@ShiftBreakEndTimeMin	

							OUTPUT INSERTED.UserShiftsId INTO @Table
				FROM	UMUserShifts										AS UserShifts
				WHERE	UserShifts.UserShiftsId= @pUserShiftsId 
						AND ISNULL(@pUserShiftsId,0)>0

		 UPDATE  UserShiftsDet	SET												   	
		
									UserShiftsDet.LeaveFrom							=   UserShiftsDetudt.LeaveFrom,
									UserShiftsDet.LeaveTo							=   UserShiftsDetudt.LeaveTo,
									UserShiftsDet.NoOfDays							=   UserShiftsDetudt.NoOfDays,
									UserShiftsDet.Remarks							=   UserShiftsDetudt.Remarks,
									UserShiftsDet.ModifiedBy						=   UserShiftsDetudt.UserId,			
									UserShiftsDet.ModifiedDate						=   GETDATE(),
									UserShiftsDet.ModifiedDateUTC					=   GETUTCDATE()

		FROM	UMUserShiftsDet											AS UserShiftsDet 
				INNER JOIN @pUMUserShiftsDet							AS UserShiftsDetudt on UserShiftsDet.UserShiftDetId=UserShiftsDetudt.UserShiftDetId
		WHERE	ISNULL(UserShiftsDetudt.UserShiftDetId,0)>0


					INSERT INTO UMUserShiftsDet
						(
							UserShiftsId,
							LeaveFrom,
							LeaveTo,
							NoOfDays,
							Remarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
							
						)

			SELECT			
							@pUserShiftsId,
							LeaveFrom,
							LeaveTo,	
							NoOfDays,
							Remarks,		
							UserId,		
							GETDATE(),			
							GETUTCDATE(),
							UserId,			
							GETDATE(),			
							GETUTCDATE()
			FROM	@pUMUserShiftsDet
			WHERE   ISNULL(UserShiftDetId,0)=0
		  
			SELECT	UserShiftsId,
					UserRegistrationId,
					[Timestamp],
					'' as ErrorMessage
			FROM	UMUserShifts
			WHERE	UserShiftsId =@pUserShiftsId

			SELECT UserShiftsId,MAX(LeaveFrom) AS LeaveFrom,MAX(LeaveTo) AS LeaveTo 
			INTO #TempLeaveDetUP 
			FROM UMUserShiftsDet WHERE UserShiftsId	=	@pUserShiftsId
			GROUP BY UserShiftsId
	
	UPDATE UserShift	SET UserShift.LeaveFrom	=	UserShiftDet.LeaveFrom,
							UserShift.LeaveTo	=	UserShiftDet.LeaveTo
	FROM	UMUserShifts						AS	UserShift		WITH(NOLOCK)
			INNER JOIN #TempLeaveDetUP			AS	UserShiftDet	WITH(NOLOCK)	ON	UserShift.UserShiftsId			=	UserShiftDet.UserShiftsId	 

	
--END   
--	ELSE
--		BEGIN
--				   SELECT	UserShiftsId,
--							[Timestamp],
--							'Record Modified. Please Re-Select' ErrorMessage
--				   FROM		UMUserShifts
--				   WHERE	UserShiftsId =@pUserShiftsId
--		END
END



	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
        END
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

-----------------------------------------------------------------------------------UDT CREATION ---------------------------------------------------

--drop proc [uspFM_UMUserShifts_Save]
--drop type udt_UMUserShiftsDet


--CREATE TYPE [dbo].[udt_UMUserShiftsDet] AS TABLE
--(
--UserShiftDetId			int null,
--LeaveFrom				DATETIME	null,
--LeaveTo					DATETIME	null,
--NoOfDays				NUMERIC	null,
--Remarks					NVARCHAR(1000)	null,
--UserId					int	null
--)
GO
