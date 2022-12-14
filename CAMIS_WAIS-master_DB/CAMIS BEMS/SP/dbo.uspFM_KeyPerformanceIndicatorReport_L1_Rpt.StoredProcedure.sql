USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_KeyPerformanceIndicatorReport_L1_Rpt]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
/*========================================================================================================  
  
Application Name : UETrack-BEMS                
  
Version    : 1.0  
  
Procedure Name  : [uspFM_BERApplicationTxn_BERSummary_Rpt]   
  
Description   : Get the BER Summary Report  
  
Authors    : Ganesan S  
  
Date    : 06-June-2018  
  
-----------------------------------------------------------------------------------------------------------  
Unit Test:  
  
exec [uspFM_KeyPerformanceIndicatorReport_L1_Rpt]  @FromYear ='2017', @ToYear='2018',   @FacilityId = 1,@TypecodeId=11  
  
-----------------------------------------------------------------------------------------------------------  
  
  
  
-----:------------:---------------------------------------------------------------------------------------  
  
Init : Date       : Details  
  
========================================================================================================*/  
CREATE PROCEDURE [dbo].[uspFM_KeyPerformanceIndicatorReport_L1_Rpt](                                                    
    @FromYear  VARCHAR(100) = '',      
          @ToYear  VARCHAR(100) = ''  ,   
          @FacilityId    int ,  
    @TypecodeId   int = null   
 )   
as                                                    
BEGIN                                      
  
SET NOCOUNT ON   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
BEGIN TRY  
  
  declare @StartDate datetime , @endDate datetime  
  set @StartDate= (select datefromparts(@FromYear, 1, 1))  
  set @endDate= (select datefromparts(@ToYear, 12, 31))  
  
DECLARE @@TempTable TABLE(      
ID    INT IDENTITY(1,1),    
FacilityName NVARCHAR(512),    
CustomerName NVARCHAR(512),    
AssetTypeCode  NVARCHAR(512),     
AssetTypeDescription  NVARCHAR(512),    
AssetCount INT,     
Dummy1 INT ,  
Dummy2 INT   
)    
  
Insert into @@TempTable(FacilityName,CustomerName,AssetTypeCode,AssetTypeDescription,AssetCount,Dummy1, Dummy2 )  
select  fac.FacilityName, '' , TypeCode.AssetTypeCode, TypeCode.AssetTypeDescription,( count(Asset.AssetNo) ) AssetCount, 1,1    
from EngAsset Asset   
inner join EngAssetTypeCode TypeCode on Asset.AssetTypeCodeId = TypeCode.AssetTypeCodeId  
inner join MstLocationFacility fac on fac.FacilityId = Asset.FacilityId  
Where Asset.Active=1 and   
 ((Asset.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))   
 and ((Asset.AssetTypeCodeId = @TypecodeId) OR (@TypecodeId IS NULL) OR (@TypecodeId = ''))   
 and  (CAST(Asset.CreatedDate AS DATE) BETWEEN CAST(@StartDate  AS DATE) AND CAST(@endDate AS DATE))    
 AND	IsLoaner = 0
group by TypeCode.AssetTypeCode, TypeCode.AssetTypeDescription, fac.FacilityName  
  
SELECT *  
, ISNULL(@FromYear,'') AS FromYearParam    
, ISNULL(@ToYear,'') AS ToYearParam    
       
From @@TempTable  

END TRY  
BEGIN CATCH  
  
INSERT INTO ERRORLOG(Spname,ErrorMessage,createddate)  
values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())  
  
END CATCH  
  
SET NOCOUNT OFF                                               
  
END
GO
