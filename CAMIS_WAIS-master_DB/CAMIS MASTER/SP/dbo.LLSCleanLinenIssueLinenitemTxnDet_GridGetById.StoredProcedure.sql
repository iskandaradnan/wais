USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueLinenitemTxnDet_GridGetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC LLSCleanLinenIssueLinenitemTxnDet_GridGetById  138             
CREATE PROCEDURE [dbo].[LLSCleanLinenIssueLinenitemTxnDet_GridGetById]              
(              
@ID INT              
)              
AS              
              
              
--/*=====================================================================================================================                                
--APPLICATION  : UETrack                                
--NAME    : LLSCleanLinenIssueLinenitemTxnDet_GridGetById                                
--DESCRIPTION  : GETS THE LLSCleanLinenIssueLinenitemTxnDet                                
--AUTHORS   : SIDDHANT                                
--DATE    : 1-APR-2020                                
-------------------------------------------------------------------------------------------------------------------------                                
--VERSION HISTORY                                 
--------------------:---------------:---------------------------------------------------------------------------------------                                
--Init    : Date          : Details                                
--------------------:---------------:---------------------------------------------------------------------------------------                                
--SIDDHANT           : 1-APR-2020 :                                 
-------:------------:----------------------------------------------------------------------------------------------------*/                                
              
BEGIN              
              
BEGIN TRY              
              
        
          
        
SELECT A.CleanLinenRequestId              
     ,B.LinenItemId              
  ,C.LinenDescription              
  ,C.LinenCode              
  ,BalanceOnShelf              
  ,RequestedQuantity              
  ,E.AgreedShelfLevel               
FROM LLSCleanLinenRequestTxn A              
INNER JOIN LLSCleanLinenRequestLinenItemTxnDet B              
ON A.CleanLinenRequestId=B.CleanLinenRequestId              
INNER JOIN dbo.LLSLinenItemDetailsMst C                          
ON B.LinenItemId = C.LinenItemId                          
INNER JOIN dbo.LLSUserAreaDetailsLinenItemMstDet E                          
ON B.LinenItemId =E.LinenItemId                          
AND A.LLSUserAreaLocationId = E.UserLocationId        
WHERE A.CleanLinenRequestId=@ID              
AND ISNULL(A.IsDeleted,'')=''              
AND ISNULL(B.IsDeleted,'')='' 
AND ISNULL(E.IsDeleted,'')='' 
AND ISNULL(C.IsDeleted,'')='' 
              
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                                  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                                  
                                  
THROW                                  
               
              
END CATCH              
SET NOCOUNT OFF                                  
              
END
GO
