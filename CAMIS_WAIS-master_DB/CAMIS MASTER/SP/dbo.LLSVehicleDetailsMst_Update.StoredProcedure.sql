USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSVehicleDetailsMst_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================                    
APPLICATION  : UETrack 1.5                    
NAME    : LLSVehicleDetailsMst_Update                    
DESCRIPTION  : UPDATE RECORD IN [LLSVehicleDetailsMst] TABLE                     
AUTHORS   : SIDDHANT                    
DATE    : 13-JAN-2020                  
-----------------------------------------------------------------------------------------------------------------------                    
VERSION HISTORY                     
------------------:---------------:---------------------------------------------------------------------------------------                    
Init    : Date          : Details                    
------------------:---------------:---------------------------------------------------------------------------------------                    
SIDDHANT          : 13-JAN-2020 :                     
-----:------------:----------------------------------------------------------------------------------------------------*/                    
                  
                    
                  
                  
                    
CREATE PROCEDURE  [dbo].[LLSVehicleDetailsMst_Update]                                               
                    
(                     
 @PModel AS NVARCHAR(50) NULL=NULL             
,@Manufacturer AS INT                
,@LaundryPlantId AS INT                
,@Status AS INT                
,@EffectiveFrom AS DATETIME                
,@LoadWeight AS NUMERIC(24,2)  NULL=NULL              
,@VehicleId AS INT               
,@ModifiedBy AS INT                
)                          
                    
AS                          
                    
BEGIN                    
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY                    
                  
DECLARE @Table TABLE (ID INT)                    
                  
UPDATE LLSVehicleDetailsMst                  
SET                  
 Model = @PModel,                  
 Manufacturer = @Manufacturer,                  
 LaundryPlantId = @LaundryPlantId,                  
 Status = @Status,                  
 EffectiveFrom= @EffectiveFrom,                  
 LoadWeight= @LoadWeight,                  
 ModifiedBy = @ModifiedBy,                  
 ModifiedDate = GETDATE(),                  
 ModifiedDateUTC = GETUTCDATE()                  
WHERE VehicleId = @VehicleId                   
                  
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
