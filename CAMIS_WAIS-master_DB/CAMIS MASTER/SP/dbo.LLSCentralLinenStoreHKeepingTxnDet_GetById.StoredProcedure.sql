USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralLinenStoreHKeepingTxnDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
          
              
CREATE PROCEDURE [dbo].[LLSCentralLinenStoreHKeepingTxnDet_GetById]              
(              
 @Id INT              
)              
               
AS               
    -- Exec [LLSCentralLinenStoreHKeepingTxnDet_GetById] 135           
            
--/*=====================================================================================================================            
--APPLICATION  : UETrack            
--NAME    : LLSCentralLinenStoreHKeepingTxnDet_GetById           
--DESCRIPTION  : GETS THE LLSCentralLinenStoreHKeepingTxnDet            
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
 CONVERT(VARCHAR, Date, 105) AS Date,           
 HousekeepingDone,          
 DateTimeStamp   ,      
 HouseKeepingDetId      
FROM  dbo.LLSCentralLinenStoreHKeepingTxnDet A          
INNER JOIN LLSCentralLinenStoreHKeepingTxn B        
ON A.HouseKeepingId=B.HouseKeepingId        
INNER JOIN dbo.FMLovMst  C            
ON B.StoreType =C.LovId                 
WHERE B.HouseKeepingId=@ID     
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
