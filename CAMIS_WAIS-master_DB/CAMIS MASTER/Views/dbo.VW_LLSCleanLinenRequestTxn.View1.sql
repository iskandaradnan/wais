USE [UetrackMasterdbPreProd]
GO

/****** Object:  View [dbo].[VW_LLSCleanLinenRequestTxn]    Script Date: 12-11-2021 14:55:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[VW_LLSCleanLinenRequestTxn]      
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
 sum(CLI.RequestedQuantity) TotalItemRequested,                      
 --E.TotalItemIssued,                    
LI.LinenCode,                          
LI.LinenDescription,
MD.AgreedShelfLevel,
ISNULL(CLI.BalanceOnShelf,0) BalanceOnShelf,                          
E.DeliveryIssuedQty1st,                          
ISNULL(E.DeliveryIssuedQty2nd,0) DeliveryIssuedQty2nd,
ISNULL(CLI.RequestedQuantity-(E.DeliveryIssuedQty1st+E.DeliveryIssuedQty2nd),0) AS Shortfall,
ISNULL(F.OpeningBalance,0) AS StoreBalance

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

INNER JOIN dbo.LLSLinenItemDetailsMst LI                           
ON CLI.LinenItemId = LI.LinenItemId  

INNER JOIN dbo.LLSUserAreaDetailsLinenItemMstDet MD                          
ON CLI.LinenItemId =MD.LinenItemId                          
AND A.LLSUserAreaLocationId =MD.UserLocationId                           
AND A.CustomerId = C.CustomerId                          
AND A.FacilityId =C.FacilityId  

INNER JOIN dbo.LLSCleanLinenIssueLinenItemTxnDet E                          
ON  CLI.CleanLinenIssueId =E.CleanLinenIssueId                          
AND CLI.LinenItemId =E.LinenitemId 

INNER JOIN dbo.LLSCentralCleanLinenStoreMstDet F         
ON CLI.LinenItemId =F.LinenItemId   
          
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
 D.StaffName ,                      
 FMLovMst1.FieldValue ,                      
 FMLovMst2.FieldValue ,                      
 A.ModifiedDate,      
 A.ModifiedDateUTC,      
 A.IsDeleted,  
LI.LinenCode,                          
LI.LinenDescription,
MD.AgreedShelfLevel,
CLI.RequestedQuantity,
CLI.BalanceOnShelf,
E.DeliveryIssuedQty1st,
E.DeliveryIssuedQty2nd,
F.OpeningBalance

GO


