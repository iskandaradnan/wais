USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTrainingScheduleTxn_Export]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngTrainingScheduleTxn_Export
Description			: Get User Training Details
Authors				: Dhilip V
Date				: 07-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngTrainingScheduleTxn_Export  @StrCondition='Year=''2018''',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngTrainingScheduleTxn_Export]

	@StrCondition	NVARCHAR(MAX)		=	NULL,
	@StrSorting		NVARCHAR(MAX)		=	NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


-- Declaration
	DECLARE @countQry	NVARCHAR(MAX);
	DECLARE @qry		NVARCHAR(MAX);
	DECLARE @condition	VARCHAR(MAX);
	DECLARE @TotalRecords INT;

-- Default Values


-- Execution

SET @qry = 'SELECT	
					
					[TrainingType],
					FORMAT(PlannedDate,''dd-MMM-yyyy'') AS PlannedDate,
					[Year],
					[QuarterVal],
					[TrainingScheduleNo] AS [TrainingScheduleNo.],
					[TrainingDescription],
					[TrainingModule],
					[MinimumNoOfParticipants] AS [MinimumNo.OfParticipants],
				    FORMAT(ActualDate,''dd-MMM-yyyy'') AS ActualDate,
					[Status]		AS	[TrainingStatus],
					[TrainerSource],
					[Presenter(Trainer)],
					[YearsOfExperience],
					[Designation],
					[TotalNo.OfParticipants],
					[Venue],
					[TrainingRescheduleDate],
					[OverallEffectiveness(%)],
					[Remarks]
			FROM	[V_EngTrainingScheduleTxn_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngTrainingScheduleTxn_Export].ModifiedDateUTC DESC')

PRINT @qry;

EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	
END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
