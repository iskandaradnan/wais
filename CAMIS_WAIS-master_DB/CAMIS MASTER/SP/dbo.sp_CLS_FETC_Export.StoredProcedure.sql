USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_FETC_Export]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC  [dbo].[sp_CLS_FETC_Export] 'FacilityId = 25'
CREATE PROCEDURE [dbo].[sp_CLS_FETC_Export]

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



SET @qry = 'SELECT [ItemCode], [ItemDescription],ItemType, Status FROM ( 
			SELECT	[FETCId], [CustomerId], [FacilityId], [ItemCode], [ItemDescription], C.FieldValue AS [ItemType], 
		    B.FieldValue AS [Status]
			FROM [CLS_FETC] A
			LEFT JOIN FMLovMst B ON A.Status = B.LovId 
			LEFT JOIN FMLovMst C ON A.ItemType = C.LovId ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'A.FETCId DESC')
			
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
