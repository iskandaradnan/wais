USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FinMonthlyFeeTxn_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FinMonthlyFeeTxn_Save
Description			: If Finance Monthly Fedd already exists then update else insert.
Authors				: Dhilip V
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @FinMonthlyFeeTxnDet AS [dbo].[udt_FinMonthlyFeeTxnDet]

 insert into  @FinMonthlyFeeTxnDet(MonthlyFeeDetId,CustomerId,FacilityId,Month,VersionNo,BemsMSF,BemsCF,BemsPercent,TotalFee,FemsMSF,FemsCF,FemsPercent,
IsAmdGenerated,AmdUserId,AmdDate,AmdDateUTC)VALUES
(109,'1','2','1','0','776391','0','77639100','77639100','776391','0','77639100',0,2,'2018-04-06 12:37:18.333','2018-04-06 12:37:18.333')

EXEC [uspFM_FinMonthlyFeeTxn_Save] @FinMonthlyFeeTxnDet=@FinMonthlyFeeTxnDet,@pMonthlyFeeId=7,@CustomerId=1,@FacilityId=2,@Year=2018,@VersionNo=0,@pUserId=1

select * FROM FinMonthlyFeeTxn
select * FROM FinMonthlyFeeTxnDet
select * FROM FinMonthlyFeeHistoryTxnDet

