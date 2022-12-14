USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DailyWeighingRecord_GetAll]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[Sp_HWMS_DailyWeighingRecord_GetAll] 50, 0, '([DWRNo] LIKE (''%0004%'')) AND FacilityId = 25', 'DWRId desc'
CREATE proc [dbo].[Sp_HWMS_DailyWeighingRecord_GetAll]
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
				FROM ( SELECT	A.[DWRId], A.[CustomerId], A.[FacilityId], A.[DWRNo], A.[TotalWeight], 				
				CONVERT(varchar(10), DAY(A.[Date])) + ''-'' +  UPPER(CONVERT(varchar(3), DATENAME(m, A.[Date]))) + ''-'' + DATENAME(YEAR, A.[Date])  AS [Date], 	A.[TotalBags], A.[TotalNoofBins],   B.ConsignmentNoteNo AS ConsignmentNo, A.[Status]
				FROM [HWMS_DailyWeighingRecord] A
				LEFT JOIN HWMS_ConsignmentNoteCWCN B ON A.ConsignmentNo = B.ConsignmentId ) A
				WHERE 1 = 1 ' 
				+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

SET @qry = 'SELECT * FROM ( SELECT	A.[DWRId], A.[CustomerId], A.[FacilityId], A.[DWRNo], A.[TotalWeight], 
			CONVERT(varchar(10), DAY(A.[Date])) + ''-'' +  UPPER(CONVERT(varchar(3), DATENAME(m, A.[Date]))) + ''-'' + DATENAME(YEAR, A.[Date])  AS [Date],  A.[TotalBags], A.[TotalNoofBins],  A.[HospitalRepresentative],
			  B.ConsignmentNoteNo AS ConsignmentNo, A.[Status], @TotalRecords AS TotalRecords
			FROM [HWMS_DailyWeighingRecord] A
			LEFT JOIN HWMS_ConsignmentNoteCWCN B ON A.ConsignmentNo = B.ConsignmentId ) A
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'DWRId DESC')
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
