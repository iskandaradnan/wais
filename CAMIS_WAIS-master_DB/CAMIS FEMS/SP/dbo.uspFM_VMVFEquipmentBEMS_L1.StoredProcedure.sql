USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMVFEquipmentBEMS_L1]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------  
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
-- =============================================    
-- Author  :Aravinda Raja     
-- Create date :08-06-2018    
-- Description :VVF approve Details    
-- =============================================    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
EXEC [uspFM_VMVFEquipmentBEMS_L1] @FacilityId = 1, @VOVFromMonth = 1, @VOVFromYear = 2018, @VOVTomonth = 12, @VOVToYear = 2019  
EXEC [uspFM_VMVFEquipmentBEMS_L1] @FacilityId = 1, @VOVFromMonth = 8, @VOVFromYear = 2018, @VOVTomonth = 9, @VOVToYear = 2018  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/           
  
CREATE PROCEDURE [dbo].[uspFM_VMVFEquipmentBEMS_L1](  
    @FacilityId  VARCHAR(20),    
    @VOVFromMonth   VARCHAR(100) = ''  ,     
    @VOVFromYear VARCHAR(100) = ''  ,     
    @VOVTomonth  VARCHAR(100) = null ,     
    @VOVToYear      VARCHAR(100) = null  
)  
AS  
BEGIN  
  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
BEGIN TRY  
  
DECLARE @@VVFTable TABLE(        
ID    INT IDENTITY(1,1),  
FacilityName NVARCHAR(512),  
CustomerName NVARCHAR(512),  
--Month   INT,  
--Year   INT,  
MonthYear  NVARCHAR(200),  
TotalCount  INT,  
DWFee   NVARCHAR(400),  
PWFee   NVARCHAR(512)  
)  

declare @pPageindex int =1, @pPageSize int=200


declare @temptable2 as table
(

  VariationId int null  
  ,AssetId int null  
  ,UserAreaName  nvarchar(200)  null
  ,AssetNo  nvarchar(200)  null
  ,Manufacturer  nvarchar(200)  null
  ,Model  nvarchar(200)  null
  ,PurchaseCost numeric(24,2)  null
  ,VariationStatus  nvarchar(200)  null
  ,CommissioningDate  datetime null
  ,StartServiceDate  datetime null
  ,WarrantyExpiryDate  datetime null
  ,StopServiceDate  datetime null
  ,MaintenanceRateDW numeric(30,2) null
  ,MaintenanceRatePW numeric(30,2)   null
  ,MonthlyProposedFeeDW numeric(30,2)  null
  ,MonthlyProposedFeePW numeric(30,2)  null
  ,CountingDays numeric(30,2)   null        
  ,Action int null
  ,Remarks nvarchar(1000) null
  ,WorkFlowStatus  nvarchar(200) null     
  , VariationWFStatus int null      
  ,VariationRaisedDate datetime null
  ,TotalRecords int null
  ,TotalPageCalc  int null
)

declare @pmonth int =2, @pyear int = 2017
INSERT INTO @temptable2
EXEC ('[uspFM_VmVariationTxnVVF_GetAll_Report] @pmonth= '+@pmonth+'  , @pyear= '+@pyear+', @pFacilityId= '+@FacilityId+', @pPageindex= '+@pPageindex+', @pPageSize= '+@pPageSize+'')
    
Declare @FacilityName varchar(200)
Declare @CustomerName varchar(200)   
DECLARE @FromDate DATE  
DECLARE @ToDate  DATE  

SET @FacilityName = (Select FacilityName from MstLocationFacility where FacilityId=@FacilityId)  
SET @CustomerName= (Select CustomerName from MstCustomer where CustomerId in (select top 1 CustomerId from MstLocationFacility where FacilityId=@FacilityId ))
SET @FromDate = CAST(@VOVFromYear +'-'+ @VOVFromMonth +'-'+ '01' AS DATE)  
SET @ToDate = DATEADD(DD,-1,DATEADD(MM,1, CAST(isnull(@VOVToYear,@VOVFromYear) +'-'+ isnull(@VOVTomonth,@VOVFromMonth) +'-'+ '01' AS DATE)))  

INSERT INTO @@VVFTable(FacilityName,CustomerName,MonthYear , TotalCount, DWFee, PWFee )  


select  @FacilityName as  FacilityName, @CustomerName as  CustomerName, DATENAME(MM,VariationRaisedDate)+ ' ' + CAST(Year(VariationRaisedDate) AS NVARCHAR(10)) as MonthYear
       ,COUNT(  Assetid) AS TotalCount, SUM(ISNULL(MonthlyProposedFeeDW,0)) AS MonthlyProposedFeeDW
	   ,SUM(ISNULL(MonthlyProposedFeePW,0)) AS MonthlyProposedFeePW

from @temptable2

where  CAST(VariationRaisedDate AS DATE) BETWEEN @FromDate AND @ToDate  
group by  DATENAME(MM,VariationRaisedDate)+ ' ' + CAST(Year(VariationRaisedDate) AS NVARCHAR(10)) 




  
  

  	declare @FromMonthDesc varchar(30), @ToMonthDesc varchar(30) = null

	set @FromMonthDesc= (Select DateName( month , DateAdd( month ,cast ( @VOVFromMonth as int) , -1 ) ))

	if(ISNULL (@VOVTomonth , 0) > 0 )
	begin
	     set @ToMonthDesc= (Select DateName( month , DateAdd( month ,cast( @VOVTomonth as int) , -1 ) ))
	end 

	



SELECT *  
, ISNULL(@VOVFromYear,'') AS FromYearParam  
, ISNULL(@FromMonthDesc,'') AS FromMonthParam  
, ISNULL(@ToMonthDesc,'') AS ToMonthParam  
, ISNULL(@VOVToYear,'') AS ToYearParam  
From @@VVFTable    
                                  
      
-- select '' as HospitalId,'' as VariationRaisedDate,'' as AssetRegisterId,'' as VariationRaisedDate,'' as AssetRegisterId,'' as Department,'' as Equipment_Description,'' as Equipment_Code,    
--'' as Asset_Number,'' as Manufacturer,'' as Model,'' as purchaseprojectcost,'' as VariationStatus,'' as StartServiceDate,'' as StartServiceDate,'' as ExpiryDate,'' as ServiceStopDate,    
--'' as ProposedRateDW,'' as ProposedRatePW,'' as MonhlyProposedFeeDW,'' as MonthlyProposedFeePW,'' as DoneRemarks,'' as Prepared_name,'' as Verified_name,'' as Acknowledged_name,    
--'' as Prepared_Designation,'' as Verified_Designation,'' as Acknowledged_Designation,'' as Prepared_date,'' as Verified_date,'' as Acknowledged_date,'' as Effective_date,'' as variation    
    
END TRY    
BEGIN CATCH    
    
insert into ErrorLog(Spname,ErrorMessage,createddate)    
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    
    
END CATCH    
SET NOCOUNT OFF    
END
GO
