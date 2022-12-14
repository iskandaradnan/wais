USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMSummaryFeeRpt_Fetch]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* UNIT TEST
EXEC [uspFM_VMSummaryFeeRpt_Fetch] @pServiceId=2,@pFacilityId=2,@pAssetClassificationId=1,@pMonth=4,@pYear=2018,@pRollOverId=NULL
EXEC [uspFM_VMSummaryFeeRpt_Fetch] @pServiceId=2,@pFacilityId=1,@pMonth=7,@pYear=2018,@pRollOverId=NULL
*/

CREATE PROCEDURE [dbo].[uspFM_VMSummaryFeeRpt_Fetch]



		@pServiceId					INT = NULL,
		@pFacilityId				INT,
		--@pAssetClassificationId		INT,
		@pMonth						NVARCHAR(10),
		@pYear						NVARCHAR(10),
		@pRollOverId				INT=null,
		@pErrorMessage				NVARCHAR(500)=null output

AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


DECLARE @Cal_Date			date,
		@SubmissionDate		date,
		@Cal_Year			VARCHAR(10)
	
	--SELECT @Cal_Year = CASE WHEN @pMonth = 4610  THEN @pYear
 --                   WHEN @pMonth = 4611  THEN (@pYear+1) END, 
	--		@Cal_Date = CASE WHEN @pMonth = 4610 THEN CONVERT(DATE,@Cal_Year+'-07'+'-01')
 --                         WHEN @pMonth = 4611 THEN CONVERT(DATE,@Cal_Year+'-01'+'-01')
	--				  END,
	--		@SubmissionDate = CASE WHEN @pMonth = 4610 THEN CONVERT(DATE,@pYear+'-01'+'-01')
 --                         WHEN @pMonth = 4611 THEN CONVERT(DATE,(@pYear)+'-07'+'-01')
	--				  END

if isnull(@pRollOverId,0)=0  and exists ( select 1 from VMRollOverFeeReport where ServiceId	 = @pServiceId and FacilityId=@pFacilityId and Month =@pMonth	and Year = @pYear	)
begin 
set @pErrorMessage='Summary of Fee already saved for the Year and Month'
return
end
ELSE
begin
set @pErrorMessage = ''
END

