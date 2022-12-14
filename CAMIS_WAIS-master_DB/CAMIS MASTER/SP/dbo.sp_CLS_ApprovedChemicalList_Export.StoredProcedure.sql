USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_ApprovedChemicalList_Export]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec [dbo].[sp_CLS_ApprovedChemicalList_Export] 'FacilityId = 25', 'DeptAreaId desc'
CREATE PROCEDURE [dbo].[sp_CLS_ApprovedChemicalList_Export]
	
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


SET @qry = 'SELECT ChemicalName, Category, AreaofApplication, KKMNumber, Properties, Status  FROM  ( 
			SELECT	[ChemicalId], [CustomerId], [FacilityId], C.FieldValue AS [Category], D.FieldValue AS [AreaofApplication],
			 [ChemicalName], [KKMNumber], [Properties], B.FieldValue AS [Status]
			FROM [CLS_ApprovedChemicalList] A
			LEFT JOIN FMLovMst B ON A.Status = B.LovId 
			LEFT JOIN FMLovMst C ON A.Category = C.LovId 
			LEFT JOIN FMLovMst D ON A.AreaofApplication = D.LovId ) A
			WHERE 1 = 1 ' + '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  + ' ORDER BY ' +  ISNULL(@strSorting,'A.ChemicalId DESC')
			
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
