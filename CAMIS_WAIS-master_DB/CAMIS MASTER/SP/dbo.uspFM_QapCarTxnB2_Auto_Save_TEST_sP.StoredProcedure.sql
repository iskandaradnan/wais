USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QapCarTxnB2_Auto_Save_TEST_sP]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
/****** Object:  StoredProcedure [dbo].[uspFM_QapCarTxnB2_Auto_Save]    Script Date: 7/15/2016 4:00:53 PM ******/  
  
  
/*  
EXEC [uspFM_QapCarTxnB2_Auto_Save_TEST_sP] @IsJob_p = 1,   
       @StateId_p  = null,  
       @pCustomerId = 1 ,   
       @pFacilityId = 1,   
       @Year_p  = 2018 ,  
       @Month_p = 10  
       */  
CREATE Procedure [dbo].[uspFM_QapCarTxnB2_Auto_Save_TEST_sP]  
(  
 @IsJob_p  bit = null,  
 @StateId_p  int = null,  
 @pCustomerId int = null,  
 @pFacilityId int = null,  
 @Year_p   int = null,  
 @Month_p  int = null,  
 @IsJob_BI  bit = null  
)  
as   
Begin  
  
 SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
BEGIN TRY  
  
if day(getdate())=15  
  
BEGIN   
  
  
Declare @StartDate date,@EndDate date,@CustomerMonth  int,@CustomerCurrentStartDate date, @CustomerCurrentEndDate date,@gendate date,  
@CustomerPreStartDate date,@CustomerPreEndDate date,@FinalStartDate  date, @FinalEndDate date  
  
  
select @CustomerMonth = configkeylovid from FMConfigCustomerValues where configkeyid=11 and CustomerId=@pCustomerId   
  
select @CustomerMonth =isnull(nullif(@CustomerMonth,0),1)  
  
select @gendate=DATEFROMPARTS(@Year_p,@Month_p,01)  
select @CustomerCurrentStartDate = DATEFROMPARTS(@Year_p,@CustomerMonth,1)  
select @CustomerCurrentEndDate = EOMONTH ( dateadd(mm,11, @CustomercurrentStartDate))  
select @CustomerPreStartDate = DATEFROMPARTS(@Year_p-1,@CustomerMonth,1)  
select @CustomerPreEndDate = EOMONTH ( dateadd(mm,11, @CustomerPreStartDate))  
  
  
if @gendate between @CustomerCurrentStartDate and @CustomerCurrentEndDate  
begin  
  
 select  @FinalStartDate = @CustomerCurrentStartDate, @FinalEndDate = @CustomerCurrentEndDate  
    
end  
else  
begin  
 select @FinalStartDate = @CustomerPreStartDate , @FinalEndDate = @CustomerPreEndDate  
end  
  
  
  
DECLARE @Month int  
DECLARE @Year int  
DECLARE @FromDate datetime  
DECLARE @ToDate datetime  
DECLARE @CARDateFinal datetime  
DECLARE @ServiceID int  
set @ServiceID=2  
  
If(@IsJob_p is null)  
 Begin  
  set @IsJob_p = 1  
 End  
  
If(@IsJob_p = 1)  
 BEGIN  
  if(@Year_p is null or @Month_p is null)  
 begin  
  set @Month= Month(DATEADD(mm, -1, GETDATE()))  
  
  set @Year=Year(DATEADD(mm, -1, GETDATE()))  
  end   
  else  
  begin  
  set @Month= @Month_p  
  set @Year=@Year_p  
  end  
 END  
Else  
 Begin  
  set @Month = @Month_p  
  set @Year = @Year_p    
 End  
set @FromDate=DATEFROMPARTS(@Year, @Month, 1 )   
set @ToDate=DATEADD(SS,-1, DATEADD(mm, 1, @FromDate))  
set @CARDateFinal=DATEFROMPARTS(Year(DATEADD(mm, 1, @FromDate)), Month(DATEADD(mm, 1, @FromDate)), 15 )  
  
DECLARE @EndYear  DATETIME  
 IF OBJECT_ID('tempdb..#AssetBasedCal') IS NOT NULL  
 DROP TABLE #AssetBasedCal  
 IF OBJECT_ID('tempdb..#AssetBasedCalw') IS NOT NULL  
 DROP TABLE #AssetBasedCalw  
 IF OBJECT_ID('tempdb..#AssetBasedCalAllMonth') IS NOT NULL  
 DROP TABLE #AssetBasedCalAllMonth  
 IF OBJECT_ID('tempdb..#TotalAssetUptimeCal') IS NOT NULL  
 DROP TABLE #TotalAssetUptimeCal  
 IF OBJECT_ID('tempdb..#TotalAssetUptimeCalAllMonth') IS NOT NULL  
 DROP TABLE #TotalAssetUptimeCalAllMonth  
 IF OBJECT_ID('tempdb..#TotalAssetUptimeCalAllMonthPrev') IS NOT NULL  
 DROP TABLE #TotalAssetUptimeCalAllMonthPrev  
    IF OBJECT_ID('tempdb..#TotalAssetUptimeCalAllMonthCurr') IS NOT NULL  
 DROP TABLE #TotalAssetUptimeCalAllMonthCurr  
  IF OBJECT_ID('tempdb..#TotalAssetUptimeCalPrevCurr') IS NOT NULL  
 DROP TABLE #TotalAssetUptimeCalPrevCurr  
  
 IF OBJECT_ID('tempdb..#TempDocNo') IS NOT NULL  
   DROP TABLE #TempDocNo  
