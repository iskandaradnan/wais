USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestTxn_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
   
  
                          
CREATE PROCEDURE [dbo].[LLSCleanLinenRequestTxn_GetById]                          
(                          
 @Id INT                          
)                          
                           
AS                           
    -- Exec [LLSCleanLinenRequestTxn_GetById] 43662                    
                        
--/*=====================================================================================================================                        
--APPLICATION  : UETrack                        
--NAME    : LLSCleanLinenRequestTxn_GetById                       
--DESCRIPTION  : GETS THE LLSCleanLinenRequestTxn                       
--AUTHORS   : SIDDHANT                        
--DATE    : 23-JAN-2020                        
-------------------------------------------------------------------------------------------------------------------------                        
--VERSION HISTORY                         
--------------------:---------------:---------------------------------------------------------------------------------------                        
--Init    : Date          : Details                        
--------------------:---------------:---------------------------------------------------------------------------------------                        
--SIDDHANT           : 23-JAN-2020 :                         
-------:------------:----------------------------------------------------------------------------------------------------*/                        
                        
BEGIN                          
SET NOCOUNT ON                          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                          
BEGIN TRY                          
  
  
  
DECLARE @TotalItemRequested INT  
DECLARE @TotalItemIssued INT  
DECLARE @TotalLinenItemShortFall INT  
DECLARE @TotalLinenIssueQuantity INT  
  
SET @TotalItemRequested=(SELECT SUM(A.RequestedQuantity) AS RequestedQuantity  
FROM LLSCleanLinenRequestLinenItemTxnDet A WHERE CleanLinenRequestId=@Id  
AND ISNULL(A.IsDeleted,'')=''  
)  
  
SET @TotalItemIssued=(SELECT SUM(C.DeliveryIssuedQty1st)+SUM(C.DeliveryIssuedQty2nd) AS IssueQuantity  
FROM LLSCleanLinenIssueTxn A   
INNER JOIN LLSCleanLinenRequestTxn B  
ON A.CleanLinenRequestId=B.CleanLinenRequestId  
INNER JOIN LLSCleanLinenIssueLinenItemTxnDet C  
ON A.CleanLinenIssueId=C.CleanLinenIssueId  
WHERE B.CleanLinenRequestId=@Id  
AND ISNULL(A.IsDeleted,'')=''  
AND ISNULL(B.IsDeleted,'')=''  
AND ISNULL(C.IsDeleted,'')=''  
)  
  
SET @TotalLinenItemShortFall=@TotalItemRequested-@TotalItemIssued  
  
        
IF(@ID=(SELECT A.CleanLinenRequestId FROM LLSCleanLinenIssueTxn A WHERE A.CleanLinenRequestId=@Id ))        
BEGIN        
                           
SELECT                   
A.CleanLinenRequestId,                  
A.DocumentNo,                      
A.RequestDateTime,                      
B.UserAreaCode,                      
C.UserAreaName,                      
D.UserLocationCode,                      
E.UserLocationName,                      
F.StaffName AS RequestedBy,                      
G.Designation,                      
                      
--CASE                       
--WHEN A.Priority = '10101'                       
--AND D.LinenSchedule = 'Delivery Time'                       
--AND FMLovMst1.LovId = 'Schedule 1'                       
--AND CONVERT(TIME, H.DeliveryDate1st, 5)                       
--BETWEEN D.[1stScheduleStartTime] AND D.[1stScheduleEndTime] THEN 'Yes'                       
                       
--WHEN A.Priority = '10101'                       
--AND D.LinenSchedule = 'Delivery Time'                       
--AND FMLovMst1.LovId = 'Schedule 2'                       
--AND CONVERT(TIME, H.DeliveryDate2nd, 5)                       
--BETWEEN D.[2ndScheduleStartTime] AND D.[2ndScheduleEndTime] THEN 'Yes'                       
                      
                      
--WHEN A.Priority = '10102'                       
--AND D.LinenSchedule = 'Delivery Time'          
--AND DATEDIFF(MINUTE, A.RequestDateTime,H.DeliveryDate1st) < '31' THEN 'Yes'                      
--ELSE 'No' END AS IssuedOnTime,                       
    
