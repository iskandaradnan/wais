USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueTxn_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                              
--NOTE :KEEPING THE LOGIC SAME AS GIVEN BY AIDA IN THE QUERY SO NOT CONVERTING ALL THE TABLES IN SINGLE JOIN CONDITION                              
                                  
CREATE PROCEDURE [dbo].[LLSCleanLinenIssueTxn_GetById]                                   
(                                  
 @Id INT                                  
)                                  
                                   
AS                                   
    -- Exec [LLSCleanLinenIssueTxn_GetById ] 68                          
                                
--/*=====================================================================================================================                                
--APPLICATION  : UETrack                                
--NAME    : LLSCleanLinenIssueTxn_GetById                                
--DESCRIPTION  : GETS THE LLSCleanLinenIssueTxn                                
--AUTHORS   : SIDDHANT                                
--DATE    : 4-FEB-2020                                
-------------------------------------------------------------------------------------------------------------------------                                
--VERSION HISTORY                                 
--------------------:---------------:---------------------------------------------------------------------------------------                                
--Init    : Date          : Details                                
--------------------:---------------:---------------------------------------------------------------------------------------                                
--SIDDHANT           : 4-FEB-2020 :                                 
-------:------------:----------------------------------------------------------------------------------------------------*/                                
                                
BEGIN                                  
SET NOCOUNT ON                                  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                  
BEGIN TRY     
  
DECLARE @TotalItemIssued INT  
DECLARE @TotalBagIssued INT  
                  
DECLARE @RequestedQuantity INT                      
SET @RequestedQuantity=                      
(                      
SELECT SUM(B.RequestedQuantity) AS RequestedQuantity                      
FROM dbo.LLSCleanLinenIssueLinenBagTxnDet A                                 
INNER JOIN dbo.LLSCleanLinenRequestLinenBagTxnDet B                                     
ON A.CleanLinenIssueId = B.CleanLinenIssueId                                    
AND A.LaundryBag = B.LaundryBag                                     
WHERE A.CleanLinenIssueId=@Id     
AND ISNULL(A.IsDeleted,'')=''  
AND ISNULL(B.IsDeleted,'')=''  
)                      
                
DECLARE @TotalLinenRequestQuantity INT                        
SET @TotalLinenRequestQuantity=(                
SELECT SUM(F.RequestedQuantity) AS TotalLinenRequestQuantity                
FROM dbo.LLSCleanLinenIssueLinenItemTxnDet A                 
INNER JOIN dbo.LlsCleanLinenRequestLinenItemTxnDet F                            
ON A.CleanLinenIssueId =F.CleanLinenIssueId                            
AND A.Linenitemid = F.Linenitemid                 
WHERE A.CleanLinenIssueId=@Id                                   
AND ISNULL(A.IsDeleted,'')=''  
AND ISNULL(F.IsDeleted,'')=''  
)                
          
    
SET @TotalItemIssued=(SELECT SUM(C.DeliveryIssuedQty1st)+SUM(C.DeliveryIssuedQty2nd) AS IssueQuantity  
FROM LLSCleanLinenIssueTxn A   
INNER JOIN LLSCleanLinenRequestTxn B  
ON A.CleanLinenRequestId=B.CleanLinenRequestId  
INNER JOIN LLSCleanLinenIssueLinenItemTxnDet C  
ON A.CleanLinenIssueId=C.CleanLinenIssueId  
WHERE A.CleanLinenIssueId=@Id  
AND ISNULL(A.IsDeleted,'')=''  
AND ISNULL(B.IsDeleted,'')=''  
AND ISNULL(C.IsDeleted,'')=''  
)  
  
  
SET @TotalBagIssued=(SELECT SUM(C.IssuedQuantity) AS IssueQuantity  
FROM LLSCleanLinenIssueTxn A   
INNER JOIN LLSCleanLinenRequestTxn B  
ON A.CleanLinenRequestId=B.CleanLinenRequestId  
INNER JOIN LLSCleanLinenIssueLinenBagTxnDet C  
ON A.CleanLinenIssueId=C.CleanLinenIssueId  
WHERE A.CleanLinenIssueId=@Id  
AND ISNULL(A.IsDeleted,'')=''  
AND ISNULL(B.IsDeleted,'')=''  
AND ISNULL(C.IsDeleted,'')=''  
)  
  
              
IF((SELECT ISNULL(A.ReceivedBy2nd,'') FROM LLSCleanLinenIssueTxn A WHERE A.CleanLinenIssueId=@Id )='')                                   
              
BEGIN                          
              
