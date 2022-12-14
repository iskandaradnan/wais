USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSVehicleDetailsMst_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================              
--APPLICATION  : UETrack 1.5              
--NAME    : LLSVehicleDetailsMst_Save             
--DESCRIPTION  : SAVE RECORD IN [LLSVehicleDetailsMst] TABLE               
--AUTHORS   : SIDDHANT              
--DATE    : 13-JAN-2020            
-------------------------------------------------------------------------------------------------------------------------              
--VERSION HISTORY               
--------------------:---------------:---------------------------------------------------------------------------------------              
--Init    : Date          : Details              
--------------------:---------------:---------------------------------------------------------------------------------------              
--SIDDHANT          : 13-JAN-2020 :               
-------:------------:----------------------------------------------------------------------------------------------------*/              
              
          
            
CREATE PROCEDURE  [dbo].[LLSVehicleDetailsMst_Save]                                         
              
(              
 @Block As [dbo].[LLSVehicleDetailsMst] READONLY              
)                    
              
AS                    
              
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
DECLARE @Table TABLE (ID INT)              
INSERT INTO LLSVehicleDetailsMst (          
 CustomerId,          
 FacilityId,          
 VehicleNo,          
 Model,          
 Manufacturer,          
 LaundryPlantId,          
 Status,          
 EffectiveFrom,      
 EffectiveTo,    
 LoadWeight,          
 CreatedBy,          
 CreatedDate,          
 CreatedDateUTC,  
 ModifiedBy,    
ModifiedDate,    
ModifiedDateUTC   
)  
           
            
 OUTPUT INSERTED.VehicleId INTO @Table              
 SELECT   CustomerId,          
 FacilityId,          
 VehicleNo,          
 Model,          
 Manufacturer,          
 LaundryPlantId,          
 Status,          
 EffectiveFrom,    
 EffectiveTo,    
 LoadWeight,          
CreatedBy,            
GETDATE(),            
GETUTCDATE(),   
ModifiedBy,        
GETDATE(),        
GETUTCDATE()            
FROM @Block              
              
SELECT VehicleId            
      ,[Timestamp]            
   ,'' ErrorMsg            
      --,GuId             
FROM LLSVehicleDetailsMst WHERE VehicleId IN (SELECT ID FROM @Table)              
              
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
END
GO
