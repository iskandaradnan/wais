USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSCleanLinenIssueTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
CREATE VIEW [dbo].[VW_LLSCleanLinenIssueTxn]                        
AS                        
                
WITH CTE AS                
(                
                
SELECT                                 
A.CustomerId,                        
A.FacilityId,                        
A.CleanLinenIssueId,                
B.CleanLinenRequestId,                
 A.DeliveryDate1st,                                  
 A.CLINo,                                  
 B.DocumentNo AS CLRNo,                                  
 FMLovMst2.FieldValue AS Priority,                                  
 C.UserAreaCode,                                  
 D.UserLocationCode,                                  
 User1.StaffName AS ReceivedBy,                                  
 User2.StaffName AS DeliveredBy,                                  
                 
 B.TotalItemRequested,                                  
 A.TotalItemIssued,                                  
COALESCE(B.TotalItemRequested,0)-                                  
COALESCE(A.TotalItemIssued,0) AS TotalItemShortfall,     
--A.TotalBagIssued,    
--B.    
    
    
----ADDED IN THE CODE 2-11-2020    
                 
                 
 CASE                                  
 WHEN FMLovMst2.FieldValue = 'Normal' AND                                  
D.LinenSchedule = 'Delivery Time' AND                                  
FMLovMst1.FieldValue = 'Schedule 1' AND                                   
 CONVERT(time, A.DeliveryDate1st, 5) BETWEEN                                  
D.[1stScheduleStartTime] AND                                  
D.[1stScheduleEndTime] THEN 'Yes'                                  
 WHEN FMLovMst2.FieldValue = 'Normal' AND                                  
D.LinenSchedule = 'Delivery Time' AND                                  
FMLovMst1.FieldValue = 'Schedule 2' AND                                  
 CONVERT(time, A.DeliveryDate2nd, 5) BETWEEN                                  
D.[2ndScheduleStartTime] AND                                  
D.[2ndScheduleEndTime] THEN 'Yes'                                  
 WHEN FMLovMst2.FieldValue = 'Emergency' AND                                  
D.LinenSchedule = 'Delivery Time' AND                                  
 DATEDIFF(minute, B.RequestDateTime,                                  
A.DeliveryDate1st) < '31' THEN 'Yes'                                  
 ELSE 'No' END AS IssuedOnTime,                                  
 FMLovMst3.FieldValue AS QCTimeliness,                                  
                 
COALESCE(A.DeliveryWeight1st+A.DeliveryWeight2nd,A.DeliveryWeight1st,A.DeliveryWeight2nd,0) AS TotalWeight,                                  
A.ModifiedDate,                        
A.ModifiedDateUTC,                        
A.IsDeleted                        
--@TotalRecords AS TotalRecords                                    
                                  
FROM dbo.LlsCleanLinenIssueTxn A  WITH (NOLOCK)                                
                                  
INNER JOIN dbo.LlsCleanLinenRequestTxn B   WITH (NOLOCK)                               
ON A.CleanLinenRequestId =B.CleanLinenRequestId                                  
                                  
INNER JOIN dbo.LLSUserAreaDetailsMst C   WITH (NOLOCK)                               
ON B.LLSUserAreaId = C.LLSUserAreaId                                  
                                  
INNER JOIN dbo.LLSUserAreaDetailsLocationMstDet D     WITH (NOLOCK)                             
ON B.LLSUserAreaLocationId = D.LLSUserAreaLocationId                                  
                                  
INNER JOIN dbo.UMUserRegistration AS User1    WITH (NOLOCK)                               
ON A.ReceivedBy1st = User1.UserRegistrationId                                  
                                  
INNER JOIN  dbo.UMUserRegistration AS User2   WITH (NOLOCK)                                
ON A.DeliveredBy = User2.UserRegistrationId                                  
                                  
INNER JOIN dbo.FMLovMst AS FMLovMst1    WITH (NOLOCK)                               
ON A.DeliverySchedule = FMLovMst1.LovId                                  
                                
INNER JOIN dbo.FMLovMst AS FMLovMst2   WITH (NOLOCK)                                
ON B.Priority = FMLovMst2.LovId                                  
                      
INNER JOIN dbo.FMLovMst AS FMLovMst3  WITH (NOLOCK)                                 
ON A.QCTimeliness = FMLovMst3.LovId           
WHERE ISNULL(A.IsDeleted,'')=''                 
)                

