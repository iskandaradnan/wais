USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_LicenseType_GetAll]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_HWMS_LicenseType_GetAll]

-- EXEC [dbo].[sp_HWMS_LicenseType_GetAll] 100,0, 'FacilityId = 25', 'LicenseTypeId desc'
-- SELECT * FROM HWMS_LicenseTypeSave
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


SET @countQry =	'SELECT @Total = COUNT(1) FROM
				 ( SELECT  [FacilityId], [LicenseTypeId], B.FieldValue AS [LicenseOfType]  , D.FieldValue AS [WasteCategory], C.FieldValue AS [WasteType]
						FROM [HWMS_LicenseType] A
						LEFT JOIN FMLovMst B ON A.LicenseType = B.LovId 
						LEFT JOIN FMLovMst C ON A.WasteType = C.LovId 
						LEFT JOIN FMLovMst D ON A.WasteCategory = D.LovId ) A 				
				WHERE 1 = 1 ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

SET @qry = ' SELECT * FROM ( SELECT	 [FacilityId], [LicenseTypeId], B.FieldValue AS [LicenseOfType]  , D.FieldValue AS [WasteCategory], C.FieldValue AS [WasteType], 
			 @TotalRecords AS TotalRecords FROM [HWMS_LicenseType] A
						LEFT JOIN FMLovMst B ON A.LicenseType = B.LovId 
						LEFT JOIN FMLovMst C ON A.WasteType = C.LovId 
						LEFT JOIN FMLovMst D ON A.WasteCategory = D.LovId ) A
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'LicenseTypeId DESC')
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
