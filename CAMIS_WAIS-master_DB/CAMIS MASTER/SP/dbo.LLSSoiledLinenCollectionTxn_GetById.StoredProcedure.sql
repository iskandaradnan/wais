USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSSoiledLinenCollectionTxn_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                              
                                  
CREATE PROCEDURE [dbo].[LLSSoiledLinenCollectionTxn_GetById]                                  
(                                  
 @Id INT                                  
)                                  
                                   
AS                                   
    -- Exec [LLSSoiledLinenCollectionTxn_GetById] 159                               
                                
--/*=====================================================================================================================                                
--APPLICATION  : UETrack                                
--NAME    : LLSSoiledLinenCollectionTxn_GetById                               
--DESCRIPTION  : GETS THE LLSSoiledLinenCollectionTxn                                
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
                                   
SELECT A.SoiledLinenCollectionId,                            
 A.DocumentNo,                              
 A.CollectionDate,                              
 SUM(B.Weight) as TotalWeight,                              
 C.LaundryPlantId,                              
 D.FieldValue AS Ownership,                              
 A.DespatchDate,        
 A.GuId,      
 SUM(B.TotalWhiteBag) as TotalWhiteBag,                              
 SUM(B.TotalRedBag) as TotalRedBag,                              
 SUM(B.TotalGreenBag) as TotalGreenBag ,                
 SUM(B.TotalBrownBag) as TotalBrownBag                           
                              
FROM dbo.LLSSoiledLinenCollectionTxn A                              
INNER JOIN dbo.LLSSoiledLinenCollectionTxnDet B                              
ON A.SoiledLinenCollectionId=B.SoiledLinenCollectionId                              
INNER JOIN dbo.LLSLaundryPlantMst C                              
ON A.LaundryPlantId=C.LaundryPlantId                              
INNER JOIN dbo.FMLovMst D                               
ON C.Ownership = D.LovId                              
WHERE A.SoiledLinenCollectionId =@Id                              
AND ISNULL(A.IsDeleted,'')=''                
AND ISNULL(C.IsDeleted,'')=''                
AND ISNULL(B.IsDeleted,'')=''                
GROUP BY                              
A.SoiledLinenCollectionId,     
A.DocumentNo,                              
A.CollectionDate,                              
C.LaundryPlantId,                              
A.DespatchDate,        
A.GuId,      
C.Ownership,                              
D.FieldValue                              
                              
                              
                              
                              
END TRY                                  
BEGIN CATCH                                  
                                  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                                  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                                  
                            
THROW                                  
                                  
END CATCH                                  
SET NOCOUNT OFF                                  
END
GO
