USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralLinenStoreHKeepingTxnDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================                
--APPLICATION  : UETrack 1.5                
--NAME    : LLSCentralLinenStoreHKeepingTxnDet_Update               
--DESCRIPTION  : UPDATE RECORD IN [LLSCentralLinenStoreHKeepingTxnDet] TABLE                 
--AUTHORS   : SIDDHANT                
--DATE    : 8-JAN-2020              
-------------------------------------------------------------------------------------------------------------------------                
--VERSION HISTORY                 
--------------------:---------------:---------------------------------------------------------------------------------------                
--Init    : Date          : Details                
--------------------:---------------:---------------------------------------------------------------------------------------                
--SIDDHANT          : 8-JAN-2020 :                 
-------:------------:----------------------------------------------------------------------------------------------------*/                
              
                
              
              
CREATE PROCEDURE  [dbo].[LLSCentralLinenStoreHKeepingTxnDet_Update]                                           
                
(         
@LLSCentralLinenStoreHKeepingTxnDet_Update AS [LLSCentralLinenStoreHKeepingTxnDet_Update] READONLY    
)                      
                
AS                      
                
BEGIN                
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                
BEGIN TRY                
            
DECLARE @Table TABLE (ID INT)                
              
UPDATE A              
SET              
 A.HousekeepingDone = B.HousekeepingDone,              
 A.Date =convert(date,B.[Date], 103) ,             
 DateTimeStamp = Format(GETDATE(), 'dd-MMM-yyyy hh:mm:ss'),              
 A.ModifiedBy = B.ModifiedBy,                 
 A.ModifiedDate =  GETDATE(),             
 A.ModifiedDateUTC =GETUTCDATE()    
FROM LLSCentralLinenStoreHKeepingTxnDet as A     
Inner join @LLSCentralLinenStoreHKeepingTxnDet_Update as B     
on A.HouseKeepingDetId= B.HouseKeepingDetId        
WHERE  A.HouseKeepingDetId = B.HouseKeepingDetId              
              
SELECT HouseKeepingDetId   ,          
HousekeepingDone,          
      Date          
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
