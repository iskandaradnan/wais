USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_Mobile_Fetch_BIS]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
      
/*========================================================================================================      
Application Name : UETrack-BEMS                    
Version    : 1.0      
Procedure Name  : [uspFM_EngAsset_Mobile_Fetch_BIS]      
Description   : Asset number info      
Authors    : deepak A      
Date    : 13-Aug-2018      
-----------------------------------------------------------------------------------------------------------      
      
Unit Test:      
EXEC [uspFM_EngAsset_Mobile_Fetch_BIS]  @pAssetNo='WFC81000032A'    
-----------------------------------------------------------------------------------------------------------      
Version History       
-----:------------:---------------------------------------------------------------------------------------      
Init : Date       : Details      
========================================================================================================*/      
CREATE PROCEDURE  [dbo].[uspFM_EngAsset_Mobile_Fetch_BIS]                                 
                                  
  @pAssetNo    NVARCHAR(100) = NULL    
    
      
AS                                                    
      
BEGIN TRY      
      
-- Paramter Validation       
      
 SET NOCOUNT ON;       
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;      
      
-- Declaration      
    DECLARE @Assetid int  
 DECLARE @TotalRecords INT      
      
-- Default Values      
      
      
-- Execution      
  select AssetId,facility.CustomerId,AssetNo,facility.facilityid,Manufacturer,Model,MLUL.UserLocationId,MLUL.UserAreaId,*,facility.CustomerId from EngAsset INNER JOIN MstLocationFacility   AS facility   ON facility.FacilityId = EngAsset.FacilityId  INNER 
  
JOIN MstLocationUserLocation as MLUL on EngAsset.UserLocationId=MLUL.UserLocationId where EngAsset.AssetNo=@pAssetNo    
  
set @Assetid =(select AssetId from EngAsset where AssetNo=@pAssetNo )   
select TOP 1 WorkOrderStatus,* from EngMaintenanceWorkOrderTxn where AssetId=@Assetid   order by  CreatedDate DESC  
    
    
      
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
