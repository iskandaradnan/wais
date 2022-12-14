USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstQAPQualityCause_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstQAPQualityCause_Save
Description			: QAPIndicator Insert/update
Authors				: Dhilip V
Date				: 30-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @MstQAPQualityCauseDet [dbo].[udt_MstQAPQualityCauseDet]
INSERT INTO @MstQAPQualityCauseDet ([QualityCauseDetId],[QualityCauseId],[ProblemCode],[QcCode],[Details],[Status]) VALUES 
(0,1,171,'QC01','QC01 Desc1',1)
EXEC [uspFM_MstQAPQualityCause_Save] @MstQAPQualityCauseDet=@MstQAPQualityCauseDet,@pQualityCauseId=0,@pServiceId=2,@pCauseCode='C01',
@pDescription='C01 Desc',@pUserId=1,@pTimestamp=null
SELECT * FROM MstQAPQualityCause
SELECT * FROM MstQAPQualityCauseDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstQAPQualityCause_Save]
	@MstQAPQualityCauseDet		[dbo].[udt_MstQAPQualityCauseDet]	READONLY,
	@pQualityCauseId			INT,
	@pServiceId					INT,
	@pCauseCode					NVARCHAR(25),
	@pDescription				NVARCHAR(250),
	@pUserId					INT,
	@pTimestamp					VARBINARY(200)		=	NULL
				
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @mQcCode NVARCHAR(25)

-- Default Values

-- Execution


	IF EXISTS(	SELECT 1 FROM @MstQAPQualityCauseDet  WHERE  QcCode =@pCauseCode)
				
	BEGIN
		SELECT 0 AS QualityCauseId,
		CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
		'Failure Symptom Code and Failure Root Cause Code should be unique' AS ErrorMessage
	END

	ELSE
	BEGIN

