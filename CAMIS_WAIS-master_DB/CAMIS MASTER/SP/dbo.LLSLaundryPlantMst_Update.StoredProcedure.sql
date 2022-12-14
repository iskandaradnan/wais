USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLaundryPlantMst_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec [LLSLaundryPlantMst_Update]       
      
--/*=====================================================================================================================      
--APPLICATION  : UETrack 1.5      
--NAME    : SaveUserAreaDetailsLLS     
--DESCRIPTION  : UPDATE RECORD IN [LLSLaundryPlantMst] TABLE       
--AUTHORS   : SIDDHANT      
--DATE    : 8-JAN-2020    
-------------------------------------------------------------------------------------------------------------------------      
--VERSION HISTORY       
--------------------:---------------:---------------------------------------------------------------------------------------      
--Init    : Date          : Details      
--------------------:---------------:---------------------------------------------------------------------------------------      
--SIDDHANT          : 8-JAN-2020 :       
-------:------------:----------------------------------------------------------------------------------------------------*/      
    
      
    
    
      
CREATE PROCEDURE  [dbo].[LLSLaundryPlantMst_Update]                                 
      
(      
 @LaundryPlantCode AS NVARCHAR(60)  
,@LaundryPlantName AS NVARCHAR(300)  
,@Ownership AS INT   
,@Capacity AS DECIMAL(10,2)  
,@ContactPerson AS NVARCHAR(60)  
,@Status AS INT 
,@LaundryPlantId AS INT  
)            
      
AS            
      
BEGIN      
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
BEGIN TRY      
    
DECLARE @Table TABLE (ID INT)      
    
UPDATE LLSLaundryPlantMst    
SET    
LaundryPlantCode=@LaundryPlantCode,
 LaundryPlantName = @LaundryPlantName,    
 Ownership = @Ownership,    
 Capacity = @Capacity,    
 ContactPerson = @ContactPerson,    
 Status = @Status
WHERE LaundryPlantId = @LaundryPlantId    
    
SELECT LaundryPlantId    
      ,[Timestamp]    
   ,'' ErrorMsg    
      --,GuId     
FROM LLSLaundryPlantMst WHERE LaundryPlantId IN (SELECT ID FROM @Table)      
      
END TRY      
BEGIN CATCH      
      
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)      
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());      
      
THROW      
      
END CATCH      
END
GO
