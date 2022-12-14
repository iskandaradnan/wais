USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FEClock_Mobile_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_PorteringTransaction_Mobile_Save
Description			: Portering Transaction save
Authors				: Dhilip V
Date				: 19-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @pFEClock AS udt_FEClock_Mobile
INSERT INTO @pFEClock([ClockId],[UserRegistrationId],[DateTime],[DateTimeUTC],[ClockIn],[ClockInUTC],[ClockInLatitude],[ClockInLongitude],[ClockOut],[ClockOutUTC],
[ClockOutLatitude],[ClockOutLongitude],[Remarks],[UserId])VALUES
(0,32,'2018-07-18 14:51:13.033','2018-07-18 14:51:13.033','2018-07-18 14:51:13.033','2018-07-18 14:51:13.033',23,45,NULL,NULL,NULL,NULL,'REWFGG',2),
(2,32,'2018-07-18 14:51:13.033','2018-07-18 14:51:13.033','2018-07-18 14:51:13.033','2018-07-18 14:51:13.033',23,45,'2018-07-18 14:57:29.960','2018-07-18 14:57:29.960',78,78,'REWFGG',2)
EXECUTE [uspFM_FEClock_Mobile_Save] @pFEClock

select getdate()
SELECT * FROM FEClock
select * from FEGPSPositionHistory 
SELECT * FROM CRMRequestWorkOrderTxn

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_FEClock_Mobile_Save]
		
		@pFEClock	 udt_FEClock_Mobile READONLY,
		@pUserId int	=	NULL
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

--//1.FMLovMst


IF EXISTS (SELECT 1 FROM @pFEClock WHERE ClockId =0 OR ClockId IS NULL)
BEGIN
			INSERT INTO FEClock
						(	
							UserRegistrationId,
							DateTime,
							DateTimeUTC,
							ClockIn,
							ClockInUTC,
							ClockInLatitude,
							ClockInLongitude,
							ClockOut,
							ClockOutUTC,
							ClockOutLatitude,
							ClockOutLongitude,
							Remarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
                       
						)	OUTPUT INSERTED.ClockId INTO @Table
	SELECT					UserRegistrationId,
							DateTime,
							DateTimeUTC,
							ClockIn,
							ClockInUTC,
							ClockInLatitude,
							ClockInLongitude,
							ClockOut,
							ClockOutUTC,
							ClockOutLatitude,
							ClockOutLongitude,
							Remarks,
							UserId,
							GETDATE(),
							GETUTCDATE(),
							UserId,
							GETDATE(),
							GETUTCDATE()
					FROM @pFEClock where ISNULL(ClockId,0)=0
								
			SELECT	ClockId,
					[Timestamp],
					'' AS	ErrorMessage
			FROM	FEClock
			WHERE	ClockId IN (SELECT ID FROM @Table)

			DECLARE @PPrimaryKey INT
			SELECT @PPrimaryKey =  ID FROM @Table

			--IF(@pCurrentWorkFlowId IS NOT NULL) 
			--BEGIN
			--IF NOT EXISTS(SELECT 1 FROM PorteringTransactionHistory WHERE PorteringId = @PPrimaryKey AND WorkFlowStatusId = @pCurrentWorkFlowId)
			--BEGIN
			--INSERT INTO PorteringTransactionHistory (PorteringId,WorkFlowStatusId,WFDoneBy,WFDoneByDate,Remarks,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			--VALUES (@PPrimaryKey,@pCurrentWorkFlowId,@pUserId,GETDATE(),@pRemarks,@pUserId,GETDATE(),GETDATE(),@pUserId,GETDATE(),GETDATE())

			--END
			--END
			--IF(@pPorteringStatus IS NOT NULL AND @pCurrentWorkFlowId IS NOT NULL) 
			--BEGIN
			--IF NOT EXISTS(SELECT 1 FROM PorteringTransactionHistory WHERE PorteringId = @PPrimaryKey AND PorteringStatusLovId = @pPorteringStatus AND WorkFlowStatusId = @pCurrentWorkFlowId)
			--BEGIN
			--INSERT INTO PorteringTransactionHistory (PorteringId,PorteringStatusLovId,PorteringStatusDoneBy,PorteringStatusDoneByDate,IsMoment,Remarks,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			--VALUES (@PPrimaryKey,@pPorteringStatus,@pUserId,GETDATE(),1,@pRemarks,@pUserId,GETDATE(),GETDATE(),@pUserId,GETDATE(),GETDATE())
			--END
			--END

END

IF EXISTS (SELECT 1 FROM @pFEClock WHERE ClockId >0)
BEGIN
  UPDATE  Clock	SET			
							Clock.UserRegistrationId						= Clockudt.UserRegistrationId,
							Clock.DateTime									= Clockudt.DateTime,
							Clock.DateTimeUTC								= Clockudt.DateTimeUTC,
							Clock.ClockIn									= Clockudt.ClockIn,
							Clock.ClockInUTC								= Clockudt.ClockInUTC,
							Clock.ClockInLatitude							= Clockudt.ClockInLatitude,
							Clock.ClockInLongitude							= Clockudt.ClockInLongitude,
							Clock.ClockOut									= Clockudt.ClockOut,
							Clock.ClockOutUTC								= Clockudt.ClockOutUTC,
							Clock.ClockOutLatitude							= Clockudt.ClockOutLatitude,
							Clock.ClockOutLongitude							= Clockudt.ClockOutLongitude,
							Clock.Remarks									= Clockudt.Remarks,
							Clock.ModifiedBy								= Clockudt.UserId,
							Clock.ModifiedDate								= GETDATE(),
							Clock.ModifiedDateUTC							= GETUTCDATE()
							OUTPUT INSERTED.ClockId INTO @Table
				FROM	FEClock										AS Clock
				INNER JOIN @pFEClock								AS Clockudt			on Clock.ClockId = Clockudt.ClockId
				WHERE	 ISNULL(Clockudt.ClockId,0)>0

			SELECT	ClockId,
					[Timestamp],
					'' AS	ErrorMessage
			FROM	FEClock
			WHERE	ClockId IN (SELECT ID FROM @Table)
END


------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------
		


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
