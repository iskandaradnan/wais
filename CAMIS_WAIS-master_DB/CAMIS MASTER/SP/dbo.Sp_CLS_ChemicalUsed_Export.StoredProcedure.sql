USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ChemicalUsed_Export]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Sp_CLS_ChemicalUsed_Export]	
	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL
AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
-- Declaration	
	DECLARE @qry		NVARCHAR(MAX);	
	DECLARE @TotalRecords INT;

-- Default Values

	
SET @qry = 'SELECT  A.[KMMNo],B.FieldValue AS [Category],C.FieldValue AS [AreaOfApplication],[Properties],D.FieldValue AS [Status],[EffectiveDate] 	
		FROM [CLS_ChemicalInUseChemicals] A 		
		LEFT JOIN FMLovMst B ON A.Category = B.LovId  
		LEFT JOIN FMLovMst C ON A.AreaOfApplication = C.LovId  
		LEFT JOIN FMLovMst D ON A.Status = D.LovId  
		WHERE 1 = 1 ' 
		+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
		+ ' ORDER BY ' +  ISNULL(@strSorting,'[CLS_ChemicalInUseChemicals].ChemicalId DESC')
			
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
