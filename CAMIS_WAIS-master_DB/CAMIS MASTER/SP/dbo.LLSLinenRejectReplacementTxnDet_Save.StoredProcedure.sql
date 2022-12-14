USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRejectReplacementTxnDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================              
--APPLICATION  : UETrack 1.5              
--NAME    : LLSLinenRejectReplacementTxnDet_Save             
--DESCRIPTION  : SAVE RECORD IN [LLSLinenRejectReplacementTxnDet_Save] TABLE               
--AUTHORS   : SIDDHANT              
--DATE    : 16-JAN-2020            
-------------------------------------------------------------------------------------------------------------------------              
--VERSION HISTORY               
--------------------:---------------:---------------------------------------------------------------------------------------              
--Init    : Date          : Details              
--------------------:---------------:---------------------------------------------------------------------------------------              
--SIDDHANT          : 16-JAN-2020 :               
-------:------------:----------------------------------------------------------------------------------------------------*/              
              
          
CREATE PROCEDURE  [dbo].[LLSLinenRejectReplacementTxnDet_Save]                                         
              
(              
 @Block As [dbo].[LLSLinenRejectReplacementTxnDet] READONLY              
)                    
              
AS                    
              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
DECLARE @Table TABLE (ID INT)              
            
INSERT INTO LLSLinenRejectReplacementTxnDet (          
 LinenRejectReplacementId,          
 CustomerId,          
 FacilityId,      
 LinenItemId,          
Ql01aTapeGlue,          
Ql01bChemical,           
Ql01cBlood,          
Ql01dPermanentStain,          
Ql02TornPatches,          
Ql03Button,          
Ql04String,          
Ql05Odor,          
Ql06aFaded,          
Ql06bThinMaterial,          
Ql06cWornOut,          
Ql06d3YrsOld,          
Ql07Shrink,          
Ql08Crumple,          
Ql09Lint,          
TotalRejectedQuantity,          
ReplacedQuantity,          
ReplacedDateTime,          
Remarks,          
CreatedBy,          
CreatedDate,          
CreatedDateUTC        
)              
            
OUTPUT INSERTED.LinenRejectReplacementDetId INTO @Table              
SELECT  LinenRejectReplacementId,       
 CustomerId,          
 FacilityId,       
 LinenItemId,          
Ql01aTapeGlue,          
Ql01bChemical,           
Ql01cBlood,          
Ql01dPermanentStain,          
Ql02TornPatches,          
Ql03Button,          
Ql04String,          
Ql05Odor,          
Ql06aFaded,          
Ql06bThinMaterial,          
Ql06cWornOut,          
Ql06d3YrsOld,          
Ql07Shrink,          
Ql08Crumple,          
Ql09Lint,          
TotalRejectedQuantity,          
ReplacedQuantity,          
ReplacedDateTime,          
Remarks,          
CreatedBy,            
GETDATE(),            
GETUTCDATE()       
     
FROM @Block              
              
SELECT LinenRejectReplacementDetId            
      ,[Timestamp]            
   ,'' ErrorMsg            
      --,GuId             
FROM [LLSLinenRejectReplacementTxnDet] WHERE LinenRejectReplacementDetId IN (SELECT ID FROM @Table)              
              
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
END 
GO
