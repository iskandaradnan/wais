USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSSoiledLinenCollectionTxnDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                      
                                    
                                    
                                                             
CREATE PROCEDURE [dbo].[LLSSoiledLinenCollectionTxnDet_GetById]                                             
(                                            
 @Id INT                                            
)                                            
                                             
AS                                             
    -- Exec [LLSSoiledLinenCollectionTxnDet_GetById ] 145                                   
                                  --SELECT * FROM LLSSoiledLinenCollectionTxnDet        
--/*=====================================================================================================================                                          
--APPLICATION  : UETrack                                          
--NAME    : LLSSoiledLinenCollectionTxnDet_GetById                                          
--DESCRIPTION  : GETS THE LLSSoiledLinenCollectionTxnDet                                        
--AUTHORS   : SIDDHANT                                          
--DATE    : 8-JAN-2020                                          
-------------------------------------------------------------------------------------------------------------------------                                          
--VERSION HISTORY                                           
--------------------:---------------:---------------------------------------------------------------------------------------                                          
--Init    : Date          : Details                                          
--------------------:---------------:---------------------------------------------------------------------------------------                                          
--SIDDHANT           : 8-JAN-2020 :                                           
-------:------------:----------------------------------------------------------------------------------------------------*/                                          
                                          
BEGIN                                            
SET NOCOUNT ON                                            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                            
BEGIN TRY                                            
                                             
SELECT A.SoiledLinenCollectionId,                
       B.UserAreaCode,                                         
       C.UserLocationCode,                                        
       A.Weight,                                        
    A.TotalWhiteBag,                                        
    A.TotalRedBag,                                        
       A.TotalGreenBag,  
	   A.TotalBrownBag,                                     
(A.TotalWhiteBag +                                        
A.TotalRedBag +                                        
A.TotalGreenBag+
A.TotalBrownBag) as TotalQuantity,                                        
 FMLovMst1.LovId as CollectionSchedule,                                        
-- CASE                                        
-- WHEN FMLovMst1.LovId = 10157 THEN                                        
--C.[1stScheduleStartTime]                                        
-- WHEN FMLovMst1.LovId = 10158 THEN                                        
--C.[2ndScheduleStartTime]                                        
-- WHEN FMLovMst1.LovId = 10159 THEN                                        
--C.[3rdScheduleStartTime]                                        
-- END AS CollectionStartTime,                                        
-- CASE                                        
-- WHEN FMLovMst1.LovId = 10157 THEN                                        
--C.[1stScheduleEndTime]                                        
-- WHEN FMLovMst1.LovId = 10158 THEN                                        
--C.[2ndScheduleEndTime]                                        
-- WHEN FMLovMst1.LovId = 10159 THEN                                        
--C.[3rdScheduleEndTime]              
-- END AS CollectionEndTime,                                        
     
 A.[CollectionStartTime],    
 A.[CollectionEndTime],    
    
 A.[CollectionTime],                                        
 FMLovMst2.LovId as OnTime,                                        
 D.StaffName as VerifiedBy,                                        
 A.VerifiedDate,                                        
 A.Remarks ,                  
 A.SoiledLinenCollectionDetId,                          
 A.LLSUserAreaId,                          
A.LLSUserAreaLocationId  ,                        
 D.UserRegistrationId  as Verified                                    
FROM dbo.LLSSoiledLinenCollectionTxnDet A                                        
INNER JOIN  dbo.LLSUserAreaDetailsMst B                                    
ON A.LLSUserAreaId =B.LLSUserAreaId                                        
INNER JOIN dbo.LLSUserAreaDetailsLocationMstDet C                                
ON A.LLSUserAreaLocationId=C.LLSUserAreaLocationId                                        
INNER JOIN dbo.FMLovMst AS FMLovMst1                                         
ON A.CollectionSchedule = FMLovMst1.LovId                                        
INNER JOIN dbo.FMLovMst AS FMLovMst2                                         
ON A.OnTime =FMLovMst2.LovId                                        
INNER JOIN dbo.UMUserRegistration D                                         
ON A.VerifiedBy=D.UserRegistrationId                              
WHERE SoiledLinenCollectionId=@Id        
AND (A.IsDeleted IS NULL OR A.IsDeleted= 0)         
AND C.LinenSchedule=10079    
          
                                        
END TRY                                            
BEGIN CATCH                                            
                                           
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                                            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                                            
                                            
THROW                                            
                                            
END CATCH                                            
SET NOCOUNT OFF                                            
END                         
    
    
GO