H.IssuedOnTime,    
FMLovMst3.LovId AS DeliverySchedule,                      
FMLovMst1.LovId AS Priority,                      
FMLovMst4.LovId AS QCTimeliness,                      
@TotalItemRequested AS TotalItemRequested,                      
@TotalItemIssued AS TotalItemIssued,                      
@TotalLinenItemShortFall AS TotalLinenItemShortfall,                      
FMLovMst5.LovId AS ShortfallQC,                      
FMLovMst2.LovId AS IssueStatus,                      
A.Remarks,              
A.GuId ,  
A.TxnStatus           
                      
FROM dbo.LlsCleanLinenRequestTxn A                      
                      
INNER JOIN dbo.LLSUserAreaDetailsMst B                      
ON A.LLSUserAreaId = B.LLSUserAreaId                      
                      
INNER JOIN dbo.MstLocationUserArea C                       
ON B.UserAreaCode =C.UserAreaCode                   
                      
INNER JOIN dbo.LLSUserAreaDetailsLocationMstDet D                      
ON A.LLSUserAreaLocationId =D.LLSUserAreaLocationId                      
                      
INNER JOIN dbo.MstLocationUserLocation E                       
ON D.UserLocationCode =E.UserLocationCode                      
                      
INNER JOIN dbo.UMUserRegistration F                   
ON A.RequestedBy =F.UserRegistrationId                      
                      
INNER JOIN dbo.UserDesignation G                      
ON F.UserDesignationId =G.UserDesignationId                      
                      
INNER JOIN dbo.FMLovMst AS FMLovMst1                       
ON A.Priority =FMLovMst1.LovId                  
                      
INNER JOIN dbo.FMLovMst AS FMLovMst2                       
ON A.IssueStatus =FMLovMst2.LovId                      
                      
INNER JOIN dbo.LLSCleanLinenIssueTxn H                      
ON A.CleanLinenRequestId =H.CleanLinenRequestId                       
AND A.CustomerId =H.CustomerId                       
AND A.FacilityId =H.FacilityId                      
                      
INNER JOIN dbo.FMLovMst AS FMLovMst3                       
ON H.DeliverySchedule =FMLovMst3.LovId                      
                      
INNER JOIN dbo.FMLovMst AS FMLovMst4                       
ON H.QCTimeliness = FMLovMst4.LovId                      
                      
INNER JOIN dbo.FMLovMst AS FMLovMst5                       
ON H.ShortfallQC =FMLovMst5.LovId     
  
--INNER JOIN LLSCleanLinenRequestLinenItemTxnDet LL  
--ON A.CleanLinenRequestId=LL.CleanLinenRequestId  
  
--INNER JOIN LLSCleanLinenRequestLinenBagTxnDet BB  
--ON A.CleanLinenRequestId=BB.CleanLinenRequestId  
  
                      
WHERE A.CleanLinenRequestId=@Id                      
AND ISNULL(A.IsDeleted,'')=''          
END        
        
ELSE         
        
BEGIN         
        
SELECT                   
A.CleanLinenRequestId,                  
A.DocumentNo,                      
A.RequestDateTime,                      
B.UserAreaCode,                      
C.UserAreaName,                      
D.UserLocationCode,                      
E.UserLocationName,                      
F.StaffName AS RequestedBy,                      
G.Designation,                      
                      
--CASE                       
--WHEN A.Priority = '10101'                       
--AND D.LinenSchedule = 'Delivery Time'                       
--AND FMLovMst1.LovId = 'Schedule 1'                       
--AND CONVERT(TIME, H.DeliveryDate1st, 5)                       
--BETWEEN D.[1stScheduleStartTime] AND D.[1stScheduleEndTime] THEN 'Yes'                       
                       
