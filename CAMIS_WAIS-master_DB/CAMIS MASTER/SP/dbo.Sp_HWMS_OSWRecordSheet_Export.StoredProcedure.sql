USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_OSWRecordSheet_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[Sp_HWMS_OSWRecordSheet_Export] 'FacilityId = 25' , 'OSWRId DESC'
CREATE procedure [dbo].[Sp_HWMS_OSWRecordSheet_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	
	DECLARE @qry		NVARCHAR(MAX);


	SET @qry = 'SELECT  [OSWRSNo], [TotalPackage], [WasteType], ConsignmentNo ,[UserAreaCode], [UserAreaName], [Month], [Year], [CollectionFrequency], [CollectionType]  FROM ( 
			SELECT	[OSWRId], A.[CustomerId], A.[FacilityId], [OSWRSNo], [TotalPackage], B.FieldValue AS [WasteType],F.[ConsignmentNoteNo] as ConsignmentNo ,[UserAreaCode], [UserAreaName],D.FieldValue AS [Month],E.FieldValue AS [Year],[CollectionFrequency],C.FieldValue AS [CollectionType]
			FROM [HWMS_OSWRecordSheet] A
			LEFT JOIN FMLovMst B ON A.WasteType = B.LovId
			LEFT JOIN FMLovMst C ON A.CollectionType = C.LovId
			LEFT JOIN FMLovMst D ON A.Month = D.LovId
			LEFT JOIN FMLovMst E ON A.Year = E.LovId
			LEFT JOIN HWMS_ConsignmentNoteOSWCN F ON A.ConsignmentNo = F.ConsignmentOSWCNId ) A
			WHERE 1 = 1 ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'A.OSWRId DESC')
			

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
