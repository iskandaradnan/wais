USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRejectReplacementTxn_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
          
              
CREATE PROCEDURE [dbo].[LLSLinenRejectReplacementTxn_GetById]              
(              
 @Id INT              
)              
               
AS               
    -- Exec [LLSLinenRejectReplacementTxn_GetById] 32           
            
--/*=====================================================================================================================            
--APPLICATION  : UETrack            
--NAME    : LLSLinenRejectReplacementTxn_GetById           
--DESCRIPTION  : GETS THE LinenRejectReplacement DETAILS            
--AUTHORS   : SIDDHANT            
--DATE    : 8-JAN-2020            
-------------------------------------------------------------------------------------------------------------------------            
--VERSION HISTORY             
--------------------:---------------:---------------------------------------------------------------------------------------            
--Init    : Date          : Details            
--------------------:---------------:---------------------------------------------------------------------------------------            
--SIDDHANT           : 8-JAN-2020 :             
-------:------------:----------------------------------------------------------------------------------------------------*/            
            
BEGIN              
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
               
SELECT       
A.LinenRejectReplacementId,      
 A.DocumentNo,          
 A.DateTime,          
 B.CLINo,          
 A.CLIDescription,          
 E.UserAreaCode,          
 D.UserAreaName,          
 E.UserLocationCode,          
 F.UserLocationName,          
 User1.StaffName AS RejectedBy,          
 Designation1.Designation AS RejectedByDesignation,          
 User2.StaffName AS ReplacementReceivedBy,          
 Designation2.Designation AS ReplacementReceivedByDesignation,          
 A.ReceivedDateTime,           
          
          
 SUM(G.TotalRejectedQuantity) AS TotalQuantityRejected,          
 SUM(G.ReplacedQuantity) AS TotalQuantityReplaced,          
 A.Remarks          
FROM dbo.LLSLinenRejectReplacementTxn A          
INNER JOIN dbo.LLSCleanLinenIssueTxn B           
ON A.CleanLinenIssueId =B.CleanLinenIssueId          
INNER JOIN dbo.LLSUserAreaDetailsMst C          
ON A.LLSUserAreaId =C.LLSUserAreaId          
INNER JOIN dbo.MstLocationUserArea D          
ON C.UserAreaCode =D.UserAreaCode          
INNER JOIN dbo.LLSUserAreaDetailsLocationMstDet E          
ON  A.LLSUserLocationId =E.LLSUserAreaLocationId          
INNER JOIN dbo.MstLocationUserLocation F          
ON E.UserLocationCode =F.UserLocationCode          
INNER JOIN dbo.UMUserRegistration AS User1           
ON A.RejectedBy= User1.UserRegistrationId          
INNER JOIN dbo.UserDesignation AS Designation1           
ON User1.UserDesignationId =Designation1.UserDesignationId          
INNER JOIN dbo.UMUserRegistration AS User2           
ON A.ReplacementReceivedBy = User2.UserRegistrationId          
INNER JOIN dbo.UserDesignation AS Designation2           
ON User2.UserDesignationId =Designation2.UserDesignationId          
INNER JOIN dbo.LLSLinenRejectReplacementTxnDet G ON          
A.LinenRejectReplacementId =G.LinenRejectReplacementId          
WHERE A.LinenRejectReplacementId=@Id          
AND ISNULL(A.IsDeleted,'')=''
GROUP BY        
A.LinenRejectReplacementId,      
 A.DocumentNo,          
 A.DateTime,          
 B.CLINo,          
 A.CLIDescription,          
 E.UserAreaCode,          
 D.UserAreaName,          
 E.UserLocationCode,          
 F.UserLocationName,          
 User1.StaffName,          
 Designation1.Designation,          
 User2.StaffName,          
 Designation2.Designation,          
 A.ReceivedDateTime,          
 A.Remarks           
          
          
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
END      
GO
