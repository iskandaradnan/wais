USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_QualityCauseMaster_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec sp_HWMS_QualityCauseMaster_Export 'FacilityId = 25' , 'QualityCauseMasterId desc'
CREATE PROCEDURE [dbo].[sp_HWMS_QualityCauseMaster_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
		
	DECLARE @qry NVARCHAR(MAX);
	

SET @qry = 'SELECT	 [FailureSymptomCode]  , [Description]
			FROM [HWMS_QualityCauseMasterTxn] A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'A.QualityCauseMasterId DESC')
			
print @qry;
EXECUTE sp_executesql @qry
	
END TRY

BEGIN CATCH

INSERT INTO ErrorLog(Spname, ErrorMessage, createddate)
	VALUES( OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),getdate()  )

END CATCH
GO
