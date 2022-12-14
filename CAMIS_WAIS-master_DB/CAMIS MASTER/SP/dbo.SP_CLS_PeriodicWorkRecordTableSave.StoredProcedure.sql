USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_PeriodicWorkRecordTableSave]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CLS_PeriodicWorkRecordTableSave]  
(  
  @pPeriodicId int,@pUserAreaCode varchar(30)='',@pStatus varchar(30),  
  @pScopeofWorkA1 varchar(30)='',@pScopeofWorkA2 varchar(30)='',@pScopeofWorkA3 varchar(30)='',  
  @pScopeofWorkA4 varchar(30)='',@pScopeofWorkA5 varchar(30)='',@pScopeofWorkA6 varchar(30)='',  
  @pScopeofWorkA7 varchar(30)='',@pScopeofWorkA8 varchar(30)='',@pScopeofWorkA9 varchar(30)='',  
  @pScopeofWorkA10 varchar(30)='',@pScopeofWorkA11 varchar(30)='',@pScopeofWorkA12 varchar(30)='',  
  @pScopeofWorkA13 varchar(30)='',@pScopeofWorkA14 varchar(30)='',@pScopeofWorkA15 varchar(30)='',  
  @pScopeofWorkA16 varchar(30)='',@pScopeofWorkA17 varchar(30)='',@pScopeofWorkA18 varchar(30)='',  
  @pScopeofWorkA19 varchar(30)='',@pScopeofWorkA20 varchar(30)='',@pScopeofWorkA21 varchar(30)='',  
  @pScopeofWorkA22 varchar(30)='',@pScopeofWorkA23 varchar(30)='',@pScopeofWorkA24 varchar(30)='')  
  
AS  
BEGIN  
SET NOCOUNT ON;  
  
BEGIN TRY  
 IF(EXISTS(SELECT 1 FROM CLS_PeriodicWorkRecordTable WHERE PeriodicId = @pPeriodicId and UserAreaCode = @pUserAreaCode))  
     BEGIN           
  UPDATE  CLS_PeriodicWorkRecordTable SET  Status=@pStatus  
  WHERE UserAreaCode=@pUserAreaCode and PeriodicId=@pPeriodicId   
   
  SELECT PeriodicId  FROM CLS_PeriodicWorkRecordTable WHERE PeriodicId = @pPeriodicId AND UserAreaCode = @pUserAreaCode   
      END  
ELSE  
     BEGIN  
       INSERT INTO CLS_PeriodicWorkRecordTable  values(@pPeriodicId,@pUserAreaCode,@pStatus,@pScopeofWorkA1,  
       @pScopeofWorkA2,@pScopeofWorkA3,@pScopeofWorkA4,@pScopeofWorkA5,@pScopeofWorkA6,@pScopeofWorkA7,  
       @pScopeofWorkA8,@pScopeofWorkA9,@pScopeofWorkA10,@pScopeofWorkA11,@pScopeofWorkA12,@pScopeofWorkA13,  
       @pScopeofWorkA14,@pScopeofWorkA15,@pScopeofWorkA16,@pScopeofWorkA17,@pScopeofWorkA18,@pScopeofWorkA19,  
       @pScopeofWorkA20,@pScopeofWorkA21,@pScopeofWorkA22,@pScopeofWorkA23,@pScopeofWorkA24)   
    
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
 Error_Procedure() as 'SP_CLS_PeriodicWorkRecordTable',    
 Error_Severity() as ErrorSeverity,    
 Error_State() as ErrorState,    
 GETDATE () as DateErrorRaised    
END CATCH  
END  
  
GO
