USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSDriverDetailsMst_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----/*=====================================================================================================================          
--APPLICATION  : UETrack 1.5          
--NAME    : LLSDriverDetailsMst_Update         
--DESCRIPTION  : UPDATE RECORD IN [LLSDriverDetailsMst] TABLE           
--AUTHORS   : SIDDHANT          
--DATE    : 8-JAN-2020        
-------------------------------------------------------------------------------------------------------------------------          
--VERSION HISTORY           
--------------------:---------------:---------------------------------------------------------------------------------------          
--Init    : Date          : Details          
--------------------:---------------:---------------------------------------------------------------------------------------          
--SIDDHANT          : 8-JAN-2020 :           
-------:------------:----------------------------------------------------------------------------------------------------*/          
        
          
        
        
          
CREATE PROCEDURE  [dbo].[LLSDriverDetailsMst_Update]                                     
          
(          
 @LaundryPlantId AS INT      
,@DriverName AS VARCHAR(100)      
,@Status AS INT      
,@EffectiveFrom DATETIME      
,@ContactNo NVARCHAR(300)  NULL=NULL      
,@ICNo AS NVARCHAR(40)   NULL=NULL      
,@DriverId AS INT   
,@ModifiedBy AS INT 
)                
          
AS                
          
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
        
DECLARE @Table TABLE (ID INT)          
        
UPDATE LLSDriverDetailsMst        
SET        
 LaundryPlantId = @LaundryPlantId,        
 DriverName = @DriverName,        
 Status = @Status,        
 EffectiveFrom = @EffectiveFrom,        
 ContactNo = @ContactNo,        
 ICNo = @ICNo,        
 ModifiedBy = @ModifiedBy,        
 ModifiedDate = GETDATE(),        
 ModifiedDateUTC = GETUTCDATE()        
WHERE DriverId = @DriverId         
        
SELECT DriverId        
      ,[Timestamp]        
   ,'' ErrorMsg        
      --,GuId         
FROM LLSDriverDetailsMst WHERE DriverId IN (SELECT ID FROM @Table)          
          
END TRY          
BEGIN CATCH          
          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());          
          
THROW          
          
END CATCH          
SET NOCOUNT OFF          
END
GO