dbcc checkident ('FinMonthlyFeeTxn',RESEED,0)
dbcc checkident ('FinMonthlyFeeTxnDet',RESEED,0)
dbcc checkident ('FinMonthlyFeeHistoryTxnDet',reseed,0)
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_FinMonthlyFeeTxn_Save]

			@FinMonthlyFeeTxnDet			AS [dbo].[udt_FinMonthlyFeeTxnDet] READONLY,
			@pMonthlyFeeId					INT,
			@CustomerId						INT,
			@FacilityId						INT,
			@Year							INT,
			@VersionNo						INT	=	0,
			@pUserId						INT,
			@pTimestamp						VARBINARY(200)		=	NULL
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

	IF(ISNULL(@pMonthlyFeeId,0)=0)

	BEGIN

	DECLARE @CNT INT=0 
	SELECT @CNT = COUNT(1)	FROM FinMonthlyFeeTxn
					WHERE	FacilityId	=	@FacilityId
							AND Year	=	@Year
	
		IF (@CNT=0)

		BEGIN
	          INSERT INTO FinMonthlyFeeTxn(
			  										CustomerId,
													FacilityId,
													Year,
													VersionNo,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC
                           )OUTPUT INSERTED.MonthlyFeeId INTO @Table
			  --VALUES								(
					--								@CustomerId,
					--								@FacilityId,
					--								@Year,
					--								@pUserId,													
					--								GETDATE(), 
					--								GETUTCDATE(),
					--								@pUserId,													
					--								GETDATE(), 
					--								GETUTCDATE()
					--								)

				SELECT								
													DISTINCT MonthlyFeeTxnType.CustomerId,
													MonthlyFeeTxnType.FacilityId,
													@Year,
													ISNULL(NULLIF(@VersionNo,''),0) + 1,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
				   FROM	@FinMonthlyFeeTxnDet			AS MonthlyFeeTxnType
						LEFT JOIN	FinMonthlyFeeTxn	AS	MonthlyFee	ON	MonthlyFeeTxnType.FacilityId=MonthlyFee.FacilityId	AND	MonthlyFee.Year=@Year
				   WHERE	MonthlyFee.MonthlyFeeId IS  NULL



			DECLARE @mPrimaryId INT;
			SELECT @mPrimaryId=MonthlyFeeId FROM FinMonthlyFeeTxn WHERE	MonthlyFeeId IN (SELECT ID FROM @Table)
			IF(@mPrimaryId IS NULL)
			SELECT @mPrimaryId=MonthlyFeeId FROM FinMonthlyFeeTxn WHERE	FacilityId=@FacilityId AND Year=@Year


			  INSERT INTO FinMonthlyFeeTxnDet(
													CustomerId,
													FacilityId,
													MonthlyFeeId,
													Month,
													VersionNo,
													BemsMSF,
													BemsCF,
													BemsPercent,
													TotalFee,
													FemsMSF,
													FemsCF,
													FemsPercent,
													IsAmdGenerated,
													AmdUserId,
													AmdDate,
													AmdDateUTC,
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
													@mPrimaryId,
													Month,
													ISNULL(NULLIF(@VersionNo,''),0) + 1,
													BemsMSF,
													BemsCF,
													BemsPercent,
													TotalFee,
													FemsMSF,
													FemsCF,
													FemsPercent,
													IsAmdGenerated,
													AmdUserId,
													AmdDate,
													AmdDateUTC,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
				   FROM @FinMonthlyFeeTxnDet	AS MonthlyFeeTxnType
				   WHERE	ISNULL(MonthlyFeeTxnType.MonthlyFeeDetId,0)=0




			   	   SELECT				MonthlyFeeId,
										[Timestamp],
										'' ErrorMessage
				   FROM					FinMonthlyFeeTxn
				   WHERE				MonthlyFeeId IN (SELECT ID FROM @Table)
		END
		ELSE
			BEGIN
				   SELECT	0 AS MonthlyFeeId,
							CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS [Timestamp],
							'Monthly service fee combination already exists for selected year' ErrorMessage
			END

	
		END

  ELSE
	  BEGIN

			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp FROM	FinMonthlyFeeTxn 
			WHERE	MonthlyFeeId	=	@pMonthlyFeeId

			IF (@mTimestamp= @pTimestamp)
			BEGIN

				SELECT @VersionNo = ISNULL(NULLIF(MAX(VersionNo),''),0) + 1 FROM FinMonthlyFeeTxnDet WHERE MonthlyFeeId=@pMonthlyFeeId 


				UPDATE [FinMonthlyFeeTxn] SET 
									@VersionNo									= @VersionNo
									OUTPUT INSERTED.MonthlyFeeId INTO @Table
			   WHERE MonthlyFeeId=@pMonthlyFeeId
			   




			  INSERT INTO FinMonthlyFeeHistoryTxnDet(
													CustomerId,
													FacilityId,
													MonthlyFeeDetId,
													MonthlyFeeId,
													Month,
													VersionNo,
													BemsMSF,
													BemsCF,
													BemsPercent,
													TotalFee,
													FemsMSF,
													FemsCF,
													FemsPercent,
													IsAmdGenerated,
													AmdUserId,
													AmdDate,
													AmdDateUTC,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													Year
                                                    )
				SELECT								
													CustomerId,
													FacilityId,
													MonthlyFeeDetId,
													MonthlyFeeId,
													Month,
													VersionNo,
													BemsMSF,
													BemsCF,
													BemsPercent,
													TotalFee,
													FemsMSF,
													FemsCF,
													FemsPercent,
													IsAmdGenerated,
													AmdUserId,
													AmdDate,
													AmdDateUTC,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@Year
				   FROM FinMonthlyFeeTxnDet	AS MonthlyFeeTxnDet
				   WHERE	MonthlyFeeTxnDet.MonthlyFeeDetId IN (SELECT MonthlyFeeDetId FROM @FinMonthlyFeeTxnDet)


			    UPDATE MonthlyFeeTxnDet SET		
									MonthlyFeeTxnDet.CustomerId					= MonthlyFeeTxnDetType.CustomerId,
									MonthlyFeeTxnDet.FacilityId					= MonthlyFeeTxnDetType.FacilityId,
									MonthlyFeeTxnDet.Month						= MonthlyFeeTxnDetType.Month,
									MonthlyFeeTxnDet.VersionNo					= @VersionNo,
									MonthlyFeeTxnDet.BemsMSF					= MonthlyFeeTxnDetType.BemsMSF,
									MonthlyFeeTxnDet.BemsCF						= MonthlyFeeTxnDetType.BemsCF,
									MonthlyFeeTxnDet.BemsPercent				= MonthlyFeeTxnDetType.BemsPercent,
									MonthlyFeeTxnDet.TotalFee					= MonthlyFeeTxnDetType.TotalFee,
									MonthlyFeeTxnDet.FemsMSF					= MonthlyFeeTxnDetType.FemsMSF,
									MonthlyFeeTxnDet.FemsCF						= MonthlyFeeTxnDetType.FemsCF,
									MonthlyFeeTxnDet.FemsPercent				= MonthlyFeeTxnDetType.FemsPercent,
									MonthlyFeeTxnDet.IsAmdGenerated				= MonthlyFeeTxnDetType.IsAmdGenerated,
									MonthlyFeeTxnDet.AmdUserId					= MonthlyFeeTxnDetType.AmdUserId,
									MonthlyFeeTxnDet.AmdDate					= MonthlyFeeTxnDetType.AmdDate,
									MonthlyFeeTxnDet.AmdDateUTC					= MonthlyFeeTxnDetType.AmdDateUTC,
									MonthlyFeeTxnDet.ModifiedBy					= @pUserid,
									MonthlyFeeTxnDet.ModifiedDate				= GETDATE(),
									MonthlyFeeTxnDet.ModifiedDateUTC			= GETDATE()
					FROM	[FinMonthlyFeeTxnDet]						AS MonthlyFeeTxnDet 
							INNER JOIN @FinMonthlyFeeTxnDet				AS MonthlyFeeTxnDetType ON MonthlyFeeTxnDet.MonthlyFeeDetId	 =	MonthlyFeeTxnDetType.MonthlyFeeDetId
					WHERE ISNULL(MonthlyFeeTxnDetType.MonthlyFeeDetId,0)>0

			
				   SELECT	MonthlyFeeId,
							[Timestamp],
							'' ErrorMessage
				   FROM		FinMonthlyFeeTxn
				   WHERE	MonthlyFeeId =@pMonthlyFeeId

	END
	ELSE
		BEGIN
				   SELECT	MonthlyFeeId,
							[Timestamp],
							'Record Modified. Please Re-Select' ErrorMessage
				   FROM		FinMonthlyFeeTxn
				   WHERE	MonthlyFeeId =@pMonthlyFeeId
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

-------------------------------------------------------------------Udt creation----------------------------------------------------------------
--DROP PROC [uspFM_FinMonthlyFeeTxn_Save]
--DROP TYPE [udt_FinMonthlyFeeTxnDet]

--CREATE TYPE [dbo].[udt_FinMonthlyFeeTxnDet] AS TABLE(

--MonthlyFeeDetId				INT,
--CustomerId					INT,
--FacilityId					INT,
--Month						INT,
--VersionNo					INT,
--BemsMSF						NUMERIC(24,2),
--BemsCF						NUMERIC(24,2),
--BemsPercent					NUMERIC(24,2),
--TotalFee					NUMERIC(24,2),
--FemsMSF						NUMERIC(24,2),
--FemsCF						NUMERIC(24,2),
--FemsPercent					NUMERIC(24,2),
--IsAmdGenerated				BIT,
--AmdUserId					INT,
--AmdDate						DATETIME,
--AmdDateUTC					DATETIME
--)
GO
