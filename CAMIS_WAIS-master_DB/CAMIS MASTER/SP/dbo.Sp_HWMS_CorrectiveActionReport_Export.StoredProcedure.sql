USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CorrectiveActionReport_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec [dbo].[Sp_HWMS_CorrectiveActionReport_Export] 
CREATE PROCEDURE [dbo].[Sp_HWMS_CorrectiveActionReport_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @qry NVARCHAR(MAX);
	
	
	SET @qry = 'SELECT [CARNo], [CARDate], [Status],[Assignee]  FROM ( SELECT	[CARId], [CustomerId], [FacilityId], [CARGeneration],[CARNo], CONVERT(varchar(10), DAY([CARDate])) + ''-'' +  UPPER(CONVERT(varchar(3), DATENAME(m, [CARDate]))) + ''-'' + DATENAME(YEAR, [CARDate])  AS [CARDate],
            B.FieldValue AS [Status],[Assignee]
			FROM [HWMS_CorrectiveActionReport] A			
			LEFT JOIN FMLovMst B ON A.Status = B.LovId  ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'A.CARId DESC')
			
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
