USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionTransactionMappingTxnDet_FetchDispute]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
    
        
CREATE PROCEDURE [dbo].[DeductionTransactionMappingTxnDet_FetchDispute]       
(    
  @Year INT              
 ,@Month INT              
 ,@IndicatorDetId INT              
  ,@DP NVARCHAR(50) = NULL      

--disable in 09022021
-- @Year INT        
--,@Month INT        
--,@IndicatorDetId INT        
        
)        
AS        
        
BEGIN        
        
--DECLARE @Year INT        
--DECLARE @Month INT        
--DECLARE @IndicatorDetId INT        
        
        
--SET @Year=2020        
--SET @Month=7        
--SET @IndicatorDetId=6     

SELECT  *  
FROM  vwDedTransactionMappingTxnDet   
WHERE Year =@Year   
AND Month =@Month   
AND IndicatorDetId =@IndicatorDetId     
AND DPStatus =@DP  
  
ORDER BY Date   
 
--disabled in 09022021 
--SELECT  CustomerId        
--,FacilityId        
--,DedTxnMappingId        
--,DedTxnMappingDetId      
--,Date        
--,DocumentNo        
--,Details        
--,AssetNo        
--,AssetDescription        
--,ScreenName        
--,DemeritPoint        
--,FinalDemeritPoint        
--,DisputedDemeritPoints        
--,IsValid        
--,Remarks   
--,RemarksJOHN  
--,FileName    
--,DeductionValue        
--,FinalDeductionValue        
--,CreatedBy        
--,CreatedDate        
--,CreatedDateUTC        
--,ModifiedBy        
--,ModifiedDate        
--,ModifiedDateUTC        
--,Year        
--,Month        
--,IndicatorDetId        
--,IndicatorName        
--,Flag        
--,UptimeAchieved        
--,PurchaseCost        
--,DeductionFigureperAsset        
--,NameofReport        
--,SubmissionDueDate        
--,DateSubmitted        
--,Frequency        
--,ScheduledDate        
--,ReScheduledDate        
--,StartDate        
--,TypeCode        
--,TRPIUptime FROM  DedTransactionMappingTxnDet WHERE Year =@Year AND Month =@Month AND IndicatorDetId =@IndicatorDetId   AND DemeritPoint <> '0'      
--AND (Remarks IS NOT NULL AND Remarks <> '')    
--ORDER BY Date  

END
GO
