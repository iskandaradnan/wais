USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngPlanner_RI_Summary_Test]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngPlanner_RI_Summary
Description			: Get the AssetTypeCode details
Authors				: Dhilip V
Date				: 07-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
exec uspFM_EngPlanner_RI_Summary_Test @pServiceId=2,@pFacilityId=2,@pWorkGroupid=1,@pYear=2018,@pPageIndex=1,@pPageSize=20
SELECT * FROM EngPlannerTxn
SELECT * FROM FMlOVMST WHERE LOVID=35
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngPlanner_RI_Summary_Test]
(
	@pServiceId			INT,
	@pFacilityId		INT,
	@pWorkGroupid		INT,
	@pYear				INT,
	@pPageIndex			INT,
	@pPageSize			INT
)

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @pTypeofPlanner		INT	=	35
	DECLARE	@TotalRecords		INT
	DECLARE	@pTotalPage			NUMERIC(24,2)

-- Execution


	SET DATEFIRST 1
	--declare @pYear int
	IF OBJECT_ID('tempdb..#CONSTEMP') IS NOT NULL
		DROP TABLE #CONSTEMP

	CREATE TABLE #CONSTEMP(	Row_Id INT IDENTITY(1,1),
							Assetno Varchar(max),
							AssetDescription  Varchar(max),
							Model varchar(max),
							Frequency varchar(200),
							Firstdate varchar(20),
							CustomerId int,
							TaskCode Varchar(max),
							Week1   int,	Week2   int,	Week3   int,	Week4   int,	Week5   int,	Week6   int,	Week7   int,	Week8   int,	Week9   int,	Week10   int,
							Week11   int,	Week12   int,	Week13   int,	Week14   int,	Week15   int,	Week16   int,	Week17   int,	Week18   int,	Week19   int,	Week20   int,
							Week21   int,	Week22   int,	Week23   int,	Week24   int,	Week25   int,	Week26   int,	Week27   int,	Week28   int,	Week29   int,	Week30   int,
							Week31   int,	Week32   int,	Week33   int,	Week34   int,	Week35   int,	Week36   int,	Week37   int,	Week38   int,	Week39   int,	Week40   int,
							Week41   int,	Week42   int,	Week43   int,	Week44   int,	Week45   int,	Week46   int,	Week47   int,	Week48   int,	Week49   int,	Week50   int,
							Week51   int,	Week52   int,	Week53   int,
							year int,weekno int,
							IntervalInWeeks int,
							UserAreaCode varchar(200),
							UserAreaName varchar(300),
							companylogo varbinary(max),
							mohlogo varbinary(max)
						)

	IF OBJECT_ID('tempdb..#month_weekno') IS NOT NULL
	DROP TABLE #month_weekno
	
	IF OBJECT_ID('tempdb..#WeekNo_Name') IS NOT NULL
	DROP TABLE #WeekNo_Name

	DECLARE @StartDate date = cast(@pYear as varchar)+'-01-01' , @Enddate date = cast(@pYear as varchar)+'-12-31'
	DECLARE @WeekNo int = 53--(select top 1 NoOfWeeks from GmMaintenanceYearDetailsMst where [Year] = @Year and isdeleted = 0)

	;WITH CTE_WeekNo AS 
	(
		SELECT datepart(ww,@StartDate) WeekNo, datepart(mm,@StartDate) MonthNo, @StartDate as StartDate
		UNION ALL
		SELECT datepart(ww,dateadd(day,1,startdate )) WeekNo, datepart(mm,@StartDate) MonthNo, dateadd(day,1,startdate ) as  StartDate
		FROM   CTE_WeekNo a
		WHERE StartDate  <= @Enddate
	)
	SELECT DISTINCT DATENAME(month,StartDate) as MonthName, month(StartDate) as MonthNo, WeekNo as WeekNo
	into #month_weekno
	from CTE_WeekNo where startdate <=@Enddate
	order by MonthNo, WeekNo
	option (maxrecursion 0)

	select monthname, 'WeekNo' + cast(weekno as varchar) as WeekNo 
	into #WeekNo_Name 
	from	(
				select * ,  dense_rank() over (partition by weekno order by monthno,weekno) as cou from #month_weekno
			) as a where cou = 1


	INSERT #CONSTEMP(	UserAreaCode,
						UserAreaName,
						CustomerId,
						year,
						weekno,
						IntervalInWeeks,
						companylogo,
						mohlogo
					)
	
	Select UserAreaCode,UserAreaName,CustomerId,[year]
	,weekno,IntervalInWeeks,companylogo,MohLogo
	FROM
		(
		  select	EUAM.UserAreaCode
					,EUAM.UserAreaName
					,'2018/01/01'	firstdate							--(select dbo.EngAssetAuditNextDatePPM(@Year,EPTD.IntervalInWeeks,EPTD.FirstDate)) as firstdate
					,'2018/01/01' as nextfirstdate
					,'2018/01/01' nextdate
					,EPTD.CustomerId
					,1 EquipmentType
					,@pYear as [year]
					,weekno=1				--datepart(ww,(select dbo.EngAssetAuditNextDatePPM(@Year,EPTD.IntervalInWeeks,EPTD.FirstDate)))
					--,datepart(ww,firstdate) weekno
					,1 IntervalInWeeks 
					,case when row_number() over (order by (select 1)) = 1 then d.Logo else convert(varbinary, '') end as CompanyLogo,
					case when row_number() over (order by (select 1)) = 1 then  d.Logo else convert(varbinary, '') end as  MohLogo 
					from	EngPlannerTxn EPTD 
							LEFT JOIN	MstLocationUserArea EUAM ON euam.UserAreaId =EPTD.UserAreaId
							LEFT JOIN	MstLocationFacility c           ON c.FacilityId=EPTD.FacilityId 
							LEFT JOIN	MstCustomer d                    ON d.CustomerId=c.CustomerId
					where	EPTD.WorkGroupId =@pWorkGroupid
							AND EPTD.FacilityId=@pFacilityId
			 				AND Year=@pYear
							AND EPTD.TypeOfPlanner=@pTypeofPlanner 
							AND EPTD.ServiceId =@pServiceId  
							
			
		)bb

	DECLARE  @Cnt INT,@Limit INT,@icount int,@Query VARCHAR(MAX),@Week_id Varchar(max),@firstdateF date,@daycount int
	SET @LIMIT = (SELECT MAX(Row_id) FROM #CONSTEMP)+1;        
	SET @cnt  = 1;

	WHILE @cnt < @LIMIT
	BEGIN   
		Select @Week_id=weekno,@firstdateF =firstdate From #CONSTEMP where Row_Id =@Cnt 
		print @Week_id
				declare @intercount int
		SELECT @intercount=IntervalInWeeks  From #CONSTEMP WHERE Row_id=@cnt 
		SET @Query='UPDATE #CONSTEMP SET '+'W'+@Week_id+'=' +CONVERT(VARCHAR(20),datepart(DD,@firstdateF))+'WHERE Row_Id='+CONVERT(VARCHAR(20),@Cnt)
		EXEC(@Query)
		--select 'Loop 1',@Week_id
		--select * from #CONSTEMP
		SET @icount=0;
		declare @j int=@Week_id
				While @j<=@WeekNo and isnull(@intercount,0)>0 
				Begin
				set @daycount=(@j-@Week_id)*7
				declare @datee datetime=dateadd(DAY,@daycount,@firstdateF)
				SET @Query='UPDATE #CONSTEMP SET '+'W'+convert(varchar(2),@j)+'=' +CONVERT(VARCHAR(20),datepart(DD,@datee))+' WHERE Row_Id='+CONVERT(VARCHAR(20),@cnt )
				EXEC(@Query)
				print @Query
				set @j=@j+@intercount
				end
		set @cnt=@cnt+1
	end

	SELECT @TotalRecords = COUNT(1)
	from #CONSTEMP

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

	select	UserAreaCode
			,UserAreaName
			,CustomerId
			,'W2' WorkGroupCode
			,'Biomedical Engineering' as WorkGroupDescription
			--,dbo.Fn_GetLogo(@pFacilityId, 'MOH') as 'MOH_Logo'
			--,dbo.Fn_GetLogo(@pFacilityId, 'Company') as 'Company_logo'
			,mohlogo as 'MOH_Logo'
			,companylogo as 'Company_logo'
			,dbo.udf_DisplayHospitalName(@pFacilityId) 'FacilityName'
			,ISNULL(Week1 ,0)	AS	Week1
			,ISNULL(Week2 ,0)	AS	Week2
			,ISNULL(Week3 ,0)	AS	Week3
			,ISNULL(Week4 ,0)	AS	Week4
			,ISNULL(Week5 ,0)	AS	Week5
			,ISNULL(Week6 ,0)	AS	Week6
			,ISNULL(Week7 ,0)	AS	Week7
			,ISNULL(Week8 ,0)	AS	Week8
			,ISNULL(Week9 ,0)	AS	Week9
			,ISNULL(Week10,0)	AS	Week10
			,ISNULL(Week11,0)	AS	Week11
			,ISNULL(Week12,0)	AS	Week12
			,ISNULL(Week13,0)	AS	Week13
			,ISNULL(Week14,0)	AS	Week14
			,ISNULL(Week15,0)	AS	Week15
			,ISNULL(Week16,0)	AS	Week16
			,ISNULL(Week17,0)	AS	Week17
			,ISNULL(Week18,0)	AS	Week18
			,ISNULL(Week19,0)	AS	Week19
			,ISNULL(Week20,0)	AS	Week20
			,ISNULL(Week21,0)	AS	Week21
			,ISNULL(Week22,0)	AS	Week22
			,ISNULL(Week23,0)	AS	Week23
			,ISNULL(Week24,0)	AS	Week24
			,ISNULL(Week25,0)	AS	Week25
			,ISNULL(Week26,0)	AS	Week26
			,ISNULL(Week27,0)	AS	Week27
			,ISNULL(Week28,0)	AS	Week28
			,ISNULL(Week29,0)	AS	Week29
			,ISNULL(Week30,0)	AS	Week30
			,ISNULL(Week31,0)	AS	Week31
			,ISNULL(Week32,0)	AS	Week32
			,ISNULL(Week33,0)	AS	Week33
			,ISNULL(Week34,0)	AS	Week34
			,ISNULL(Week35,0)	AS	Week35
			,ISNULL(Week36,0)	AS	Week36
			,ISNULL(Week37,0)	AS	Week37
			,ISNULL(Week38,0)	AS	Week38
			,ISNULL(Week39,0)	AS	Week39
			,ISNULL(Week40,0)	AS	Week40
			,ISNULL(Week41,0)	AS	Week41
			,ISNULL(Week42,0)	AS	Week42
			,ISNULL(Week43,0)	AS	Week43
			,ISNULL(Week44,0)	AS	Week44
			,ISNULL(Week45,0)	AS	Week45
			,ISNULL(Week46,0)	AS	Week46
			,ISNULL(Week47,0)	AS	Week47
			,ISNULL(Week48,0)	AS	Week48
			,ISNULL(Week49,0)	AS	Week49
			,ISNULL(Week50,0)	AS	Week50
			,ISNULL(Week51,0)	AS	Week51
			,ISNULL(Week52,0)	AS	Week52
			,ISNULL(Week53,0)	AS	Week53
			,@TotalRecords							AS	TotalRecords
			,@pTotalPage							AS	TotalPageCalc
			--, a.*
		from #CONSTEMP 
		ORDER BY Assetno ASC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
		--cross apply (select * from ( select * from #WeekNo_Name ) x pivot
		--(
		--	MAX(MonthName)
		--	for WeekNo in (WeekNo1,WeekNo2,WeekNo3,WeekNo4,WeekNo5,WeekNo6,WeekNo7,WeekNo8,WeekNo9,WeekNo10,WeekNo11,WeekNo12,WeekNo13,WeekNo14,WeekNo15,WeekNo16,WeekNo17,WeekNo18,WeekNo19,WeekNo20,WeekNo21,WeekNo22,WeekNo23,WeekNo24,WeekNo25,
		--	WeekNo26,WeekNo27,WeekNo28,WeekNo29,WeekNo30,WeekNo31,WeekNo32,WeekNo33,WeekNo34,WeekNo35,WeekNo36,WeekNo37,WeekNo38,WeekNo39,WeekNo40,WeekNo41,WeekNo42,WeekNo43,WeekNo44,WeekNo45,WeekNo46,WeekNo47,WeekNo48,WeekNo49,WeekNo50,WeekNo51,WeekNo52,WeekNo53)
		--) p 
		--) a


END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
