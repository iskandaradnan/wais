USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MonthlyServiceFee_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MonthlyServiceFee_Save
Description			: If Finance Monthly Fedd already exists then update else insert.
Authors				: Dhilip V
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC [uspFM_MonthlyServiceFee_Save] @pCustomerId=1

select * FROM FinMonthlyFeeTxn
select * FROM FinMonthlyFeeTxnDet
select * FROM FinMonthlyFeeHistoryTxnDet

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MonthlyServiceFee_Save]

			--@pCustomerId						INT =null

AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT
	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE 	@mLoopStart				INT =1,
				@mLoopLimit				INT
-- Default Values
IF OBJECT_ID('tempdb..#temp') IS NOT NULL
  DROP TABLE #temp 
IF OBJECT_ID('tempdb..#TempFacilityMonths') IS NOT NULL
  DROP TABLE #TempFacilityMonths 
IF OBJECT_ID('tempdb..#CustomerWiseFee') IS NOT NULL
DROP TABLE #CustomerWiseFee 
-- Execution

create table #temp  (id int)
insert into #temp select YEAR(GETDATE())


--- Temp table with Year and month
select    IDENTITY(INT,1,1) AS ID,  
	t.id as [year]
   ,m.[month]
   ,DateName(month,DateAdd(month,(m.[month]-1),0)) as MonthName
   ,cast(null as numeric(24,2)) as MonthlyServiceFee
   ,cast(null as numeric(24,2)) as CF
   ,cast(null as numeric(24,2)) as KPI
   ,cast(null as numeric(24,2)) as TotalFee
   ,cast(null as int) CustomerId
   ,cast(null as int) FacilityId
	INTO #TempFacilityMonths
from      #temp t
cross join   (values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) m([month])

--- Temp table with CustomerId and FacilityId

			SELECT	CustomerId,
					FacilityId,
					MonthlyServiceFee
			INTO #CustomerWiseFee
			FROM MstLocationFacility	
			WHERE --CustomerId	=	@pCustomerId AND 
			MonthlyServiceFee IS NOT NULL

	ALTER TABLE #CustomerWiseFee ADD ID INT 
	SELECT  ROW_NUMBER() OVER (ORDER BY FacilityId) AS ID,FacilityId INTO #ID from #CustomerWiseFee
	
	UPDATE A SET A.ID=B.ID FROM #CustomerWiseFee A INNER JOIN #ID B ON A.FacilityId=B.FacilityId


----- Temp table for Change Fee from VM

--	select  CustomerId,FacilityId,MONTH(VariationRaisedDate) MONTH,sum(CalculatedFeeDW) as DW,sum(CalculatedFeePW) as PW , 
--	CASE	WHEN max(WarrantyEndDate)>= GETDATE() THEN SUM(CalculatedFeeDW)
--			WHEN max(WarrantyEndDate)< GETDATE() THEN SUM(CalculatedFeePW)
--			END ChangeFee
--	INTO #AssetStartFee
--	from VmVariationTxn
--	where 
--	--CustomerId = @pCustomerId	and 
--	YEAR(VariationRaisedDate) = YEAR(GETDATE())
--	AND ServiceStopDate IS NULL
--	group by CustomerId,FacilityId,MONTH(VariationRaisedDate),AssetId
	
	
--	select FacilityId,MONTH,SUM(ChangeFee) AS ChangeFee 
--	INTO #VMStartFee
--	from #AssetStartFee
--	group by FacilityId,MONTH
	
