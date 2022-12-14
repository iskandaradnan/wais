USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLinenItemMstDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
-- Exec [LLSUserAreaDetailsLinenItemMstDet_Save]       
      
--/*=====================================================================================================================      
--APPLICATION  : UETrack 1.5      
--NAME    : SaveUserAreaDetailsLLS     
--DESCRIPTION  : Update RECORD IN [LLSUserAreaDetailsLinenItemMstDet] TABLE       
--AUTHORS   : SIDDHANT      
--DATE    : 19-DEC-2019    
-------------------------------------------------------------------------------------------------------------------------      
--VERSION HISTORY       
--------------------:---------------:---------------------------------------------------------------------------------------      
--Init    : Date          : Details      
--------------------:---------------:---------------------------------------------------------------------------------------      
--SIDDHANT          : 19-DEC-2019 :       
-------:------------:----------------------------------------------------------------------------------------------------*/      
    
      
    
    
      
CREATE PROCEDURE  [dbo].[LLSUserAreaDetailsLinenItemMstDet_Update]                                 
      
(      
 @Par1 AS NUMERIC(24,2)   
,@Par2 AS NUMERIC(24,2)  
,@DefaultIssue AS INT  
,@AgreedShelfLevel AS NUMERIC(24,2)  
,@ModifiedBy AS INT  
--,@ModifiedDate AS DATETIME  
--,@ModifiedDateUTC AS DATETIME  
,@LLSUserAreaLinenItemId AS  INT  
  
)            
      
AS            
      
BEGIN      
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
BEGIN TRY      
    
DECLARE @Table TABLE (ID INT)     
    
UPDATE A    
SET    
Par1 = @Par1,    
Par2 = @Par2,    
DefaultIssue = @DefaultIssue,    
AgreedShelfLevel = @AgreedShelfLevel,    
ModifiedBy = @ModifiedBy,     
ModifiedDate = GETDATE() ,    
ModifiedDateUTC =GETUTCDATE()    
FROM LLSUserAreaDetailsLinenItemMstDet A    
WHERE LLSUserAreaLinenItemId = @LLSUserAreaLinenItemId     
    
    
SELECT LLSUserAreaId    
      ,[Timestamp]    
   ,'' ErrorMsg    
      --,GuId     
FROM LLSUserAreaDetailsLinenItemMstDet WHERE LLSUserAreaId IN (SELECT ID FROM @Table)      
      
END TRY      
BEGIN CATCH      
      
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)      
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());      
      
THROW      
      
END CATCH      
SET NOCOUNT OFF      
END
GO
