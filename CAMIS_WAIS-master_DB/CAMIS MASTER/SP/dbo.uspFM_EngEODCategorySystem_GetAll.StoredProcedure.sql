USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODCategorySystem_GetAll]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODCategorySystem_GetAll
Description			: Get all EOD CategorySystem
Authors				: Dhilip V
Date				: 11-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngEODCategorySystem_GetAll  @PageSize=10,@PageIndex=0,@StrCondition='CategorySystemName=''MRI''',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngEODCategorySystem_GetAll]
(
	@PageSize INT,
	@PageIndex INT,
	@StrCondition NVARCHAR(MAX) = NULL,
	@StrSorting NVARCHAR(MAX) = NULL
)
AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


--Create TABLE #temp_columns (actual_column varchar(500),replace_column varchar(500))

--INSERT INTO #temp_columns(actual_column,replace_column) values	
--				('[UserRole]','A.Name'),
--				('[UserType]','B.Name'),
--				('[StatusValue]','C.FieldValue')

--SELECT @strCondition =  replace(@strCondition,actual_column,replace_column) from #temp_columns
--SELECT @strSorting =  replace(@strSorting,actual_column,replace_column) from #temp_columns

-- Declaration
	DECLARE @countQry	NVARCHAR(MAX);
	DECLARE @qry		NVARCHAR(MAX);
	DECLARE @condition	VARCHAR(MAX);
	DECLARE @TotalRecords INT;

-- Default Values

	SET @PageIndex	=	@PageIndex+1		/* This is for JQ grid implementation */

-- Execution


SET @countQry =	'SELECT @Total = COUNT(1)
				FROM [V_EngEODCategorySystem]
				WHERE 1 = 1 ' 
				+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

SET @qry = 'SELECT	CategorySystemId,
					ServiceName,
					CategorySystemName,
					@TotalRecords AS TotalRecords
			FROM [V_EngEODCategorySystem]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngEODCategorySystem].ModifiedDateUTC DESC')
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
