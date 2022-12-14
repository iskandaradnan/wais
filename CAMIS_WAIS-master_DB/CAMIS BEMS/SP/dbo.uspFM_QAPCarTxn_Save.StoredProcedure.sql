USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QAPCarTxn_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*========================================================================================================

Application Name	: UETrack-BEMS              

Version				: 1.0

Procedure Name		: uspFM_QAPCarTxn_Save

Description			: Manual CAR

Authors				: DHILIP V

Date				: 02-July-2018

-----------------------------------------------------------------------------------------------------------



Unit Test:

DECLARE @CurrDate DATETIME = GETDATE()

DECLARE @pQAPCarTxnDet			[dbo].[udt_QAPCarTxnDet]

INSERT INTO @pQAPCarTxnDet (CustomerId,FacilityId,ServiceId,CarId,Activity,StartDate,[TargetDate],CompletedDate,[ResponsiblePersonUserId],[ResponsibilityId],[IsDeleted])

VALUES(1,1,2,1,'sdfdsf',GETDATE(),GETDATE(),GETDATE(),1,333,0)

EXEC uspFM_QAPCarTxn_Save @pQAPCarTxnDet=@pQAPCarTxnDet,@pCarId=12,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pCARNumber=NULL,@pCARDate=@CurrDate,@pQAPIndicatorId=1,

@pFromDate=@CurrDate,@pToDate=@CurrDate,@pFollowupCARId=NULL,@pProblemStatement='',@pRootCause='',@pSolution='',@pPriorityLovId=296,@pStatus=300,

@pIssuerUserId=1,@pVerifiedDate=@CurrDate,@pVerifiedBy=2,@pRemarks='',@pFailureSymptomId=1,@pUserId=1,@pTimestamp=NULL,@pAssignedUserId=1



SELECT * FROM QAPCarTxn

SELECT * FROM QAPCarTxnDet

-----------------------------------------------------------------------------------------------------------

Version History 

-----:------------:---------------------------------------------------------------------------------------

Init :  Date       : Details

========================================================================================================*/



CREATE PROCEDURE  [dbo].[uspFM_QAPCarTxn_Save]

	@pQAPCarTxnDet				[dbo].[udt_QAPCarTxnDet]	READONLY,

	@pCarId						INT,

	@pCustomerId				INT,

	@pFacilityId				INT,

	@pServiceId					INT,

	@pCARNumber					NVARCHAR(50)	=	NULL,

	@pCARDate					DATETIME,

	@pQAPIndicatorId			INT,

	@pFromDate					DATETIME		=	NULL,

	@pToDate					DATETIME		=	NULL,

	@pFollowupCARId				INT				=	NULL,

	@pProblemStatement			NVARCHAR (500)	=	NULL,

	@pRootCause					NVARCHAR (500)	=	NULL,

	@pSolution					NVARCHAR (500)	=	NULL,

	@pPriorityLovId				INT,

	@pStatus					INT,

	@pIssuerUserId				INT				=	NULL,

	@pCARTargetDate				DATETIME,

	@pVerifiedDate				DATETIME		=	NULL,

	@pVerifiedBy				INT				=	NULL,

	@pRemarks					NVARCHAR (500)	=	NULL,

	@pTimestamp					VARBINARY(200)	=	NULL,

	@pUserId					INT				=	NULL,

	--@pFailureSymptomId			INT				=	NULL,

	@pAssignedUserId			INT				=	NULL,

	@pCarStatus					INT				=	NULL



	--@pAssetId					INT				=	NULL,

	--@pAssetTypeCodeId			INT				=	NULL,

	--@pExpectedPercentage		NUMERIC(24,2)	=	NULL,

	--@pActualPercentage		NUMERIC(24,2)	=	NULL

								

AS                                              



BEGIN TRY



	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT



	--BEGIN TRANSACTION



-- Paramter Validation 



	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



-- Declaration

	

	DECLARE @Table TABLE (ID INT)	

	DECLARE	@pFromDateUTC		DATETIME,	

			@pToDateUTC			DATETIME,	

			@pVerifiedDateUTC	DATETIME,

			@pCARDateUTC		DATETIME,

			@mIndicatorCode		NVARCHAR(50)



