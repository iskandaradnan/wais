USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenCondemnationTxnDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
            
                
CREATE PROCEDURE [dbo].[LLSLinenCondemnationTxnDet_GetById]                
(                
 @Id INT                
)                
                 
AS                 
    -- Exec [LLSLinenCondemnationTxnDet_GetById] 135             
              
--/*=====================================================================================================================              
--APPLICATION  : UETrack              
--NAME    : LLSLinenCondemnationTxnDet_GetById             
--DESCRIPTION  : GETS THE LLSLinenCondemnationTxnDet              
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
 A.BatchNo,            
 (A.Torn+A.Stained+A.Faded+A.Vandalism+A.WearTear+A.StainedByChemical) as Total,            
 A.Torn,            
 A.Stained,            
 A.Faded,            
 A.Vandalism,            
 A.WearTear,            
 A.StainedByChemical,        
 A.LinenCondemnationDetId    
            
FROM dbo.LLSLinenCondemnationTxnDet A            
INNER JOIN dbo.LLSLinenItemDetailsMst B             
ON A.LinenItemId = B.LinenItemId             
WHERE A.LinenCondemnationId=@Id   
AND ISNULL(A.IsDeleted,'')=''  
AND ISNULL(B.IsDeleted,'')=''
            
END TRY                
BEGIN CATCH                
                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                
                
THROW                
                
END CATCH                
SET NOCOUNT OFF                
END  
  
  
      
GO