--	select CustomerId,FacilityId, MONTH(VariationRaisedDate) MONTH,sum(CalculatedFeeDW) as DW,sum(CalculatedFeePW) as PW ,
--	CASE	WHEN max(WarrantyEndDate)>= GETDATE() THEN SUM(CalculatedFeeDW)
--			WHEN max(WarrantyEndDate)< GETDATE() THEN SUM(CalculatedFeePW)
--			END ChangeFee
--	INTO #AssetStopFee
--	from VmVariationTxn 
--	where 
--	--CustomerId = @pCustomerId	and 
--	YEAR(VariationRaisedDate) = YEAR(GETDATE())
--	AND ServiceStopDate IS NOT NULL
--	group by CustomerId,FacilityId,MONTH(VariationRaisedDate),AssetId
	
	
--	select FacilityId,MONTH,SUM(ChangeFee) AS ChangeFee 
--	INTO #VMStopFee
--	from #AssetStopFee
--	group by FacilityId,MONTH
	
	
	
	--- Temp table for Change Fee from VM

	select  CustomerId,FacilityId,MONTH(VariationRaisedDate) MONTH,count(case when isnull(MonthlyProposedFeeDW,0)>0 then 1 else 0  end) DWCount,  
	count(case when isnull(MonthlyProposedFeePW,0)>0 then 1 else 0  end) PWCount,
	sum(MonthlyProposedFeeDW) as DW,sum(MonthlyProposedFeePW) as PW , 	
	sum(isnull(MonthlyProposedFeeDW,0)+isnull(MonthlyProposedFeePW,0)) as ChangeFee
	INTO #AssetStartFee
	from VmVariationTxn v
	where 
	--CustomerId = @pCustomerId	and 
	YEAR(VariationRaisedDate) = YEAR(GETDATE())
	AND ServiceStopDate IS NULL
	AND v.VariationWFStatus = 230
	--and FacilityId = isnull(nullif(@pFacilityId,0),FacilityId)
	group by CustomerId,FacilityId,MONTH(VariationRaisedDate)--,AssetId
	
	
	select  CustomerId,FacilityId,MONTH(VariationRaisedDate) MONTH,count(case when isnull(MonthlyProposedFeeDW,0)>0 then 1 else 0  end) DWCount,
	count(case when isnull(MonthlyProposedFeePW,0)>0 then 1 else 0  end) PWCount,
	sum(MonthlyProposedFeeDW) *-1 as DW,sum(MonthlyProposedFeePW)*-1 as PW , 
	sum(isnull(MonthlyProposedFeeDW,0)+isnull(MonthlyProposedFeePW,0)) *-1 as ChangeFee
	INTO #AssetStopFee
	from VmVariationTxn v
	where YEAR(VariationRaisedDate) = YEAR(GETDATE())
	AND ServiceStopDate IS NOT NULL
	AND v.VariationWFStatus = 230
	--and FacilityId = isnull(nullif(@pFacilityId,0),FacilityId)
	group by CustomerId,FacilityId,MONTH(VariationRaisedDate)--,AssetId
	
	select  CustomerId,FacilityId,MONTH,count(DWCount) as DWCount ,
	sum(DW) as DWTotalFee,count(PWCount) as PWCount,
	sum(PW) as PWTotalFee , sum(ChangeFee) as ChangeFee
	into #VMStartFee
	from (
	select * from #AssetStartFee
	union all
	select * from #AssetStopFee
	)a
	group by CustomerId,FacilityId,a.MONTH



