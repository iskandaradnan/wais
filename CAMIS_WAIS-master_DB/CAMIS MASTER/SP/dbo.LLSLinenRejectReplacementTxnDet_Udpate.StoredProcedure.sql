USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRejectReplacementTxnDet_Udpate]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LLSLinenRejectReplacementTxnDet_Udpate]          
(          
-- @ReceivedQuantity AS INT        
--,@DespatchedQuantity AS INT        
--,@Remarks AS NVARCHAR(1000)        
--,@ModifiedBy AS INT        
--,@ModifiedDate AS DATETIME        
--,@ModifiedDateUTC AS DATETIME        
--,@CleanLinenDespatchDetId AS INT        
        
@LLSLinenRejectReplacementTxnDet_Udpate AS LLSLinenRejectReplacementTxnDet_Udpate READONLY        
)          
          
AS          
          
BEGIN          
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY            
          
UPDATE A        
SET       
A.Ql01aTapeGlue = B.Ql01aTapeGlue,        
A.Ql01bChemical = B.Ql01bChemical,       
A.Ql01cBlood = B.Ql01cBlood,        
A.Ql01dPermanentStain = B.Ql01dPermanentStain,        
A.Ql02TornPatches = B.Ql02TornPatches,       
A.Ql03Button = B.Ql03Button,        
A.Ql04String = B.Ql04String,        
A.Ql05Odor = B.Ql05Odor,       
A.Ql06aFaded = B.Ql06aFaded,        
A.Ql06bThinMaterial = B.Ql06bThinMaterial,       
A.Ql06cWornOut = B.Ql06cWornOut,       
A.Ql06d3YrsOld = B.Ql06d3YrsOld,        
A.Ql07Shrink = B.Ql07Shrink,       
A.Ql08Crumple = B.Ql08Crumple,        
A.Ql09Lint = B.Ql09Lint,       
A.TotalRejectedQuantity = (B.Ql01aTapeGlue + B.Ql01bChemical + B.Ql01cBlood + B.Ql01dPermanentStain +  B.Ql02TornPatches + B.Ql03Button + B.Ql04String + B.Ql05Odor + B.Ql06aFaded + B.Ql06bThinMaterial + B.Ql06cWornOut + B.Ql06d3YrsOld + B.Ql07Shrink + B.Ql08Crumple + B.Ql09Lint),        
A.ReplacedQuantity = B.ReplacedQuantity,        
A.ReplacedDateTime = B.ReplacedDateTime,      
A.Remarks = B.Remarks,       
A.ModifiedBy = B.ModifiedBy,       
A.ModifiedDate = GETDATE(),       
A.ModifiedDateUTC = GETUTCDATE()       
FROM LLSLinenRejectReplacementTxnDet A INNER JOIN @LLSLinenRejectReplacementTxnDet_Udpate B ON A.LinenRejectReplacementDetId=B.LinenRejectReplacementDetId       
WHERE A.LinenRejectReplacementDetId = B.LinenRejectReplacementDetId            
          
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
END
GO
