USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DedNCRValidationTxn_SaveTEST]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC DedNCRValidationTxn_SaveTEST 2021, 1

CREATE PROCEDURE [dbo].[DedNCRValidationTxn_SaveTEST]   
( @YEAR INT   
,@MONTH INT )              

AS  
BEGIN


DELETE FROM DedNCRValidationTxnTest06022021 WHERE YEAR=@YEAR AND MONTH=@MONTH  
 
DECLARE @PREV_YEAR INT
DECLARE @PREV_MONTH INT
SET @PREV_YEAR=(CASE WHEN @MONTH=1 THEN @YEAR-1 ELSE @YEAR END)                    
SET @PREV_MONTH=(CASE WHEN @MONTH=1 THEN 12 ELSE @MONTH-1 END)   

-- INSERT INTO DedNCRValidationTxnTest06022021 (  
-- CustomerId        
--,FacilityId        
--,ServiceId        
--,Month        
--,Year        
--,DedGenerationId        
--,IndicatorDetId        
--,CreatedBy        
--,CreatedDate        
--,CreatedDateUTC        
--,ModifiedBy        
--,ModifiedDate        
--,ModifiedDateUTC        
--,IsAdjustmentSaved )   

--DECLARE @YEAR INT   
--DECLARE @MONTH INT
--DECLARE @PREV_YEAR INT
--DECLARE @PREV_MONTH INT

--SET @YEAR = 2021
--SET @MONTH = 1
--SET @PREV_YEAR=(CASE WHEN @MONTH=1 THEN @YEAR-1 ELSE @YEAR END)                    
--SET @PREV_MONTH=(CASE WHEN @MONTH=1 THEN 12 ELSE @MONTH-1 END)


IF  
	(SELECT count(requestdatetime) from [uetrackMasterdbPreProd].[dbo].CRMRequest where year(requestdatetime) = @YEAR and Month(requestdatetime) = @MONTH 
	AND ServiceId=2 AND ISNULL(Indicators_all,'')<>'') > 0

	BEGIN

	INSERT INTO DedNCRValidationTxnTest06022021 (  
	 CustomerId        
	,FacilityId        
	,ServiceId        
	,Month        
	,Year        
	,DedGenerationId        
	,IndicatorDetId        
	,CreatedBy        
	,CreatedDate        
	,CreatedDateUTC        
	,ModifiedBy        
	,ModifiedDate        
	,ModifiedDateUTC        
	,IsAdjustmentSaved ) 

		SELECT DISTINCT         
		157 AS  CustomerId        
		,144 AS FacilityId        
		,2 AS ServiceId        
		,@MONTH AS MONTH       
		,@YEAR AS YEAR       
		,NULL AS DedGenerationId        
		,Indicators_all         
		,19 AS CreatedBy        
		,GETDATE() AS CreatedDate        
		,GETUTCDATE() AS CreatedDateUTC        
		,19 AS ModifiedBy        
		,GETDATE() AS ModifiedDate        
		,GETUTCDATE() AS ModifiedDateUTC        
		,0 AS IsAdjustmentSaved
		FROM [uetrackMasterdbPreProd].[dbo].CRMRequest  
		where year(requestdatetime) = @YEAR 
		and month(RequestDateTime) = @MONTH
		AND ServiceId=2 
		AND ISNULL(Indicators_all,'')<>'' 
	END

ELSE

IF @MONTH = 1
	BEGIN

	INSERT INTO DedNCRValidationTxnTest06022021 (  
	 CustomerId        
	,FacilityId        
	,ServiceId        
	,Month        
	,Year        
	,DedGenerationId        
	,IndicatorDetId        
	,CreatedBy        
	,CreatedDate        
	,CreatedDateUTC        
	,ModifiedBy        
	,ModifiedDate        
	,ModifiedDateUTC        
	,IsAdjustmentSaved ) 

		SELECT DISTINCT         
		157 AS  CustomerId        
		,144 AS FacilityId        
		,2 AS ServiceId        
		,@MONTH AS MONTH       
		,@YEAR AS YEAR       
		,NULL AS DedGenerationId        
		,Indicators_all         
		,19 AS CreatedBy        
		,GETDATE() AS CreatedDate        
		,GETUTCDATE() AS CreatedDateUTC        
		,19 AS ModifiedBy        
		,GETDATE() AS ModifiedDate        
		,GETUTCDATE() AS ModifiedDateUTC        
		,0 AS IsAdjustmentSaved
		FROM [uetrackMasterdbPreProd].[dbo].CRMRequest  
		where Completed_Date IS NULL 
		and year(requestdatetime) <= @PREV_YEAR
		and month(RequestDateTime) <= 12
		AND ServiceId=2 
		AND ISNULL(Indicators_all,'')<>'' 
	END

ELSE

	

		SELECT DISTINCT         
		157 AS  CustomerId        
		,144 AS FacilityId        
		,2 AS ServiceId        
		,@MONTH AS MONTH       
		,@YEAR AS YEAR       
		,NULL AS DedGenerationId        
		,Indicators_all         
		,19 AS CreatedBy        
		,GETDATE() AS CreatedDate        
		,GETUTCDATE() AS CreatedDateUTC        
		,19 AS ModifiedBy        
		,GETDATE() AS ModifiedDate        
		,GETUTCDATE() AS ModifiedDateUTC        
		,0 AS IsAdjustmentSaved
		FROM [uetrackMasterdbPreProd].[dbo].CRMRequest  
		where Completed_Date IS NULL 
		and year(requestdatetime) <= @PREV_YEAR
		and month(RequestDateTime) <= 12
		AND ServiceId=2 
		AND ISNULL(Indicators_all,'')<>'' 

		UNION

		SELECT DISTINCT         
		157 AS  CustomerId        
		,144 AS FacilityId        
		,2 AS ServiceId        
		,@MONTH AS MONTH       
		,@YEAR AS YEAR      
		,NULL AS DedGenerationId        
		,Indicators_all         
		,19 AS CreatedBy        
		,GETDATE() AS CreatedDate        
		,GETUTCDATE() AS CreatedDateUTC        
		,19 AS ModifiedBy        
		,GETDATE() AS ModifiedDate        
		,GETUTCDATE() AS ModifiedDateUTC        
		,0 AS IsAdjustmentSaved
		FROM [uetrackMasterdbPreProd].[dbo].CRMRequest  
		where Completed_Date IS NULL 
		and year(requestdatetime) = @YEAR
		and month(RequestDateTime) <= @PREV_MONTH
		AND ServiceId=2 
		AND ISNULL(Indicators_all,'')<>'' 
 
	END


GO
