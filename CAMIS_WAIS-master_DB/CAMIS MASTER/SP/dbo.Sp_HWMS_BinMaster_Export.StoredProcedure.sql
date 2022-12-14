USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_BinMaster_Export]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[Sp_HWMS_BinMaster_Export]	
CREATE proc [dbo].[Sp_HWMS_BinMaster_Export]	
	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @qry		NVARCHAR(MAX);
	
SET @qry = 'SELECT [CapacityCode], [Description], [WasteType], [NoofBins] FROM (
			 SELECT	[BinMasterId],[CustomerId], [FacilityId],B.FieldValue AS [CapacityCode], [Description]
			,C.FieldValue AS [WasteType], [NoofBins]
			FROM [HWMS_BinMaster] A
			LEFT JOIN FMLovMst B ON A.CapacityCode = B.LovId
			LEFT JOIN FMLovMst C ON A.WasteType =C.LovId ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'BinMasterId DESC')
			
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
