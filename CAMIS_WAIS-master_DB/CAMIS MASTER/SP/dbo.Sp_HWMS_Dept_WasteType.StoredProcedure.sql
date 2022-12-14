USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_Dept_WasteType]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_Dept_WasteType]

AS
BEGIN 
SET NOCOUNT ON; 
BEGIN TRY
BEGIN
select B.FieldValue AS WasteType from HWMS_Wastetype A
LEFT JOIN FMLovMst B ON A.WasteType = B.LovId 
END
end try
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
	Error_Procedure() as 'Sp_HWMS_Dept_WasteType',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

	SELECT 'Error occured while inserting'
END CATCH 
end
GO
