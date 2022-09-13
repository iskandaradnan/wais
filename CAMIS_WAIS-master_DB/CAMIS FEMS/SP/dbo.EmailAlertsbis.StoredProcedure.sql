USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[EmailAlertsbis]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





      
-- Exec [EmailAlertsbis] '1       
      
      
CREATE PROCEDURE  [dbo].[EmailAlertsbis]                            
      
(      
 @pID int    
    
      
)            
      
AS            
      
BEGIN      
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
BEGIN TRY      
   
  
INSERT INTO [BIS_Notification] ([BISWOID],[Created date],[Email_sent]) VALUES (@pID ,GETDATE(),1)  
    
      
      
       
      
      
      
      
END TRY      
BEGIN CATCH      
      
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)      
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());      
      
THROW      
      
END CATCH      
SET NOCOUNT OFF      
END
GO
