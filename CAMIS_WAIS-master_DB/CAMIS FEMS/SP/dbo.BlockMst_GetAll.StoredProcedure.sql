USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[BlockMst_GetAll]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[BlockMst_GetAll]
(
	@PageSize INT		=	5,
	@PageIndex INT		=	0,
	@StrCondition NVARCHAR(MAX) = NULL,
	@StrSorting NVARCHAR(MAX) = NULL
)
AS 

-- Exec [BlockMst_GetAll] 10, 0, null, null
--EXEC BlockMst_GetAll  @StrCondition='Active=''1''',@StrSorting=null,@PageSize=5,@PageIndex=0
--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetAllBlock
--DESCRIPTION		: GET RECORDS FOR THE LIST
--AUTHORS			: BIJU NB
--DATE				: 19-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 19-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

DECLARE @countQry NVARCHAR(MAX);
DECLARE @qry NVARCHAR(MAX);
DECLARE @condition VARCHAR(MAX);
DECLARE @TotalRecords INT;

Create TABLE #temp_columns (actual_column varchar(500),replace_column varchar(500))

INSERT INTO #temp_columns(actual_column,replace_column) values	
				('[BlockName]','A.BlockName'),
				('Active','A.Active')

SELECT @strCondition =  replace(@strCondition,actual_column,replace_column) from #temp_columns
SELECT @strSorting =  replace(@strSorting,actual_column,replace_column) from #temp_columns

SET @countQry = 'SELECT @Total = COUNT(1)
			FROM MstLocationBlock A
			JOIN MstLocationFacility B ON A.FacilityId = B.FacilityId 
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

SET @qry = 'SELECT BlockId,
			B.FacilityName FacilityName,
			A.BlockName BlockName,
			A.ShortName ShortName,
			A.BlockCode BlockCode,
			A.Active Active,
			A.ModifiedDateUTC,
			@TotalRecords TotalRecords
			FROM MstLocationBlock A
			JOIN MstLocationFacility B ON A.FacilityId = B.FacilityId 
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'A.ModifiedDateUTC DESC')
			+ ' OFFSET '  + CAST((@PageSize *  @PageIndex) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;
print @qry;
EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
