USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRepairTxn_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================            
--APPLICATION  : UETrack 1.5            
--NAME    : SaveUserAreaDetailsLLS           
--DESCRIPTION  : UPDATE RECORD IN [LLSLinenRepairTxn] TABLE             
--AUTHORS   : SIDDHANT            
--DATE    : 17-JAN-2020          
-------------------------------------------------------------------------------------------------------------------------            
--VERSION HISTORY             
--------------------:---------------:---------------------------------------------------------------------------------------            
--Init    : Date          : Details            
--------------------:---------------:---------------------------------------------------------------------------------------            
--SIDDHANT          : 8-JAN-2020 :             
-------:------------:----------------------------------------------------------------------------------------------------*/            
          
            
          
          
            
CREATE PROCEDURE  [dbo].[LLSLinenRepairTxn_Update]                                       
            
(            
 @Remarks AS NVARCHAR(1000) NULL=NULL        
,@LinenRepairId AS INT        
,@ModifiedBy AS INT
)                  
            
AS                  
            
BEGIN            
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY            
          
DECLARE @Table TABLE (ID INT)            
          
UPDATE          
 LLSLinenRepairTxn          
SET          
 Remarks = @Remarks,          
 ModifiedBy = @ModifiedBy,          
 ModifiedDate = GETDATE(),          
 ModifiedDateUTC = GETUTCDATE()          
WHERE LinenRepairId = @LinenRepairId          
          
          
SELECT LinenRepairId          
      ,[Timestamp]          
   ,'' ErrorMsg          
      --,GuId           
FROM LLSLinenRepairTxn WHERE LinenRepairId IN (SELECT ID FROM @Table)            
            
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
END
GO
