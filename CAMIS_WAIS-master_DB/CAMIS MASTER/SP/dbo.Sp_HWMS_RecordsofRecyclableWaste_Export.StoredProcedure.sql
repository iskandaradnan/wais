USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_RecordsofRecyclableWaste_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- exec [dbo].[Sp_HWMS_RecordsofRecyclableWaste_Export]  'RecordsofRecyclableWasteId desc' 
CREATE PROCEDURE [dbo].[Sp_HWMS_RecordsofRecyclableWaste_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
-- Declaration
	
	DECLARE @qry		NVARCHAR(MAX);


SET @qry = 'SELECT [RRWNo],[DateTime], [TotalWeight], [MethodofDisposal],[VendorName], [TotalAmount], [WasteType],[WasteCode]  FROM ( 
			SELECT	[RecyclableId], [CustomerId], [FacilityId], [RRWNo], CONVERT(varchar(10), DAY([DateTime])) + ''-'' +  UPPER(CONVERT(varchar(3), DATENAME(m, [DateTime]))) + ''-'' + DATENAME(YEAR, [DateTime])  AS [DateTime],
            [TotalWeight],B.FieldValue AS [MethodofDisposal],[VendorName], 
		    [TotalAmount],C.FieldValue AS [WasteType],[WasteCode]
			FROM [HWMS_RecordsofRecyclableWaste_Save] A
			LEFT JOIN FMLovMst B ON A.MethodofDisposal = B.LovId 
			LEFT JOIN FMLovMst C ON A.WasteType = C.LovId ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'A.RecyclableId DESC')
			

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