--SELECT * FROM CTE

                
,CTE_REQUESTED AS                
(                
SELECT F.CleanLinenRequestId,SUM(F.RequestedQuantity) AS TotalLinenRequestQuantity                              
FROM dbo.LLSCleanLinenIssueLinenItemTxnDet A   WITH (NOLOCK)                            
INNER JOIN dbo.LlsCleanLinenRequestLinenItemTxnDet F  WITH (NOLOCK)                                        
ON A.CleanLinenIssueId =F.CleanLinenIssueId                                          
AND A.Linenitemid = F.Linenitemid                               
WHERE ISNULL(A.IsDeleted,'')=''                
AND ISNULL(F.IsDeleted,'')=''                
GROUP BY F.CleanLinenRequestId                
)                

--SELECT * FROM CTE_REQUESTED
                
,CTE_ISSUED AS                
(                
SELECT B.CleanLinenRequestId                
,A.CleanLinenIssueId                
,SUM(ISNULL(C.DeliveryIssuedQty1st,0)) AS IssueQuantity1                 
,SUM(ISNULL(C.DeliveryIssuedQty2nd,0)) AS IssueQuantity2                
--,SUM(C.DeliveryIssuedQty1st)+SUM(C.DeliveryIssuedQty2nd)                
FROM LLSCleanLinenIssueTxn A   WITH (NOLOCK)              
INNER JOIN LLSCleanLinenRequestTxn B  WITH (NOLOCK)              
ON A.CleanLinenRequestId=B.CleanLinenRequestId                
INNER JOIN LLSCleanLinenIssueLinenItemTxnDet C                
ON A.CleanLinenIssueId=C.CleanLinenIssueId                
WHERE                 
ISNULL(A.IsDeleted,'')=''                
AND ISNULL(B.IsDeleted,'')=''                
AND ISNULL(C.IsDeleted,'')=''                
GROUP BY B.CleanLinenRequestId,A.CleanLinenIssueId                
)                
              
--SELECT * FROM CTE_ISSUED              
--WHERE CleanLinenIssueId=100193              
              
                
,SHORTFALL AS                
(                
SELECT A.CleanLinenRequestId                
,B.CleanLinenIssueId                
,A.TotalLinenRequestQuantity                
,(B.IssueQuantity1+B.IssueQuantity2) AS TotalIssued                
,A.TotalLinenRequestQuantity-(B.IssueQuantity1+B.IssueQuantity2) AS Shortfall                
FROM CTE_REQUESTED A                
INNER JOIN CTE_ISSUED B                
ON A.CleanLinenRequestId=B.CleanLinenRequestId                
)                
--SELECT * FROM SHORTFALL    
    
--------------------------  BAG 2-11-2020    
    
,CTE_BAGREQUESTED AS                
(                
SELECT F.CleanLinenRequestId,SUM(F.RequestedQuantity) AS TotalLinenBagRequestQuantity                              
FROM dbo.LLSCleanLinenIssueLinenBagTxnDet A   WITH (NOLOCK)                            
INNER JOIN dbo.LLSCleanLinenRequestLinenBagTxnDet F  WITH (NOLOCK)                                        
ON A.CleanLinenIssueId =F.CleanLinenIssueId                                          
AND A.LaundryBag = F.LaundryBag    
WHERE ISNULL(A.IsDeleted,'')=''                
AND ISNULL(F.IsDeleted,'')=''                
GROUP BY F.CleanLinenRequestId                
) 
--SELECT * FROM CTE_BAGREQUESTED

                
,CTE_BAGISSUED AS                
(                
SELECT B.CleanLinenRequestId                
,A.CleanLinenIssueId                
,SUM(C.IssuedQuantity) AS IssuedBagQuantity    
--,SUM(ISNULL(C.DeliveryIssuedQty1st,0)) AS IssueQuantity1                 
--,SUM(ISNULL(C.DeliveryIssuedQty2nd,0)) AS IssueQuantity2                
--,SUM(C.DeliveryIssuedQty1st)+SUM(C.DeliveryIssuedQty2nd)                
FROM LLSCleanLinenIssueTxn A   WITH (NOLOCK)              
INNER JOIN LLSCleanLinenRequestTxn B  WITH (NOLOCK)              
ON A.CleanLinenRequestId=B.CleanLinenRequestId                
INNER JOIN LLSCleanLinenIssueLinenBagTxnDet C                
ON A.CleanLinenIssueId=C.CleanLinenIssueId                
WHERE                 
ISNULL(A.IsDeleted,'')=''                
AND ISNULL(B.IsDeleted,'')=''                
AND ISNULL(C.IsDeleted,'')=''                
GROUP BY B.CleanLinenRequestId,A.CleanLinenIssueId                
)                

