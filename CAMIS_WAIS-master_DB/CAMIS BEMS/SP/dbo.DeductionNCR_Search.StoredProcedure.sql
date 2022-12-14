USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionNCR_Search]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                
--EXEC [DeductionNCR_Search] 2021,1,'CRMWAC/B/2020/000058'              
--include  Open, Work In Progress, Closed            
CREATE PROCEDURE [dbo].[DeductionNCR_Search]                
(                
@Year INT                
,@Month INT         
,@Search NVARCHAR(50) = NULL      
      
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
AND C.Year=@YEAR        --added on 17/2/2021               
AND C.Month=@MONTH     --added on 17/2/2021
--AND YEAR(A.RequestDateTime)=@YEAR                
--AND MONTH(A.RequestDateTime)=@MONTH       
AND (      
((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( C.AssetNo LIKE + '%' + @Search + '%'  OR C.AssetNo LIKE + '%' + @Search + '%' )))      
      
----HERE @Search BEHAVES AS COMMON SEARCH PARAMETER FOR ALL THE FILEDS      
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( D.FieldValue LIKE + '%' + @Search + '%'  OR D.FieldValue LIKE + '%' + @Search + '%' )))      
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( A.NCRDescription LIKE + '%' + @Search + '%'  OR A.NCRDescription LIKE + '%' + @Search + '%' )))      
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( C.IsValid LIKE + '%' + @Search + '%'  OR C.IsValid LIKE + '%' + @Search + '%' )))      
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( C.Remarks LIKE + '%' + @Search + '%'  OR C.Remarks LIKE + '%' + @Search + '%' )))      
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( C.RemarksJOHN LIKE + '%' + @Search + '%'  OR C.RemarksJOHN LIKE + '%' + @Search + '%' )))      
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( E.IndicatorNo LIKE + '%' + @Search + '%'  OR E.IndicatorNo LIKE + '%' + @Search + '%' )))      
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( A.RequestNo LIKE + '%' + @Search + '%'  OR A.RequestNo LIKE + '%' + @Search + '%' )))        --added on 17/2/2021
)      
END                 
                
      
      
      
      
GO
