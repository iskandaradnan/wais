USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstLocationUserLocation_GetAll]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UspFM_MstLocationUserLocation_GetAll]
(
	@PageSize INT,
	@PageIndex INT,
	@StrCondition NVARCHAR(MAX) = NULL,
	@StrSorting NVARCHAR(MAX) = NULL
)
AS 


--EXEC [UspFM_MstLocationUserLocation_GetAll] 10,1,'facilityId=''1''',NULL
--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetAllUserRole
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



--				INSERT INTO #temp_columns(actual_column,replace_column) values	
--				('[StatusValue]','A.Active')
--				,('FacilityId','a.FacilityId')
--				,('[UserAreaCode]','b.UserAreaName')
			

--SELECT @strCondition =  replace(@strCondition,actual_column,replace_column) from #temp_columns
--SELECT @strSorting =  replace(@strSorting,actual_column,replace_column) from #temp_columns

SET @countQry = 'SELECT @Total = COUNT(1) from
				V_MstLocationUserLocation			
				WHERE 1 = 1 ' 
				+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

SET @qry = 'select 
			UserLocationId,
			UserLocationCode,
			UserLocationName,
			(case when [StatusValue]=1 then ''Active''  else ''Inactive'' end) [StatusValue] ,
			UserAreaCode,
			UserAreaName,
			BlockId,
			BlockName,
			LevelId,
			LevelName,
			@TotalRecords TotalRecords,
			ModifiedDateUTC,
			FacilityId
  from V_MstLocationUserLocation 
	  WHERE 1 = 1 
 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'V_MstLocationUserLocation.ModifiedDateUTC DESC')
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
