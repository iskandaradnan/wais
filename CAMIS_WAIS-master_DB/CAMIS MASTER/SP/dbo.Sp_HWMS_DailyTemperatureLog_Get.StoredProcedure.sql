USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DailyTemperatureLog_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_HWMS_DailyTemperatureLog_Get]    
    -- exec [dbo].[Sp_HWMS_DailyTemperatureLog_Get]  30
 @Id INT    
    
AS     
BEGIN    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
BEGIN TRY    
     
 SELECT * FROM HWMS_DailyTemperatureLog WHERE DailyId = @Id    
    
 SELECT *FROM HWMS_DailyTemperatureLogDate WHERE DailyId=@Id AND [isDeleted]=0  ORDER BY [DATE]  

 select * from HWMS_DailyTemperatureLog_Attachment where  DailyId = @Id AND [isDeleted]=0   
     
END TRY    
BEGIN CATCH    
    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());    
    
THROW    
    
END CATCH    
SET NOCOUNT OFF    
END
GO
