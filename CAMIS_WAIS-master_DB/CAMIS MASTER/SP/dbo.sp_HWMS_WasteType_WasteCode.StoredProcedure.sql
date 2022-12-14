USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_WasteType_WasteCode]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_HWMS_WasteType_WasteCode](  
 @WasteId  int,  
 @WasteTypeId  int,  
 @WasteCode nvarchar(50),  
 @WasteDescription nvarchar(500),  
 @isDeleted bit  
 )  
AS  
BEGIN   
SET NOCOUNT ON;   
BEGIN TRY  
  
BEGIN  
 IF(@WasteId = 0)  
 BEGIN  
  IF(EXISTS(SELECT 1 FROM HWMS_WasteType_WasteCode WHERE [WasteCode] =  @WasteCode))   
     BEGIN  
       SELECT 'Waste Code already exists'  
  END  
  ELSE  
  BEGIN  
    INSERT INTO HWMS_Wastetype_WasteCode ( [WasteTypeId], [WasteCode], [WasteDescription], [isDeleted] )   
       VALUES( @WasteTypeId, @WasteCode, @WasteDescription,  CAST(@isDeleted AS INT))   
   
    SELECT @@Identity as 'WasteId'  
  END  
 END   
    ELSE  
 BEGIN           
     UPDATE HWMS_Wastetype_WasteCode SET [WasteCode] = @WasteCode, [WasteDescription] = @WasteDescription,  
  [isDeleted] = CAST(@isDeleted AS INT)   
  WHERE WasteId = @WasteId AND WasteTypeId=@WasteTypeId    
  
  SELECT @WasteId as 'WasteId'  
  
 END  
  
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
 Error_Procedure() as 'sp_HWMS_WasteType_WasteCode',    
 Error_Severity() as ErrorSeverity,    
 Error_State() as ErrorState,    
 GETDATE () as DateErrorRaised    
  
 SELECT 'Error occured while inserting'  
END CATCH   
end  
GO
