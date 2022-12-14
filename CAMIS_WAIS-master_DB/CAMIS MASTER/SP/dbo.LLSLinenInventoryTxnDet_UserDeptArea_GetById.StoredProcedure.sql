USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInventoryTxnDet_UserDeptArea_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                  
                      
CREATE PROCEDURE [dbo].[LLSLinenInventoryTxnDet_UserDeptArea_GetById]                      
(                      
 @Id INT                      
)                      
                       
AS                       
    -- Exec [LLSLinenInventoryTxnDet_UserDeptArea_GetById] 135                   
                    
--/*=====================================================================================================================                    
--APPLICATION  : UETrack                    
--NAME    : LLSLinenInventoryTxnDet_UserDeptArea                    
--DESCRIPTION  : LLSLinenInventoryTxnDet_UserDeptArea_GetById                    
--AUTHORS   : SIDDHANT                    
--DATE    : 13-FEB-2020                    
-------------------------------------------------------------------------------------------------------------------------                    
--VERSION HISTORY                     
--------------------:---------------:---------------------------------------------------------------------------------------                    
--Init    : Date          : Details                    
--------------------:---------------:---------------------------------------------------------------------------------------                    
--SIDDHANT           : 13-FEB-2020 :                     
-------:------------:----------------------------------------------------------------------------------------------------*/                    
                    
BEGIN                      
SET NOCOUNT ON                      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                      
BEGIN TRY                      
                       
SELECT         
 A.LinenInventoryId,      
 B.LinenItemId,      
 B.LinenCode,              
 B.LinenDescription,         
 A.InUse,              
 A.Shelf,              
 (A.InUse+A.Shelf) AS              
TotalPcs ,          
C.UserLocationCode,
C.UserAreaCode,
C.LLSUserAreaLocationId,
C.LLSUserAreaId,
A.LlsLinenInventoryTxnDetId          
FROM dbo.LLSLinenInventoryTxnDet A              
INNER JOIN dbo.LLSLinenItemDetailsMst B              
ON A.LinenItemId = B.LinenItemId   
INNER JOIN LLSUserAreaDetailsLocationMstDet C
ON A.LLSUserAreaLocationId=C.LLSUserAreaLocationId
WHERE LinenInventoryId=@ID     
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