create table #TempDocNo(DocNo nvarchar(200))  
  
  set @EndYear=DATEFROMPARTS(@YEAR, 12 , 31)  
  
 create table #TotalAssetUptimeCalAllMonth ([Year] int,[Month] int,CustomerId int,FacilityId int,AssetId int,AssetTypeCodeId int,AssignedUserId int,Uptime decimal(24,2),FromDate date,Todate date)  
 create table #TotalAssetUptimeCalPrevCurr ([Year] int,[Month] int,CustomerId int,FacilityId int,AssetId int,AssetTypeCodeId int,AssignedUserId int,Uptime decimal(24,2),FromDate date,Todate date)  
--DECLARE @MonthCount INT =1,@CurrentMonthCount int =0 ,@PrevMonthCount int =0  
  
  
insert into #TotalAssetUptimeCalAllMonth   
  
SELECT distinct @Year,@Month,ar.CustomerId,ar.FacilityId,ar.AssetId,ar.AssetTypeCodeId,'',  
cast(isnull(case when ar.TestingandCommissioningDetId is null then  
-----------first----------------  
case when DATEADD(mm, 1, cast( ar.CommissioningDate as date))>=@FinalStartDate  
then  
 (DATEDIFF(day, DATEFROMPARTS(Year(DATEADD(mm, 1, ar.CommissioningDate)), Month(DATEADD(mm, 1, ar.CommissioningDate)) , 1),DATEADD(dd, 1,   
 case when (ar.ServiceStartDate is null or cast(ar.ServiceStopDate as date)>@FinalEndDate) then @FinalEndDate else case when month(ar.ServiceStopDate)=@Month then ar.ServiceStopDate else @FinalEndDate end end ))*24)*60   
else  
 (DATEDIFF(day,@FinalStartDate,DATEADD(dd, 1,   
case when (ar.ServiceStopDate is null or cast(ar.ServiceStopDate as date)>@FinalEndDate) then @FinalEndDate  
else  
case when month(ar.ServiceStopDate)=@Month then  
ar.ServiceStopDate  
else @FinalEndDate  
end  
end  
  
))*24)*60    
end  
------------second---------  
else  
case when DATEADD(mm, 1,cast( ts.TandCDate as date))>=@FinalStartDate then  
(DATEDIFF(day, DATEFROMPARTS(Year(DATEADD(mm, 1, ts.TandCDate)), Month(DATEADD(mm, 1, ts.TandCDate)) , 1),DATEADD(dd, 1,  
case when (ar.ServiceStopDate is null or cast(ar.ServiceStopDate as date)>@FinalEndDate) then  
@FinalEndDate  
else  
case when month(ar.ServiceStopDate)=@Month then  
ar.ServiceStopDate  
else   
@FinalEndDate  
end  
end  
   
 ))*24)*60    
else  
(DATEDIFF(day,@FinalStartDate,DATEADD(dd, 1,   
case when (ar.ServiceStopDate is null or cast(ar.ServiceStopDate as date)>@FinalEndDate) then  
@FinalEndDate  
else  
case when month(ar.ServiceStopDate)=@Month then  
ar.ServiceStopDate  
else   
@FinalEndDate  
end  
end  
))*24)*60    
end  
--------------------------  
end ,0)as decimal(24,2))  
-------------------  
as Uptime ,cast (@FromDate as date),cast (case when (ar.ServiceStopDate is null or cast(ar.ServiceStopDate as date)>@FinalEndDate) then  
@ToDate  
else  
ar.ServiceStopDate  
end as date)  
   
 FROM   
  EngAsset ar   
  join EngAssetTypeCode AS TypeCode on ar.AssetTypeCodeId=TypeCode.AssetTypeCodeId     
   left join EngTestingandCommissioningTxnDet TandCDet on ar.TestingandCommissioningDetId=TandCDet.TestingandCommissioningDetId  
   left join EngTestingandCommissioningTxn ts on TandCDet.TestingandCommissioningId=ts.TestingandCommissioningId  
     
   
 WHERE   
  ar.ServiceId=@ServiceID   
  and TypeCode.QAPServiceAvailabilityB2=1  
  and ar.[Authorization]=199    
 and case when ar.TestingandCommissioningDetId is null then  
   DATEFROMPARTS(Year(DATEADD(mm, 1,ar.CommissioningDate)), Month(DATEADD(mm, 1, ar.CommissioningDate)) , 1)  
  else  
  DATEFROMPARTS(Year(DATEADD(mm, 1,ts.TandCDate)), Month(DATEADD(mm, 1, ts.TandCDate)) , 1)  
  end  
  <= cast(@ToDate as date)   
  and isnull(ar.IsLoaner,0)=0  
  
  
  
 insert into #TotalAssetUptimeCalPrevCurr   
  
 select * from #TotalAssetUptimeCalAllMonth   
 where Month= @MONTH  AND Year=@Year  
  
  
  
