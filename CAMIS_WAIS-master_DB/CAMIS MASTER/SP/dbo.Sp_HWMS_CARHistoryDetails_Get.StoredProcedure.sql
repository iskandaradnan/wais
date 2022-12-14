USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CARHistoryDetails_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_CARHistoryDetails_Get]
(
@Id INT
)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
SELECT  B.FieldValue AS [Status],A.RootCause,A.Solution,A.Remarks FROM
HWMS_CorrectiveActionReport A
LEFT JOIN FMLovMst B ON A.Status = B.LovId 
WHERE CARId=@Id

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
	Error_Procedure() as 'Sp_HWMS_CARHistoryDetails_Get',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

END CATCH
end

GO