SELECT                             
A.CleanLinenIssueId,                            
 A.CLINo,                              
 B.DocumentNo,                              
 B.RequestDateTime,                              
 A.DeliveryDate1st,                              
 --A.DeliveryDate2nd,                              
 C.UserAreaCode,                              
 D.UserAreaName,                              
 E.UserLocationCode,                              
 F.UserLocationName,                              
 User1.StaffName AS RequestedBy,                              
 Designation1.Designation AS RequestedByDesignation,                              
 User2.StaffName AS ReceivedBy1st,                              
 Designation2.Designation AS ReceivedBy1stDesignation,                              
 --User3.StaffName               
 '' AS ReceivedBy2nd,                              
-- Designation3.Designation               
 '' AS ReceivedBy2ndDesignation,                              
 User4.StaffName AS [Verifier(MOH)],                               
 Designation4.Designation AS [Verifier(MOH)Designation],                              
 User5.StaffName AS DeliveredBy,                              
 Designation5.Designation AS DeliveredByDesignation,                              
 A.DeliveryWeight1st,                              
 A.DeliveryWeight2nd,                              
COALESCE(A.DeliveryWeight1st +                              
A.DeliveryWeight2nd,               
A.DeliveryWeight1st,                              
A.DeliveryWeight2nd, 0) AS TotalWeight,                              
             
 CASE                              
 WHEN FMLovMst2.LovId = 10101 AND                              
E.LinenSchedule = 'Delivery Time' AND                              
FMLovMst1.LovId = 10157 AND                              
 convert(time, A.DeliveryDate1st, 5) BETWEEN                              
E.[1stScheduleStartTime] AND                              
E.[1stScheduleEndTime] THEN 'Yes'                              
 WHEN FMLovMst2.LovId = 10101 AND                              
E.LinenSchedule = 'Delivery Time' AND                              
FMLovMst1.LovId = 10158 AND                              
 convert(time, A.DeliveryDate2nd, 5) BETWEEN                              
E.[2ndScheduleStartTime] AND                              
E.[2ndScheduleEndTime] THEN 'Yes'                              
 WHEN FMLovMst2.LovId = 10102 AND                              
E.LinenSchedule = 'Delivery Time' AND                              
 DATEDIFF(minute, B.RequestDateTime,                     
A.DeliveryDate1st) < '31' THEN 'Yes'                              
 ELSE 'No' END AS IssuedOnTime,                              
           
 CASE                              
 WHEN FMLovMst2.LovId = 10101 AND                              
E.LinenSchedule = 'Delivery Time' AND                              
FMLovMst1.LovId = 10157 AND                              
 convert(time, A.DeliveryDate1st, 5) BETWEEN                              
E.[1stScheduleStartTime] AND                              
E.[1stScheduleEndTime] THEN 10155                              
             
 WHEN FMLovMst2.LovId = 10101 AND                              
E.LinenSchedule = 'Delivery Time' AND                              
FMLovMst1.LovId = 10158 AND                              
 convert(time, A.DeliveryDate2nd, 5) BETWEEN                              
E.[2ndScheduleStartTime] AND                              
E.[2ndScheduleEndTime] THEN 10155          
             
 WHEN FMLovMst2.LovId = 10102 AND                              
E.LinenSchedule = 'Delivery Time' AND                              
 DATEDIFF(minute, B.RequestDateTime,                     
A.DeliveryDate1st) < '31' THEN 10155                              
 ELSE 10156 END AS IssuedOnTimeID,                              
       
 FMLovMst1.LovId as DeliverySchedule,                              
 FMLovMst2.LovId as Priority,                              
 FMLovMst3.LovId as QCTimeliness,                              
  
 @RequestedQuantity AS TotalBagRequested,                              
 @TotalBagIssued AS  TotalBagIssued,                              
 @TotalLinenRequestQuantity AS TotalItemRequested,                              
 @TotalItemIssued AS TotalItemIssued,                               
  
 (@TotalLinenRequestQuantity-@TotalItemIssued) AS TotalItemShortfall,                              
  
 FMLovMst4.LovId as ShortfallQC,                              
 CASE                              
 WHEN A.CLIOption = '0' THEN '1st' ELSE '2nd'                              
 END AS CLIOption,                              
 A.Remarks,     
 A.ReceivedBy2nd as SecondReceivedBy,   
 A.ReceivedBy1st as FirstReceivedBy,  
 A.GuId,  
 B.TxnStatus  
                                 
FROM dbo.LlsCleanLinenIssueTxn A                              
INNER JOIN dbo.LlsCleanLinenRequestTxn B                              
ON A.CleanLinenRequestId = B.CleanLinenRequestId                              
                              
INNER JOIN dbo.LLSUserAreaDetailsMst C                              
ON B.LLSUserAreaId =C.LLSUserAreaId                              
                              
INNER JOIN dbo.MstLocationUserArea D                              
ON C.UserAreaCode =D.UserAreaCode                             
                              
INNER JOIN dbo.LLSUserAreaDetailsLocationMstDet E                              
ON B.LLSUserAreaLocationId =E.LLSUserAreaLocationId                
                              
