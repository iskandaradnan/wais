USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_OSWRecordSheet_GetAll]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[Sp_HWMS_OSWRecordSheet_GetAll] 50, 0, 'FacilityId = 25' , 'OSWRId DESC'
CREATE procedure [dbo].[Sp_HWMS_OSWRecordSheet_GetAll]

	@PageSize		INT,
	@PageIndex		INT,
	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @countQry	NVARCHAR(MAX);
	DECLARE @qry		NVARCHAR(MAX);
	DECLARE @condition	VARCHAR(MAX);
	DECLARE @TotalRecords INT;

	SET @PageIndex	=	@PageIndex+1		/* This is for JQ grid implementation */

-- Execution
SET @countQry =	'SELECT @Total = COUNT(1) FROM ( SELECT [OSWRId], A.[CustomerId], A.[FacilityId], [OSWRSNo], [TotalPackage], B.FieldValue AS [WasteType],			F.[ConsignmentNoteNo] as ConsignmentNo, [UserAreaCode], 
		    [UserAreaName],D.FieldValue AS [Month],E.FieldValue AS[Year],[CollectionFrequency],C.FieldValue AS [CollectionType]
			FROM [HWMS_OSWRecordSheet] A
			LEFT JOIN FMLovMst B ON A.WasteType = B.LovId
			LEFT JOIN FMLovMst C ON A.CollectionType = C.LovId
			LEFT JOIN FMLovMst D ON A.Month = D.LovId
			LEFT JOIN FMLovMst E ON A.Year = E.LovId
			LEFT JOIN HWMS_ConsignmentNoteOSWCN F ON A.ConsignmentNo = F.ConsignmentOSWCNId ) A
			WHERE 1 = 1 ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END 

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

			SET @qry = 'SELECT * FROM ( SELECT	[OSWRId], A.[CustomerId], A.[FacilityId], [OSWRSNo], [TotalPackage], B.FieldValue AS [WasteType],F.[ConsignmentNoteNo] as ConsignmentNo ,[UserAreaCode], 
		    [UserAreaName],D.FieldValue AS [Month],E.FieldValue AS[Year],[CollectionFrequency],C.FieldValue AS [CollectionType], @TotalRecords AS TotalRecords
			FROM [HWMS_OSWRecordSheet] A
			LEFT JOIN FMLovMst B ON A.WasteType = B.LovId
			LEFT JOIN FMLovMst C ON A.CollectionType = C.LovId
			LEFT JOIN FMLovMst D ON A.Month = D.LovId
			LEFT JOIN FMLovMst E ON A.Year = E.LovId
			LEFT JOIN HWMS_ConsignmentNoteOSWCN F ON A.ConsignmentNo = F.ConsignmentOSWCNId ) A
			WHERE 1 = 1 ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'A.OSWRId DESC')
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
