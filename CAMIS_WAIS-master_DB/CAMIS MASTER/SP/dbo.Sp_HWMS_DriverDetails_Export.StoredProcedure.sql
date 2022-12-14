USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DriverDetails_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec [dbo].[Sp_HWMS_DriverDetails_Export] 'FacilityId = 25', 'DriverId desc'
CREATE PROC [dbo].[Sp_HWMS_DriverDetails_Export]
		
		@StrCondition	NVARCHAR(MAX) = NULL,
		@StrSorting		NVARCHAR(MAX) = NULL

AS 
BEGIN TRY
 
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	DECLARE @qry NVARCHAR(MAX);


SET @qry = 'SELECT [DriverCode],[DriverName],[TreatmentPlant],[Status],[EffectiveFrom],[Route] FROM ( 
			SELECT	[DriverId], A.[CustomerId], A.[FacilityId], [DriverCode], 
			[DriverName], T.[TreatmentPlantName] AS [TreatmentPlant], B.FieldValue AS [Status], 
			 datename(dd,[EffectiveFrom]) + ''-'' + UPPER(CONVERT(varchar(3),datename(MM,  [EffectiveFrom]))) + ''-'' + datename(yyyy,[EffectiveFrom]) AS [EffectiveFrom],[EffectiveTo], [ContactNo], [Route]
			FROM [HWMS_DriverDetails] A
			LEFT JOIN FMLovMst B ON A.Status = B.LovId 
			LEFT JOIN HWMS_TreatementPlant T ON A.TreatmentPlant = T.TreatmentPlantID ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'A.DriverId DESC')
			
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
