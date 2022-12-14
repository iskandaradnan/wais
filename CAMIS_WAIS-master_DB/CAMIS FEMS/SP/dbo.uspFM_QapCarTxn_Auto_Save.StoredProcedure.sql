USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QapCarTxn_Auto_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspFM_QapCarTxn_Auto_Save]
(
	@CustomerId_p	int = null,
	@FacilityId_p	int = null,
	@Year_p			int = null,
	@Month_p		int = null,
	@IsJob_BI		bit = null
)
as 
Begin

 SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY


if day(getdate())=15

BEGIN 

	DECLARE @Month int
	DECLARE @Year int
	DECLARE @FromDate datetime
	DECLARE @ToDate datetime
	DECLARE @CARDateFinal datetime
	DECLARE @ServiceID int
	DECLARE @YearEndDate datetime
	set @ServiceID=2


			if(@Year_p is null or @Month_p is null)
			begin
			set @Month= Month(DATEADD(mm, -1, GETDATE()))

			set @Year=Year(DATEADD(mm, -1, GETDATE()))
			end 
			else
			begin
			set @Month= @Month_p
			set @Year=@Year_p
			END

	set @FromDate=DATEFROMPARTS(@Year, @Month, 1 ) 
	set @ToDate=DATEADD(dd,-1, DATEADD(mm, 1, @FromDate))
	set @CARDateFinal=DATEFROMPARTS(Year(DATEADD(mm, 1, @FromDate)), Month(DATEADD(mm, 1, @FromDate)), 15 )
	set @YearEndDate= DATEFROMPARTS(@Year, 12, 31 )

	DECLARE @CarGenIndDet table (id int identity(1,1),IndiCator nvarchar(100),DDate datetime,FacilityId int,FacilityCode nvarchar(100),CustomerId int,
	service int,QindicatorID int,ExpectedPercentage decimal(18,3),TotalPer decimal(18,3),DocNumber NVARCHAR(100),CarId int,AssetId int,
	 count1 decimal(18,2), count2 decimal(18,2), stateid int,AssignedUserId int)

	 DECLARE @CarGenIndDetFinal table (id int identity(1,1),IndiCator nvarchar(100),DDate datetime,FacilityId int,FacilityCode nvarchar(100),CustomerId int,
	service int,QindicatorID int,ExpectedPercentage decimal(18,3),TotalPer decimal(18,3),DocNumber NVARCHAR(100),CarId int,AssetId int,
	count1 decimal(18,2), count2 decimal(18,2), stateid int,AssignedUserId int)

	IF OBJECT_ID('tempdb..#tmpWorkOrder') IS NOT NULL
				DROP TABLE #tmpWorkOrder

	IF OBJECT_ID('tempdb..#tmpWorkOrderFinal') IS NOT NULL
				DROP TABLE #tmpWorkOrderFinal
	IF OBJECT_ID('tempdb..#TempDocNo') IS NOT NULL
				DROP TABLE #TempDocNo
	create table #TempDocNo(DocNo nvarchar(200))




	SELECT egman.WorkOrderId,egman.TargetDateTime,
	(SELECT top 1 PlannerDate FROM EngPlannerTxnDet WHERE PlannerId=EPTD.PlannerId and PlannerDate>egman.TargetDateTime  order by PlannerDate) as NextTargetDateTime

	,EPTD.PlannerId
	INTO #TempNextSchdDate
	from  EngPlannerTxn EPTD 
				inner join EngMaintenanceWorkOrderTxn egman on EPTD.PlannerId=egman.PlannerId 
				WHERE  @FromDate>=egman.TargetDateTime  AND YEAR(egman.TargetDateTime)=@Year  and EPTD.TypeOfPlanner=34  
				and egman.CustomerId = isnull(@CustomerId_p, egman.CustomerId)
				and egman.FacilityId = isnull(@FacilityId_p, egman.FacilityId)
	
	--update #TempNextSchdDate set  NextTargetDateTime = NextTargetDateTime-1 where NextTargetDateTime is not null
	update #TempNextSchdDate set  NextTargetDateTime = @YearEndDate where NextTargetDateTime is  null

	select  egman.CustomerId,egman.FacilityId,egman.ServiceId,egman.AssetId,egman.WorkOrderId,egman.TargetDateTime,mwoc.EndDateTime,
		case when cast (mwoc.EndDateTime as date)<= cast(tplan.NextTargetDateTime as date)
		then 1
		else
		0
		end as CompleteCount,egman.AssignedUserId
	
		into #tmpWorkOrder
				from  #TempNextSchdDate as tplan
				inner join EngMaintenanceWorkOrderTxn egman on tplan.WorkOrderId=egman.WorkOrderId 
				join EngAsset AS Asset on egman.AssetId=Asset.AssetId   
				join EngAssetTypeCode TypeCode on Asset.AssetTypeCodeId=TypeCode.AssetTypeCodeId   
				join MstLocationFacility gmhos on Asset.FacilityId=gmhos.FacilityId 
				left outer join EngMwoCompletionInfoTxn mwoc on mwoc.WorkOrderId=egman.WorkOrderId 
				where  TypeCode.QAPAssetTypeB1=1   
				and (egman.WorkOrderStatus in (192,194,195))
				and  Year(tplan.NextTargetDateTime)=@Year 
				and Month(tplan.NextTargetDateTime)=@Month
				and Year(egman.TargetDateTime)=@YEAR
				and egman.CustomerId = isnull(@CustomerId_p, egman.CustomerId)
				and egman.FacilityId = isnull(@FacilityId_p, egman.FacilityId)
				and isnull(Asset.IsLoaner,0)=0

			
	select	CustomerId,FacilityId,AssignedUserId,
	cast(count(AssignedUserId) as decimal(18,2)) as TotalScedule,cast(isnull(sum(CompleteCount),0)as decimal(18,2)) as TotalSceduleComplete 
	into #tmpWorkOrderFinal from #tmpWorkOrder group by CustomerId,FacilityId,AssignedUserId


	DECLARE @QIndicatorId int
	DECLARE @IndicatorStandard decimal(18,2)
	set @QIndicatorId=(isnull((select top 1 QAPIndicatorId from MstQAPIndicator where IndicatorCode = 'B1' ),0))
	set @IndicatorStandard=(isnull((select top 1 IndicatorStandard from MstQAPIndicator where IndicatorCode = 'B1' ),0))


	insert  @CarGenIndDetFinal(IndiCator,DDate,FacilityId,FacilityCode,CustomerId,service,QindicatorID,ExpectedPercentage,TotalPer,DocNumber,count1,count2,AssignedUserId)
		select DISTINCT 'B1',
			   DATEADD(dd, -1, GETDATE()),
			   fn.FacilityId,
			   Facility.FacilityCode ,
			   fn.CustomerId,
			   2,
			  @QIndicatorId,
			  @IndicatorStandard,
			   0,
				'',
			fn.TotalScedule,
			fn.TotalSceduleComplete,
			fn.AssignedUserId
		from #tmpWorkOrderFinal fn  
		join UMUserRegistration UMUser on fn.AssignedUserId=UMUser.UserRegistrationId
		--join #tmpWorkOrder AS tmpWrk on fn.AssignedUserId=tmpWrk.AssignedUserId
		join MstLocationFacility AS Facility on fn.FacilityId=Facility.FacilityId
		--where  engasert.ServiceId=@ServiceID and TypeCode.QAPAssetTypeB1=1   
		--AND engasert.AssetStatusLovId=1 
		--and 	isnull((select count(*) from EngPlannerTxn where AssetId=engasert.AssetId  and TypeOfPlanner=34),0)>0 
		--and fn.CustomerId = isnull(@CustomerId_p, gmhos.CustomerId)
		--and gmhos.FacilityId = isnull(@FacilityId_p, gmhos.FacilityId)


		update @CarGenIndDetFinal set TotalPer = (
										case
											when  count1 = 0 then 100.00
											else  cast(cast((cast(count2 as decimal(18,5)) / cast(count1 as decimal(18,5))) as decimal(18,5) )*100.00 as  decimal(18,3))
											end 
										)
	
									
	-----CAR insert and update-------
	 insert into @CarGenIndDet (IndiCator,DDate,FacilityId,FacilityCode,CustomerId,service,QindicatorID ,ExpectedPercentage,TotalPer,DocNumber,CarId,AssetId,count1,count2,stateid,AssignedUserId ) 
	select DISTINCT IndiCator,DDate,FacilityId,FacilityCode ,CustomerId,service,QindicatorID ,ExpectedPercentage,TotalPer,DocNumber,CarId,AssetId,count1, count2,stateid ,AssignedUserId
	  from  @CarGenIndDetFinal where TotalPer>=0 and TotalPer<ExpectedPercentage	

		 declare @Current int = 1;
		 declare @Max int;
		 SET  @Max = (SELECT count(*) from @CarGenIndDet)
	  
		 if(@IsJob_BI is null)
		 begin
		 set @IsJob_BI=0
		 end
	 	

		
		 if(@IsJob_BI!=1)
		 begin	 
		 while @Current <= @Max

		 BEGIN
		 DECLARE @CARNUMBER NVARCHAR(50), @DocNumber NVARCHAR(50),@hosalcode nvarchar(15),@IndiCator nvarchar(50),@TotalPer decimal(18,2),@ExpectedPercentage decimal(18,2)
		 set @hosalcode=(select top 1 FacilityCode from @CarGenIndDet where id=@Current)
		 set @IndiCator=(select top 1 IndiCator from @CarGenIndDet where id=@Current)
		 set @TotalPer=(select top 1 TotalPer from @CarGenIndDet where id=@Current)
		 DECLARE @TotalPer3dec decimal(18,3) 
		 set @TotalPer3dec=(select top 1 TotalPer from @CarGenIndDet where id=@Current)
		 set @TotalPer= left(@TotalPer3dec,len(@TotalPer3dec)-1)

		 set @ExpectedPercentage=(select top 1 ExpectedPercentage from @CarGenIndDet where id=@Current)
		 declare @Hospid int ,@indid int ,@Servid int ,@compid int ,@CARNId int,@AssetRegId int	 ,@AssignUserId int	,@AssignUserName nvarchar(200)	
	 set @Hospid=(select top 1 FacilityId from @CarGenIndDet where id=@Current)
	 set @compid=(select top 1 CustomerId from @CarGenIndDet where id=@Current)
	 set @indid=(select top 1 QindicatorID from @CarGenIndDet where id=@Current)
	 set @AssetRegId=(select top 1 AssetId from @CarGenIndDet where id=@Current)
	 set @AssignUserId=(select top 1 a.AssignedUserId from @CarGenIndDet a inner join UMUserRegistration b on a.AssignedUserId=b.UserRegistrationId where id=@Current)
	 set @AssignUserName=(select top 1 b.StaffName from @CarGenIndDet a inner join UMUserRegistration b on a.AssignedUserId=b.UserRegistrationId where id=@Current)
	 set @Servid=(select top 1 service from @CarGenIndDet where id=@Current)
	 set @CARNId=isnull((select top 1 CarId from QapCarTxn where FacilityId=@Hospid and CustomerId=@compid 
	 and QAPIndicatorId=@indid and ServiceId=@Servid and Year(FromDate)=@Year and Month(FromDate)=@Month  and IsAutoCar=1 and AssignedUserId=@AssignUserId),0)
	 DECLARE @TABLE TABLE (ID INT,AssignedUserId int,CARNumber nvarchar(1000),FacilityId int,CustomerId int)
	  
	 -----Check already exists-----------------
	 if(@CARNId=0)
	 BEGIN

		 DECLARE @pOutParam NVARCHAR(50)
		 DECLARE @id int

		insert #TempDocNo	
		EXEC [uspFM_GenerateDocumentNumber] @pFlag='QAPCarTxn',@pCustomerId=@compid,@pFacilityId=@Hospid,@Defaultkey='CAR',@pModuleName=@IndiCator,@pMonth=@Month_p,@pYear=@Year_p,@pOutParam=@pOutParam OUTPUT
		SET @CARNUMBER=@pOutParam

		  update @CarGenIndDet set DocNumber=case when TotalPer<ExpectedPercentage then  @CARNUMBER 
		 else '' end from @CarGenIndDet where id=@Current
		 --DECLARE @AssetCode nvarchar(100)
		 --set @AssetCode=(select top 1 ast.AssetNo from 
		 --EngAsset ast   where ast.AssetId=(select top 1 AssetId from @CarGenIndDet where id=@Current))
		  DECLARE @ProblemStatement nvarchar(1000)
		 set @ProblemStatement='CAR Generated for the month of '+UPPER(SUBSTRING (DATENAME(MONTH,DATEFROMPARTS(@Year, @Month, 1 )),1,3))+', '+cast(@year as varchar(10))+' for the Indicator B1  for Assigned Staff '+ @AssignUserName
 
		  --inserting into corrective action report
		INSERT INTO QapCarTxn(FacilityId, CustomerId,CARNumber,CARDate,ProblemStatement,ServiceId,PriorityLovId,Status, 
		QAPIndicatorId,FromDate,ToDate,AssetId,ExpectedPercentage,ActualPercentage,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,
		AssignedUserId,IsAutoCar) OUTPUT INSERTED.CarId,INSERTED.AssignedUserId,INSERTED.CARNumber,INSERTED.FacilityId ,INSERTED.CustomerId INTO @TABLE
		select FacilityId,CustomerId,DocNumber,	getdate()	-- @CARDateFinal  -- DD This should be changed after UAT for CarDate
		,@ProblemStatement,service,296, 300,QindicatorID,@FromDate,@ToDate,AssetId 
		,@ExpectedPercentage,@TotalPer,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),AssignedUserId,1
		from @CarGenIndDet  where id=@Current	
		set @id = (SELECT top 1 ID FROM @TABLE)
		insert into QapB1AdditionalInformationTxn (CustomerId,FacilityId,CarId,ServiceId,AssetId,WorkOrderId,TargetDateTime,EndDateTime,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,CauseCodeId,QcCodeId)
		select A.CustomerId,A.FacilityId,@id,A.ServiceId,A.AssetId,A.WorkOrderId,A.TargetDateTime,A.EndDateTime,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),B.CauseCode,B.QCCode
		from #tmpWorkOrder A LEFT JOIN EngMwoCompletionInfoTxn B ON A.WorkOrderId = B.WorkOrderId 
		where CompleteCount=0 and AssignedUserId in (select AssignedUserId from @CarGenIndDet  where id=@Current)
	
		--DECLARE @CarDate datetime
		--SET @CarDate = DATEFROMPARTS(@Year, (@Month-1), 1 )
		--update QAPCarTxn set CARDate=@CarDate,FromDate=@CarDate,ToDate=EOMONTH(@CarDate) WHERE CarId = @id


	
						
			
		




		 end

	 else
	 begin
	 if(@TotalPer<@ExpectedPercentage)
	 begin
	 update QapCarTxn set ExpectedPercentage=@ExpectedPercentage,ActualPercentage=@TotalPer,ModifiedDate=getdate() where CarId=@CARNId 

	 DELETE FROM QapB1AdditionalInformationTxn where CarId=@CARNId 

	 insert into QapB1AdditionalInformationTxn (CustomerId,FacilityId,CarId,ServiceId,AssetId,WorkOrderId,TargetDateTime,EndDateTime,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,CauseCodeId,QcCodeId)
		select A.CustomerId,A.FacilityId,@CARNId,A.ServiceId,A.AssetId,A.WorkOrderId,A.TargetDateTime,A.EndDateTime,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),B.CauseCode,B.QCCode
		from #tmpWorkOrder A LEFT JOIN EngMwoCompletionInfoTxn B ON A.WorkOrderId = B.WorkOrderId 
		 where CompleteCount=0 and AssignedUserId in (select AssignedUserId from @CarGenIndDet  where id=@Current)

	 end
	 else
	 begin
	 update QapCarTxn set ModifiedDate=getdate() where CarId=@CARNId
	 update QapB1AdditionalInformationTxn set ModifiedDate=getdate() where CarId=@CARNId 
	 end
	 end

			set @Current += 1;

		 end
		  update QapCarTxn  set ModifiedDate=getdate() from QapCarTxn
		 inner join @CarGenIndDetFinal sct on QapCarTxn.QAPIndicatorId=sct.QindicatorID and QapCarTxn.ServiceId=sct.service
		 and Month(QapCarTxn.FromDate)=@Month and Year(QapCarTxn.FromDate)=@Year  and QapCarTxn.FacilityId=sct.FacilityId
		 and QapCarTxn.CustomerId=sct.CustomerId and (sct.TotalPer<0 or sct.TotalPer>=sct.ExpectedPercentage) and QapCarTxn.AssetId=sct.AssetId
		 and QapCarTxn.IsAutoCar=1
		 end
		  -----End CAR insert and update-------

		   -----Start QapIndicatorCommonMst--
	--	  DECLARE @CarGenIndDetCommonmst table (id int identity(1,1),IndiCator nvarchar(100),DDate datetime,FacilityId int,FacilityCode nvarchar(100),CustomerId int,
	--service int,QindicatorID int,ExpectedPercentage decimal(18,2),TotalPer decimal(18,3),DocNumber NVARCHAR(100),CarId int,
	--count1 decimal(18,2), count2 decimal(18,2))

	-- insert into @CarGenIndDetCommonmst (FacilityId,CustomerId,service,QindicatorID ,ExpectedPercentage,count1,count2 ) 
	--select  FacilityId ,CustomerId,service,QindicatorID ,ExpectedPercentage,isnull((sum(count1)),0), isnull((sum(count2)),0)  
	--  from  @CarGenIndDetFinal group by FacilityId ,CustomerId,service,QindicatorID ,ExpectedPercentage	
	--  update @CarGenIndDetCommonmst set TotalPer = (
	--									case
	--										when  count1 = 0 then 100.00
	--										else  cast(cast((cast(count2 as decimal(18,5)) / cast(count1 as decimal(18,5))) as decimal(18,5) )*100.00 as  decimal(18,3))
	--										end 
	--									)

	--	 DECLARE @indicaId int,@ServiceId1 int,@tcount int ,@Ecount int,@existsCount int
	--	 set @indicaId=(select top 1 QindicatorID from @CarGenIndDetCommonmst )
	--	  set @ServiceId1=(select top 1 service from @CarGenIndDetCommonmst )
	--	 if exists(select * from QapIndicatorCommonMst where QIndicatorId=@indicaId and Service=@ServiceId and Month(FromDate)=@Month and Year(FromDate)=@Year )
	--	 begin

	--	 if(@CustomerId_p is not null )
	--	 begin
	--	 update  QapIndicatorCommonMst set IsDeleted=1 ,ModifiedDate=getdate() where CustomerId=@CustomerId_p and QIndicatorId=@indicaId and Service=@ServiceId and Month(FromDate)=@Month and Year(FromDate)=@Year 
	--	 end
	--	 if(@FacilityId_p is not null )
	--	 begin
	--	 update  QapIndicatorCommonMst set IsDeleted=1 ,ModifiedDate=getdate() where FacilityId=@FacilityId_p and QIndicatorId=@indicaId and Service=@ServiceId and Month(FromDate)=@Month and Year(FromDate)=@Year 
	--	 end
	--	 if(@CustomerId_p is null and @FacilityId_p is null )
	--	 begin
	--	 update  QapIndicatorCommonMst set IsDeleted=1 ,ModifiedDate=getdate() where QIndicatorId=@indicaId and Service=@ServiceId and Month(FromDate)=@Month and Year(FromDate)=@Year 
	--	 end
	--	 INSERT INTO QapIndicatorCommonMst(FacilityId, CustomerId,Service,QIndicatorId,ExceptedPercentage,
	--	 ActualPercentage,DateTime,FromDate,ToDate,	 CarId,CreatedBy,CreatedDate,TotalCount,ExceptionCount,PassedCount) 
	--	 select FacilityId,CustomerId,service,QindicatorID,ExpectedPercentage,left(TotalPer,len(TotalPer)-1),@CARDateFinal,@FromDate,@ToDate,@id,1,GETDATE(),  0,count1,isnull(count1,0)-isnull(count2,0),count2
	--	 from @CarGenIndDetCommonmst 
	--	 ---Update 
	--	-- update QapIndicatorCommonMst  set ModifiedDate=getdate(),ExceptedPercentage=sct.ExpectedPercentage,
	--ActualPercentage=left(sct.TotalPer,len(sct.TotalPer)-1),TotalCount=sct.count1,ExceptionCount=isnull(sct.count1,0)-isnull(sct.count2,0),PassedCount=sct.count2 from QapIndicatorCommonMst
	--	-- inner join @CarGenIndDetCommonmst sct on QapIndicatorCommonMst.QIndicatorId=sct.QindicatorID and QapIndicatorCommonMst.Service=sct.service
	--	-- and Month(QapIndicatorCommonMst.FromDate)=@Month and Year(QapIndicatorCommonMst.FromDate)=@Year and QapIndicatorCommonMst.IsDeleted=0 and QapIndicatorCommonMst.FacilityId=sct.FacilityId
	--	-- and QapIndicatorCommonMst.CustomerId=sct.CustomerId

	--	--set @tcount=isnull((select count(*) from QapIndicatorCommonMst where QIndicatorId=@indicaId and Service=@ServiceId and Month(FromDate)=@Month and Year(FromDate)=@Year ),0)
	--	--set @Ecount=isnull((select count(*) from @CarGenIndDetCommonmst),0)

	--	--if(@tcount!=@Ecount)
	--	--begin
	--	-----Missing Data insert
	--	--INSERT INTO QapIndicatorCommonMst(FacilityId, CustomerId,Service,QIndicatorId,ExceptedPercentage,
	--	-- ActualPercentage,DateTime,FromDate,ToDate,	 CarId,CreatedBy,CreatedDate,TotalCount,ExceptionCount,PassedCount) 
	--	-- select sct.FacilityId,sct.CustomerId,sct.service,sct.QindicatorID,sct.ExpectedPercentage,left(sct.TotalPer,len(sct.TotalPer)-1),@CARDateFinal,@FromDate,@ToDate,@id,1,GETDATE(),  0,sct.count1,isnull(sct.count1,0)-isnull(sct.count2,0),sct.count2
	--	-- from QapIndicatorCommonMst 
	--	-- left join @CarGenIndDetCommonmst sct on QapIndicatorCommonMst.QIndicatorId=sct.QindicatorID and QapIndicatorCommonMst.Service=sct.service
	--	-- and Month(QapIndicatorCommonMst.FromDate)=@Month and Year(QapIndicatorCommonMst.FromDate)=@Year and QapIndicatorCommonMst.IsDeleted=0 and QapIndicatorCommonMst.FacilityId=sct.FacilityId
	--	-- and QapIndicatorCommonMst.CustomerId=sct.CustomerId where QapIndicatorCommonMst.IndicatorCGId is null
	-- --   -----------Delete record
	--	--update QapIndicatorCommonMst  set IsDeleted=1,ModifiedDate=getdate() from QapIndicatorCommonMst
	--	-- left join @CarGenIndDetCommonmst sct on QapIndicatorCommonMst.QIndicatorId=sct.QindicatorID and QapIndicatorCommonMst.Service=sct.service
	--	-- and Month(QapIndicatorCommonMst.FromDate)=@Month and Year(QapIndicatorCommonMst.FromDate)=@Year and QapIndicatorCommonMst.IsDeleted=0 and QapIndicatorCommonMst.FacilityId=sct.FacilityId
	--	-- and QapIndicatorCommonMst.CustomerId=sct.CustomerId and sct.FacilityId is null 
	--	--  where Month(QapIndicatorCommonMst.FromDate)=@Month and Year(QapIndicatorCommonMst.FromDate)=@Year and QapIndicatorCommonMst.IsDeleted=0 
	--	-- and QapIndicatorCommonMst.QIndicatorId=@indicaId
	--	-- and QapIndicatorCommonMst.FacilityId=sct.FacilityId
	--	-- and QapIndicatorCommonMst.CustomerId=sct.CustomerId

	--	--end
	--	 end
	--	 else
	--	 begin
	--	 INSERT INTO QapIndicatorCommonMst(FacilityId, CustomerId,Service,QIndicatorId,ExceptedPercentage,
	--	 ActualPercentage,DateTime,FromDate,ToDate,	 CarId,CreatedBy,CreatedDate,TotalCount,ExceptionCount,PassedCount) 
	--	 select FacilityId,CustomerId,service,QindicatorID,ExpectedPercentage,left(TotalPer,len(TotalPer)-1),@CARDateFinal,@FromDate,@ToDate,@id,1,GETDATE(),  0,count1,isnull(count1,0)-isnull(count2,0),count2
	--	 from @CarGenIndDetCommonmst 
	--	 end
     
	---End QapIndicatorCommonMst



	select IndiCator,AssignedUserId,b.StaffName as AssignedUser,DDate,a.FacilityId,FacilityCode,a.CustomerId,service,QindicatorID,ExpectedPercentage, stateid, count1, count2, 0 as TotalPer
	--,case when sum(count1) = 0 then 100.00
	--		 else  cast(cast((cast(sum(count2) as decimal(18,5)) / cast(sum(count1) as decimal(18,5))) as decimal(18,5) )*100.00 as  decimal(18,2))  
	--		 end as TotalPer

	from @CarGenIndDetFinal a inner join UMUserRegistration b on a.AssignedUserId=b.UserRegistrationId

	--group by IndiCator,DDate,FacilityId,FacilityCode,CustomerId,service,QindicatorID,ExpectedPercentage, stateid



	select  ID ,AssignedUserId ,CARNumber ,FacilityId ,CustomerId, (select email from  UMUserRegistration u where u.UserRegistrationId=t.AssignedUserId) as email into #TABLE  from   @TABLE t 

	declare @notificationTable table (id int)

	INSERT INTO WebNotification (	CustomerId,
											FacilityId,
											UserId,
											NotificationAlerts,
											Remarks,
											HyperLink,
											IsNew,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC	,
											NotificationDateTime,
											IsNavigate							                                                                                                           
										)  output inserted.NotificationId into @notificationTable

										select  	a.CustomerId,
													a.FacilityId,
													a.AssignedUserId,
													'Auto CAR has been generated '+a.CARNumber+ ' and assgined to user',
													'',
													'/qap/correctiveactionreport?id='+cast(a.id as varchar(100)),
													1,
													1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE(),getdate(),
													0		
							FROM #TABLE A 	
							where not exists (select 1 from EmailQueue e  where  e.EmailTemplateId = 60	and  TemplateVars =a.CARNumber)





SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification1
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = 60

	
		
	SELECT	distinct A.UserRegistrationId,
			b.FacilityId,
			b.CustomerId		
		INTO	#TempUserEmails_all1
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification1)
	--IN (SELECT DISTINCT FacilityId FROM #Notification)

									

	INSERT INTO WebNotification (	CustomerId,
											FacilityId,
											UserId,
											NotificationAlerts,
											Remarks,
											HyperLink,
											IsNew,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC	,
											NotificationDateTime,
											IsNavigate							                                                                                                           
										)

										select  distinct	b.CustomerId,
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
													b.ModifiedDateUTC	,
													b.NotificationDateTime,
													b.IsNavigate		
										from #TempUserEmails_all1 a  left join   WebNotification  b 
										on a.CustomerId=b.CustomerId  and a.FacilityId=b.FacilityId
										where b.NotificationId  in (select  id  from @notificationTable ) 

										

			
			SELECT	NotificationDeliveryId,
					NotificationTemplateId,
					UserRoleId,
					UserRegistrationId,
					FacilityId
			INTO	#Notification
			FROM	NotificationDeliveryDet
			WHERE	NotificationTemplateId = 60



	
			SELECT	DISTINCT
				IDENTITY(INT ,1,1) AS ID,
				b.FacilityId,
				b.CustomerId,
				ltrim(rtrim(Email)) as EMAIL		
				INTO	#TempUserEmails_all
			FROM	UMUserRegistration AS A	
					INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
			WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification)
			--AND B.FacilityId	= @pFacilityId
			--IN (SELECT DISTINCT FacilityId FROM #Notification)
	
	
			select IDENTITY(INT ,1,1) AS ID,
				FacilityId,
				CustomerId,
				Email
			INTO	#TempUserEmails
			from 
	
			(
			select
			distinct
				A.FacilityId,
				A.CustomerId,
				CAST(STUFF((SELECT ',' + RTRIM(AA.Email ) FROM #TempUserEmails_all AA where A.FacilityId = AA.FacilityId and A.CustomerId = AA.CustomerId -- AA.FacilityId=b.FacilityId 
				FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) AS Email
	
			 from #TempUserEmails_all a) a


		

	



			INSERT INTO EmailQueue(CustomerId,FacilityId,ToIds,CcIds,BccIds,ReplyIds,Subject,EmailTemplateId,TemplateVars,ContentBody,SendAsHtml,Priority,Status,TypeId,GroupId,
			QueuedOn,QueuedBy,SubjectVars,DataSource,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			SELECT A.CustomerId,A.FacilityId,isnull(A.email,'')+','+isnull(c.Email,'') as Email,null,NULL,NULL,b.Subject,B.NotificationTemplateId,
			A.CARNumber,
			REPLACE([Definition],'{0}',A.CARNumber),1,1,3,NULL,NULL,GETDATE(),
			NULL,'',0,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE() FROM #TABLE A cross join  NotificationTemplate B
			left join #TempUserEmails c on a.CustomerId=c.CustomerId and  a.FacilityId = c.FacilityId
			WHERE B.NotificationTemplateId = 60
			and  not exists (select 1 from EmailQueue e  where  e.EmailTemplateId = 60	and  TemplateVars =a.CARNumber)
			and len(isnull(A.email,'')+','+isnull(c.Email,'') )>5









END

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)
		VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate());

	THROW;

END CATCH
SET NOCOUNT OFF

End
GO
