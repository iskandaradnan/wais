USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[GetAllBlockedUsers]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAllBlockedUsers]
(
	@PageSize INT,
	@PageIndex INT,
	@StrCondition NVARCHAR(MAX) = NULL,
	@StrSorting NVARCHAR(MAX) = NULL
)
AS 

-- Exec [GetAllBlockedUsers] 10, 0, null, null
-- Exec [GetAllBlockedUsers] 10, 0, '(([UserRole] LIKE (''%Role%'')) and ([UserType] = (''Company User'')) and ([StatusValue] = (''InActive'')))', 'UserRole asc'
--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetAllBlockedUsers
--DESCRIPTION		: GET RECORDS FOR THE LIST
--AUTHORS			: BIJU NB
--DATE				: 23-March-2018
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
				('[CustomerName]','E.CustomerName'),
				('[StaffName]','A.StaffName'),
				('[UserName]','A.UserName'),
				('[UserTypeValue]','C.Name'),
				('[Email]','A.Email'),
				('[UserName]','A.UserName'),
				('[StatusValue]','D.FieldValue')

SELECT @strCondition =  replace(@strCondition,actual_column,replace_column) from #temp_columns
SELECT @strSorting =  replace(@strSorting,actual_column,replace_column) from #temp_columns

SET @countQry = 'SELECT  @Total = COUNT(1)
				FROM  UMUserRegistration A
				JOIN UMUserType C ON A.UserTypeId = C.UserTypeId
				JOIN FmLovMst D ON A.[Status] = D.LovId
				JOIN MstCustomer E ON A.CustomerId = E.CustomerId WHERE A.IsBlocked = 1 ' 
				+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT

SET @qry = 'SELECT A.UserRegistrationId, E.CustomerName, A.StaffName, 
			A.UserName, C.Name UserTypeValue, A.Email, D.FieldValue StatusValue, A.ModifiedDateUTC, 
			@TotalRecords TotalRecords
			FROM  UMUserRegistration A
			JOIN UMUserType C ON A.UserTypeId = C.UserTypeId
			JOIN FmLovMst D ON A.[Status] = D.LovId
			JOIN MstCustomer E ON A.CustomerId = E.CustomerId WHERE A.IsBlocked = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'A.ModifiedDateUTC DESC')
			+ ' OFFSET '  + CAST((@PageSize *  @PageIndex) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;

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