-------------------------UnScheduled--------------------------------------  
  
  
SELECT DISTINCT ar.CustomerId,ar.FacilityId,ar.AssetId,ar.AssetNo,ar.AssetTypeCodeId,engm.MaintenanceWorkNo,engm.WorkOrderId,engm.AssignedUserId,  
totalaaset.Uptime  
as Uptime ,   
   cast(isnull(case when  engm.MaintenanceWorkDateTime>=DATEFROMPARTS(Year(DATEADD(mm, 1,   
    ---------Condition ---  
    case when ar.TestingandCommissioningDetId is null then  
    ar.CommissioningDate  
    else  
    ts.TandCDate  
    end  
    --------End--------  
    )), Month(DATEADD(mm, 1,   
     ---------Condition ---  
   case when ar.TestingandCommissioningDetId is null then  
    ar.CommissioningDate  
    else  
    ts.TandCDate  
    end  
  
     --------End--------  
    )) , 1) then  
    SUM(--case when tc.DowntimeHoursMin=0 or tc.DowntimeHoursMin is null then   
    case when tc.StartDateTime is not null then  
   datediff(minute,tc.StartDateTime, tc.EndDateTime)  
    else  
    0  
    end  
    --else tc.DowntimeHoursMin end   
      
    )  
     else  
    0  
    end,0)as decimal(24,2))  
   --DATEDIFF(MINUTE,t.MaintenanceWorkDateTime,ISNULL(tci.EndDateTime,@LastDate)) StartDateTime  
    AS DownTime  
 INTO #AssetBasedCalAllMonth  
 FROM   
  #TotalAssetUptimeCalPrevCurr totalaaset  
  join EngAsset ar  on totalaaset.AssetId=ar.AssetId  
  join EngMaintenanceWorkOrderTxn engm on ar.AssetId=engm.AssetId  
  INNER join EngMwoAssesmentTxn engast on  engm.WorkOrderId=engast.WorkOrderId     -- DD it should be inner join  
  left join EngTestingandCommissioningTxn ts on ar.TestingandCommissioningDetId=ts.TestingandCommissioningId    
 left JOIN EngMwoCompletionInfoTxn tc ON tc.workorderid = engm.workorderid   
 WHERE  
 ar.ServiceId=@ServiceID and engm.MaintenanceWorkCategory=188  and ar.RealTimeStatusLovId=56   
  and ar.AssetStatusLovId=1   
  --and (engm.WorkOrderStatus=194 or engm.WorkOrderStatus=195)        -- DD it should be uncommented  
 --and Year(engm.MaintenanceWorkDateTime)=@Year and engm.MaintenanceWorkDateTime<=@ToDate -- DD it should be uncommented  
  --and isnull((select count( *) from EngMwoProcessStatusTxnDet where CompletionInfoId=tc.CompletionInfoId and (ProvideLoaner=1 or AlternativeServiceProvided=1)),0)=0  
 and isnull(ar.IsLoaner,0)=0  
 GROUP BY ar.AssetId,ar.AssetNo,ar.AssetTypeCodeId, engm.MaintenanceWorkDateTime,   
 tc.EndDateTime ,ts.TandCDate,ar.CustomerId,ar.FacilityId ,engm.MaintenanceWorkNo,engm.WorkOrderId,engm.AssignedUserId,ar.CommissioningDate,ar.TestingandCommissioningDetId,totalaaset.Uptime  
  
  
  
---------------------------End---------------------------------------------------  
  
-------------------------Scheduled-----------------------------------------------  
  
