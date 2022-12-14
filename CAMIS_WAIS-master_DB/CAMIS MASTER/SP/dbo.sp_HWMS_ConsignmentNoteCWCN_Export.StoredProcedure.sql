USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_ConsignmentNoteCWCN_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[sp_HWMS_ConsignmentNoteCWCN_Export] 'FacilityId = 25' , 'ConsignmentId DESC'
CREATE procedure [dbo].[sp_HWMS_ConsignmentNoteCWCN_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @qry		NVARCHAR(MAX);
	

SET @qry = 'SELECT [ConsignmentNoteNo], [DateTime], [QC], [TreatmentPlantName] AS TreatmentPlant , [DriverCode], [DriverName],  [TotalNoOfBins] ,[TotalEst]  FROM (
			SELECT	[ConsignmentId], [CustomerId], [FacilityId], [ConsignmentNoteNo],CONVERT(varchar(10), DAY([DateTime])) + ''-'' +  UPPER(CONVERT(varchar(3), DATENAME(m, [DateTime]))) + ''-'' + DATENAME(YEAR, [DateTime])  AS [DateTime],  B.FieldValue AS [QC],
            [TreatmentPlantName] ,[DriverCode], [DriverName],  [TotalNoOfBins] ,[TotalEst] 
			FROM [HWMS_ConsignmentNoteCWCN] A
			LEFT JOIN FMLovMst B ON A.QC = B.LovId ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'A.ConsignmentId DESC')
			
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
