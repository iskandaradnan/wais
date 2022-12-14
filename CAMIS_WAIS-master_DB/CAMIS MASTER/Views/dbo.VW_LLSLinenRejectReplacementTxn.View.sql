USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSLinenRejectReplacementTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSLinenRejectReplacementTxn]
AS
SELECT              
 A.CustomerId,
 A.FacilityId,
 A.LinenRejectReplacementId,            
 FORMAT (A.DateTime, 'MMMM') as Month,        
 A.DateTime,                  
 A.DocumentNo,                  
 B.CLINo,                  
 C.UserAreaCode,                  
 D.UserLocationCode,   
 A.ModifiedDate,
 A.ModifiedDateUTC,
 A.IsDeleted,

 SUM(E.TotalRejectedQuantity) as TotalQuantityRejected,                  
 SUM(E.ReplacedQuantity) as TotalQuantityReplaced              
               
-- @TotalRecords AS TotalRecords                      
                      
                      
FROM dbo.LLSLinenRejectReplacementTxn A                  
INNER JOIN dbo.LLSCleanLinenIssueTxn  B                  
ON A.CleanLinenIssueId =B.CleanLinenIssueId                  
INNER JOIN dbo.LLSUserAreaDetailsMst C                   
ON A.LLSUserAreaId = C.LLSUserAreaId                  
INNER JOIN dbo.LLSUserAreaDetailsLocationMstDet D                  
ON A.LLSUserLocationId =D.LLSUserAreaLocationId                  
INNER JOIN dbo.LLSLinenRejectReplacementTxnDet E                  
ON A.LinenRejectReplacementId =E.LinenRejectReplacementId                  
WHERE ISNULL(A.IsDeleted,'')=''
GROUP BY              
 A.CustomerId,
 A.FacilityId,
 A.LinenRejectReplacementId,            
 FORMAT (A.DateTime, 'MMMM'),        
 A.DateTime,                  
 A.DocumentNo,                  
 B.CLINo,                  
 C.UserAreaCode,                  
 D.UserLocationCode,   
 A.ModifiedDate,
 A.ModifiedDateUTC,
 A.IsDeleted
GO
