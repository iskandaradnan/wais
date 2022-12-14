USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_TreatmentPlant_VehicleDetails_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_TreatmentPlant_VehicleDetails_Get]
@TreatmentPlantId INT = NULL,
@CustomerId int = null,
@FacilityId int = null
AS
BEGIN
SET NOCOUNT ON; 
BEGIN TRY

		SELECT VehicleNo,C.FieldValue AS [Manufacturer],LoadWeight,EffectiveFrom, B.FieldValue AS [Status]
		FROM HWMS_VehicleDetails A
		LEFT JOIN FMLovMst B ON A.Status = B.LovId 
		LEFT JOIN FMLovMst C ON A.Manufacturer = C.LovId 
		WHERE B.FieldValue='Active' AND TreatmentPlant = @TreatmentPlantId

		
END TRY 
BEGIN CATCH 
INSERT INTO ExceptionLog (  
		ErrorLine, ErrorMessage, ErrorNumber,  
		ErrorProcedure, ErrorSeverity, ErrorState,  
		DateErrorRaised  
		)  
		SELECT  
		ERROR_LINE () as ErrorLine,  
		Error_Message() as ErrorMessage,  
		Error_Number() as ErrorNumber,  
		Error_Procedure() as 'Sp_HWMS_VehicleDetails_Get',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  
		END CATCH 
END
GO
