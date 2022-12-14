USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRM_BemsAsset_Fetch]    Script Date: 20-01-2022 16:08:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : [uspFM_CRM_BemsAsset_Fetch]    
Description   : Asset number fetch control    
Authors    :Srinivas Gangula    
Date    : 29-July-2020    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
EXEC [uspFM_CRM_BemsAsset_Fetch]  @pAssetNo='a',@pFacilityId=144 ,@pPageIndex=1,   @pPageSize=5
    
SELECT * FROM EngAsset where Manufacturer=3 and Model=1 and FacilityId=1    
    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
========================================================================================================*/    
DROP PROCEDURE  [dbo].[uspFM_CRM_BemsAsset_Fetch]      
GO
CREATE PROCEDURE  [dbo].[uspFM_CRM_BemsAsset_Fetch]                               
                                
  @pAssetNo     NVARCHAR(100) = NULL,    
  @pManufacturerId   NVARCHAR(100) = NULL,    
  @pModelId   INT    = NULL,    
  @pFacilityId    INT ,  
  @pPageIndex    INT,                         
 @pPageSize    INT     
    
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
  FROM  EngAsset          AS Asset    WITH(NOLOCK)    
     INNER JOIN EngAssetStandardizationManufacturer AS Manufacturer  WITH(NOLOCK) ON Asset.Manufacturer    = Manufacturer.ManufacturerId    
     INNER JOIN EngAssetStandardizationModel  AS Model    WITH(NOLOCK) ON Asset.Model      = Model.ModelId    
  WHERE  Asset.Active =1 AND Asset.AssetStatusLovId <>2    
     AND ((ISNULL(@pAssetNo,'')='' )  OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))    
     AND ((ISNULL(@pManufacturerId,'')='' )  OR (ISNULL(@pManufacturerId,'') <> '' AND Asset.Manufacturer =  + @pManufacturerId ))    
     AND ((ISNULL(@pModelId,'')='' )  OR (ISNULL(@pModelId,'') <> '' AND Asset.Model =  + @pModelId ))    
     AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))    
    
  SELECT  Asset.AssetId,    
     Asset.AssetNo,    
     Asset.AssetDescription,    
     Asset.Manufacturer  AS ManufacturerId,    
     Manufacturer.Manufacturer,    
     Asset.Model    AS ModelId,    
     Model.Model,    
     Asset.SoftwareVersion,    
     Asset.SoftwareKey,    
     Asset.SerialNo,    
	 Loc.UserLocationId,
	 Loc.UserLocationCode,
	 Loc.UserLocationName,
	 Loc.UserAreaId,
					UserArea.UserAreaCode,
					UserArea.UserAreaName,
					Level.LevelCode,
					Level.LevelName,
					Block.BlockCode,
					Block.BlockName,
     @TotalRecords AS TotalRecords    
  FROM  EngAsset          AS Asset    WITH(NOLOCK)    
     INNER JOIN EngAssetStandardizationManufacturer AS Manufacturer  WITH(NOLOCK) ON Asset.Manufacturer    = Manufacturer.ManufacturerId    
     INNER JOIN EngAssetStandardizationModel  AS Model    WITH(NOLOCK) ON Asset.Model      = Model.ModelId  
	 INNER JOIN MstLocationUserLocation  AS Loc WITH(NOLOCK) ON Asset.UserLocationId=loc.UserLocationId
	 INNER JOIN	MstLocationUserArea				AS UserArea		WITH(NOLOCK) ON loc.UserAreaId=UserArea.UserAreaId
	 INNER JOIN MstLocationLevel		AS	Level	 WITH(NOLOCK)	ON	UserArea.LevelId		=	Level.LevelId
	 INNER JOIN MstLocationBlock		AS	Block	 WITH(NOLOCK)	ON	Level.BlockId			=	Block.BlockId
  WHERE  Asset.Active =1 AND Asset.AssetStatusLovId <>2    
     AND ((ISNULL(@pAssetNo,'')='' )  OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))    
     AND ((ISNULL(@pManufacturerId,'')='' )  OR (ISNULL(@pManufacturerId,'') <> '' AND Asset.Manufacturer =  + @pManufacturerId ))    
     AND ((ISNULL(@pModelId,'')='' )  OR (ISNULL(@pModelId,'') <> '' AND Asset.Model =  + @pModelId ))    
     AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))    
  ORDER BY Asset.ModifiedDateUTC DESC    
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