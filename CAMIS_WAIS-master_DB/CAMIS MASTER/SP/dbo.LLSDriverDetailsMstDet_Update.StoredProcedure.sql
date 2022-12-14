USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSDriverDetailsMstDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================              
APPLICATION  : UETrack 1.5              
NAME    : LLSDriverDetailsMstDet_Update             
DESCRIPTION  : UPDATE RECORD IN [LLSDriverDetailsMstDet] TABLE               
AUTHORS   : SIDDHANT              
DATE    : 13-JAN-2020            
-----------------------------------------------------------------------------------------------------------------------              
VERSION HISTORY               
------------------:---------------:---------------------------------------------------------------------------------------              
Init    : Date          : Details              
------------------:---------------:---------------------------------------------------------------------------------------              
SIDDHANT          : 13-JAN-2020 :               
-----:------------:----------------------------------------------------------------------------------------------------*/              
            
              
            
            
              
CREATE PROCEDURE  [dbo].[LLSDriverDetailsMstDet_Update]                                         
              
(              
 @LLSDriverDetailsMstDet_Update AS LLSDriverDetailsMstDet_Update READONLY    
)                    
              
AS                    
              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
DECLARE @Table TABLE (ID INT)              
            
UPDATE A            
SET            
 A.LicenseTypeDetId = B.LicenseTypeDetId,            
 A.LicenseNo = B.LicenseNo,            
 A.ClassGrade = B.ClassGrade,            
 A.IssuedBy = B.IssuedBy,            
 A.IssuedDate = B.IssuedDate,            
 A.ExpiryDate = B.ExpiryDate,            
 A.ModifiedBy = B.ModifiedBy,            
 A.ModifiedDate = GETDATE(),            
 A.ModifiedDateUTC = GETUTCDATE()      
 FROM LLSDriverDetailsMstDet A     
 INNER JOIN @LLSDriverDetailsMstDet_Update B    
 ON A.LicenseTypeDetId=B.LicenseTypeDetId    
WHERE A.DriverId = B.DriverId            
            
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