insert INTO #AssetBasedCalAllMonth SELECT DISTINCT ar.CustomerId,ar.FacilityId,ar.AssetId,ar.AssetNo,ar.AssetTypeCodeId,engm.MaintenanceWorkNo,engm.WorkOrderId,engm.AssignedUserId,  
totalaaset.Uptime  
as Uptime ,   
   cast(isnull(case when  engm.MaintenanceWorkDateTime>=DATEFROMPARTS(Year(DATEADD(mm, 1,   
    ---------Condition ---  
    case when ar.TestingandCommissioningDetId is null then  
    ar.CommissioningDate  
    else  
    ts.TandCDate  
    end  
    --------End--------  
    )), Month(DATEADD(mm, 1,   
     ---------Condition ---  
   case when ar.TestingandCommissioningDetId is null then  
    ar.CommissioningDate  
    else  
    ts.TandCDate  
    end  
  
     --------End--------  
    )) , 1) then  
    SUM(--case when tc.DowntimeHoursMin=0 or tc.DowntimeHoursMin is null then   
    case when tc.StartDateTime is not null then  
    datediff(minute,tc.StartDateTime, tc.EndDateTime)  
    else  
    0  
    end  
    --else tc.DowntimeHoursMin end   
      
    )  
     else  
    0  
    end ,0)as decimal(24,2))  
   --DATEDIFF(MINUTE,t.MaintenanceWorkDateTime,ISNULL(tci.EndDateTime,@LastDate)) StartDateTime  
    AS DownTime  
   
 FROM   
    #TotalAssetUptimeCalPrevCurr totalaaset  
  join EngAsset ar  on totalaaset.AssetId=ar.AssetId   
  join EngMaintenanceWorkOrderTxn engm on ar.AssetId=engm.AssetId   
  --join EngMwoAssesmentTxn engast on  engm.WorkOrderId=engast.WorkOrderId  
  left join EngTestingandCommissioningTxn ts on ar.TestingandCommissioningDetId=ts.TestingandCommissioningId    
 left JOIN EngMwoCompletionInfoTxn tc ON tc.workorderid = engm.workorderid   
 WHERE   
  ar.ServiceId=@ServiceID  and engm.MaintenanceWorkCategory=187   
  and ar.AssetStatusLovId=1   
   and isnull(ar.IsLoaner,0)=0  
  --and (engm.WorkOrderStatus=194 or engm.WorkOrderStatus=195)  -- DD   
 and cast(engm.MaintenanceWorkDateTime as date)>=@FinalStartDate and engm.MaintenanceWorkDateTime<=@ToDate  -- DD   
  --and isnull((select count( *) from EngMwoProcessStatusTxnDet where CompletionInfoId=tc.CompletionInfoId and (ProvideLoaner=1 or AlternativeServiceProvided=1) and IsDeleted=0),0)=0  
   
 GROUP BY ar.AssetId,ar.AssetNo,ar.AssetTypeCodeId, engm.MaintenanceWorkDateTime,   
 tc.EndDateTime ,ts.TandCDate,ar.CustomerId,ar.FacilityId ,engm.MaintenanceWorkNo,engm.WorkOrderId,engm.AssignedUserId,ar.CommissioningDate,ar.TestingandCommissioningDetId,totalaaset.Uptime  
  
  
  
 select *   INTO #AssetBasedCal from #AssetBasedCalAllMonth  
