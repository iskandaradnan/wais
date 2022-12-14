USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInjectionTxnDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[LLSLinenInjectionTxnDet_GetById]                                 
(                                
 @Id INT                                
)                                
                                 
AS                                 
    -- Exec [LLSLinenInjectionTxnDet_GetById ] 135                             
                              
--/*=====================================================================================================================                              
--APPLICATION  : UETrack                              
--NAME    : LLSLinenInjectionTxnDet_GetById                              
--DESCRIPTION  : GETS THE LLSLinenInjection                              
--AUTHORS   : SIDDHANT                              
--DATE    : 21-JAN-2020                              
-------------------------------------------------------------------------------------------------------------------------                              
--VERSION HISTORY                               
--------------------:---------------:---------------------------------------------------------------------------------------                              
--Init    : Date          : Details                              
--------------------:---------------:---------------------------------------------------------------------------------------                              
--SIDDHANT           : 21-JAN-2020 :                               
-------:------------:----------------------------------------------------------------------------------------------------*/                              
                              
BEGIN                                
SET NOCOUNT ON                                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                
BEGIN TRY                                
                                 
SELECT                            
B.LinenCode,                            
 B.LinenDescription,                            
 A.QuantityInjected,                            
 A.TestReport,                     
 A.LinenInjectionDetId,                    
 DATEADD(year, 3, C.InjectionDate) as LifeSpanValidity,  
 A.LinenPrice  
     
FROM dbo.LLSLinenInjectionTxnDet A                            
LEFT JOIN dbo.LLSLinenItemDetailsMst B                            
ON A.LinenItemId =B.LinenItemId                            
LEFT JOIN dbo.LLSLinenInjectionTxn C                            
ON A.LinenInjectionId =C.LinenInjectionId                            
                            
WHERE A.LinenInjectionId=@Id            
AND ISNULL(C.IsDeleted,'')=''        
AND ISNULL(B.IsDeleted,'')=''       
AND ISNULL(A.IsDeleted,'')=''       
                            
END TRY                                
BEGIN CATCH                                
                                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                                
                                
THROW                                
                                
END CATCH                                
SET NOCOUNT OFF                                
END
GO