INNER JOIN dbo.MstLocationUserLocation F                              
ON E.UserLocationId =F.UserLocationId                              
                         
INNER JOIN dbo.UMUserRegistration AS User1                               
ON B.RequestedBy = User1.UserRegistrationId                              
                              
INNER JOIN dbo.UserDesignation AS Designation1                               
ON User1.UserDesignationId = Designation1.UserDesignationId                              
                              
INNER JOIN dbo.UMUserRegistration AS User2                               
ON A.ReceivedBy1st = User2.UserRegistrationId                              
                              
INNER JOIN dbo.UserDesignation AS Designation2                               
ON User2.UserDesignationId = Designation2.UserDesignationId                              
                              
--INNER JOIN dbo.UMUserRegistration AS User3                               
--ON A.ReceivedBy2nd = User3.UserRegistrationId                              
                              
--INNER JOIN dbo.UserDesignation AS Designation3                               
--ON User3.UserDesignationId = Designation3.UserDesignationId                              
                              
INNER JOIN dbo.UMUserRegistration AS User4                               
ON A.Verifier = User4.UserRegistrationId                              
                              
INNER JOIN dbo.UserDesignation AS Designation4                               
ON User4.UserDesignationId = Designation4.UserDesignationId                              
                              
INNER JOIN dbo.UMUserRegistration AS User5                               
ON A.DeliveredBy = User5.UserRegistrationId                              
                              
INNER JOIN dbo.UserDesignation AS Designation5                               
ON User5.UserDesignationId = Designation5.UserDesignationId                              
                              
INNER JOIN dbo.FMLovMst AS FMLovMst1                     
ON A.DeliverySchedule =FMLovMst1.LovId                              
                              
INNER JOIN dbo.FMLovMst AS FMLovMst2                               
ON B.Priority = FMLovMst2.LovId                              
                              
INNER JOIN dbo.FMLovMst AS FMLovMst3                               
ON A.QCTimeliness = FMLovMst3.LovId                              
                              
INNER JOIN dbo.FMLovMst AS FMLovMst4                               
ON A.ShortfallQC = FMLovMst4.LovId                              
                              
WHERE CleanLinenIssueId=@Id                          
              
END              
ELSE              
BEGIN              
              
SELECT                             
A.CleanLinenIssueId,                            
 A.CLINo,                              
 B.DocumentNo,                              
 B.RequestDateTime,                              
 A.DeliveryDate1st,                              
 A.DeliveryDate2nd,                              
 C.UserAreaCode,                              
 D.UserAreaName,                              
 E.UserLocationCode,                              
 F.UserLocationName,                              
 User1.StaffName AS RequestedBy,                              
 Designation1.Designation AS RequestedByDesignation,                              
 User2.StaffName AS ReceivedBy1st,                              
 Designation2.Designation AS ReceivedBy1stDesignation,                              
 User3.StaffName,               
 User3.StaffName AS ReceivedBy2nd,                              
 Designation3.Designation,               
 Designation3.Designation AS ReceivedBy2ndDesignation,                              
 User4.StaffName AS [Verifier(MOH)],                               
 Designation4.Designation AS [Verifier(MOH)Designation],                              
 User5.StaffName AS DeliveredBy,                              
 Designation5.Designation AS DeliveredByDesignation,                              
 A.DeliveryWeight1st,                              
 A.DeliveryWeight2nd,                              
COALESCE(A.DeliveryWeight1st +                              
A.DeliveryWeight2nd,                              
A.DeliveryWeight1st,                              
A.DeliveryWeight2nd, 0) AS TotalWeight,                              
             
 CASE                              
 WHEN FMLovMst2.LovId = 10101 AND                              
E.LinenSchedule = 'Delivery Time' AND                              
FMLovMst1.LovId = 10157 AND                              
 convert(time, A.DeliveryDate1st, 5) BETWEEN                              
E.[1stScheduleStartTime] AND                              
E.[1stScheduleEndTime] THEN 'Yes'                              
             
             
 WHEN FMLovMst2.LovId = 10101 AND                              
E.LinenSchedule = 'Delivery Time' AND                              
FMLovMst1.LovId = 10158 AND                              
 convert(time, A.DeliveryDate2nd, 5) BETWEEN                              
E.[2ndScheduleStartTime] AND                              
E.[2ndScheduleEndTime] THEN 'Yes'                              
             
             
 WHEN FMLovMst2.LovId = 10102 AND                              
E.LinenSchedule = 'Delivery Time' AND                              
 DATEDIFF(minute, B.RequestDateTime,                     
A.DeliveryDate1st) < '31' THEN 'Yes'                              
 ELSE 'No' END AS IssuedOnTime,                              
             
             
            
 CASE                              
 WHEN FMLovMst2.LovId = 10101 AND                              
