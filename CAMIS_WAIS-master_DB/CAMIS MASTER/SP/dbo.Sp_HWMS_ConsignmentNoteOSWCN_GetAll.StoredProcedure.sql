USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_ConsignmentNoteOSWCN_GetAll]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- exec [dbo].[Sp_HWMS_ConsignmentNoteOSWCN_GetAll] 5, 0, 'FacilityId = 25' , 'ConsignmentOSWCNId DESC'
CREATE procedure [dbo].[Sp_HWMS_ConsignmentNoteOSWCN_GetAll]

	@PageSize		INT,
	@PageIndex		INT,
	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @countQry	NVARCHAR(MAX);
	DECLARE @qry		NVARCHAR(MAX);
	DECLARE @condition	VARCHAR(MAX);
	DECLARE @TotalRecords INT;

	SET @PageIndex	=	@PageIndex+1		/* This is for JQ grid implementation */

-- Execution
SET @countQry =	'SELECT @Total = COUNT(1) FROM ( SELECT	[ConsignmentOSWCNId],[CustomerId], [FacilityId], [ConsignmentNoteNo],CONVERT(varchar(10), DAY([DateTime])) + ''-'' +  UPPER(CONVERT(varchar(3), DATENAME(m, [DateTime]))) + ''-'' + DATENAME(YEAR, [DateTime])  AS [DateTime],
           [TotalEst],[TotalNoofPackaging],[TreatmentPlant],[VehicleNo] ,[DriverName], B.FieldValue AS[Wastetype]
			FROM [HWMS_ConsignmentNoteOSWCN] A
           LEFT JOIN FMLovMst B ON A.Wastetype = B.LovId ) A

			WHERE 1 = 1 ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
				

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

SET @qry = 'SELECT	[ConsignmentOSWCNId], [CustomerId], [FacilityId], [ConsignmentNoteNo],CONVERT(varchar(10), DAY([DateTime])) + ''-'' +  UPPER(CONVERT(varchar(3), DATENAME(m, [DateTime]))) + ''-'' + DATENAME(YEAR, [DateTime])  AS [DateTime],
           [TotalEst],[TotalNoofPackaging],[TreatmentPlant],[VehicleNo] ,[DriverName], B.FieldValue AS[Wastetype], @TotalRecords AS TotalRecords
			FROM [HWMS_ConsignmentNoteOSWCN] A
           LEFT JOIN FMLovMst B ON A.Wastetype = B.LovId 

			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[HWMS_ConsignmentNoteOSWCN].ConsignmentOSWCNId DESC')
			+ ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;
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
