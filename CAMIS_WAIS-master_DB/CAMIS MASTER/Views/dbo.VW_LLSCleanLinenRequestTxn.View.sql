USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSCleanLinenRequestTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSCleanLinenRequestTxn]      
AS      
SELECT               
 A.CustomerId,      
 A.FacilityId,      
 A.CleanLinenRequestId,              
 A.DocumentNo,                      
 A.RequestDateTime,                      
 B.UserAreaCode,                      
 C.UserLocationCode,                      
 D.StaffName as RequestedBy,                      
 FMLovMst1.FieldValue as Priority,                      
 FMLovMst2.FieldValue as IssueStatus,                      
 A.ModifiedDate,      
 A.ModifiedDateUTC,      
 A.IsDeleted,      
 SUM(CLI.RequestedQuantity) AS TotalItemRequested                      
 --E.TotalItemIssued,                    
   
-- @TotalRecords AS TotalRecords                    
                       
FROM dbo.LLSCleanLinenRequestTxn A                      
INNER JOIN dbo.LLSUserAreaDetailsMst B                   
ON A.LLSUserAreaId=B.LLSUserAreaId                      
INNER JOIN dbo.LLSUserAreaDetailsLocationMstDet C                       
ON A.LLSUserAreaLocationId =C.LLSUserAreaLocationId                      
INNER JOIN dbo.UMUserRegistration D                      
ON A.RequestedBy =D.UserRegistrationId                       
INNER JOIN dbo.FMLovMst as FMLovMst1                       
ON A.Priority =FMLovMst1.LovId               
INNER JOIN dbo.FMLovMst as FMLovMst2                       
ON A.IssueStatus =FMLovMst2.LovId  
INNER JOIN LLSCleanLinenRequestLinenItemTxnDet CLI  
ON A.CleanLinenRequestId=CLI.CleanLinenRequestId  
--INNER JOIN dbo.LLSCleanLinenIssueTxn E                      
--ON A.CleanLinenRequestId =E.CleanLinenRequestId                       
--AND A.CustomerId = E.CustomerId                       
--AND A.FacilityId = E.FacilityId          
WHERE ISNULL(A.IsDeleted,'')=''   
AND ISNULL(CLI.IsDeleted,'')=''  
GROUP BY   
A.CustomerId,      
 A.FacilityId,      
 A.CleanLinenRequestId,              
 A.DocumentNo,                      
 A.RequestDateTime,                      
 B.UserAreaCode,                      
 C.UserLocationCode,                      
 D.StaffName,                      
 FMLovMst1.FieldValue,                      
 FMLovMst2.FieldValue,                      
 A.ModifiedDate,      
 A.ModifiedDateUTC,      
 A.IsDeleted
GO