E.LinenSchedule = 'Delivery Time' AND                              
FMLovMst1.LovId = 10157 AND                              
 convert(time, A.DeliveryDate1st, 5) BETWEEN                              
E.[1stScheduleStartTime] AND                              
E.[1stScheduleEndTime] THEN 10155                              
             
             
 WHEN FMLovMst2.LovId = 10101 AND                              
E.LinenSchedule = 'Delivery Time' AND                              
FMLovMst1.LovId = 10158 AND                              
 convert(time, A.DeliveryDate2nd, 5) BETWEEN                              
E.[2ndScheduleStartTime] AND                              
E.[2ndScheduleEndTime] THEN 10155                              
             
             
 WHEN FMLovMst2.LovId = 10102 AND                              
E.LinenSchedule = 'Delivery Time' AND                              
 DATEDIFF(minute, B.RequestDateTime,                     
A.DeliveryDate1st) < '31' THEN 10155                              
 ELSE 10156 END AS IssuedOnTimeID,                              
             
 FMLovMst1.LovId as DeliverySchedule,                              
 FMLovMst2.LovId as Priority,                              
 FMLovMst3.LovId as QCTimeliness,                              
  
  
 @RequestedQuantity AS TotalBagRequested,                              
 @TotalBagIssued AS  TotalBagIssued,                              
 @TotalLinenRequestQuantity AS TotalItemRequested,                              
 @TotalItemIssued AS TotalItemIssued,                               
  
  
(@TotalLinenRequestQuantity-@TotalItemIssued) AS TotalItemShortfall,                              
  
 FMLovMst4.LovId as ShortfallQC,                              
 CASE                              
 WHEN A.CLIOption = '0' THEN '1st' ELSE '2nd'                              
 END AS CLIOption,                              
 A.Remarks,     
 A.ReceivedBy2nd as SecondReceivedBy,   
 A.ReceivedBy1st as FirstReceivedBy,  
 A.GuId,  
 B.TxnStatus  
                              
                              
FROM dbo.LlsCleanLinenIssueTxn A                              
INNER JOIN dbo.LlsCleanLinenRequestTxn B                              
ON A.CleanLinenRequestId = B.CleanLinenRequestId                              
                              
INNER JOIN dbo.LLSUserAreaDetailsMst C                              
ON B.LLSUserAreaId =C.LLSUserAreaId                              
                              
INNER JOIN dbo.MstLocationUserArea D                              
ON C.UserAreaCode =D.UserAreaCode                              
                              
INNER JOIN dbo.LLSUserAreaDetailsLocationMstDet E                              
ON B.LLSUserAreaLocationId =E.LLSUserAreaLocationId                
                              
INNER JOIN dbo.MstLocationUserLocation F                              
ON E.UserLocationId =F.UserLocationId                              
                              
                              
INNER JOIN dbo.UMUserRegistration AS User1                               
ON B.RequestedBy = User1.UserRegistrationId                              
                              
INNER JOIN dbo.UserDesignation AS Designation1                               
ON User1.UserDesignationId = Designation1.UserDesignationId                              
                              
INNER JOIN dbo.UMUserRegistration AS User2                               
ON A.ReceivedBy1st = User2.UserRegistrationId                              
                              
INNER JOIN dbo.UserDesignation AS Designation2                               
ON User2.UserDesignationId = Designation2.UserDesignationId                              
                              
INNER JOIN dbo.UMUserRegistration AS User3                               
ON A.ReceivedBy2nd = User3.UserRegistrationId                              
                              
INNER JOIN dbo.UserDesignation AS Designation3                               
ON User3.UserDesignationId = Designation3.UserDesignationId                              
                              
INNER JOIN dbo.UMUserRegistration AS User4                               
ON A.Verifier = User4.UserRegistrationId                              
                              
INNER JOIN dbo.UserDesignation AS Designation4                               
ON User4.UserDesignationId = Designation4.UserDesignationId                              
                              
INNER JOIN dbo.UMUserRegistration AS User5                               
ON A.DeliveredBy = User5.UserRegistrationId                              
                              
INNER JOIN dbo.UserDesignation AS Designation5                               
ON User5.UserDesignationId = Designation5.UserDesignationId                              
                              
INNER JOIN dbo.FMLovMst AS FMLovMst1                               
ON A.DeliverySchedule =FMLovMst1.LovId                              
                              
INNER JOIN dbo.FMLovMst AS FMLovMst2                               
ON B.Priority = FMLovMst2.LovId                              
                              
INNER JOIN dbo.FMLovMst AS FMLovMst3                               
ON A.QCTimeliness = FMLovMst3.LovId                              
                              
INNER JOIN dbo.FMLovMst AS FMLovMst4                               
ON A.ShortfallQC = FMLovMst4.LovId                              
                              
WHERE CleanLinenIssueId=@Id                          
              
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
