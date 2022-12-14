USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_ARPDetails_GetAllbyID]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/*========================================================================================================      
Application Name : UETrack-BEMS                    
Version    : 1.0      
Procedure Name  : [uspFM_ARPDetails_GetAll]      
Description   : Get the [uspFM_ARPDetails_GetAll] ARP details      
Authors    : Srinivas    
Date    : 29-Nov-2019      
-----------------------------------------------------------------------------------------------------------      
      
Unit Test:      
EXEC uspFM_BERApplicationTxnBER2_GetAll  @PageSize=10,@PageIndex=0,@StrCondition='AssetNo=''''',@StrSorting=null      
EXEC uspFM_ARPDetails_GetAllbyID  @pArpid=1   
  select * from EngARP_Details    
-----------------------------------------------------------------------------------------------------------      
Version History       
-----:------------:---------------------------------------------------------------------------------------      
Init : Date       : Details      
========================================================================================================*/      
    
CREATE PROCEDURE [dbo].[uspFM_ARPDetails_GetAllbyID]      
    -- Add the parameters for the stored procedure here      
    @pArpid int      
          
AS       
      
BEGIN TRY    
    -- SET NOCOUNT ON added to prevent extra result sets from      
    -- interfering with SELECT statements.      
    SET NOCOUNT ON; 
	--SELECT *
 -- FROM [EngARP_Details]  JOIN [EngARP_Propsal] ON [EngARP_Details] .ARPID= [EngARP_Propsal].ARPID where [EngARP_Details] .ARPID=@pArpid   order by PROP_ID    
      
    Select EngARP_Details.ARPID,EngARP_Details.BERno,ConditionAppraisalNo,AssetName,EngARP_Details.AssetTypeDescription,DepartmentNameID,
	LocationNameID,EngARP_Details.Quantity,BERRemarks,
	EngARP_Propsal.PROP_ID,EngARP_Propsal.Model,EngARP_Propsal.Brand,    
    EngARP_Propsal.Manufacturer,EngARP_Propsal.EstimationPrice,EngARP_Details.AssetNo,
	AssetTypeCode.AssetTypeCode, Asset.AssetId,
	UserArea.UserAreaName          AS DepartmentName,  UserLocation.UserLocationName        AS UserLocationName, 
	Asset.PurchaseCostRM, 
	 Asset.PurchaseDate           AS PurchaseDate,   
	  Asset.BatchNo, 
	   Asset.Package_Code AS PackageCode,  
          BER.BER1Remarks, 
		  BER.ApplicationDate, 
		  Asset.Item_Code  , 
 EngARP_Propsal.SupplierName,EngARP_Propsal.ContactNo From EngARP_Details     
 LEFT JOIN EngARP_Propsal ON EngARP_Details.ARPID = EngARP_Propsal.ARPID    
LEFT JOIN   EngAsset                             AS Asset               ON Asset.AssetId  = EngARP_Details.AssetID  
  LEFT JOIN  EngAssetTypeCode      AS AssetTypeCode  WITH(NOLOCK)   ON Asset.AssetTypeCodeId     = AssetTypeCode.AssetTypeCodeId
   LEFT JOIN  MstLocationUserLocation     AS UserLocation   WITH(NOLOCK)   ON Asset.UserLocationId      = UserLocation.UserLocationId  
    LEFT JOIN  EngTestingandCommissioningTxnDet  AS TandCDet    WITH(NOLOCK)   ON Asset.TestingandCommissioningDetId  = TandCDet.TestingandCommissioningDetId                  
   LEFT JOIN  EngTestingandCommissioningTxn   AS TandC    WITH(NOLOCK)   ON TandCDet.TestingandCommissioningId  = TandC.TestingandCommissioningId                  
  LEFT JOIN    BERApplicationTxn      AS BER (NOLOCK) ON Asset.AssetId = BER.AssetId 
  LEFT JOIN  MstLocationUserArea      AS UserArea    WITH(NOLOCK)   ON UserLocation.UserAreaId     = UserArea.UserAreaId                           
 where EngARP_Details.ARPID =@pArpid order by PROP_ID    

          
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
