USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralCleanLinenStoreMst_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LLSCentralCleanLinenStoreMst_GetById]              
(              
 @Id INT              
)              
               
AS               
              
-- Exec [LLSCentralCleanLinenStoreMst_GetById] 7               
              
--/*=====================================================================================================================              
--APPLICATION  : UETrack              
--NAME    : GetAreaDetails              
--DESCRIPTION  : GET USER ROLE FOR THE GIVEN ID              
--AUTHORS   : BIJU NB              
--DATE    : 20-March-2018              
-------------------------------------------------------------------------------------------------------------------------              
--VERSION HISTORY               
--------------------:---------------:---------------------------------------------------------------------------------------              
--Init    : Date          : Details              
--------------------:---------------:---------------------------------------------------------------------------------------              
--BIJU NB           : 20-March-2018 :               
-------:------------:----------------------------------------------------------------------------------------------------*/              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
               
SELECT            
FMLovMst1.LovId AS StoreType , C.StockLevel,C.Par1,C.Par2,C.StoreBalance,C.ReorderQuantity           
FROM dbo.LLSCentralCleanLinenStoreMst A            
INNER JOIN dbo.FMLovMst AS FMLovMst1             
ON A.StoreType = FMLovMst1.LovId     
INNER JOIN LLSCentralCleanLinenStoreMstDet C    
ON A.CCLSId=c.CCLSId    
WHERE A.StoreType= @Id    
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