insert into #AssetBasedCal select CustomerId,FacilityId,AssetId,'',AssetTypeCodeId,'','','',Uptime,0 from #TotalAssetUptimeCalPrevCurr   
where AssetId not in (select AssetId from #AssetBasedCalAllMonth)  
  
  
  IF OBJECT_ID('tempdb..#AssetBasedCal2') IS NOT NULL  
 DROP TABLE #AssetBasedCal2  
 
 select tt.AssetTypeCodeId,CustomerId,FacilityId, tt.AssetId,sum(tt.DownTime) as DownTime,  
 isnull((select top 1 Uptime from #AssetBasedCal where AssetId=tt.AssetId ),0) as Uptime,  
 1 as AssetTotal,  
 0 as PassAsset,  
 0 as FailAsset,  
 max(engnew.QAPUptimeTargetPerc) as QAPUptimeTargetPer,  
 AssignedUserId  
 into #AssetBasedCal2  
  from  #AssetBasedCal tt   
  join EngAssetTypeCode engnew on tt.AssetTypeCodeId=engnew.AssetTypeCodeId  
   where engnew.QAPServiceAvailabilityB2=1  
      
  group by tt.AssetId,tt.AssetTypeCodeId,CustomerId,FacilityId,AssignedUserId  
  
  
 update #AssetBasedCal2 set PassAsset=  
  case when isnull((Uptime),0)=0 then 0 else case when   
 isnull(cast(cast(((Uptime)-(DownTime))/(Uptime) as decimal(18,5))*100.00 as decimal(18,3)),0)<(isnull(QAPUptimeTargetPer,0)) then 0 else 1 end   
 end  
  
 update #AssetBasedCal2 set FailAsset= case when PassAsset=0 and Uptime>0 then 1 else 0 end  
  
   
 IF OBJECT_ID('tempdb..#AssetBasedCal1') IS NOT NULL  
 DROP TABLE #AssetBasedCal1  
  
 IF OBJECT_ID('tempdb..#AssetBasedCalFinal') IS NOT NULL  
 DROP TABLE #AssetBasedCalFinal  
  
 select AssetTypeCodeId,CustomerId,FacilityId,AssignedUserId,  
 isnull(sum(Uptime),0) as TotalUptime,  
 isnull(sum(DownTime),0) as TotalDownTime,  
 isnull(sum(AssetTotal),0) as AssetTotal,  
 isnull(sum(PassAsset),0) as PassAsset,  
 isnull(sum(FailAsset),0) as FailAsset   
  into #AssetBasedCalFinal   
 from #AssetBasedCal2 tt   
 group by AssetTypeCodeId,CustomerId,FacilityId,AssignedUserId having isnull(sum(Uptime),0)>0  
  
  
DECLARE @CarGenIndDet table (id int identity(1,1),IndiCator nvarchar(100),DDate datetime,FacilityId int,HospitalCode nvarchar(100),CustomerId int,  
service int,QindicatorID int,ExpectedPercentage decimal(18,3),TotalPer decimal(18,3),DocNumber NVARCHAR(100),CarId int,AssetTypeCodeId int,  
 count1 decimal(18,2), count2 decimal(18,2), stateid int,AssignedUserId int)  
  
 DECLARE @CarGenIndDetFainal table (id int identity(1,1),IndiCator nvarchar(100),DDate datetime,FacilityId int,HospitalCode nvarchar(100),CustomerId int,  
service int,QindicatorID int,ExpectedPercentage decimal(18,3),TotalPer decimal(18,3),DocNumber NVARCHAR(100),CarId int,AssetTypeCodeId int,  
count1 decimal(18,2), count2 decimal(18,2), stateid int,AssetTotal int,PassAsset int,FailAsset int,AssignedUserId int)  
  
insert  @CarGenIndDetFainal(IndiCator,DDate,FacilityId,HospitalCode,CustomerId,service,QindicatorID,ExpectedPercentage,TotalPer,DocNumber,AssetTypeCodeId,count1,count2, stateid,AssetTotal,PassAsset,FailAsset,AssignedUserId)  
select 'B2',DATEADD(dd, -1, GETDATE()),  
 fin.FacilityId,gmhos.FacilityCode ,fin.CustomerId,2,  
 (isnull((select top 1 QAPIndicatorId from MstQAPIndicator where IndicatorCode = 'B2'),0)),  
 (isnull(engnew.QAPUptimeTargetPerc,0)),  
 (case when  
isnull((fin.TotalUptime),0)=0  
then  
100.00  
else  
 cast(cast(((fin.TotalUptime)-(fin.TotalDownTime))/(fin.TotalUptime) as decimal(18,5))*100.00 as decimal(18,3))  
 end),'',fin.AssetTypeCodeId,  
 (--count 1  
  isnull((fin.TotalUptime),0)  
 ),  
 (--count 2  
  (fin.TotalUptime)-(fin.TotalDownTime)  
 ),  
 '' as State,  
 fin.AssetTotal,fin.PassAsset,fin.FailAsset,fin.AssignedUserId  
  from #AssetBasedCalFinal fin  
  join EngAssetTypeCode engnew on fin.AssetTypeCodeId=engnew.AssetTypeCodeId    
   join MstLocationFacility gmhos on fin.FacilityId=gmhos.FacilityId    
   where engnew.QAPServiceAvailabilityB2=1   
   --and cast(cast(((fin.TotalUptime)-(fin.TotalDownTime))/(fin.TotalUptime) as decimal(18,5))*100.00 as decimal(18,3))>=0  
  and gmhos.CustomerId = isnull(@pCustomerId, gmhos.CustomerId)  
  and gmhos.FacilityId = isnull(@pFacilityId, gmhos.FacilityId)  
  
   --select * from @CarGenIndDet  
  
If(@IsJob_p = 1)  
Begin  
  
-----CAR insert and update-------  
 insert into @CarGenIndDet (IndiCator,DDate,FacilityId,HospitalCode,CustomerId,service,QindicatorID ,ExpectedPercentage,TotalPer,DocNumber,CarId,AssetTypeCodeId,count1,count2,stateid,AssignedUserId )   
select  IndiCator,DDate,FacilityId,HospitalCode ,CustomerId,service,QindicatorID ,ExpectedPercentage,TotalPer,DocNumber,CarId,AssetTypeCodeId,count1, count2,stateid  ,AssignedUserId  
  from  @CarGenIndDetFainal where TotalPer>=0 and TotalPer<ExpectedPercentage   
  declare @Current int = 1;  
  declare @Max int;  
  select @Max = count(*) from @CarGenIndDet  
  if(@IsJob_BI is null)  
  begin  
  set @IsJob_BI=0  
  end  
  if(@IsJob_BI!=1)  
  begin  
  while @Current <= @Max  
  BEGIN  
  DECLARE @CARNUMBER NVARCHAR(50), @DocNumber NVARCHAR(50),@SIQNUMBER NVARCHAR(50),@hosalcode nvarchar(15),@IndiCator nvarchar(50),@TotalPer decimal(18,2),@ExpectedPercentage decimal(18,2),@AssignUserId int ,@AssignUserName nvarchar(200)  
  set @hosalcode=(select top 1 HospitalCode from @CarGenIndDet where id=@Current)  
  set @IndiCator=(select top 1 IndiCator from @CarGenIndDet where id=@Current)  
  --set @TotalPer=(select top 1 TotalPer from @CarGenIndDet where id=@Current)  
   DECLARE @TotalPer3dec decimal(18,3)   
  set @TotalPer3dec=(select top 1 TotalPer from @CarGenIndDet where id=@Current)  
  set @TotalPer= left(@TotalPer3dec,len(@TotalPer3dec)-1)  
  
  set @ExpectedPercentage=(select top 1 ExpectedPercentage from @CarGenIndDet where id=@Current)  
  declare @Hospid int ,@indid int ,@Servid int ,@compid int ,@CARNId int,@AssetTypeId int  
 set @Hospid=(select top 1 FacilityId from @CarGenIndDet where id=@Current)  
 set @compid=(select top 1 CustomerId from @CarGenIndDet where id=@Current)  
 set @indid=(select top 1 QindicatorID from @CarGenIndDet where id=@Current)  
 set @AssetTypeId=(select top 1 AssetTypeCodeId from @CarGenIndDet where id=@Current)  
 set @Servid=(select top 1 service from @CarGenIndDet where id=@Current)  
 set @CARNId=isnull((select top 1 CarId from QapCarTxn where FacilityId=@Hospid and CustomerId=@compid   
 and QAPIndicatorId=@indid and ServiceId=@Servid and Year(FromDate)=@Year and Month(FromDate)=@Month  and IsAutoCar=1 and AssetTypeCodeId=@AssetTypeId),0)  
  set @AssignUserId=(select top 1 a.AssignedUserId from @CarGenIndDet a inner join UMUserRegistration b on a.AssignedUserId=b.UserRegistrationId where id=@Current)  
 set @AssignUserName=(select top 1 b.StaffName from @CarGenIndDet a inner join UMUserRegistration b on a.AssignedUserId=b.UserRegistrationId where id=@Current)  
 DECLARE @id int  
   DECLARE @TABLE TABLE (ID INT,AssignedUserId int,CARNumber varchar(1000),FacilityId int,CustomerId int)  
 -----Check already exists-----------------  
 if(@CARNId=0)  
 begin  
    
  DECLARE @pOutParam NVARCHAR(50)  
 insert #TempDocNo   
 EXEC [uspFM_GenerateDocumentNumber] @pFlag='QAPCarTxn',@pCustomerId=@compid,@pFacilityId=@Hospid,@Defaultkey='CAR',@pModuleName=@IndiCator,@pMonth=@Month_p,@pYear=@Year_p,@pOutParam=@pOutParam OUTPUT  
 SET @CARNUMBER = @pOutParam;  
  
  update @CarGenIndDet set DocNumber=case when TotalPer<ExpectedPercentage then  @CARNUMBER   
  else '' end from @CarGenIndDet where id=@Current  
  DECLARE @AssetCode nvarchar(100)  
  set @AssetCode=(select top 1 ast.AssetTypeCode from   
  EngAssetTypeCode ast   where ast.AssetTypeCodeId=(select top 1 AssetTypeCodeId from @CarGenIndDet where id=@Current))  
  DECLARE @ProblemStatement nvarchar(1000)  
  set @ProblemStatement='CAR Generated for the month of '+UPPER(SUBSTRING (DATENAME(MONTH,DATEFROMPARTS(@Year, @Month, 1 )),1,3))  
  +', '+cast(@year as varchar(10))+' for the Indicator B2  for Asset Type - '+@AssetCode +  ' and Assigned Staff - '+ @AssignUserName  
   
  
  
 -- -- inserting into corrective action report  
 --INSERT INTO QapCarTxn(FacilityId, CustomerId,CARNumber,CARDate,ProblemStatement,ServiceId,PriorityLovId,Status,CreatedBy,CreatedDate,CreatedDateUTC,IsAutoCar,   
 --QAPIndicatorId,FromDate,ToDate,AssetTypeCodeId,ExpectedPercentage,ActualPercentage,ModifiedBy,ModifiedDate,ModifiedDateUTC,AssignedUserId)   
 --OUTPUT INSERTED.CarId,INSERTED.AssignedUserId,INSERTED.CARNumber,INSERTED.FacilityId ,INSERTED.CustomerId INTO @TABLE  
 select FacilityId,CustomerId,DocNumber,@CARDateFinal,@ProblemStatement,service,296, 300,1,GETDATE(),GETUTCDATE(),1,QindicatorID,@FromDate,@ToDate,AssetTypeCodeId   
 ,@ExpectedPercentage,@TotalPer,1,GETDATE(),GETUTCDATE(),AssignedUserId  
 from @CarGenIndDet  where id=@Current  
  
  set @id = (SELECT top 1 CarId FROM QapCarTxn WHERE IsAutoCar=1 AND AssetTypeCodeId IN(SELECT AssetTypeCodeId FROM @CarGenIndDet WHERE id=@Current)  AND AssignedUserId IN(SELECT ISNULL(AssignedUserId,'') FROM @CarGenIndDet WHERE id=@Current)  
   )  
  
 --insert into QapB1AdditionalInformationTxn (CustomerId,FacilityId,CarId,ServiceId,AssetId,WorkOrderId,TargetDateTime,EndDateTime,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,CauseCodeId,QcCodeId)  
 select A.CustomerId,A.FacilityId,@id,2,A.AssetId,A.WorkOrderId,null,null,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),B.CauseCode,B.QCCode  
 from #AssetBasedCalAllMonth A LEFT JOIN EngMwoCompletionInfoTxn B ON A.WorkOrderId = B.WorkOrderId  
 where  AssetTypeCodeId in (select AssetTypeCodeId from @CarGenIndDet  where id=@Current)   
 and  AssignedUserId in (select ISNULL(AssignedUserId,'') from @CarGenIndDet  where id=@Current)  
  
 DECLARE @CarDate datetime  
 SET @CarDate = DATEFROMPARTS(@Year, (@Month-1), 1 )  
 --update QAPCarTxn set CARDate=@CarDate,FromDate=@CarDate,ToDate=EOMONTH(@CarDate) WHERE CarId = @id  
  
  end  
 else  
 begin  
 if(@TotalPer<@ExpectedPercentage)  
 begin  
   --update QapCarTxn set ExpectedPercentage=@ExpectedPercentage,ActualPercentage=@TotalPer ,ModifiedDate=getdate() where CarId=@CARNId   
  
--DELETE FROM QapB1AdditionalInformationTxn where CarId=@CARNId   
  
 --insert into QapB1AdditionalInformationTxn (CustomerId,FacilityId,CarId,ServiceId,AssetId,WorkOrderId,TargetDateTime,EndDateTime,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,CauseCodeId,QcCodeId)  
 select A.CustomerId,A.FacilityId,@CARNId,2,A.AssetId,A.WorkOrderId,null,null,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),B.CauseCode,B.QCCode  
 from #AssetBasedCalAllMonth A  LEFT JOIN EngMwoCompletionInfoTxn B ON A.WorkOrderId = B.WorkOrderId   
 where  AssetTypeCodeId in (select AssetTypeCodeId from @CarGenIndDet  where id=@Current)  
  
 end  
 --else  
 --begin  
 --update QapCarTxn set ModifiedDate=getdate() where CarId=@CARNId  
 --end  
 end  
  set @Current += 1;  
  end  
  
  -- update QapCarTxn  set ModifiedDate=getdate() from QapCarTxn  
  --inner join @CarGenIndDetFainal sct on QapCarTxn.QAPIndicatorId=sct.QindicatorID and QapCarTxn.ServiceId=sct.service  
  --and Month(QapCarTxn.FromDate)=@Month and Year(QapCarTxn.FromDate)=@Year  and QapCarTxn.FacilityId=sct.FacilityId  
  --and QapCarTxn.CustomerId=sct.CustomerId and (sct.TotalPer<0 or sct.TotalPer>=sct.ExpectedPercentage) and QapCarTxn.AssetTypeCodeId=sct.AssetTypeCodeId   
  --and QapCarTxn.IsAutoCar=1  
  end  
end  

--select * from @CarGenIndDet  
select IndiCator,DDate,FacilityId,HospitalCode,CustomerId,service,QindicatorID,ExpectedPercentage, stateid, count1, count2, TotalPer as TotalPer  
--,AssetTotal,PassAsset,FailAsset  
  
   -- case when sum(count1) = 0 then 100.00  
   --else  cast(cast((cast(sum(count2) as decimal(18,5)) / cast(sum(count1) as decimal(18,5))) as decimal(18,5) )*100.00 as  decimal(18,2))    
   --end as TotalPer  
  
from @CarGenIndDetFainal  
  
--group by IndiCator,DDate,FacilityId,HospitalCode,CustomerId,service,QindicatorID,ExpectedPercentage, stateid  
  
  
  
  
  
  
 select  ID ,AssignedUserId ,CARNumber ,FacilityId ,CustomerId, (select email from  UMUserRegistration u where u.UserRegistrationId=t.AssignedUserId) as email into #TABLE  from   @TABLE t   
  
 declare @notificationTable table (id int)  
  
 --INSERT INTO WebNotification ( CustomerId,  
 --          FacilityId,  
 --          UserId,  
 --          NotificationAlerts,  
 --          Remarks,  
 --          HyperLink,  
 --          IsNew,  
 --          CreatedBy,  
 --          CreatedDate,  
 --          CreatedDateUTC,  
 --          ModifiedBy,  
 --          ModifiedDate,  
 --          ModifiedDateUTC ,  
 --          NotificationDateTime,  
 --          IsNavigate                                                                                                                    
 --         )  output inserted.NotificationId into @notificationTable  
  
          select   a.CustomerId,  
             a.FacilityId,  
             a.AssignedUserId,  
             'Auto CAR has been generated '+a.CARNumber+ ' and assgined to user',  
             '',  
             '/qap/correctiveactionreport?id='+cast(a.id as varchar(100)),  
             1,  
             1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),getdate(),  
             0    
       FROM #TABLE A    
       where not exists (select 1 from EmailQueue e  where  e.EmailTemplateId = 60 and  TemplateVars =a.CARNumber)  
  
  
  
  
  
