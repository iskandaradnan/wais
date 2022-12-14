USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInventoryTxn_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================              
--APPLICATION  : UETrack 1.5              
--NAME    : SaveUserAreaDetailsLLS             
--DESCRIPTION  : Update RECORD IN [LLSLinenInventoryTxn_Update] TABLE               
--AUTHORS   : SIDDHANT              
--DATE    : 13-FEB-2020            
-------------------------------------------------------------------------------------------------------------------------              
--VERSION HISTORY               
--------------------:---------------:---------------------------------------------------------------------------------------              
--Init    : Date          : Details              
--------------------:---------------:---------------------------------------------------------------------------------------              
--SIDDHANT          : 13-FEB-2020 :               
-------:------------:----------------------------------------------------------------------------------------------------*/              
            
              
            
          
              
CREATE PROCEDURE  [dbo].[LLSLinenInventoryTxn_Update]                                         
              
(              
 @VerifiedBy AS INT        
,@Remarks AS NVARCHAR(500)  =null      
,@LinenInventoryId  AS INT        
,@ModifiedBy AS INT
)                    
              
AS                    
              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
DECLARE @Table TABLE (ID INT)              
            
UPDATE LLSLinenInventoryTxn        
SET        
VerifiedBy = @VerifiedBy,        
Remarks = @Remarks,        
ModifiedBy = @ModifiedBy,        
ModifiedDate = GETDATE(),        
ModifiedDateUTC = GETUTCDATE()        
WHERE LinenInventoryId = @LinenInventoryId          
            
            
SELECT LinenInventoryId            
      ,[Timestamp]            
   ,'' ErrorMsg            
      --,GuId             
FROM LLSLinenInventoryTxn WHERE LinenInventoryId IN (SELECT ID FROM @Table)              
              
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
END
GO
