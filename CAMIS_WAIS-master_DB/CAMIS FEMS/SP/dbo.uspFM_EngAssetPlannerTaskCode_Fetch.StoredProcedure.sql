USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPlannerTaskCode_Fetch]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
/*========================================================================================================    
Application Name : UETrack-FEMS                  
Version    : 1.0    
Procedure Name  : [uspFM_EngAssetPlannerTaskCode_Fetch]    
Description   : Task Code fetch control    
Authors    : Srinivas Gangula 
Date    : 6-April-2021    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
EXEC [uspFM_EngAssetPlannerTaskCode_Fetch]  @pAssetID='WF657010167A',@pPageIndex=1,@pPageSize=5,@pFacilityId=144, @pYear = 2021   
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
========================================================================================================*/  





CREATE PROCEDURE [dbo].[uspFM_EngAssetPlannerTaskCode_Fetch]
  @pAssetID     NVARCHAR(100) = NULL,    
  @pPageIndex    INT,    
  @pPageSize    INT,    
  @pFacilityId    INT,    
  @pYear     int    = NULL    

  AS                                                  
    
BEGIN    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
BEGIN TRY    
     
 DECLARE  @IsDuplicate BIT = 0;  
  DECLARE @Assetno INT ;
 DECLARE @Cnt INT=0;    
   
     set @Assetno= (select AssetId from EngAsset where AssetNo=@pAssetID)  

select * from (select IIF( AQuantityText IS NULL, 0 , AQuantityText) as AQuantityText,PPMFrequency,FieldValue from 
(select ald.PPMFrequency as fre, * from (select case when CAST(IntervalInWeeks AS int) = 52 then 44        
            when CAST(IntervalInWeeks AS int) = 26 then 45        
            when CAST(IntervalInWeeks AS int) = 13 then 46         
            when CAST(IntervalInWeeks AS int) = 8  then 47        
            when CAST(IntervalInWeeks AS int) = 4 then 48        
            when CAST(IntervalInWeeks AS int) = 2 then 49        
            when CAST(IntervalInWeeks AS int) = 1 then 50 END AS AQuantityText  from  EngPlannerTxn where AssetId=@Assetno) as alpha 

 right join (select case when eppcl.PPMFrequency = 44 then 52        
            when eppcl.PPMFrequency = 45 then 26        
            when eppcl.PPMFrequency = 46 then 13         
            when eppcl.PPMFrequency = 47 then 8         
            when eppcl.PPMFrequency = 48 then 4        
            when eppcl.PPMFrequency = 49 then 2        
            when eppcl.PPMFrequency = 50 then 1 END AS QuantityText , eppcl.PPMFrequency,flo.FieldValue,AssetId from  FMLovMst as flo
 LEFT JOIN 		EngAssetPPMCheckList as eppcl on flo.LovId=eppcl.PPMFrequency
 LEFT JOIN EngAssetTypeCode as etpc on etpc.AssetTypeCodeId=eppcl.AssetTypeCodeId
 LEFT JOIN EngAsset as EA on EA.AssetTypeCodeId=etpc.AssetTypeCodeId where EA.AssetNo=@Assetno) as ald on ald.PPMFrequency=alpha.AQuantityText ) as kong) as final where final.AQuantityText =0


    
END TRY    
BEGIN CATCH    
    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),ERROR_LINE()) + ' - '+ERROR_MESSAGE(),GETDATE());    
    
THROW    
    
END CATCH    
SET NOCOUNT OFF    
END  
GO
