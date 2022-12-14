USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_KpiGenerationTxn_Popup_Save_test]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspFM_KpiGenerationTxn_Popup_Save_test] (
	@pYear INT,
	@pMonth INT,
	@pServiceId INT,
	@pFacilityId INT
	)AS

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_DedGenerationTxn]
Description			: Asset number fetch control
Authors				: Dhilip V
Date				: 08-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_DedGenerationTxn_Popup_Save] @pYear=2018,@pMonth=05, @pServiceId=2,@pFacilityId=2
select * from DedGenerationBemsPopupTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================
------------------:------------:-------------------------------------------------------------------
Raguraman J		  : 07/09/2016 : B1 - Responsetime emergency:15 mins / normal:120 mins
								 B2 - Working days greater than 7 days
								 B3 - PPM,SCM & RI
								 B4 - Uptime & Downtime Calculation
								 B5 - From NCR 
-----:------------:------------------------------------------------------------------------------*/


BEGIN TRY


		select distinct customerreportid,ReportName  into #Custreport from MstCustomerReport  
				where  customerid in (select customerid from MstLocationFacility where facilityid = @pFacilityId)
				and active=1

				select distinct b.customerreportid,b.ReportsandRecordTxnDetId,b.Verified,b.Remarks into #KPIreport from KPIReportsandRecordTxn a join KPIReportsandRecordTxnDet  b on a.ReportsandRecordTxnId=b.ReportsandRecordTxnId
				where a.facilityid = @pFacilityId
				AND Month	=	@pMonth 
				AND Year	=	@pYear
				

				--select count(a.customerreportid)  as DemeritPoint into #tmpB6 from #Custreport  a
				--left join #KPIreport  b on a.customerreportid=b.customerreportid
				--where b.customerreportid is null


				 
				select ReportName as Item,Remarks as Remarks , case when Verified=0 then 'No' else 'Yes' end as Verified, 1 as DemeritPoint into #tmpB6 from #Custreport  a
				left join #KPIreport  b on a.customerreportid=b.customerreportid
				where b.customerreportid is null

					declare @Weightage  numeric(24,2)  , @mCustomerId  int , @MonthlyServiceFee  float,@keyIndicatorValue decimal(24,4),
			@Ringittequivalent decimal(12,2),@TotalParameters float,@MonthlyServiceFeeVal float,@TotalDM int,@GearingRatio decimal(12,4),
			@DeductionValue decimal(12,2), @DeductionPer decimal(12,2)

	
	select @mCustomerId = customerid from MstLocationFacility where facilityid = @pFacilityId


	set @Weightage = ( select Weightage from MstDedIndicatorDet dmd where  dmd.IndicatorNo = 'B.6' )
	set @Weightage=1.00

	SELECT	@MonthlyServiceFee = B.BemsMSF
	FROM	FinMonthlyFeeTxn A
			JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId
	WHERE A.[Year] = @pYear AND B.[Month] = @pMonth AND A.CustomerId = @mCustomerId AND A.FacilityId = @pFacilityId

	
	
	set @MonthlyServiceFeeVal = @MonthlyServiceFee;
	set @keyIndicatorValue = (@Weightage * @MonthlyServiceFeeVal);
		
	
	select @TotalParameters = count(customerreportid) from  #Custreport
	select @TotalDM = count(DemeritPoint) from  #tmpB6

	if(@TotalParameters !=0)

	begin

	set @Ringittequivalent = (@keyIndicatorValue/@TotalParameters);

	end

	set @GearingRatio = (@Ringittequivalent * 200)/100.00;
	set @DeductionValue = (@GearingRatio * @TotalDM);

	set @DeductionPer = (@DeductionValue / @MonthlyServiceFeeVal)*100.00;


	
	--update #dedCalc set TotalDemeritPoints = isnull(@TotalDM,0) ,
	--NCRDemeritPoints = (ISNULL(@totalNcrPoints,0)),
	--TotalParameters = isnull(@TotalParameter,0),DeductionValue = isnull(@DeductionValue,0),
	--DeductionPer = isnull(@DeductionPer,0),GearingRatio=isnull(@GearingRatio,0),
	--Ringittequivalent=isnull(@Ringittequivalent,0),keyIndicatorValue=isnull(@keyIndicatorValue,0),Weightage = ISNULL(@Weightage, 0) 
	--where IndicatorNo = 'FM.1' 

	
	
	
	SELECT 6, 'B.6'
		, 'Report', NULL AS SubParameter
		,  @TotalDM AS TransDemeritPoints		
		,  @TotalDM AS TotalDemeritPoints
		, NULL AS TotalParameters	
		, @DeductionValue AS DeductionValue
		, @DeductionPer AS DeductionPer
	FROM #tmpB6 t

	

		SELECT 
		'B.6',
		(select DedGenerationId from DedGenerationTxn where FacilityId = @pFacilityId and Month = @pMonth and Year = @pYear),
		@pFacilityId, 
		@pMonth,
		@pyear,
		item,
		item,
		Remarks,
		'No' as UnderWarranty,
		DemeritPoint,
		0,0,2, GETDATE(), GETUTCDATE(),0
		from  #tmpB6




END TRY

BEGIN CATCH
THROW
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
