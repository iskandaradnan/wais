USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralLinenStoreHKeepingTxnDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================      
--APPLICATION  : UETrack 1.5      
--NAME    : LLSCentralLinenStoreHKeepingTxnDet_Save     
--DESCRIPTION  : SAVE RECORD IN [LLSCentralLinenStoreHKeepingTxnDet] TABLE       
--AUTHORS   : SIDDHANT      
--DATE    : 13-JAN-2020    
-------------------------------------------------------------------------------------------------------------------------      
--VERSION HISTORY       
--------------------:---------------:---------------------------------------------------------------------------------------      
--Init    : Date          : Details      
--------------------:---------------:---------------------------------------------------------------------------------------      
--SIDDHANT          : 13-JAN-2020 :       
-------:------------:----------------------------------------------------------------------------------------------------*/      
  
      
CREATE PROCEDURE  [dbo].[LLSCentralLinenStoreHKeepingTxnDet_Save]                                 
      
(      
 @Block As [dbo].[LLSCentralLinenStoreHKeepingTxnDet] READONLY      
)            
      
AS            
      
BEGIN      
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
BEGIN TRY      
    
DECLARE @Table TABLE (ID INT)      
INSERT INTO LLSCentralLinenStoreHKeepingTxnDet (    
 HouseKeepingId,    
 CustomerId,    
 FacilityId,     
 [Date],    
 HousekeepingDone,    
 DateTimeStamp,    
 CreatedBy,    
 CreatedDate,    
 CreatedDateUTC)    
 OUTPUT INSERTED.HouseKeepingDetId INTO @Table      
 SELECT HouseKeepingId,    
 CustomerId,    
 FacilityId,     
 [Date],    
 HousekeepingDone,    
 DateTimeStamp,    
CreatedBy,    
GETDATE(),    
GETUTCDATE()    
FROM @Block      
      
SELECT HouseKeepingDetId    
      ,[Timestamp]    
   ,'' ErrorMsg    
      --,GuId     
FROM LLSCentralLinenStoreHKeepingTxnDet WHERE HouseKeepingDetId IN (SELECT ID FROM @Table)      
      
END TRY      
BEGIN CATCH      
      
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)      
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());      
      
THROW      
      
END CATCH      
SET NOCOUNT OFF      
END  
GO