---SELECT * FROM CTE_BAGISSUED              
--SELECT * FROM CTE_ISSUED              
--WHERE CleanLinenIssueId=100193              
              
                
,BAGSHORTFALL AS                
(                
SELECT A.CleanLinenRequestId                
,B.CleanLinenIssueId                
,A.TotalLinenBagRequestQuantity                
,(B.IssuedBagQuantity) AS TotalBagIssued                
,A.TotalLinenBagRequestQuantity-(B.IssuedBagQuantity) AS ShortfallBag                
FROM CTE_BAGREQUESTED A                
INNER JOIN CTE_BAGISSUED B                
ON A.CleanLinenRequestId=B.CleanLinenRequestId                
)                
    
--SELECT * FROM BAGSHORTFALL    
    
                
--SELECT * FROM SHORTFALL         
                
--SELECT * FROM LLSCleanLinenIssueLinenItemTxnDet WHERE CleanLinenIssueId='10741'                
                
                
SELECT A.CustomerId                
,A.FacilityId                
,A.CleanLinenIssueId                
,A.CleanLinenRequestId                
,A.DeliveryDate1st                
,A.CLINo                
,A.CLRNo                
,A.Priority                
,A.UserAreaCode                
,A.UserLocationCode                
,A.ReceivedBy                
,A.DeliveredBy                
,A.IssuedOnTime                
,A.QCTimeliness                
,A.TotalWeight                
,A.ModifiedDate                
,A.ModifiedDateUTC                
,A.IsDeleted                
,B.TotalLinenRequestQuantity AS TotalItemRequested                
,(C.IssueQuantity1+C.IssueQuantity2) AS TotalItemIssued                
,D.Shortfall AS TotalItemShortfall                
    
-----BAG ADDED IN BAG    
    
,E.TotalLinenBagRequestQuantity AS TotalBagRequested    
,F.IssuedBagQuantity AS TotalBagIssued    
,G.ShortfallBag AS TotalBagShortFall    
    
    
FROM CTE A                
INNER JOIN CTE_REQUESTED B                
ON A.CleanLinenRequestId=B.CleanLinenRequestId                
INNER JOIN CTE_ISSUED C                
ON A.CleanLinenRequestId=C.CleanLinenRequestId                
AND A.CleanLinenIssueId=C.CleanLinenIssueId              
INNER JOIN SHORTFALL D                
ON A.CleanLinenRequestId=D.CleanLinenRequestId      
    
-----BAG ADDED ON 2-11-2020    
    
INNER JOIN CTE_BAGREQUESTED E                
ON A.CleanLinenRequestId=E.CleanLinenRequestId                
INNER JOIN CTE_BAGISSUED F                
ON A.CleanLinenRequestId=F.CleanLinenRequestId                
--AND A.CleanLinenIssueId=F.CleanLinenIssueId              
INNER JOIN BAGSHORTFALL G                
ON A.CleanLinenRequestId=G.CleanLinenRequestId      
    
    
--AND A.CleanLinenIssueId=D.CleanLinenIssueId              
--WHERE A.CleanLinenIssueId=100193              
GO