-- Default Values

	SET @pFromDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pFromDate)

	SET @pToDateUTC			= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pToDate)

	SET @pVerifiedDateUTC	= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pVerifiedDate)

	SET @pCARDateUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pCARDate)



	



-- Execution



	--DELETE FROM QAPCarTxnDet WHERE CarId	=	@pCarId AND CarDetId IN (SELECT CarDetId FROM @pQAPCarTxnDet WHERE IsDeleted =1)

	

	CREATE TABLE #TempActivity (Id INT IDENTITY(1,1), Activity NVARCHAR(250));

	INSERT INTO #TempActivity (Activity)

	SELECT Activity FROM @pQAPCarTxnDet WHERE IsDeleted =0



	DECLARE @TempCarId INT;

	SELECT TOP 1 @TempCarId = CarId FROM @pQAPCarTxnDet



	IF @TempCarId <> 0

	BEGIN

	INSERT INTO #TempActivity (Activity)

	SELECT Activity FROM QAPCarTxnDet WHERE CarDetId NOT IN (SELECT CarDetId FROM @pQAPCarTxnDet) AND CarId = (SELECT DISTINCT CarId FROM @pQAPCarTxnDet)

	END



	--SELECT	ROW_NUMBER() OVER (ORDER BY CarDetId) AS ID,

	--		CarDetId,

	--		CarId,

	--		Activity

	--INTO	#TempActivity

	--FROM QAPCarTxnDet WHERE CarId IN (SELECT DISTINCT CarId FROM @pQAPCarTxnDet)



	--INSERT INTO #TempActivity (	CarDetId

	--							,CarId

	--							,Activity)

	--		SELECT	CarDetId

	--				,CarId

	--				,Activity

	--		FROM	@pQAPCarTxnDet WHERE CarDetId NOT IN (SELECT CarDetId FROM QAPCarTxnDet WHERE CarId IN (SELECT DISTINCT CarId FROM @pQAPCarTxnDet) )





	--IF EXISTS ((SELECT 1 FROM  @pQAPCarTxnDet GROUP BY LTRIM(RTRIM(ISNULL(Activity,''))) HAVING COUNT(*)>1))

	--BEGIN

	--	SELECT	0 AS CarId,

	--			NULL AS CARNumber,

	--			NULL AS [Timestamp],

	--			'Activity should be unique' AS ErrorMessage,

	--			NULL GuId



	--END



	--ELSE IF EXISTS (	SELECT 1 

	--					FROM QAPCarTxnDet WITH(NOLOCK) 

	--					WHERE	Activity IN	(SELECT Activity FROM  @pQAPCarTxnDet WHERE CarDetId=0)

	--					AND	CarId IN (SELECT DISTINCT CarId FROM @pQAPCarTxnDet)

	--				)

	--ELSE 

	IF  exists (SELECT 1 FROM  QapB1AdditionalInformationTxn AddInfo where CarId=@pCarId)

		and @pCarStatus = 369 

		and  not exists (SELECT 1 FROM  QapB1AdditionalInformationTxn AddInfo where CarId=@pCarId and 

		isnull(AddInfo.CauseCodeId,0)>0 and 	isnull(AddInfo.QcCodeId	,0) >0 )	

	BEGIN

	SELECT	CAR.CarId,

						CARNumber,

						CAR.[Timestamp],

						'Please save Work Order deails before approving CAR' AS ErrorMessage,

						CAR.GuId,

						CAR.CARStatus,

						LovStatus.FieldValue	AS CARStatusValue

				FROM	QAPCarTxn AS CAR

				LEFT JOIN FMLovMst AS LovStatus ON	 CAR.CARStatus	=	LovStatus.LovId

				WHERE	CarId =@pCarId

	END

	ELSE IF EXISTS ((SELECT 1 FROM  #TempActivity GROUP BY LTRIM(RTRIM(ISNULL(Activity,''))) HAVING COUNT(*)>1))

	BEGIN

		SELECT	0 AS CarId,

				NULL AS CARNumber,

				NULL AS [Timestamp],

				'Activity should be unique' AS ErrorMessage,

				NULL GuId,

				NULL AS CARStatus,

				NULL AS CARStatusValue

	END





	ELSE IF (ISNULL(@pCarId,0)=0 OR @pCarId='')



	BEGIN



	DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT, @mPrimaryId INT

	SET @mMonth	=	MONTH(@pCARDate)

	SET @mYear	=	YEAR(@pCARDate)

	SET @mIndicatorCode	=	(SELECT IndicatorCode FROM MstQAPIndicator	WHERE	QAPIndicatorId	=	@pQAPIndicatorId)

	--SELECT @mIndicatorCode

	EXEC [uspFM_GenerateDocumentNumber] @pFlag='QAPCarTxn',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='CAR',@pModuleName=@mIndicatorCode,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT

	SELECT @pCARNumber=@pOutParam





			INSERT INTO QAPCarTxn	(	CustomerId,

										FacilityId,

										ServiceId,

										CARNumber,

										CARDate,

										CARDateUTC,

										QAPIndicatorId,

										FromDate,

										FromDateUTC,

										ToDate,

										ToDateUTC,

										FollowupCARId,

										ProblemStatement,

										PriorityLovId,

										Status,

										IssuerUserId,

										CARTargetDate,

										VerifiedDate,

										VerifiedDateUTC,

										VerifiedBy,

										CreatedBy,

										CreatedDate,

										CreatedDateUTC,

										ModifiedBy,

										ModifiedDate,

										ModifiedDateUTC,

										--FailureSymptomId,

										AssignedUserId,

										CARStatus

										--AssetId,

										--AssetTypeCodeId,

										--ExpectedPercentage,

										--ActualPercentage,

							

							)	OUTPUT INSERTED.CarId INTO @Table

							VALUES

							(	@pCustomerId,

								@pFacilityId,

								@pServiceId,

								@pCARNumber,

								@pCARDate,

								@pCARDateUTC,

								@pQAPIndicatorId,

								@pFromDate,

								@pFromDateUTC,

								@pToDate,

								@pToDateUTC,

								@pFollowupCARId,

								@pProblemStatement,

								@pPriorityLovId,

								@pStatus,

								@pIssuerUserId,

								@pCARTargetDate,

								@pVerifiedDate,

								@pVerifiedDateUTC,

								@pVerifiedBy,

								@pUserId,						

								GETDATE(),					

								GETUTCDATE(),					

								@pUserId,						

								GETDATE(),					

								GETUTCDATE(),

								--@pFailureSymptomId,

								@pAssignedUserId,

								@pCarStatus



							--@pAssetId,

							--@pAssetTypeCodeId,

							--@pExpectedPercentage,

							--@pActualPercentage

							)





		SET @mPrimaryId	=	(SELECT ID FROM @Table)



--- QAPCarTxnDet save

		INSERT INTO QAPCarTxnDet	(	CustomerId,

										FacilityId,

										ServiceId,

										CarId,

										Activity,

										StartDate,

										StartDateUTC,

										CompletedDate,

										CompletedDateUTC,

										CreatedBy,

										CreatedDate,

										CreatedDateUTC,

										ModifiedBy,

										ModifiedDate,

										ModifiedDateUTC,

										ResponsiblePersonUserId,

										TargetDate,

										ResponsibilityId

									)

							SELECT	CustomerId,

									FacilityId,

									ServiceId,

									@mPrimaryId,

									Activity,

									StartDate,

									DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), StartDate) AS StartDateUTC,

									CompletedDate,

									DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), CompletedDate) AS CompletedDateUTC,

									@pUserId,		

									GETDATE(),		

									GETUTCDATE(),

									@pUserId,		

									GETDATE(),		

									GETUTCDATE(),

									ResponsiblePersonUserId,

									TargetDate,

									ResponsibilityId

					FROM @pQAPCarTxnDet

					WHERE	ISNULL(CarDetId,0)=0





				--IF EXISTS (SELECT 1 FROM QAPCarHistory where CarId	=	@mPrimaryId AND Status=@pCarStatus)

				--	BEGIN

				--		UPDATE	QAPCarHistory SET	RootCause		=	@pRootCause,

				--									Solution		=	@pSolution,

				--									Remarks			=	@pRemarks,

				--									ModifiedBy		=	@pUserId,

				--									ModifiedDate	=	GETDATE(),

				--									ModifiedDateUTC	=	GETUTCDATE()

				--		WHERE	CarId	=	@mPrimaryId

				--				AND Status=@pCarStatus

				--	END

				--ELSE

				--	BEGIN

						INSERT INTO QAPCarHistory (	CarId

													,RootCause

													,Solution

													,Remarks

													,Status

													,CreatedBy

													,CreatedDate

													,CreatedDateUTC

													,ModifiedBy

													,ModifiedDate

													,ModifiedDateUTC

												)

										VALUES	(

													@mPrimaryId

													,@pRootCause

													,@pSolution

													,@pRemarks

													,@pCarStatus

													,@pUserId	

													,GETDATE()

													,GETUTCDATE()

													,@pUserId	

													,GETDATE()

													,GETUTCDATE()

												)

							--END



		SELECT	CAR.CarId,

				CARNumber,

				CAR.[Timestamp],

				'' ErrorMessage,

				CAR.GuId,

				CAR.CARStatus,

				LovStatus.FieldValue	AS CARStatusValue

		FROM	QAPCarTxn AS CAR

				LEFT JOIN FMLovMst AS LovStatus ON	 CAR.CARStatus	=	LovStatus.LovId

		WHERE	CarId IN (SELECT ID FROM @Table)



		END







	ELSE





		BEGIN



			DECLARE @mTimestamp varbinary(200);



			SELECT	@mTimestamp = [Timestamp] 

			FROM QAPCarTxn 

			WHERE CarId=@pCarId



			IF (@mTimestamp=@pTimestamp)

			

			BEGIN



			UPDATE QAPCarTxn SET	QAPIndicatorId			=	@pQAPIndicatorId,

									FromDate				=	@pFromDate,

									FromDateUTC				=	@pFromDateUTC,

									ToDate					=	@pToDate,

									ToDateUTC				=	@pToDateUTC,

									FollowupCARId			=	@pFollowupCARId,

									ProblemStatement		=	@pProblemStatement,

									PriorityLovId			=	@pPriorityLovId,

									Status					=	@pStatus,

									IssuerUserId			=	@pIssuerUserId,

									CARTargetDate			=   @pCARTargetDate,

									VerifiedDate			=	@pVerifiedDate,

									VerifiedDateUTC			=	@pVerifiedDateUTC,

									VerifiedBy				=	@pVerifiedBy,

									ModifiedBy				=	@pUserId,

									ModifiedDate			=	GETDATE(),

									ModifiedDateUTC			=	GETUTCDATE(),

									--FailureSymptomId		=	@pFailureSymptomId,

									AssignedUserId			=	@pAssignedUserId,

									CarStatus				=	@pCarStatus

									--AssetId				=	@pAssetId,

									--AssetTypeCodeId		=	@pAssetTypeCodeId,

									--ExpectedPercentage	=	@pExpectedPercentage,

									--ActualPercentage		=	@pActualPercentage

					WHERE	CarId	=	@pCarId

	

		DELETE FROM QAPCarTxnDet WHERE CarId	=	@pCarId AND CarDetId IN (SELECT CarDetId FROM @pQAPCarTxnDet WHERE IsDeleted =1)								



		UPDATE CarDet SET	CarDet.Activity					=   udt_CarDet.Activity	,		

							CarDet.StartDate				=   udt_CarDet.StartDate	,	

							CarDet.StartDateUTC				=   DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), udt_CarDet.StartDate),

							CarDet.CompletedDate			=   udt_CarDet.CompletedDate,

							CarDet.CompletedDateUTC			=   DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), udt_CarDet.CompletedDate),

							CarDet.TargetDate				=   udt_CarDet.TargetDate,

							CarDet.ResponsiblePersonUserId	=   udt_CarDet.ResponsiblePersonUserId,

							CarDet.ResponsibilityId			=   udt_CarDet.ResponsibilityId

		FROM @pQAPCarTxnDet udt_CarDet INNER JOIN  QAPCarTxnDet CarDet  ON udt_CarDet.CarDetId	=	CarDet.CarDetId

		WHERE ISNULL(udt_CarDet.CarDetId,0)>0  AND IsDeleted =0



		INSERT INTO QAPCarTxnDet	(	CustomerId,

										FacilityId,

										ServiceId,

										CarId,

										Activity,

										StartDate,

										StartDateUTC,

										CompletedDate,

										CompletedDateUTC,

										CreatedBy,

										CreatedDate,

										CreatedDateUTC,

										ModifiedBy,

										ModifiedDate,

										ModifiedDateUTC,

										ResponsiblePersonUserId,

										TargetDate,

										ResponsibilityId

									)

							SELECT	CustomerId,

									FacilityId,

									ServiceId,

									@pCarId,

									Activity,

									StartDate,

									DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), StartDate) AS StartDateUTC,

									CompletedDate,

									DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), CompletedDate) AS CompletedDateUTC,

									@pUserId,		

									GETDATE(),		

									GETUTCDATE(),

									@pUserId,		

									GETDATE(),		

									GETUTCDATE(),

									ResponsiblePersonUserId,

									TargetDate,

									ResponsibilityId

					FROM @pQAPCarTxnDet

					WHERE	ISNULL(CarDetId,0)=0 AND IsDeleted =0

												



				--IF EXISTS (SELECT 1 FROM QAPCarHistory where CarId	=	@pCarId AND Status=@pCarStatus)

				--	BEGIN

				--		UPDATE	QAPCarHistory SET	RootCause		=	@pRootCause,

				--									Solution		=	@pSolution,

				--									Remarks			=	@pRemarks,

				--									ModifiedBy		=	@pUserId,

				--									ModifiedDate	=	GETDATE(),

				--									ModifiedDateUTC	=	GETUTCDATE()

				--		WHERE	CarId	=	@pCarId

				--				AND Status=@pCarStatus

				--	END

				--ELSE

				--	BEGIN

						INSERT INTO QAPCarHistory (	CarId

													,RootCause

													,Solution

													,Remarks

													,Status

													,CreatedBy

													,CreatedDate

													,CreatedDateUTC

													,ModifiedBy

													,ModifiedDate

													,ModifiedDateUTC

												)

										VALUES	(

													@pCarId

													,@pRootCause

													,@pSolution

													,@pRemarks

													,@pCarStatus

													,@pUserId	

													,GETDATE()

													,GETUTCDATE()

													,@pUserId	

													,GETDATE()

													,GETUTCDATE()

												)

							--END







		SELECT	CAR.CarId,

				CARNumber,

				CAR.[Timestamp],

				'' ErrorMessage,

				CAR.GuId,

				CAR.CARStatus,

				LovStatus.FieldValue	AS CARStatusValue

		FROM	QAPCarTxn AS CAR

				LEFT JOIN FMLovMst AS LovStatus ON	 CAR.CARStatus	=	LovStatus.LovId

		WHERE	CAR.CarId =	@pCarId



		END

		ELSE

			BEGIN

				SELECT	CAR.CarId,

						CARNumber,

						CAR.[Timestamp],

						'Record Modified. Please Re-Select' AS ErrorMessage,

						CAR.GuId,

						CAR.CARStatus,

						LovStatus.FieldValue	AS CARStatusValue

				FROM	QAPCarTxn AS CAR

				LEFT JOIN FMLovMst AS LovStatus ON	 CAR.CARStatus	=	LovStatus.LovId

				WHERE	CarId =@pCarId

			END

		END



			



	--IF @mTRANSCOUNT = 0

 --       BEGIN

 --           COMMIT TRANSACTION

 --       END   





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

		   throw;



END CATCH
GO
