USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Summary_DAR_Data]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version				:               
File Name			:              
Procedure Name		: [usp_FM_Summary_DAR_Data] 
Author(s) Name(s)	: Balaji M S
Date				: 31/05/2018
Purpose				: 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
EXEC SPNAME Parameter    
EXEC [uspFM_Summary_DAR_Data]  '@pFacilityId','@pFromMonth','@pYear'
EXEC [uspFM_Summary_DAR_Data] '2',2,5,2018
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/   
 			          
CREATE PROCEDURE  [dbo].[uspFM_Summary_DAR_Data]                           
( 
		@pFacilityId						INT,                                           
		@pFromMonth							INT,
		@pToMonth							INT,
		@pYear								INT

 )           
AS                                              
BEGIN                                
SET NOCOUNT ON  
SET ARITHABORT OFF
SET ANSI_WARNINGS OFF                                 
 


CREATE TABLE #RESULT   
 (  
		Services							NVARCHAR(200),
		MSF									NUMERIC(13,2),
		RM									NUMERIC(13,2),
		Deduction_Percentage 				NUMERIC(13,2),
		CF									NUMERIC(13,2)
 ) 
 
CREATE TABLE #FINAL
(
		Indicator_No						VARCHAR(5),
		Deduction_Value_RM					NUMERIC(13,2),
		MSF									NUMERIC(13,2),
		FLAG								VARCHAR(2)

)

DECLARE 
		@Ind_No								VARCHAR(5),
		@COUNT								INT,
		@INDEX								INT = 0,
		@WEIGHT								NUMERIC(13,2),
		@KEY								NUMERIC(13,2),
		@PARAMETER							INT,
		@RINGEQ								NUMERIC(13,2),
		@GEAR_RATIO							NUMERIC(13,2),
		@UNSATIS							INT,
		@DED_VALUE							NUMERIC(13,2),
		@DED_PERCENT						NUMERIC(13,2),
		@MSF								NUMERIC(13,2),
		@BEMSKEY							NUMERIC(13,2),
		@BEMSMSF							NUMERIC(13,2),
		@BEMSRM								NUMERIC(13,2),	
		@DEDVALUE							NUMERIC(13,2),
		@BEMSCF								NUMERIC(13,2),
		@CF									NUMERIC(13,2),
		@MonthId							INT
INSERT	INTO #FINAL (Indicator_No,FLAG)
SELECT	IndicatorNo,'N'		FROM MstDedIndicatorDet
 



SELECT	@COUNT = COUNT(*) FROM #FINAL

WHILE	(@INDEX <= @COUNT)
BEGIN

SET ROWCOUNT 1

SELECT	@Ind_No							= Indicator_No FROM #FINAL
WHERE	FLAG							= 'N'

SET ROWCOUNT 0

SELECT	@MonthId						= F.Month,
		@WEIGHT							= D.Weightage,
		@BEMSKEY						= CONVERT(NUMERIC(13,2),(D.Weightage * (F.BemsMSF*0.975))),
		@PARAMETER						= B.TotalParameter,
		@BEMSMSF						= F.BemsMSF, --BemsMSF,
		@BEMSCF							= F.BemsCF,
		@UNSATIS						= (B.TransactionDemeritPoint),
		@DEDVALUE						= case when deductionstatus = 'G' then b.deductionvalue else b.postdeductionvalue end
FROM	DedGenerationTxn A
join 	DedGenerationTxnDet B	on		A.DedGenerationId				= B.DedGenerationId
join	MstDedIndicator C		on 		A.ServiceId						= C.ServiceId
join	MstDedIndicatorDet D	on		C.IndicatorId					= D.IndicatorId AND		B.IndicatorDetId				= D.IndicatorDetId
join	FinMonthlyFeeTxn E		on		A.FacilityId					= E.FacilityId
join	FinMonthlyFeeTxnDet F   on		E.MonthlyFeeId					= F.MonthlyFeeId

WHERE	A.FacilityId					 in (@pFacilityId)
AND		A.MONTH		BETWEEN      		 @pFromMonth AND @pToMonth
AND		A.YEAR							= @pYear
AND		E.Year							= @pYear
AND		F.Month		BETWEEN      		 @pFromMonth AND @pToMonth
AND		D.IndicatorNo					= @Ind_No
AND		B.SubParameterDetId				IS NULL


IF (@Ind_No LIKE 'B%')
BEGIN
SELECT	@RINGEQ							= @BEMSKEY / @PARAMETER
SELECT	@MSF							= @BEMSMSF
SELECT  @CF								= @BEMSCF
END


SELECT	@GEAR_RATIO						= @RINGEQ * 2

SELECT	@DED_VALUE						= @GEAR_RATIO * @UNSATIS



UPDATE	#FINAL
SET		Deduction_Value_RM				= @DEDVALUE,
		--Deduction_Value_RM				= @DED_VALUE,
		MSF								= @MSF,
		FLAG							= 'Y'
WHERE	Indicator_No					= @Ind_No

SET		@INDEX							= @INDEX + 1

END



SELECT * FROM #FINAL


--SELECT	@BEMSRM							= ISNULL(SUM(Deduction_Value_RM),0) From	#FINAL Where Indicator_No LIKE 'B%'



--INSERT INTO	 #RESULT(Services,MSF,RM,Deduction_Percentage,CF)
--VALUES	('Biomedical Engineering Maintenance Services',@BEMSMSF,@BEMSRM,(@BEMSRM/@BEMSMSF) * 100,@CF)

INSERT INTO	 #RESULT(Services,MSF,RM,Deduction_Percentage,CF)
VALUES	('Biomedical Engineering Maintenance Services',@BEMSMSF,@DEDVALUE,(@DEDVALUE/@BEMSMSF) * 100,@CF)

	
Select * from #RESULT
--SELECT * FROM #FINAL

DROP TABLE #RESULT
DROP TABLE #FINAL

SET ANSI_WARNINGS ON 
SET ARITHABORT ON
SET NOCOUNT OFF  

END
GO
