USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_CSWRecordSheet_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [dbo].[sp_HWMS_CSWRecordSheet_Export] 'FacilityId = 25' , 'CSWRecordSheetId DESC'
CREATE procedure [dbo].[sp_HWMS_CSWRecordSheet_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	
	
	DECLARE @qry		NVARCHAR(MAX);
	

SET @qry = 'SELECT [DocumentNo], [RRWNo], [WasteType],[WasteCode],[UserAreaCode], [UserAreaName], [Month], [Year], [CollectionType] FROM ( 
			SELECT	[CSWRecordSheetId], [CustomerId], [FacilityId], [DocumentNo], [RRWNo], B.FieldValue AS [WasteType],[WasteCode],[UserAreaCode], 
		    [UserAreaName],D.FieldValue AS [Month],E.FieldValue AS [Year],C.FieldValue AS [CollectionType]
			FROM [HWMS_CSWRecordSheet] A
			LEFT JOIN FMLovMst B ON A.WasteType = B.LovId
			LEFT JOIN FMLovMst C ON A.CollectionType = C.LovId
			LEFT JOIN FMLovMst D ON A.Month = D.LovId
			LEFT JOIN FMLovMst E ON A.Year = E.LovId ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'A.CSWRecordSheetId DESC')
			

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