SELECT NotificationDeliveryId,  
   NotificationTemplateId,  
   UserRoleId,  
   UserRegistrationId,  
   FacilityId  
 INTO #Notification1  
 FROM NotificationDeliveryDet  
 WHERE NotificationTemplateId = 60  
  
   
    
 SELECT distinct A.UserRegistrationId,  
   b.FacilityId,  
   b.CustomerId    
  INTO #TempUserEmails_all1  
 FROM UMUserRegistration AS A   
   INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId  
 WHERE B.UserRoleId IN (SELECT DISTINCT UserRoleId FROM #Notification1)  
 --IN (SELECT DISTINCT FacilityId FROM #Notification)  
  
           
  
 --INSERT INTO WebNotification ( CustomerId,  
 --          FacilityId,  
 --          UserId,  
 --          NotificationAlerts,  
 --          Remarks,  
 --          HyperLink,  
 --          IsNew,  
 --          CreatedBy,  
 --          CreatedDate,  
 --          CreatedDateUTC,  
 --          ModifiedBy,  
 --          ModifiedDate,  
 --          ModifiedDateUTC ,  
 --          NotificationDateTime,  
 --          IsNavigate                                                                                                                    
 --         )  
  
          select  distinct b.CustomerId,  
             b.FacilityId,  
             a.UserRegistrationId,  
             b.NotificationAlerts,  
             b.Remarks,  
             b.HyperLink,  
             b.IsNew,  
             b.CreatedBy,  
             b.CreatedDate,  
             b.CreatedDateUTC,  
             b.ModifiedBy,  
             b.ModifiedDate,  
             b.ModifiedDateUTC ,  
             b.NotificationDateTime,  
             b.IsNavigate    
          from #TempUserEmails_all1 a  left join   WebNotification  b   
          on a.CustomerId=b.CustomerId  and a.FacilityId=b.FacilityId  
          where b.NotificationId  in (select  id  from @notificationTable )   
  
  
  
SELECT NotificationDeliveryId,  
     NotificationTemplateId,  
     UserRoleId,  
     UserRegistrationId,  
     FacilityId  
   INTO #Notification  
   FROM NotificationDeliveryDet  
   WHERE NotificationTemplateId = 60  
  
  
  
   
   SELECT DISTINCT  
    IDENTITY(INT ,1,1) AS ID,  
    b.FacilityId,  
    b.CustomerId,  
    ltrim(rtrim(Email)) as EMAIL    
    INTO #TempUserEmails_all  
   FROM UMUserRegistration AS A   
     INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId  
   WHERE B.UserRoleId IN (SELECT DISTINCT UserRoleId FROM #Notification)  
   --AND B.FacilityId = @pFacilityId  
   --IN (SELECT DISTINCT FacilityId FROM #Notification)  
   
   
   select IDENTITY(INT ,1,1) AS ID,  
    FacilityId,  
    CustomerId,  
    Email  
   INTO #TempUserEmails  
   from   
   
   (  
   select  
   distinct  
    A.FacilityId,  
    A.CustomerId,  
    CAST(STUFF((SELECT ',' + RTRIM(AA.Email ) FROM #TempUserEmails_all AA where A.FacilityId = AA.FacilityId and A.CustomerId = AA.CustomerId -- AA.FacilityId=b.FacilityId   
    FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) AS Email  
   
    from #TempUserEmails_all a) a  
  
  
   --select  ID ,AssignedUserId ,CARNumber ,FacilityId ,CustomerId, (select email from  UMUserRegistration u where u.UserRegistrationId=t.AssignedUserId) as email into #TABLE  from   @TABLE t   
  
   
   --INSERT INTO EmailQueue(CustomerId,FacilityId,ToIds,CcIds,BccIds,ReplyIds,Subject,EmailTemplateId,TemplateVars,ContentBody,SendAsHtml,Priority,Status,TypeId,GroupId,  
   --QueuedOn,QueuedBy,SubjectVars,DataSource,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)  
   SELECT A.CustomerId,A.FacilityId,isnull(A.email,'')+','+isnull(c.Email,'') as Email,null,NULL,NULL,b.Subject,B.NotificationTemplateId,  
   A.CARNumber,  
   REPLACE([Definition],'{0}',A.CARNumber),1,1,3,NULL,NULL,GETDATE(),  
   NULL,'',0,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE() FROM #TABLE A cross join  NotificationTemplate B  
   left join #TempUserEmails c on a.CustomerId=c.CustomerId and  a.FacilityId = c.FacilityId  
   WHERE B.NotificationTemplateId = 60  
   and  not exists (select 1 from EmailQueue e  where  e.EmailTemplateId = 60 and  TemplateVars =a.CARNumber)  
   and len(isnull(A.email,'')+','+isnull(c.Email,'') )>5  
  
  
END  
  
END TRY  
BEGIN CATCH  
  
insert into ErrorLog(Spname,ErrorMessage,createddate)  
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate());  
 THROW;  
  
END CATCH  
SET NOCOUNT OFF  
End
GO
