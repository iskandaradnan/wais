USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetStandardizationManufacturer_Fetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


    
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : uspFM_EngAssetStandardizationManufacturer_Fetch    
Description   : Manufacturer search popup    
Authors    : Balaji M S    
Date    : 02-April-2018    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
EXEC uspFM_EngAssetStandardizationManufacturer_Fetch  @pManufacturer='No',@pPageIndex=1,@pPageSize=5    
    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
========================================================================================================*/    
CREATE PROCEDURE  [dbo].[uspFM_EngAssetStandardizationManufacturer_Fetch]                               
  @pManufacturer  NVARCHAR(100) = NULL,    
  @pPageIndex   INT,    
  @pPageSize   INT,  
  @pServiceId INT  
AS                                                  
    
BEGIN TRY    
    
-- Paramter Validation     
    
 SET NOCOUNT ON;     
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    
-- Declaration    
    
 DECLARE @TotalRecords INT    
    
-- Default Values    
    
    
-- Execution    
  SELECT  @TotalRecords = COUNT(*)    
  FROM  EngAssetStandardizationManufacturer      AS Manufacturer WITH(NOLOCK)    
  WHERE  Manufacturer.Active =1    
     AND ((ISNULL(@pManufacturer,'')='' ) OR ( ISNULL(@pManufacturer,'') <> ''  AND Manufacturer LIKE '%' + @pManufacturer + '%'))    
    
  SELECT  Manufacturer.ManufacturerId,    
     Manufacturer.Manufacturer,    
     @TotalRecords AS TotalRecords    
  FROM  EngAssetStandardizationManufacturer      AS Manufacturer WITH(NOLOCK)    
  WHERE  Manufacturer.Active =1  AND ServiceID= @pServiceId  
     AND ((ISNULL(@pManufacturer,'')='' ) OR ( ISNULL(@pManufacturer,'') <> ''  AND Manufacturer LIKE '%' + @pManufacturer + '%'))    
  ORDER BY Manufacturer.ModifiedDateUTC DESC    
  OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY     
    
END TRY    
    
BEGIN CATCH    
    
 INSERT INTO ErrorLog(    
    Spname,    
    ErrorMessage,    
    createddate)    
 VALUES(  OBJECT_NAME(@@PROCID),    
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),    
    getdate()    
     )    
    
END CATCH

GO
