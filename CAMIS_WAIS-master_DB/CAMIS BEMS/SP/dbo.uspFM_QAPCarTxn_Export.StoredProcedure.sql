USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QAPCarTxn_Export]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_QAPCarTxn_Export
Description			: To export the QAPCar details
Authors				: Dhilip V
Date				: 19-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_QAPCarTxn_Export  @StrCondition='([Assignee] LIKE ''%NewCompanyUser2%'')',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_QAPCarTxn_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

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


SET @qry = 'SELECT	 CARNumber  AS CARNo
					,FORMAT(CARDate,''dd-MMM-yyyy'') AS CARDate
					,IndicatorCode AS Indicator
					,FORMAT(FromDate,''dd-MMM-yyyy'') AS CARPeriodFrom
					,FORMAT(ToDate,''dd-MMM-yyyy'')	  AS CARPeriodTo
					,FollowupCAR   AS [Follow-up CAR]
					,StaffName     AS [Assignee]
					,ProblemStatement
					,RootCause
					,Solution
					,Priority
					,StatusValue   AS Status
					,Issuer
					,FORMAT(CARTargetDate,''dd-MMM-yyyy'') AS CARTargetDate
					,FORMAT(VerifiedDate,''dd-MMM-yyyy'') AS VerifiedDate
					,VerifiedBy
					,Remarks
					,Activity
					,FORMAT(StartDate,''dd-MMM-yyyy'') AS StartDate
					,FORMAT(TargetDate,''dd-MMM-yyyy'') AS  TargetDate
					,FORMAT(CompletedDate,''dd-MMM-yyyy'') AS [ActualCompletionDate]
					,Responsibility
					,ResponsiblePerson
					,CARStatusValue AS CARStatus,
					WorkOrderNo  as WorkOrderNo,
					Assignee as AssigneeName,
					QcCode  as [FailureSymptomCode]
			FROM [V_QAPCarTxn_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_QAPCarTxn_Export].ModifiedDateUTC DESC')

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
