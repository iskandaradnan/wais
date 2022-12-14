USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_WasteCodeData]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[Sp_HWMS_WasteCodeData]
		(@pWastetype nvarchar(30))
AS
BEGIN
SET NOCOUNT ON; 
BEGIN TRY
		SELECT B.WasteCode
				FROM HWMS_Wastetype A
				INNER JOIN HWMS_WasteType_WasteCode B ON A.WasteTypeId = B.WasteId 
				WHERE A.WasteType=@pWastetype;
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
		Error_Procedure() as 'Sp_HWMS_WasteCodeData',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
END
GO
