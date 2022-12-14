USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSSoiledLinenCollectionTxnDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================                            
--APPLICATION  : UETrack 1.5                            
--NAME    : SaveUserAreaDetailsLLS                           
--DESCRIPTION  : UPDATE RECORD IN [LLSSoiledLinenCollectionTxnDet] TABLE                             
--AUTHORS   : SIDDHANT                            
--DATE    : 8-JAN-2020                          
-------------------------------------------------------------------------------------------------------------------------                            
--VERSION HISTORY                             
--------------------:---------------:---------------------------------------------------------------------------------------                            
--Init    : Date          : Details                            
--------------------:---------------:---------------------------------------------------------------------------------------                            
--SIDDHANT          : 8-JAN-2020 :                             
-------:------------:----------------------------------------------------------------------------------------------------*/                            
                          
                            
--DROP PROCEDURE  LLSSoiledLinenCollectionTxnDet_Update                         
                          
                            
CREATE PROCEDURE  [dbo].[LLSSoiledLinenCollectionTxnDet_Update]                                                        
                            
(                            
-- @LLSUserAreaId AS INT                        
--,@LLSUserAreaLocationId AS INT                        
--,@Weight AS NUMERIC(24,2)                        
--,@TotalWhiteBag AS INT                        
--,@TotalRedBag AS INT                        
--,@TotalGreenBag AS INT                  
--,@TotalQuantity AS INT                   
--,@CollectionSchedule AS INT                        
--,@CollectionStartTime AS DATETIME                        
--,@CollectionEndTime AS DATETIME                        
--,@CollectionTime AS DATETIME                        
--,@OnTime AS INT                        
--,@VerifiedBy AS INT                        
--,@VerifiedDate AS nvarchar(25)                        
--,@Remarks AS NVARCHAR(1000)                     
--,@SoiledLinenCollectionDetId AS  INT                        
@LLSSoiledLinenCollectionTxnDet_Update AS [LLSSoiledLinenCollectionTxnDet_Update] READONLY          
)                                  
                            
AS                                  
                            
BEGIN                            
SET NOCOUNT ON                            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                            
BEGIN TRY                            
                          
DECLARE @Table TABLE (ID INT)                            
                          
UPDATE A                          
SET                          
 A.LLSUserAreaId = B.LLSUserAreaId,                          
 A.LLSUserAreaLocationId = B.LLSUserAreaLocationId,                          
 A.Weight = B.Weight,                          
 A.TotalWhiteBag = B.TotalWhiteBag,                          
 A.TotalRedBag = B.TotalRedBag,                          
 A.TotalGreenBag = B.TotalGreenBag,                          
 --TotalQuantity = TotalWhiteBag + TotalRedBag + TotalGreenRBag,                    
 A.TotalQuantity=B.TotalQuantity,                
 A.CollectionSchedule = B.CollectionSchedule,                          
 A.CollectionStartTime = B.CollectionStartTime,                          
 A.CollectionEndTime = B.CollectionEndTime,                          
 A.CollectionTime = B.CollectionTime,                          
 A.OnTime = B.OnTime,                          
 A.TotalBrownBag=B.BrownBag,    
 A.VerifiedBy = B.VerifiedBy,                           
 --VerifiedDate =B.VerifiedDate,              
 A.Remarks = B.Remarks,                          
 A.ModifiedBy = B.ModifiedBy,                          
 A.ModifiedDate = GETDATE(),                          
 A.ModifiedDateUTC = GETUTCDATE()                    
 --IsDeleted = 0                    
FROM LLSSoiledLinenCollectionTxnDet as A     
INNER JOIN @LLSSoiledLinenCollectionTxnDet_Update     
AS B ON A.SoiledLinenCollectionDetId= B.SoiledLinenCollectionDetId        
WHERE A.SoiledLinenCollectionDetId = B.SoiledLinenCollectionDetId                          
                          
SELECT SoiledLinenCollectionDetId                          
      ,[Timestamp]                          
      ,'' ErrorMsg                        --,GuId                           
FROM LLSSoiledLinenCollectionTxnDet WHERE SoiledLinenCollectionDetId IN (SELECT ID FROM @Table)                            
                            
END TRY                            
BEGIN CATCH                            
                            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                            
                            
THROW                            
                            
END CATCH                            
SET NOCOUNT OFF                            
END 
GO
