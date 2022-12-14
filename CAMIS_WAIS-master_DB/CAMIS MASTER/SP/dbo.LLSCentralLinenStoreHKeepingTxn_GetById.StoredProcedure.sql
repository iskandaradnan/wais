USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralLinenStoreHKeepingTxn_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec LLSCentralLinenStoreHKeepingTxn_GetById 231  
  
                
                    
CREATE PROCEDURE [dbo].[LLSCentralLinenStoreHKeepingTxn_GetById]                    
(                    
 @Id INT                    
)                    
                     
AS                     
    -- Exec [LLSCentralLinenStoreHKeepingTxn_GetById] 10115                
                  
--/*=====================================================================================================================                  
--APPLICATION  : UETrack                  
--NAME    : LLSCentralLinenStoreHKeepingTxn_GetById                 
--DESCRIPTION  : GETS THE LLSCentralLinenStoreHKeeping                  
--AUTHORS   : SIDDHANT                  
--DATE    : 13-JAN-2020                  
-------------------------------------------------------------------------------------------------------------------------                  
--VERSION HISTORY                   
--------------------:---------------:---------------------------------------------------------------------------------------                  
--Init    : Date          : Details                  
--------------------:---------------:---------------------------------------------------------------------------------------                  
--SIDDHANT           : 13-JAN-2020 :                   
-------:------------:----------------------------------------------------------------------------------------------------*/                  
                  
BEGIN                    
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY                    
                
SELECT                
 B.LovId as StoreType,               
 A.[Year] AS [Year],
 A.[Month] AS [Month]


 --D.FieldCode as Year,                
 --C.FieldCode as Month                
FROM                
 dbo.LLSCentralLinenStoreHKeepingTxn A                
INNER JOIN dbo.FMLovMst  B   ON A.StoreType =B.LovId             
--INNER JOIN dbo.FMLovMst  C    ON A.[Month] =C.FieldCode            
--INNER JOIN dbo.FMLovMst  D    ON A.[YEAR] =D.FieldCode            
WHERE HouseKeepingId=@ID                
AND ISNULL(A.IsDeleted,'')=''      
                
END TRY                    
BEGIN CATCH                    
                    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                    
                    
THROW                    
                    
END CATCH                    
SET NOCOUNT OFF                    
END  
  
      
      
      
      
                
    
          --select * from LLSCentralLinenStoreHKeepingTxn  
    --select * from VW_LLSCentralLinenStoreHKeepingTxn
GO
