USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Deduction_DashBoard]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_Deduction_DashBoard
Description			: Get the Deduction_DashBoard
Authors				: Dhilip V
Date				: 09-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_Deduction_DashBoard  @pFacilityId=2,@pYear=2018,@pMonth=4

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Deduction_DashBoard]    
		@pFacilityId	INT,
		@pYear			INT,
		@pMonth			INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


	DECLARE @TempDed TABLE	(	CustomerId int,
								FacilityId int,
								ServiceId int ,
								Year int,
								Month int,
								MSF numeric(12,2),
								DeductionValue numeric(12,2),
								DeductionPercentage numeric(12,2),
								PenaltyValue numeric(12,2),
								PenaltyPercentage numeric(12,2),
								[Group] int
							)


-- Default Values

	INSERT INTO @TempDed	(	CustomerId,
								FacilityId,
								Year,
								Month,
								MSF,
								ServiceId,
								[Group])
	SELECT	SF1.CustomerId,
			SF1.FacilityId,
			SF1.Year,
			SF2.Month,
			SF2.BemsPercent,
			2					AS	ServiceId,
			88					AS	[Group]
	FROM	FinMonthlyFeeTxn				AS	SF1	WITH(NOLOCK)
			INNER JOIN	FinMonthlyFeeTxnDet	AS	SF2	WITH(NOLOCK) ON SF1.MonthlyFeeId=SF2.MonthlyFeeId
	WHERE	Year	=	@pYear

-- Execution



	UPDATE Ded SET	Ded.DeductionValue		=	Ded1.DeductionValue,
					Ded.DeductionPercentage	=	Ded1.DeductionPercentage 
		FROM	@TempDed Ded 
		INNER JOIN (	SELECT	DG1.CustomerId,
								DG1.FacilityId,
								DG1.Year,
								DG1.Month,
								DG1.ServiceId,
								[group],
								SUM(CASE 
										WHEN DG1.DeductionStatus='A' THEN DG2.PostDeductionValue 
										WHEN DG1.DeductionStatus='G' THEN DG2.DeductionValue 
									END)								AS	DeductionValue,
								SUM(CASE 
										WHEN DG1.DeductionStatus='A' THEN DG2.PostDeductionPercentage 
										WHEN DG1.DeductionStatus='G' THEN DG2.DeductionPercentage 
									END)								AS	DeductionPercentage
							FROM	DedGenerationTxn					AS	 DG1	WITH(NOLOCK) 
									LEFT OUTER JOIN DedGenerationTxnDet	AS	 DG2	WITH(NOLOCK) ON DG1.DedGenerationId=DG2.DedGenerationId 
							GROUP BY DG1.CustomerId,DG1.FacilityId,DG1.Year,DG1.Month,DG1.ServiceId,[group]
					)Ded1 ON	Ded.CustomerId=Ded1.CustomerId 
								AND Ded.FacilityId=Ded1.FacilityId 
								AND Ded.year=Ded1.Year 
								AND Ded.month=Ded1.Month 
								AND Ded.ServiceId=Ded1.ServiceId 
								AND Ded.[group]=Ded1.[group]

/*
	UPDATE Ded SET	Ded.PenaltyValue		=	Ded1.PenaltyValue,
					Ded.PenaltyPercentage	=	Ded1.PenaltyPercentage 
		FROM	@TempDed Ded 
				INNER JOIN (	SELECT	DP1.CustomerId,
										DP1.FacilityId,
										DP1.Year,
										DP1.Month,
										DP1.ServiceId,
										DP1.[group],
										sum(DP1.PenaltyValue)PenaltyValue,
										sum(DP1.PenaltyPercentage)PenaltyPercentage
								FROM  DedPenaltyAssessmentTxn DP1 
								WHERE DP1.IsDeleted=0  
								GROUP BY DP1.CustomerId,DP1.FacilityId,DP1.Year,DP1.Month,DP1.ServiceId,[group]
							)	Ded1 ON	Ded.CustomerId=Ded1.CustomerId 
								AND Ded.FacilityId=Ded1.FacilityId 
								AND Ded.year=Ded1.Year 
								AND Ded.month=Ded1.Month 
								AND Ded.ServiceId=Ded1.ServiceId 
								AND Ded.[group]=Ded1.[group]
*/


		SELECT	'BEMS'									AS	Service,
				ISNULL(Ded.MSF,0)AS MSF,
				ISNULL(Ded.Deductionvalue,0)			AS DeductionValue,
				--ISNULL(Ded.deductionpercentage,0)		AS DeductionPercentage,
				CASE 
					WHEN ISNULL(Ded.MSF,0)=0 THEN 0 
					ELSE CAST((ISNULL(Ded.Deductionvalue,0)*100)/ISNULL(Ded.MSF,0) AS NUMERIC(12,2))  
				END										AS DeductionPercentage
				--ISNULL(Ded.PenaltyValue,0) AS PenaltyValue,
				--ISNULL(Ded.PenaltyPercentage,0) AS PenaltyPercentage 
		FROM	@TempDed Ded 
		WHERE	Ded.FacilityId	=	@pFacilityId
				AND Ded.Year	=	@pYear
				AND Ded.Month	=	@pMonth
		order by ServiceID


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
