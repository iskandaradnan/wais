USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRejectReplacementTxnDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
              
                  
CREATE PROCEDURE [dbo].[LLSLinenRejectReplacementTxnDet_GetById]                  
(                  
 @Id INT                  
)                  
                   
AS                   
    -- Exec [LLSLinenRejectReplacementTxnDet_GetById] 135               
                
--/*=====================================================================================================================                
--APPLICATION  : UETrack                
--NAME    : LLSLinenRejectReplacementTxnDet_GetById               
--DESCRIPTION  : GETS THE LLSLinenRejectReplacementTxnDet            
--AUTHORS   : SIDDHANT                
--DATE    : 16-JAN-2020                
-------------------------------------------------------------------------------------------------------------------------                
--VERSION HISTORY                 
--------------------:---------------:---------------------------------------------------------------------------------------                
--Init    : Date          : Details                
--------------------:---------------:---------------------------------------------------------------------------------------                
--SIDDHANT           : 16-JAN-2020 :                 
-------:------------:----------------------------------------------------------------------------------------------------*/                
                
BEGIN                  
SET NOCOUNT ON                  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                  
BEGIN TRY                  
                   
SELECT            
 B.LinenCode,            
 B.LinenDescription,            
 A.Ql01aTapeGlue,            
 A.Ql01bChemical,            
 A.Ql01cBlood,            
 A.Ql01dPermanentStain,            
 A.Ql02TornPatches,             
 A.Ql03Button,            
 A.Ql04String,            
 A.Ql05Odor,            
 A.Ql06aFaded,            
 A.Ql06bThinMaterial,            
 A.Ql06cWornOut,            
 A.Ql06d3YrsOld,            
 A.Ql07Shrink,            
 A.Ql08Crumple,            
 A.Ql09Lint,            
 A.TotalRejectedQuantity,            
 A.ReplacedQuantity,            
 A.ReplacedDateTime,            
 A.Remarks,      
 A.LinenRejectReplacementDetId      
FROM dbo.LLSLinenRejectReplacementTxnDet A            
INNER JOIN dbo.LLSLinenItemDetailsMst B            
ON A.LinenItemId = B.LinenItemId             
WHERE            
--A.LinenRejectReplacementDetId=@Id            
A.LinenRejectReplacementId=@Id    
AND  ISNULL(A.IsDeleted,'')='' 
              



END TRY                  
BEGIN CATCH                  
                  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                  
                  
THROW                  
                  
END CATCH                  
SET NOCOUNT OFF                  
END  
  
  
     
GO
