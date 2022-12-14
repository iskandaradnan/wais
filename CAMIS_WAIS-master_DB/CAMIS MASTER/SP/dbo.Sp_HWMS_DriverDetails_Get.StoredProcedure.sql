USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DriverDetails_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_DriverDetails_Get]  
(  
 @DriverId INT  
)  
   
AS   
  
-- Exec [DriverDetails_Get] 1  
BEGIN  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
BEGIN TRY  
  
 SELECT * FROM HWMS_DriverDetails where  DriverId =  @DriverId  
  
 SELECT * FROM HWMS_DriverDetailsLicense where  DriverId =  @DriverId and [isDeleted]=0  

 SELECT * FROM HWMS_DriverDetails_Attachment where  DriverId =  @DriverId  and [isDeleted]=0  
   
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
  Error_Procedure() as 'Sp_HWMS_DriverDetails_Get',    
  Error_Severity() as ErrorSeverity,    
  Error_State() as ErrorState,    
  GETDATE () as DateErrorRaised     
END CATCH  
END
GO
