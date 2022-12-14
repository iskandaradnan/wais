USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_CARAutoGenaratedCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- EXEC [dbo].[Sp_CLS_CARAutoGenaratedCode]  
CREATE proc [dbo].[Sp_CLS_CARAutoGenaratedCode]  
AS  
BEGIN  
SET NOCOUNT ON;  
  
BEGIN TRY  

DECLARE @CurrentMonth VARCHAR(6), @PreviousCARNo VARCHAR(30) , @NewCARNo VARCHAR(20)
SET @CurrentMonth = CONVERT(VARCHAR(6), GETDATE(), 112)


IF(EXISTS(SELECT 1 FROM CLS_CorrectiveActionReport WHERE CARNo LIKE '%' + @CurrentMonth + '%'))
	BEGIN
		
		SELECT TOP 1 @PreviousCARNo = CARNo FROM CLS_CorrectiveActionReport WHERE CARNo like '%' + @CurrentMonth + '%' ORDER BY CARId DESC 
		SELECT @NewCARNo = RIGHT('00000000' + CONVERT(VARCHAR, CONVERT(INT, RIGHT(@PreviousCARNo,6)) + 1) , 6)

		SELECT 'CAR/WAC/C' + @CurrentMonth + '/' + @NewCARNo AS CARNo
		SELECT IndicatorNo FROM CLS_IndicatorMaster  
	END
ELSE
	BEGIN
		SELECT 'CAR/WAC/C' + CONVERT(VARCHAR(6), GETDATE(), 112) + '/000001' AS CARNo
		SELECT IndicatorNo FROM CLS_IndicatorMaster  
	END
	

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
 Error_Procedure() as 'Sp_CLS_CARAutoGenaratedCode',    
 Error_Severity() as ErrorSeverity,    
 Error_State() as ErrorState,    
 GETDATE () as DateErrorRaised    
  
END CATCH  
end
GO
