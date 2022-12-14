USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSDriverDetailsMstDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================          
APPLICATION  : UETrack 1.5          
NAME    : LLSDriverDetailsMstDet_Save         
DESCRIPTION  : SAVE RECORD IN [LLSDriverDetailsMstDet] TABLE           
AUTHORS   : SIDDHANT          
DATE    : 13-JAN-2020        
-----------------------------------------------------------------------------------------------------------------------          
VERSION HISTORY           
------------------:---------------:---------------------------------------------------------------------------------------          
Init    : Date          : Details          
------------------:---------------:---------------------------------------------------------------------------------------          
SIDDHANT          : 13-JAN-2020 :           
-----:------------:----------------------------------------------------------------------------------------------------*/          
          
      
CREATE PROCEDURE  [dbo].[LLSDriverDetailsMstDet_Save]                                     
          
(          
 @Block As [dbo].[LLSDriverDetailsMstDet] READONLY          
)                
          
AS                
          
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
        
DECLARE @Table TABLE (ID INT)          
 INSERT INTO LLSDriverDetailsMstDet (        
 DriverId,        
 CustomerId,        
 FacilityId,        
 LicenseTypeDetId,        
 LicenseNo,        
 ClassGrade,        
 IssuedBy,        
 IssuedDate,        
 ExpiryDate,        
 CreatedBy,        
 CreatedDate,        
 CreatedDateUTC,    
 IsDeleted    
 )         
     
    
        
OUTPUT INSERTED.DriverDetId INTO @Table          
SELECT   DriverId,        
 CustomerId,        
 FacilityId,        
 LicenseTypeDetId,        
 LicenseNo,        
 ClassGrade,        
 IssuedBy,        
 IssuedDate,        
 ExpiryDate,        
CreatedBy,        
GETDATE(),        
GETUTCDATE(),    
0    
FROM @Block          
          
SELECT DriverDetId        
      ,[Timestamp]        
   ,'' ErrorMsg        
      --,GuId         
FROM LLSDriverDetailsMstDet WHERE DriverDetId IN (SELECT ID FROM @Table)          
          
END TRY          
BEGIN CATCH          
          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());          
          
THROW          
          
END CATCH          
SET NOCOUNT OFF          
END    
GO
