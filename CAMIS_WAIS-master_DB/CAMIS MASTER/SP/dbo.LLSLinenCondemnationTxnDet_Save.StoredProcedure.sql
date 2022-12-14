USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenCondemnationTxnDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================            
--APPLICATION  : UETrack 1.5            
--NAME    : LLSLinenCondemnationTxnDet_Save           
--DESCRIPTION  : SAVE RECORD IN [LLSLinenCondemnationTxnDet] TABLE             
--AUTHORS   : SIDDHANT            
--DATE    : 8-JAN-2020          
-------------------------------------------------------------------------------------------------------------------------            
--VERSION HISTORY             
--------------------:---------------:---------------------------------------------------------------------------------------            
--Init    : Date          : Details            
--------------------:---------------:---------------------------------------------------------------------------------------            
--SIDDHANT          : 8-JAN-2020 :             
-------:------------:----------------------------------------------------------------------------------------------------*/            
         
            
CREATE PROCEDURE  [dbo].[LLSLinenCondemnationTxnDet_Save]                                       
            
(            
 @Block As [dbo].[LLSLinenCondemnationTxnDet] READONLY            
)                  
            
AS                  
            
BEGIN            
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY            
          
DECLARE @Table TABLE (ID INT)            
          
INSERT INTO LLSLinenCondemnationTxnDet (          
 LinenCondemnationId,          
 CustomerId,          
 FacilityId,          
 LinenItemId,          
 BatchNo,          
 Total,          
 Torn,          
 Stained,          
 Faded,          
 Vandalism,          
 WearTear,          
 StainedByChemical,          
 CreatedBy,          
 CreatedDate,          
 CreatedDateUTC      
 )            
          
          
OUTPUT INSERTED.LinenCondemnationDetId INTO @Table            
SELECT LinenCondemnationId,          
 CustomerId,          
 FacilityId,          
 LinenItemId,          
 BatchNo,          
 Torn+Stained+Faded+Vandalism+WearTear+StainedByChemical AS Total,          
 Torn,          
 Stained,          
 Faded,          
 Vandalism,          
 WearTear,          
 StainedByChemical,          
CreatedBy,          
GETDATE(),          
GETUTCDATE()      
  
FROM @Block            
            
SELECT LinenCondemnationDetId          
      ,[Timestamp]          
   ,'' ErrorMsg          
      --,GuId           
FROM LLSLinenCondemnationTxnDet WHERE LinenCondemnationDetId IN (SELECT ID FROM @Table)            
            
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
END 
GO
