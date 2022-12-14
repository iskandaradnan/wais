USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSSoiledLinenCollectionTxnDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================                          
--APPLICATION  : UETrack 1.5                          
--NAME    : LLSLinenItemDetailsMst_Save                         
--DESCRIPTION  : SAVE RECORD IN [LLSSoiledLinenCollectionTxnDet] TABLE                           
--AUTHORS   : SIDDHANT                          
--DATE    : 16-JAN-2020                        
-------------------------------------------------------------------------------------------------------------------------                          
--VERSION HISTORY                           
--------------------:---------------:---------------------------------------------------------------------------------------                          
--Init    : Date          : Details                          
--------------------:---------------:---------------------------------------------------------------------------------------                          
--SIDDHANT          : 16-JAN-2020 :                           
-------:------------:----------------------------------------------------------------------------------------------------*/                          
  
 --DROP PROCEDURE  [LLSSoiledLinenCollectionTxnDet_Save]
                       
                          
CREATE PROCEDURE  [dbo].[LLSSoiledLinenCollectionTxnDet_Save]                                                     
                          
(                          
 @Block As [dbo].[LLSSoiledLinenCollectionTxnDet] READONLY                          
)                                
                          
AS                                
                          
BEGIN                          
SET NOCOUNT ON                          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                          
BEGIN TRY                          
                        
DECLARE @Table TABLE (ID INT)                          
 INSERT INTO LLSSoiledLinenCollectionTxnDet (                        
 SoiledLinenCollectionId,                        
 CustomerId,                        
 FacilityId,                        
 LLSUserAreaId,                        
 LLSUserAreaLocationId,                        
 Weight,                        
 TotalWhiteBag,                        
 TotalRedBag,                        
 TotalGreenBag,                        
 TotalBrownBag,  
 TotalQuantity,                        
 CollectionSchedule,                        
 CollectionStartTime,                        
 CollectionEndTime,                         
 CollectionTime,                        
 OnTime,                        
 VerifiedBy,                        
 VerifiedDate,                        
 Remarks,                        
 CreatedBy,                        
 CreatedDate,                        
 CreatedDateUTC      
       
 )                        
                        
OUTPUT INSERTED.SoiledLinenCollectionDetId INTO @Table                          
SELECT   SoiledLinenCollectionId,                        
 CustomerId,                        
 FacilityId,                        
 LLSUserAreaId,                        
 LLSUserAreaLocationId,                        
 Weight,                        
 TotalWhiteBag,                        
 TotalRedBag,                        
 TotalGreenBag,  
 TotalBrownBag,  
 TotalWhiteBag + TotalRedBag + TotalGreenBag+TotalBrownBag AS TotalQuantity,                     ---BROWN BAG ADDED 10062020   
 CollectionSchedule,                        
 CollectionStartTime,                        
 CollectionEndTime,                         
 CollectionTime,                        
 OnTime,                        
 VerifiedBy,                        
 VerifiedDate,                        
 Remarks,                        
CreatedBy,                        
GETDATE(),                        
GETUTCDATE()      
     
        
FROM @Block                          
            
SELECT SoiledLinenCollectionDetId                        
      ,[Timestamp]                        
   ,'' ErrorMsg                        
      --,GuId                         
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