--WHEN A.Priority = '10101'                       
--AND D.LinenSchedule = 'Delivery Time'                       
--AND FMLovMst1.LovId = 'Schedule 2'                       
--AND CONVERT(TIME, H.DeliveryDate2nd, 5)                       
--BETWEEN D.[2ndScheduleStartTime] AND D.[2ndScheduleEndTime] THEN 'Yes'                       
                      
                      
--WHEN A.Priority = '10102'                       
--AND D.LinenSchedule = 'Delivery Time'                       
--AND DATEDIFF(MINUTE, A.RequestDateTime,H.DeliveryDate1st) < '31' THEN 'Yes'                      
--ELSE 'No' END AS         
'' AS IssuedOnTime,                       
                      
--FMLovMst3.LovId AS         
'' AS DeliverySchedule,                      
FMLovMst1.LovId AS Priority,                      
--FMLovMst4.LovId AS         
'' AS QCTimeliness,                      
@TotalItemRequested AS TotalItemRequested,                      
0 AS TotalItemIssued,                      
0 AS TotalLinenItemShortfall,                      
--FMLovMst5.LovId AS         
'' AS ShortfallQC,                      
FMLovMst2.LovId AS IssueStatus,                      
A.Remarks,              
A.GuId    ,  
A.TxnStatus          
                      
FROM dbo.LlsCleanLinenRequestTxn A                      
                      
INNER JOIN dbo.LLSUserAreaDetailsMst B                      
ON A.LLSUserAreaId = B.LLSUserAreaId                      
                      
INNER JOIN dbo.MstLocationUserArea C                       
ON B.UserAreaCode =C.UserAreaCode                      
                      
INNER JOIN dbo.LLSUserAreaDetailsLocationMstDet D                      
ON A.LLSUserAreaLocationId =D.LLSUserAreaLocationId                      
                      
INNER JOIN dbo.MstLocationUserLocation E                       
ON D.UserLocationCode =E.UserLocationCode                      
                      
INNER JOIN dbo.UMUserRegistration F                      
ON A.RequestedBy =F.UserRegistrationId                      
                      
INNER JOIN dbo.UserDesignation G          
ON F.UserDesignationId =G.UserDesignationId                      
                      
INNER JOIN dbo.FMLovMst AS FMLovMst1                       
ON A.Priority =FMLovMst1.LovId                  
                      
INNER JOIN dbo.FMLovMst AS FMLovMst2                       
ON A.IssueStatus =FMLovMst2.LovId                      
                      
--INNER JOIN dbo.LLSCleanLinenIssueTxn H                      
--ON A.CleanLinenRequestId =H.CleanLinenRequestId                       
--AND A.CustomerId =H.CustomerId                       
--AND A.FacilityId =H.FacilityId                      
                      
--INNER JOIN dbo.FMLovMst AS FMLovMst3                       
--ON H.DeliverySchedule =FMLovMst3.LovId                      
                      
--INNER JOIN dbo.FMLovMst AS FMLovMst4                       
--ON H.QCTimeliness = FMLovMst4.LovId                      
                      
--INNER JOIN dbo.FMLovMst AS FMLovMst5                       
--ON H.ShortfallQC =FMLovMst5.LovId                       
  
--INNER JOIN LLSCleanLinenRequestLinenItemTxnDet LL  
--ON A.CleanLinenRequestId=LL.CleanLinenRequestId  
  
--INNER JOIN LLSCleanLinenRequestLinenBagTxnDet BB  
--ON A.CleanLinenRequestId=BB.CleanLinenRequestId  
  
                      
WHERE A.CleanLinenRequestId=@Id                      
AND ISNULL(A.IsDeleted,'')=''          
        
        
END        
        
                      
END TRY                          
BEGIN CATCH                          
                          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                          
                          
THROW                          
                          
END CATCH                          
SET NOCOUNT OFF                          
END
GO
