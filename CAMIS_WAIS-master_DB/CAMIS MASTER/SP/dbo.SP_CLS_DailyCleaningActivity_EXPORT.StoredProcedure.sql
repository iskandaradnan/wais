USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_DailyCleaningActivity_EXPORT]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_CLS_DailyCleaningActivity_EXPORT]
       
		@StrCondition	NVARCHAR(MAX) = NULL,
		@StrSorting		NVARCHAR(MAX) = NULL

AS 
BEGIN TRY


	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	DECLARE @countQry	NVARCHAR(MAX);
	DECLARE @qry		NVARCHAR(MAX);
	DECLARE @condition	VARCHAR(MAX);
	DECLARE @TotalRecords INT;



SET @qry = 'SELECT DocumentNo,  [Date],   [TotalDone], [TotalNotDone] FROM ( 
			SELECT 	[DailyActivityId], [CustomerId], [FacilityId], [DocumentNo],  CONVERT(varchar(10), DAY([Date])) + ''-'' +  UPPER(CONVERT(varchar(3), DATENAME(m, [Date]))) + ''-'' + DATENAME(YEAR, [Date])  AS [Date],
            [TotalDone], [TotalNotDone] FROM [CLS_DailyCleaningActivity] ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'DailyActivityId DESC')
			
print @qry;
EXECUTE sp_executesql @qry

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
