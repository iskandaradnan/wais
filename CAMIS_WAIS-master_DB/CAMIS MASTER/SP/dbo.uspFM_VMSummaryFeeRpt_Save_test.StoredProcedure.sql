USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMSummaryFeeRpt_Save_test]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_VMSummaryFeeRpt_Save
Description			: Get the variation details for bulk authorization.
Authors				: Dhilip V
Date				: 06-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_VMSummaryFeeRpt_Save] @pServiceId=2,@pFacilityId=2,@pAssetClassificationId=1,@pMonth=04,@pYear=2018,@pRollOverID=15,@pStatusFlag='verify'
SELECT * FROM VMRollOverFeeReport
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_VMSummaryFeeRpt_Save_test]

		@pServiceId				INT,
		@pFacilityId			INT,
		@pAssetClassificationId	INT		=	NULL,
		@pMonth					NVARCHAR(10),
		@pYear					NVARCHAR(10),
		@pRollOverID			INT=null,
		@pUserId				INT=1,
		@pStatusFlag			NVARCHAR(100)	=	NULL

AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declare
	DECLARE @Table TABLE (ID INT)

	CREATE TABLE #VMRollOverFeeReport (
		[RollOverFeeId] [int]   NULL,
		[CustomerId] [int]  NULL,
		[FacilityId] [int]  NULL,
		[FacilityName] nvarchar(100)  NULL,
		DWCOUNT_ID INT,
		DWCOUNT INT,
		DWTotalFee NUMERIC(24,2),
		Year INT,
		Month INT,
		PWCOUNT_ID INT,
		PWCOUNT INT,
		PWTotalFee NUMERIC(24,2),
		Total_Fee NUMERIC(24,2),
		Service_Name [nvarchar](50) NULL,
		[AssetClassification] [nvarchar](50) NULL,	
		VerifiedBy [int] NULL,
		VerifiedDate [datetime] NULL,
		ApprovedBy [int] NULL,
		ApprovedDate [datetime] NULL,
		PaymentStartDate [datetime] NULL,
		ServiceID [int] NULL,
		ClassificationID [int] NULL,
		[Status] [int] NULL,
		SubmissionMONTH [int] NULL
		)



	INSERT INTO #VMRollOverFeeReport (	[CustomerId],
										[FacilityId],
										[FacilityName],
										DWCOUNT_ID,
										DWCOUNT,
										DWTotalFee,
										Year,
										Month,
										PWCOUNT_ID,
										PWCOUNT,
										PWTotalFee,
										Total_Fee,
										Service_Name,
										--[AssetClassification],	
										VerifiedBy,
										VerifiedDate,
										ApprovedBy,
										ApprovedDate,
										PaymentStartDate,
										ServiceID,
										--ClassificationID,
										[Status],
										SubmissionMONTH
									)
	EXEC [uspFM_VMSummaryFeeRpt_Fetch] @pServiceId=@pServiceId,@pFacilityId=@pFacilityId,--@pAssetClassificationId=@pAssetClassificationId,
	@pMonth=@pMonth,@pYear=@pYear,@pRollOverID=@pRollOverID

	IF(LOWER(ISNULL(@pStatusFlag,''))='save')
	BEGIN
	
		INSERT INTO VMRollOverFeeReport (CustomerId,FacilityId,ServiceId,AssetClassificationId,Year,Month,DWStartDate,PWStartDate,DoneBy,DoneDate,Remarks,Status,CreatedBy
											,CreatedDate
											,CreatedDateUTC
											,ModifiedBy
											,ModifiedDate
											,ModifiedDateUTC
											,StatusFlag)
		OUTPUT inserted.RollOverFeeId INTO @Table

		SELECT A.CustomerId,A.FacilityId,A.ServiceId,@pAssetClassificationId,A.Year,A.Month,null AS DWStartDate,null AS  PWStartDate,@pUserId,GETDATE(),Remarks,1 AS Status ,
				1 AS CreatedBy,GETDATE()	as	CreatedDate,GETUTCDATE()	as	CreatedDateUTC,1 AS ModifiedBy,GETDATE()	as	ModifiedDate,GETUTCDATE()	as	ModifiedDateUTC,1
		FROM	#VMRollOverFeeReport A 
				LEFT JOIN VMRollOverFeeReport B ON A.FacilityId = B.FacilityId	AND A.CustomerId=B.CustomerId
				AND A.Month	=	B.Month AND A.Year	=	b.Year
		--WHERE	a.Month IS NULL


	END


	IF(LOWER(ISNULL(@pStatusFlag,''))='edit')
	BEGIN
	
		UPDATE VMRollOverFeeReport	SET		Status	=	232,
											DoneBy	=	@pUserId,
											DoneDate	=	GETDATE(),
											StatusFlag	=	1,
											ModifiedBy	=	@pUserId,
											ModifiedDate	=	GETDATE(),
											ModifiedDateUTC	=	GETUTCDATE()
										
		OUTPUT inserted.RollOverFeeId INTO @Table
		where 	RollOverFeeId	=@pRollOverID

		IF NOT EXISTS (SELECT COUNT(1) FROM	VMRollOverFeeReportHistoryDet WHERE RollOverFeeId	=@pRollOverID AND Status	=	233)
		
		BEGIN

		INSERT INTO VMRollOverFeeReportHistoryDet (	RollOverFeeId,
													Status,
													DoneBy,
													DoneDate,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC
												)
												VALUES
												(	@pRollOverID,
													232,
													@pUserId,
													GETDATE(),
													NULL,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
												)
			END

	END



	IF(LOWER(ISNULL(@pStatusFlag,''))='verify')
	BEGIN


	
		UPDATE VMRollOverFeeReport	SET		Status	=	233,
											DoneBy	=	@pUserId,
											DoneDate	=	GETDATE(),
											StatusFlag	=	9,
											ModifiedBy	=	@pUserId,
											ModifiedDate	=	GETDATE(),
											ModifiedDateUTC	=	GETUTCDATE()
										
		OUTPUT inserted.RollOverFeeId INTO @Table
		where 	RollOverFeeId	=@pRollOverID


		IF NOT EXISTS (SELECT 1 FROM	VMRollOverFeeReportHistoryDet WHERE RollOverFeeId	=@pRollOverID AND Status	=	233)
		
		BEGIN
		
		INSERT INTO VMRollOverFeeReportHistoryDet (	RollOverFeeId,
													Status,
													DoneBy,
													DoneDate,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC
												)
												VALUES
												(	@pRollOverID,
													233,
													@pUserId,
													GETDATE(),
													NULL,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
												)
			END

	END

	IF(LOWER(ISNULL(@pStatusFlag,''))='approve')
	BEGIN
	
		UPDATE VMRollOverFeeReport	SET Status	=	230,
											DoneBy	=	@pUserId,
											DoneDate	=	GETDATE(),
											StatusFlag	=	7,
											ModifiedBy	=	@pUserId,
											ModifiedDate	=	GETDATE(),
											ModifiedDateUTC	=	GETUTCDATE()
										
		OUTPUT inserted.RollOverFeeId INTO @Table
		where 	RollOverFeeId	=@pRollOverID

		IF NOT EXISTS (SELECT 1 FROM	VMRollOverFeeReportHistoryDet WHERE RollOverFeeId	=@pRollOverID AND Status	=	230)
		
		BEGIN

		INSERT INTO VMRollOverFeeReportHistoryDet (	RollOverFeeId,
													Status,
													DoneBy,
													DoneDate,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC
												)
												VALUES
												(	@pRollOverID,
													230,
													@pUserId,
													GETDATE(),
													NULL,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
												)
			END
	END


	
	IF(LOWER(ISNULL(@pStatusFlag,''))='reject')
	BEGIN
	
		UPDATE VMRollOverFeeReport	SET Status	=	231,
											DoneBy	=	@pUserId,
											DoneDate	=	GETDATE(),
											StatusFlag	=	8,
											ModifiedBy	=	@pUserId,
											ModifiedDate	=	GETDATE(),
											ModifiedDateUTC	=	GETUTCDATE()
										
		OUTPUT inserted.RollOverFeeId INTO @Table
		where 	RollOverFeeId	=@pRollOverID

		IF NOT EXISTS (SELECT 1 FROM	VMRollOverFeeReportHistoryDet WHERE RollOverFeeId	=@pRollOverID AND Status	=	230)
		
		BEGIN

		INSERT INTO VMRollOverFeeReportHistoryDet (	RollOverFeeId,
													Status,
													DoneBy,
													DoneDate,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC
												)
												VALUES
												(	@pRollOverID,
													231,
													@pUserId,
													GETDATE(),
													NULL,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE()
												)
			END
	END

SELECT	RollOverFeeId,
		[Timestamp]
FROM VMRollOverFeeReport
WHERE RollOverFeeId	IN (SELECT ID FROM @Table)

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
