USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CWRecordSheet_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec [dbo].[Sp_HWMS_CWRecordSheet_Export] 25, 0, '' 
CREATE PROCEDURE [dbo].[Sp_HWMS_CWRecordSheet_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @qry NVARCHAR(MAX);


SET @qry = 'SELECT [Date], [TotalUserArea], [TotalBagCollected], [TotalSanitized] FROM ( 
			SELECT	[CWRecordSheetId], [CustomerId], [FacilityId],CONVERT(varchar(10), DAY([Date])) + ''-'' +  UPPER(CONVERT(varchar(3), DATENAME(m, [Date]))) + ''-'' + DATENAME(YEAR, [Date])  AS [Date], [TotalUserArea], [TotalBagCollected], [TotalSanitized]
			FROM [HWMS_CWRecordSheet_Save] ) A			
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'CWRecordSheetId DESC')
			

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