--- Temp table for deduction value form KPI
	
	select KPI.FacilityId,KPI.Month,SUM(DeductionValue) AS DeductionValue 
	INTO #KpiFee
	from DedGenerationTxn AS KPI INNER JOIN DedGenerationTxnDet AS	KPIDet ON KPI.DedGenerationId	=	KPIDet.DedGenerationId
	WHERE Year	=	YEAR(GETDATE())
	--AND KPI.FacilityId=1
	GROUP BY KPI.FacilityId,KPI.Month

	SELECT @mLoopLimit	=	COUNT(1) FROM #CustomerWiseFee
	WHILE (@mLoopStart<=@mLoopLimit)

	BEGIN

	UPDATE #TempFacilityMonths SET	FacilityId = (SELECT DISTINCT FacilityId FROM #CustomerWiseFee WHERE ID=@mLoopStart),
									CustomerId= (SELECT DISTINCT CustomerId FROM #CustomerWiseFee WHERE ID=@mLoopStart),
									MonthlyServiceFee= (SELECT DISTINCT MonthlyServiceFee FROM #CustomerWiseFee WHERE ID=@mLoopStart)

		IF NOT EXISTS (SELECT * FROM FinMonthlyFeeTxn 
			WHERE	FacilityId in (select FacilityId from #TempFacilityMonths) AND Year in (SELECT DISTINCT Year from #TempFacilityMonths))
			BEGIN
	          INSERT INTO FinMonthlyFeeTxn(
			  										CustomerId,
													FacilityId,
													Year,
													VersionNo,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC
                           )OUTPUT INSERTED.MonthlyFeeId INTO @Table
				SELECT	DISTINCT A.CustomerId,
						A.FacilityId,
						A.Year,
						1,
						1,
						GETDATE(),
						GETUTCDATE(),
						1,
						GETDATE(),
						GETUTCDATE()
				FROM
				#TempFacilityMonths			AS A
						LEFT JOIN	FinMonthlyFeeTxn	AS	MonthlyFee	ON	A.FacilityId=MonthlyFee.FacilityId	AND	MonthlyFee.Year=A.year
				   WHERE	MonthlyFee.MonthlyFeeId IS  NULL



			DECLARE @mPrimaryId INT;
			SELECT @mPrimaryId=MonthlyFeeId FROM FinMonthlyFeeTxn WHERE	MonthlyFeeId IN (SELECT ID FROM @Table)
			IF(@mPrimaryId IS NULL)

			SELECT @mPrimaryId=MonthlyFeeId FROM FinMonthlyFeeTxn 
			WHERE	FacilityId in (select FacilityId from #TempFacilityMonths) AND Year in (SELECT DISTINCT Year from #TempFacilityMonths)


			  INSERT INTO FinMonthlyFeeTxnDet(
													CustomerId,
													FacilityId,
													MonthlyFeeId,
													Month,
													VersionNo,
													BemsMSF,
													BemsKPIF,
													BemsCF,
													BemsPercent,
													TotalFee,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC
                                                    )
				SELECT	DISTINCT CustomerId,
						FacilityId,
						@mPrimaryId,
						month,
						1,
						MonthlyServiceFee,
						null,
						null,
						null,
						MonthlyServiceFee,
						1,
						GETDATE(),
						GETUTCDATE(),
						1,
						GETDATE(),
						GETUTCDATE()
				FROM #TempFacilityMonths

				END
--SELECT * FROM #AssetStartFee A LEFT JOIN #AssetStopFee B ON A.FacilityId=B.FacilityId



--SELECT * FROM FinMonthlyFeeTxnDet A INNER JOIN #AssetStartFee B  ON A.FacilityId=B.FacilityId AND A.Month=B.MONTH

--UPDATE A SET A.ChangeFee = A.ChangeFee-ISNULL(B.ChangeFee,0)
--FROM #VMStartFee A LEFT JOIN #VMStopFee B ON A.FacilityId=B.FacilityId AND A.MONTH=B.MONTH



UPDATE A SET A.CF=case when isnull(B.ChangeFee,0)>0 then B.ChangeFee else 0 end 
FROM #TempFacilityMonths A INNER JOIN #VMStartFee B  ON A.FacilityId=B.FacilityId AND A.Month=B.MONTH


UPDATE A SET A.KPI=B.DeductionValue
FROM #TempFacilityMonths A INNER JOIN #KpiFee B  ON A.FacilityId=B.FacilityId AND A.Month=B.MONTH


update a set  monthlyservicefee = isnull(a.monthlyservicefee,0)+isnull(b.CF_pervmonth,0)
from
#TempFacilityMonths  a 
OUTER APPLY  (select SUM(cf) AS CF_pervmonth from #TempFacilityMonths a1 WHERE a1.month<A.month and a1.year= A.year) b



UPDATE A SET A.BemsMSF=B.MonthlyServiceFee,a.BemsCF=b.CF,a.BemsKPIF=b.KPI
FROM FinMonthlyFeeTxnDet A INNER JOIN #TempFacilityMonths B  ON A.FacilityId=B.FacilityId AND A.Month=B.MONTH
--WHERE B.month>= (MONTH(GETDATE())-1)

UPDATE FinMonthlyFeeTxnDet  SET TotalFee = ISNULL(BemsMSF,0)+ISNULL(BemsCF,0)-ISNULL(BemsKPIF,0)
WHERE FacilityId in (select FacilityId from #TempFacilityMonths)
--AND month>= (MONTH(GETDATE())-1)

--SELECT * FROM #TempFacilityMonths

--select *,SUM(MonthlyServiceFee+ISNULL(CF,0)) OVER (ORDER BY ID) from #TempFacilityMonths

	SET @mLoopStart	=	@mLoopStart+1
	END



	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           COMMIT TRANSACTION
 --       END   


END TRY

BEGIN CATCH

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           ROLLBACK TRAN
 --       END

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
