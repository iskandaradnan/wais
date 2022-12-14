USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_CollectionCategory_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[sp_HWMS_CollectionCategory_Export] '','RouteCollectionId desc'
CREATE procedure [dbo].[sp_HWMS_CollectionCategory_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @qry NVARCHAR(MAX);

SET @qry = 'SELECT [RouteCode], [RouteDescription], [RouteCategory], [Status]  FROM ( 
			SELECT	[FacilityId], [RouteCollectionId], [RouteCode], [RouteDescription], [RouteCategory], B.FieldValue AS [Status] 
			FROM [HWMS_RouteCollectionCategory] A
			LEFT JOIN FMLovMst B ON A.Status = B.LovId ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'A.RouteCollectionId DESC')
			
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
