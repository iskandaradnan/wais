USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_JIScheduleGeneration_GetAll]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[Sp_CLS_JIScheduleGeneration_GetAll] 5, 0, '([MonthName] LIKE ('%july%')) AND FacilityId = 25', 'JIId desc'
-- select * from CLS_JIScheduleGeneration where [Week] LIKE ('%31%')
CREATE procedure [dbo].[Sp_CLS_JIScheduleGeneration_GetAll]
			
		@PageSize		INT,
		@PageIndex		INT,
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

	SET @PageIndex	=	@PageIndex+1		/* This is for JQ grid implementation */

-- Execution


SET @countQry =	'SELECT @Total = COUNT(1)
				FROM (SELECT *, case when [Month] = 1 then ''January''  when [Month] = 2 then ''February''  when [Month] = 3 then ''March'' when [Month] = 4 then ''April'' when [Month] = 5 then ''May'' when [Month] = 6 then ''June'' when [Month] = 7 then ''July'' when [Month] = 8 then ''August''
			when [Month] = 9 then ''September'' when [Month] = 10 then ''October'' when [Month] = 11 then ''November'' when [Month] = 12 then ''December''
			end AS [MonthName] FROM [CLS_JIScheduleGeneration] ) A WHERE 1 = 1  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END 

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

SET @qry = 'SELECT * FROM ( SELECT	[JIId], [Year], [Month] , 
			case when [Month] = 1 then ''January''  when [Month] = 2 then ''February''  when [Month] = 3 then ''March'' when [Month] = 4 then ''April''
			when [Month] = 5 then ''May'' when [Month] = 6 then ''June'' when [Month] = 7 then ''July'' when [Month] = 8 then ''August''
			when [Month] = 9 then ''September'' when [Month] = 10 then ''October'' when [Month] = 11 then ''November'' when [Month] = 12 then ''December''
			end AS [MonthName],[Week], FacilityId, @TotalRecords AS TotalRecords
			FROM [CLS_JIScheduleGeneration] ) A 
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'A.JIId DESC')
			+ ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;
print @qry;

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
