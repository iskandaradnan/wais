USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRejectReplacementTxn_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================              
--APPLICATION  : UETrack 1.5              
--NAME    : SaveUserAreaDetailsLLS             
--DESCRIPTION  : UPDATE RECORD IN [LLSLinenRejectReplacementTxn] TABLE               
--AUTHORS   : SIDDHANT              
--DATE    : 8-JAN-2020            
-------------------------------------------------------------------------------------------------------------------------              
--VERSION HISTORY               
--------------------:---------------:---------------------------------------------------------------------------------------              
--Init    : Date          : Details              
--------------------:---------------:---------------------------------------------------------------------------------------              
--SIDDHANT          : 8-JAN-2020 :               
-------:------------:----------------------------------------------------------------------------------------------------*/              
            
              
            
            
              
CREATE PROCEDURE  [dbo].[LLSLinenRejectReplacementTxn_Update]                                         
              
(              
 @Remarks AS NVARCHAR(1000)       
,@LinenRejectReplacementId AS INT           
,@ModifiedBy AS INT
)                    
              
AS                    
              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
DECLARE @Table TABLE (ID INT)              
            
UPDATE          
 LLSLinenRejectReplacementTxn         
SET          
 Remarks = @Remarks,           
 ModifiedBy =@ModifiedBy,       
 ModifiedDate = GETDATE(),        
 ModifiedDateUTC = GETUTCDATE()      
WHERE LinenRejectReplacementId = @LinenRejectReplacementId            
            
SELECT LinenRejectReplacementId            
      ,[Timestamp]            
   ,'' ErrorMsg            
      --,GuId             
FROM LLSLinenRejectReplacementTxn WHERE LinenRejectReplacementId IN (SELECT ID FROM @Table)              
              
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
END 
GO