IF EXISTS (SELECT  1 FROM @MstQAPQualityCauseDet group by QcCode having count(QcCode)>1 )
	BEGIN
	SELECT 0 AS QualityCauseId,
	CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
	'Failure Root Cause Code should be unique' AS ErrorMessage
	END

	ELSE
	BEGIN

	  IF(ISNULL(@pQualityCauseId,0)= 0 OR @pQualityCauseId='')
	  BEGIN

	IF EXISTS(SELECT 1 FROM MstQAPQualityCause WHERE CauseCode = @pCauseCode) 
	BEGIN
	SELECT 0 AS QualityCauseId,
	CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
	'Failure Symptom Code should be unique' AS ErrorMessage
	END
	
	IF EXISTS (SELECT 1 FROM MstQAPQualityCauseDet A INNER JOIN @MstQAPQualityCauseDet B ON A.QcCode = B.QcCode GROUP BY B.QcCode HAVING COUNT(B.QcCode)>1)
	BEGIN
	SELECT 0 AS QualityCauseId,
	CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
	'Failure Root Cause Code should be unique' AS ErrorMessage
	END

	ELSE

	BEGIN

	          INSERT INTO MstQAPQualityCause (	ServiceId,
												CauseCode,
												Description,
												CreatedBy,
												CreatedDate,
												CreatedDateUTC,
												ModifiedBy,
												ModifiedDate,
												ModifiedDateUTC									                                                                                                           
											)OUTPUT INSERTED.QualityCauseId INTO @Table
			  VALUES						(	@pServiceId,
												@pCauseCode,
												@pDescription,
												@pUserId,
												GETDATE(),
												GETUTCDATE(),
												@pUserId,
												GETDATE(),
												GETUTCDATE()							
											)


			DECLARE @mPrimaryId INT;
			SELECT @mPrimaryId	=	QualityCauseId from MstQAPQualityCause WHERE	QualityCauseId IN (SELECT ID FROM @Table)

	        INSERT INTO MstQAPQualityCauseDet(	QualityCauseId,
												ProblemCode,
												QcCode,
												Details,
												Status,
												CreatedBy,
												CreatedDate,
												CreatedDateUTC,
												ModifiedBy,
												ModifiedDate,
												ModifiedDateUTC									                                                                                                           
											)OUTPUT INSERTED.QualityCauseId INTO @Table
									SELECT	@mPrimaryId,
											ProblemCode,
											QcCode,
											Details,
											Status,
											@pUserId,
											GETDATE(),
											GETUTCDATE(),
											@pUserId,
											GETDATE(),
											GETUTCDATE()
									FROM	@MstQAPQualityCauseDet
									WHERE	ISNULL(QualityCauseDetId,0)= 0



			   	   SELECT				QualityCauseId,
										[Timestamp],
										'' AS ErrorMessage
				   FROM					MstQAPQualityCause
				   WHERE				QualityCauseId IN (SELECT ID FROM @Table)
	
		END
	END
  ELSE
	  BEGIN

			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp FROM	MstQAPQualityCause 
			WHERE	QualityCauseId	=	@pQualityCauseId




	IF EXISTS (SELECT  1 FROM @MstQAPQualityCauseDet group by QcCode having count(QcCode)>1 )
	BEGIN
		SELECT 0 AS QualityCauseId,
		CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
		'Failure Root Cause Code should be unique' AS ErrorMessage
		END

	ELSE

	BEGIN

	IF (@mTimestamp= @pTimestamp)
			BEGIN

				UPDATE MstQAPQualityCause SET	ServiceId			=	@pServiceId,
												CauseCode			=	@pCauseCode,
												Description			=	@pDescription,
												ModifiedBy			=	@pUserId,
												ModifiedDate		=	GETDATE(),
												ModifiedDateUTC		=	GETUTCDATE()
												OUTPUT INSERTED.QualityCauseId INTO @Table
				WHERE QualityCauseId =   @pQualityCauseId

				UPDATE QAPQCDet SET	QAPQCDet.QualityCauseId		=	udtQAPQCDet.QualityCauseId,
									QAPQCDet.ProblemCode		=	udtQAPQCDet.ProblemCode,
									QAPQCDet.QcCode				=	udtQAPQCDet.QcCode,
									QAPQCDet.Details			=	udtQAPQCDet.Details,
									QAPQCDet.Status				=	udtQAPQCDet.Status,
									QAPQCDet.ModifiedBy			=	@pUserId,
									QAPQCDet.ModifiedDate		=	GETDATE(),
									QAPQCDet.ModifiedDateUTC	=	GETUTCDATE()
									OUTPUT INSERTED.QualityCauseId INTO @Table
				FROM	MstQAPQualityCauseDet		AS	QAPQCDet
						INNER JOIN @MstQAPQualityCauseDet	AS	udtQAPQCDet	ON	QAPQCDet.QualityCauseDetId	=	udtQAPQCDet.QualityCauseDetId
				WHERE	ISNULL(udtQAPQCDet.QualityCauseDetId,0)> 0

					        INSERT INTO MstQAPQualityCauseDet(	QualityCauseId,
												ProblemCode,
												QcCode,
												Details,
												Status,
												CreatedBy,
												CreatedDate,
												CreatedDateUTC,
												ModifiedBy,
												ModifiedDate,
												ModifiedDateUTC									                                                                                                           
											)OUTPUT INSERTED.QualityCauseId INTO @Table
									SELECT	@pQualityCauseId,
											ProblemCode,
											QcCode,
											Details,
											Status,
											@pUserId,
											GETDATE(),
											GETUTCDATE(),
											@pUserId,
											GETDATE(),
											GETUTCDATE()
									FROM	@MstQAPQualityCauseDet
									WHERE	ISNULL(QualityCauseDetId,0)= 0

			   	SELECT	QualityCauseId,
						[Timestamp],
						'' ErrorMessage
				FROM	MstQAPQualityCause
				WHERE	QualityCauseId IN (SELECT ID FROM @Table)

	END
	ELSE
		BEGIN
				SELECT	QualityCauseId,
						[Timestamp],
						'Record Modified. Please Re-Select' ErrorMessage
				FROM	MstQAPQualityCause
				WHERE	QualityCauseId = @pQualityCauseId
		END
	END
	END

	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   

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
GO
