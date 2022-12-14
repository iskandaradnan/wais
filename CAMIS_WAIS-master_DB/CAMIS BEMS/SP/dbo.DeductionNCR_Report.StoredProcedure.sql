USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionNCR_Report]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
--EXEC [DeductionNCR_Report] 2020,11,'B.4'    
CREATE PROCEDURE [dbo].[DeductionNCR_Report]                    
(                    
@Year INT                    
,@Month INT     
,@Indicator NVARCHAR(50) = NULL     
)                    
AS                    
BEGIN                    
    
    
    
SELECT                     
A.RequestDateTime,A.Completed_Date,A.RequestNo,B.FieldValue,A.NCRDescription,A.RequestStatus,D.FieldValue AS Status,A.Action_Taken,C.DedNCRValidationDetId                  
 ,YEAR(A.RequestDateTime) AS Year                    
,MONTH(A.RequestDateTime)  AS Month                    
,Indicators_all         
,E.IndicatorNo      
,C.AssetNo                    
,C.DemeritPoint                    
,C.FinalDemeritPoint   
,C.DeductionValue  
,C.DeductionValue AS DeductionFigureProHawk  
,C.IsValid                    
,C.DisputedDemeritPoints                    
,C.Remarks           
,C.RemarksJOHN        
,C.FileName         
FROM [uetrackMasterdbPreProd].[dbo].CRMRequest A                    
INNER JOIN [uetrackMasterdbPreProd].[dbo].FMLovMst B                    
ON A.TypeOfRequest=B.LovId                    
LEFT OUTER JOIN DedNCRValidationTxnDet C                  
ON A.CRMRequestId = C.CRMRequestId                  
LEFT OUTER JOIN [uetrackMasterdbPreProd].[dbo].FMLovMst D                    
ON A.RequestStatus=D.LovId             
LEFT OUTER JOIN MstDedIndicatorDet E                    
ON A.Indicators_all=E.IndicatorDetId         
WHERE B.LovId='10020'                    
AND A.RequestStatus IN (139, 140, 142)                    
AND A.ServiceId=2            
AND C.Year=@YEAR                    
AND C.Month=@MONTH  
AND E.IndicatorNo=@Indicator
ORDER BY E.IndicatorDetId   
END                     
                    
GO
