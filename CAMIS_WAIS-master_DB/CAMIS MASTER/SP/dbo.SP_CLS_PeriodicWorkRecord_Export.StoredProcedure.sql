USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_PeriodicWorkRecord_Export]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[SP_CLS_PeriodicWorkRecord_Export]

		@StrCondition	NVARCHAR(MAX) = NULL,
		@StrSorting		NVARCHAR(MAX) = NULL

AS 
BEGIN TRY

-- Paramter Validation 
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	DECLARE @qry		NVARCHAR(MAX);




SET @qry = 'SELECT [DocumentNo], [Year],[Month] FROM ( 
			SELECT	[PeriodicId], [CustomerId], [FacilityId], [DocumentNo], B.FieldValue AS  [Year], 
			C.FieldValue AS [Month]			
			FROM [CLS_PeriodicWorkRecord] A
			LEFT JOIN FMLovMst B ON A.Year = B.LovId
			LEFT JOIN FMLovMst C ON A.Month = C.LovId ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'PeriodicId DESC')
			
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
