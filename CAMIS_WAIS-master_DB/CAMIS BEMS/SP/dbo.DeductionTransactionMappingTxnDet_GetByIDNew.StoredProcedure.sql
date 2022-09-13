USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionTransactionMappingTxnDet_GetByIDNew]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
         
		 

--EXEC DeductionTransactionMappingTxnDet_GetByIDNew 2020,10,2,'With DP'            
            
CREATE PROCEDURE [dbo].[DeductionTransactionMappingTxnDet_GetByIDNew]            
(            
  @Year INT            
 ,@Month INT            
 ,@IndicatorDetId INT            
  ,@DP NVARCHAR(50) = NULL      
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
END
GO
