USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSVehicleDetailsMstDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================                
--APPLICATION  : UETrack 1.5                
--NAME    : LLSVehicleDetailsMstDet_Update               
--DESCRIPTION  : UPDATE RECORD IN [LLSVehicleDetailsMstDet] TABLE                 
--AUTHORS   : SIDDHANT                
--DATE    : 8-JAN-2020              
-------------------------------------------------------------------------------------------------------------------------                
--VERSION HISTORY                 
--------------------:---------------:---------------------------------------------------------------------------------------                
--Init    : Date          : Details                
--------------------:---------------:---------------------------------------------------------------------------------------                
--SIDDHANT          : 8-JAN-2020 :                 
-------:------------:----------------------------------------------------------------------------------------------------*/                
              
                
              
              
                
CREATE PROCEDURE  [dbo].[LLSVehicleDetailsMstDet_Update]                                           
                
(                
 @LLSVehicleDetailsMstDet_Update AS [LLSVehicleDetailsMstDet_Update] READONLY    
)                      
                
AS                      
                
BEGIN                
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                
BEGIN TRY                
              
DECLARE @Table TABLE (ID INT)                
              
UPDATE  A             
SET   
 A.LicenseTypeDetId = B.LicenseTypeDetId,              
 A.LicenseNo = B.LicenseNo,              
 A.ClassGrade= B.ClassGrade,              
 A.IssuedBy = B.IssuedBy,              
 A.IssuedDate = B.IssuedDate,              
 A.ExpiryDate= B.ExpiryDate,              
 A.ModifiedBy = B.ModifiedBy,              
 A.ModifiedDate = GETDATE(),              
 A.ModifiedDateUTC = GETUTCDATE()              
FROM LLSVehicleDetailsMstDet as A Inner join @LLSVehicleDetailsMstDet_Update as B on A.VehicleDetId= B.VehicleDetId  
WHERE A.VehicleDetId= B.VehicleDetId             
              
SELECT VehicleDetId              
      ,[Timestamp]              
   ,'' ErrorMsg              
      --,GuId               
FROM LLSVehicleDetailsMstDet WHERE VehicleDetId IN (SELECT ID FROM @Table)                
                
END TRY                
BEGIN CATCH                
                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                
                
THROW                
                
END CATCH                
SET NOCOUNT OFF                
END
GO
