USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMSummaryEquipmentBEMSRpt_L2]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
Application Name	: UETrack-BEMS
Version				: 
File Name			: uspFM_VMSummaryEquipmentBEMSRpt_L2
Procedure Name		: uspFM_VMSummaryEquipmentBEMSRpt_L2
Author(s) Name(s)	: Hari Haran N
Date				: 14 Jun 2018
Purpose				: Report SP For approved list of buildings BEMS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        


 --EXEC [uspFM_VMSummaryEquipmentBEMSRpt_L2] @MenuName='', @From_Year ='2015', @To_Year    ='2017', @Facility_Id='1'
 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
Modification History        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
          
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/       
    

CREATE PROCEDURE [dbo].[uspFM_VMSummaryEquipmentBEMSRpt_L2]
(
	@FacilityId  VARCHAR(20),    
    @VOVFromMonth   VARCHAR(100) = ''  ,     
    @VOVFromYear VARCHAR(100) = ''   
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
SET @ToDate = DATEADD(DD,-1,DATEADD(MM,1, CAST(isnull(@VOVFromYear,@VOVFromYear) +'-'+ isnull(@VOVFromMonth,@VOVFromMonth) +'-'+ '01' AS DATE)))  
  
  
  

  	declare @FromMonthDesc varchar(30), @ToMonthDesc varchar(30) = null

	set @FromMonthDesc= (Select DateName( month , DateAdd( month ,cast ( @VOVFromMonth as int) , -1 ) ))


	select @FacilityName as FacilityName, ISNULL(@VOVFromYear,'') AS FromYearParam  
, ISNULL(@FromMonthDesc,'') AS FromMonthParam   , 

  VariationId
  ,AssetId 
  ,UserAreaName  
  ,AssetNo 
  ,Manufacturer 
  ,Model 
  ,PurchaseCost
  ,VariationStatus  
  ,format(cast(CommissioningDate as Date),'dd-MMM-yyyy') as CommissioningDate 
  ,format(cast(StartServiceDate as Date),'dd-MMM-yyyy') as StartServiceDate  
  ,format(cast(WarrantyExpiryDate as Date),'dd-MMM-yyyy') as WarrantyExpiryDate 
  ,format(cast(StopServiceDate as Date),'dd-MMM-yyyy') as StopServiceDate  
  ,MaintenanceRateDW
  ,MaintenanceRatePW 
  ,MonthlyProposedFeeDW 
  ,MonthlyProposedFeePW 
  ,CountingDays        
  ,Action 
  ,Remarks
  ,WorkFlowStatus       
  , VariationWFStatus      
  ,format(cast(VariationRaisedDate as Date),'dd-MMM-yyyy') as VariationRaisedDate
  ,TotalRecords 
  ,TotalPageCalc  

 from @temptable2 a 
where CAST(VariationRaisedDate AS DATE) BETWEEN @FromDate AND @ToDate 

END TRY

BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())  

END CATCH
SET NOCOUNT OFF
END
GO
