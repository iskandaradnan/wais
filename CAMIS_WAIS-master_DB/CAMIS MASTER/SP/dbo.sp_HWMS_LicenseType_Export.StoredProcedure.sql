USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_LicenseType_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC [dbo].[sp_HWMS_LicenseType_Export]  'FacilityId = 25', 'LicenseTypeId desc'
CREATE PROCEDURE [dbo].[sp_HWMS_LicenseType_Export]
	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @qry		NVARCHAR(MAX);


SET @qry = 'SELECT [LicenseOfType], [WasteCategory],[WasteType] FROM (
			SELECT	 [FacilityId], [LicenseTypeId], B.FieldValue AS [LicenseOfType]  , D.FieldValue AS [WasteCategory], C.FieldValue AS [WasteType] 
			FROM [HWMS_LicenseType] A
			LEFT JOIN FMLovMst B ON A.LicenseType = B.LovId 
			LEFT JOIN FMLovMst C ON A.WasteType = C.LovId 
			LEFT JOIN FMLovMst D ON A.WasteCategory = D.LovId ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'LicenseTypeId DESC')
			
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
