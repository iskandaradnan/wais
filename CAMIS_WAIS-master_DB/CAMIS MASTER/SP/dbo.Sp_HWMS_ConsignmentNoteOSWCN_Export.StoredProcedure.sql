USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_ConsignmentNoteOSWCN_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[Sp_HWMS_ConsignmentNoteOSWCN_Export] 5, 0, 'FacilityId = 25' , 'ConsignmentOSWCNId DESC'
CREATE procedure [dbo].[Sp_HWMS_ConsignmentNoteOSWCN_Export]
	
	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	
	DECLARE @qry		NVARCHAR(MAX);
	

SET @qry = 'SELECT	[ConsignmentNoteNo], [DateTime], [TotalEst],[TotalNoofPackaging],[TreatmentPlant],[VehicleNo] ,[DriverName], [Wastetype] FROM ( 
			SELECT [ConsignmentOSWCNId], [CustomerId], [FacilityId], [ConsignmentNoteNo],CONVERT(varchar(10), DAY([DateTime])) + ''-'' +  UPPER(CONVERT(varchar(3), DATENAME(m, [DateTime]))) + ''-'' + DATENAME(YEAR, [DateTime])  AS [DateTime],
           [TotalEst],[TotalNoofPackaging],[TreatmentPlant],[VehicleNo] ,[DriverName], B.FieldValue AS[Wastetype]
			FROM [HWMS_ConsignmentNoteOSWCN] A
           LEFT JOIN FMLovMst B ON A.Wastetype = B.LovId ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'ConsignmentOSWCNId DESC')
			
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
