USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_DailyTemperatureLogDate]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_HWMS_DailyTemperatureLogDate]  
 @TemperatureId INT,  
 @pDate DATETIME,  
 @pTemperatureReading NVARCHAR(50),  
 @pDailyId INT,  
 @IsDeleted BIT  
  
AS  
BEGIN  
SET NOCOUNT ON;  
  
BEGIN TRY  
BEGIN  
   
IF(@TemperatureId = 0)  
      BEGIN  
  IF(EXISTS(SELECT 1 FROM HWMS_DailyTemperatureLogDate WHERE [Date] = @pDate))  
   BEGIN  
    SELECT -1 AS TemperatureId       
   END  
  ELSE  
   BEGIN  
   INSERT INTO HWMS_DailyTemperatureLogDate([Date],[TemperatureReading],[DailyId],[isDeleted])      
   VALUES(@pDate,@pTemperatureReading,@pDailyId,CAST(@IsDeleted AS INT))  
                                                
   SELECT @@Identity AS TemperatureId  
   END  
      END  
ELSE  
      BEGIN  
      UPDATE HWMS_DailyTemperatureLogDate SET [Date] = @pDate, [TemperatureReading] = @pTemperatureReading, 
      [isDeleted] = CAST(@IsDeleted AS INT)   
      WHERE  [DateId] = @TemperatureId AND [DailyId] = @pDailyId  
  
     SELECT @TemperatureId AS TemperatureId  
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
 Error_Procedure() as 'sp_HWMS_DailyTemperatureLogDate',  
 Error_Severity() as ErrorSeverity,  
 Error_State() as ErrorState,  
 GETDATE () as DateErrorRaised  
END CATCH  
END
GO