set @Cal_Date = CONVERT(DATE,@pYear+'-'+@pMonth+'-01')
SET @SubmissionDate= eomonth(CONVERT(DATE,@pYear+'-'+@pMonth+'-01'))

	 CREATE TABLE #Consolidated_DW
	(
	 Row_Id INT IDENTITY(1,1),
	 FacilityId			INT,
	 Month             VARCHAR(10),
	 DWCOUNT_ID			INT,
	 DWCOUNT            INT,
	 DWTotalFee         DECIMAL(18,2),
	 ServiceId          INT
	 )

	 CREATE TABLE #Consolidated_PW
	(
	 Row_Id INT IDENTITY(1,1),
	 FacilityId			INT,
	 Month             VARCHAR(10),
	 PWCOUNT_ID			INT,
	 PWCOUNT            INT,
	 PWTotalFe          DECIMAL(18,2),
	 ServiceId          INT
	 )

	  CREATE TABLE #Consolidated
	(
	 Row_Id INT IDENTITY(1,1),
	 FacilityId			INT,
	 Month             VARCHAR(10),
	 DWCOUNT_ID			INT,
	 DWCOUNT            INT,
	 DWTotalFee         DECIMAL(18,2),
	 PWCOUNT_ID			INT,
	 PWCOUNT            INT,
	 PWTotalFe          DECIMAL(18,2),
	 ServiceId          INT
	 )




	--- Temp table for Change Fee from VM

	select  CustomerId,FacilityId,MONTH(VariationRaisedDate) MONTH,sum(case when isnull(MonthlyProposedFeeDW,0)>0 then 1 else 0  end) DWCount,  
	sum(case when isnull(MonthlyProposedFeePW,0)>0 then 1 else 0  end) PWCount,
	sum(MonthlyProposedFeeDW) as DW,sum(MonthlyProposedFeePW) as PW , 	
	sum(isnull(MonthlyProposedFeeDW,0)+isnull(MonthlyProposedFeePW,0)) as ChangeFee
	INTO #AssetStartFee
	from VmVariationTxn v
	where 
	--CustomerId = @pCustomerId	and 
	Month(VariationRaisedDate) = @pMonth
	AND YEAR(VariationRaisedDate) = @pYear
	AND ServiceStopDate IS NULL
	AND v.VariationWFStatus = 230
	and FacilityId = isnull(nullif(@pFacilityId,0),FacilityId)
	group by CustomerId,FacilityId,MONTH(VariationRaisedDate)--,AssetId
	
	
	select  CustomerId,FacilityId,MONTH(VariationRaisedDate) MONTH,sum(case when isnull(MonthlyProposedFeeDW,0)>0 then 1 else 0  end) DWCount,
	sum(case when isnull(MonthlyProposedFeePW,0)>0 then 1 else 0  end) PWCount,
	sum(MonthlyProposedFeeDW) *-1 as DW,sum(MonthlyProposedFeePW)*-1 as PW , 
	sum(isnull(MonthlyProposedFeeDW,0)+isnull(MonthlyProposedFeePW,0)) *-1 as ChangeFee
	INTO #AssetStopFee
	from VmVariationTxn v
	where Month(VariationRaisedDate) = @pMonth
	AND YEAR(VariationRaisedDate) = @pYear
	AND ServiceStopDate IS NOT NULL
	AND v.VariationWFStatus = 230
	and FacilityId = isnull(nullif(@pFacilityId,0),FacilityId)
	group by CustomerId,FacilityId,MONTH(VariationRaisedDate)--,AssetId
	
	select  CustomerId,FacilityId,MONTH,sum(DWCount) as DWCount ,
	sum(DW) as DWTotalFee,sum(PWCount) as PWCount,
	sum(PW) as PWTotalFee , sum(ChangeFee) as ChangeFee
	into #AssetFee
	from (
	select * from #AssetStartFee
	union all
	select * from #AssetStopFee
	)a
	group by CustomerId,FacilityId,a.MONTH

	
	DECLARE 			 @VerifiedBy    VARCHAR(500), 	 @VerifiedDate	date, 	
						 @ApprovedBy    VARCHAR(500),	 @ApprovedDate	date,   
						  @Status int
	
	--Verified By
	SELECT @VerifiedBy =  B.StaffName, @VerifiedDate = DoneDate--, @VerifiedDesignation = 'Engineer'
	FROM VmRollOverFeeReportHistoryDet A INNER JOIN UMUserRegistration B ON A.DoneBy = B.UserRegistrationId
	WHERE RollOverFeeId = @pRollOverID AND A.[Status] = 233 

	--Approved By
	SELECT @ApprovedBy =  B.StaffName, @ApprovedDate = DoneDate--, @ApprovedDesignation = 'Engineer'
	FROM VmRollOverFeeReportHistoryDet A INNER JOIN UMUserRegistration B ON A.DoneBy = B.UserRegistrationId
	WHERE RollOverFeeId = @pRollOverID AND A.[Status] = 230 


	SELECT TOP 1 @Status = [Status] FROM VmRollOverFeeReport WHERE [Year] = @pYear AND Month = @pMonth --AND AssetClassificationId = @pAssetClassificationId 
	and ServiceId = @pServiceId
	
	
		   SELECT top 1
				CND.CustomerId,
				CND.FacilityId,
				c.FacilityName AS 'Facility_Name',
				1 as DWCOUNT_ID,
				DWCOUNT,
				cast( case when DWTotalFee>0 then DWTotalFee else 0 end as numeric(30,2)) as DWTotalFee,
				@pYear	AS	Year,
				@pMonth Month ,
				2 as PWCOUNT_ID,
				PWCOUNT,
				cast( case when PWTotalFee>0 then PWTotalFee else 0 end as numeric(30,2)) as PWTotalFe,				
				cast(isnull(cast( case when DWTotalFee>0 then DWTotalFee else 0 end as numeric(30,2)) ,0) + isnull(cast( case when PWTotalFee>0 then PWTotalFee else 0 end as numeric(30,2)) ,0)  as numeric(30,2)) AS 'Total_Fee',
				'BEMS' AS 'Service_Name',
				--@pAssetClassificationId AS 'Asset_Classification',
				@VerifiedBy	 AS 'VerifiedBy',
				format(@VerifiedDate,'dd-MMM-yyyy')   AS 'VerifiedDate',		
				@ApprovedBy	 AS 'ApprovedBy',
				format(@ApprovedDate,'dd-MMM-yyyy')   AS 'ApprovedDate',		
				format(@Cal_Date,'dd-MMM-yyyy') as PaymentStartDate,
				@pServiceId as 'ServiceID',
				--@pAssetClassificationId as 'ClassificationID',
				@Status AS [Status],
				MONTH(@SubmissionDate) AS SubmissionMONTH
			FROM 
				#AssetFee CND
		    LEFT JOIN 
				dbo.MstLocationFacility as c on c.FacilityId = CND.FacilityId
			LEFT JOIN 
				MstCustomer f on f.CustomerId = c.CustomerId
			WHERE 
				c.FacilityId = isnull(nullif(@pFacilityId,0),c.FacilityId)
			ORDER BY
				FacilityId
						

		


	drop table #Consolidated_DW
	drop table #Consolidated_PW
	drop table #Consolidated


		
END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		   THROW;

END CATCH
GO
