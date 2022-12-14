USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DailyTemperatureLog]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- select * from HWMS_DailyTemperatureLog
CREATE procedure [dbo].[Sp_HWMS_DailyTemperatureLog]    
    
 @pDailyId int,    
 @pCustomerId int,    
 @pFacilityId int,    
 @pYear int,    
 @pMonth nvarchar(30)    
      
AS    
BEGIN     
SET NOCOUNT ON;     
BEGIN TRY    
	IF(@pDailyId = 0)    
	BEGIN    
		 IF(EXISTS(SELECT 1 FROM HWMS_DailyTemperatureLog WHERE Year=@pYear AND Month=@pMonth and CustomerId = @pCustomerId and FacilityId = @pFacilityId))  
			 BEGIN  
				SELECT -1 AS DailyId  
			 END  
		 ELSE  
		 BEGIN  
			   INSERT INTO HWMS_DailyTemperatureLog([CustomerId],[FacilityId],[Year],[Month])    
			   VALUES(@pCustomerId,@pFacilityId,@pYear,@pMonth)    
    
			  SELECT MAX(DailyId) AS DailyId FROM HWMS_DailyTemperatureLog    
		END 
	END
	ELSE
	BEGIN
		SELECT @pDailyId AS DailyId
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
 Error_Procedure() as 'SP_HWMS_DailyTemperatureLog',      
 Error_Severity() as ErrorSeverity,      
 Error_State() as ErrorState,      
 GETDATE () as DateErrorRaised      
    
 SELECT 'Error occured while inserting'    
END CATCH     
END
GO
