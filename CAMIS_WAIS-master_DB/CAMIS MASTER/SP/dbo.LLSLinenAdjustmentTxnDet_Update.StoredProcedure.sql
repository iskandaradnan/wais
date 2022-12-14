USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenAdjustmentTxnDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================              
--APPLICATION  : UETrack 1.5              
--NAME    : LLSLinenAdjustmentTxnDet             
--DESCRIPTION  : UPDATE RECORD IN [LLSLinenAdjustmentTxnDet_Update] TABLE               
--AUTHORS   : SIDDHANT              
--DATE    : 20-JAN-2020            
-------------------------------------------------------------------------------------------------------------------------              
--VERSION HISTORY               
--------------------:---------------:---------------------------------------------------------------------------------------              
--Init    : Date          : Details              
--------------------:---------------:---------------------------------------------------------------------------------------              
--SIDDHANT          : 20-JAN-2020 :               
-------:------------:----------------------------------------------------------------------------------------------------*/              
            
              
            
            
              
CREATE PROCEDURE  [dbo].[LLSLinenAdjustmentTxnDet_Update]                                         
              
(              
 @LLSLinenAdjustmentTxnDet_Update AS [LLSLinenAdjustmentTxnDet_Update] READONLY     
)                    
              
AS                    
              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
DECLARE @Table TABLE (ID INT)              
            
UPDATE A               
SET     
 A.Justification = B.Justification,          
 A.ModifiedBy = B.ModifiedBy,              
 A.ModifiedDate = GETDATE(),              
 A.ModifiedDateUTC = GETUTCDATE()           
FROM LLSLinenAdjustmentTxnDet as A Inner join @LLSLinenAdjustmentTxnDet_Update as B on A.LinenAdjustmentDetId= B.LinenAdjustmentDetId    
WHERE A.LinenAdjustmentDetId= B.LinenAdjustmentDetId               
                  
            
SELECT LinenAdjustmentDetId            
      ,[Timestamp]            
   ,'' ErrorMsg            
      --,GuId             
FROM LLSLinenAdjustmentTxnDet WHERE LinenAdjustmentDetId IN (SELECT ID FROM @Table)              
              
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
END

GO
