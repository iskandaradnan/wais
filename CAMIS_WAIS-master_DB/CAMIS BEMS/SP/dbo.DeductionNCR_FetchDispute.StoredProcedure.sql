USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionNCR_FetchDispute]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
          
--EXEC DeductionNCR_FetchDispute 2020,11       
--include  Open, Work In Progress, Closed      
CREATE PROCEDURE [dbo].[DeductionNCR_FetchDispute]          
(          
@Year INT          
,@Month INT          
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
INNER JOIN [uetrackMasterdbPreProd].[dbo].FMLovMst D          
ON A.RequestStatus=D.LovId  
INNER JOIN MstDedIndicatorDet E              
ON A.Indicators_all=E.IndicatorDetId  
WHERE B.LovId='10020'          
AND A.RequestStatus IN (139, 140, 142)          
AND A.ServiceId=2      
AND C.Year=@YEAR                  
AND C.Month=@MONTH  
--AND YEAR(A.RequestDateTime)=@YEAR          
--AND MONTH(A.RequestDateTime)=@MONTH     
--AND (C.Remarks IS NOT NULL AND C.Remarks <> '')  
END           
          
GO
