USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInjectionTxnDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================              
--APPLICATION  : UETrack 1.5              
--NAME    : LLSLinenInjectionTxnDet_Save             
--DESCRIPTION  : SAVE RECORD IN [LLSLinenInjectionTxnDet] TABLE               
--AUTHORS   : SIDDHANT              
--DATE    : 21-JAN-2020            
-------------------------------------------------------------------------------------------------------------------------              
--VERSION HISTORY               
--------------------:---------------:---------------------------------------------------------------------------------------              
--Init    : Date          : Details              
--------------------:---------------:---------------------------------------------------------------------------------------              
--SIDDHANT          : 21-JAN-2020 :               
-------:------------:----------------------------------------------------------------------------------------------------*/              
              
          
CREATE PROCEDURE  [dbo].[LLSLinenInjectionTxnDet_Save]                                         
              
(              
 @Block As [dbo].[LLSLinenInjectionTxnDet] READONLY              
)                    
              
AS                    
              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
DECLARE @Table TABLE (ID INT)              
INSERT INTO LLSLinenInjectionTxnDet (         
 LinenInjectionId,      
 CustomerId,          
 FacilityId,          
 LinenItemId,          
 QuantityInjected,          
 TestReport,          
 LifeSpanValidity,          
 CreatedBy,          
 CreatedDate,          
 CreatedDateUTC       
 )          
          
  OUTPUT INSERTED.LinenInjectionDetId INTO @Table              
 SELECT        
 LinenInjectionId,      
 CustomerId,          
 FacilityId,          
 LinenItemId,          
 QuantityInjected,          
 TestReport,          
 LifeSpanValidity,          
CreatedBy,            
GETDATE(),            
GETUTCDATE()        
    
FROM @Block              
              
SELECT LinenInjectionDetId            
      ,[Timestamp]            
   ,'' ErrorMsg            
      --,GuId             
FROM LLSLinenInjectionTxnDet WHERE LinenInjectionDetId IN (SELECT ID FROM @Table)              
              
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
END
GO
