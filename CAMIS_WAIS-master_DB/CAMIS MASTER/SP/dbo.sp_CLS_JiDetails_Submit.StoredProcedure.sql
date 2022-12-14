USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_JiDetails_Submit]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_CLS_JiDetails_Submit]  
  
@pIsSubmitted INT,  
@pDetailsId INT  
  
AS    
begin    
  
SET NOCOUNT ON;    
    
BEGIN TRY  
  
	DECLARE @STATUS INT 
	update [dbo].[CLS_JiDetails] SET IsSubmitted = 1 WHERE DetailsId = @pDetailsId  
  
	select  @STATUS = LovId from FMLovMst where ScreenName = 'JIScheduleGeneration' and LovKey = 'StatusJIValues' and FieldValue = 'Closed'

	UPDATE CLS_JIScheduleDocument SET [Status] = @STATUS WHERE DocumentNo in ( select DocumentNo from [dbo].[CLS_JiDetails] WHERE DetailsId = @pDetailsId )
	   
    
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
 Error_Procedure() as 'sp_CLS_JiDetails_Submit',    
 Error_Severity() as ErrorSeverity,    
 Error_State() as ErrorState,    
 GETDATE () as DateErrorRaised    
END CATCH    
END
GO
