USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_TreatmentPlant_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [Sp_HWMS_TreatmentPlant_Export] 'FacilityId = 25' , 'TreatmentPlantId desc'
CREATE PROC [dbo].[Sp_HWMS_TreatmentPlant_Export]
	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @qry NVARCHAR(MAX);


SET @qry = 'SELECT [TreatmentPlantCode], [TreatmentPlantName], [State], [Ownership], [DOEFileNo], [CapacityOfStorage] FROM ( 
			SELECT	[TreatmentPlantId], [CustomerId], [FacilityId], [TreatmentPlantCode], [TreatmentPlantName],
            B.FieldValue AS [State] , C.FieldValue AS [Ownership]  ,A.[DOEFileNo] ,A.[CapacityOfStorage]
			FROM [HWMS_TreatementPlant] A
			LEFT JOIN FMLovMst B ON A.State = B.LovId 
			LEFT JOIN FMLovMst C ON A.Ownership = C.LovId ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'A.TreatmentPlantId DESC')

			
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
