USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMVFEquipmentBEMS_L1_test]    Script Date: 20-09-2021 16:43:02 ******/
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
  
create PROCEDURE [dbo].[uspFM_VMVFEquipmentBEMS_L1_test](  
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
  
DECLARE @FromDate DATE  
DECLARE @ToDate  DATE  
  
SET @FromDate = CAST(@VOVFromYear +'-'+ @VOVFromMonth +'-'+ '01' AS DATE)  
SET @ToDate = DATEADD(DD,-1,DATEADD(MM,1, CAST(isnull(@VOVToYear,@VOVFromYear) +'-'+ isnull(@VOVTomonth,@VOVFromMonth) +'-'+ '01' AS DATE)))  
  
--SELECT @FromDate,@ToDate , DATEADD(DD,-1,DATEADD(MM,1, CAST(isnull(@VOVToYear,@VOVFromYear) +'-'+ isnull(@VOVTomonth,@VOVFromMonth) +'-'+ '01' AS DATE))) 
  
INSERT INTO @@VVFTable(FacilityName,CustomerName,MonthYear , TotalCount, DWFee, PWFee )    
SELECT  MLF.FacilityName, MC.CustomerName, DATENAME(MM,VariationRaisedDate)+ ' ' + CAST(Year(VariationRaisedDate) AS NVARCHAR(10)) as MonthYear,   
COUNT( DISTINCT Assetid) AS TotalCount, SUM(ISNULL(MonthlyProposedFeeDW,0)) AS MonthlyProposedFeeDW,   
SUM(ISNULL(MonthlyProposedFeePW,0)) AS MonthlyProposedFeePW  
FROM VmVariationTxn AS VVT WITH (NOLOCK)  
INNER JOIN MstLocationFacility AS MLF WITH (NOLOCK) ON VVT.FACILITYID = MLF.FACILITYID  
INNER JOIN MstCustomer  AS MC WITH (NOLOCK) ON MC.CustomerID = MLF.CustomerID  
WHERE VVT.IsMonthClosed = 1  
AND  VVT.FacilityId  = @FacilityId  
AND  CAST(VVT.VariationRaisedDate AS DATE) BETWEEN @FromDate AND @ToDate  
GROUP BY MLF.FacilityName, MC.CustomerName, DATENAME(MM,VariationRaisedDate) + ' ' +  CAST(Year(VariationRaisedDate) AS NVARCHAR(10))  
  
--EXEC [uspFM_VMVFEquipmentBEMS_L1] @FacilityId = 1, @VOVFromMonth = 8, @VOVFromYear = 2018, @VOVTomonth = 9, @VOVToYear = 2018  
  
  

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
