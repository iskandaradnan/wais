USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueTxn_FetchLinenBag]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
      
      
                                
---LLSCleanLinenIssueTxn_FetchLinenBag 83                   
                       
CREATE PROCEDURE [dbo].[LLSCleanLinenIssueTxn_FetchLinenBag]                                  
 @DocumentNo AS VARCHAR(100)                              
--@FacilityID AS INT                              
--,@pPageIndex    INT              
--,@pPageSize    INT                   
              
        
                              
AS                                  
                                  
BEGIN                                  
SET NOCOUNT ON                                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                    
BEGIN TRY                                    
              
              
DECLARE @TotalRecords INT                   
SELECT  @TotalRecords = COUNT(*)                    
FROM dbo.LLSCleanLinenRequestTxn A                                
INNER JOIN dbo.FMLovMst AS FMLovMst1                                 
ON A.IssueStatus = FMLovMst1.LovId                                
INNER JOIN dbo.LLSUserAreaDetailsMst B                                
ON A.LLSUserAreaId = B.LLSUserAreaId                                
INNER JOIN dbo.MstLocationUserArea  C                                
ON B.UserAreaCode = C.UserAreaCode                                
INNER JOIN dbo.LLSUserAreaDetailsLocationMstDet D                                
ON A.LLSUserAreaLocationId = D.LLSUserAreaLocationId                                
INNER JOIN dbo.MstLocationUserLocation E                                 
ON D.UserLocationCode = E.UserLocationCode                                
INNER JOIN dbo.UMUserRegistration F                                
ON A.RequestedBy = F.UserRegistrationId                                
INNER JOIN dbo.UserDesignation G                                
ON F.UserDesignationId = G.UserDesignationId                                
INNER JOIN dbo.FMLovMst AS FMLovMst2                                 
ON A.Priority = FMLovMst2.LovId                                
INNER JOIN LLSCleanLinenRequestLinenItemTxnDet H                  
ON A.CleanLinenRequestId=H.CleanLinenRequestId                  
INNER JOIN LLSCleanLinenRequestLinenBagTxnDet I                  
ON A.CleanLinenRequestId=I.CleanLinenRequestId                  
INNER JOIN LLSLinenItemDetailsMst J                  
ON J.LinenItemId=H.LinenItemId                  
INNER JOIN LLSCleanLinenIssueTxn Z                
ON I.CleanLinenRequestId=Z.CleanLinenRequestId                
WHERE 
---AS DISCUSSED LOGIC ON 06-07-2020
--FMLovMst1.FieldValue = 'Pending'                                
((ISNULL(@DocumentNo,'') = '' ) OR (ISNULL(@DocumentNo,'') <> '' AND ( A.CleanLinenRequestId = @DocumentNo   OR A.CleanLinenRequestId = @DocumentNo)))                         
AND ISNULL(A.IsDeleted,'')=''                  
                               
           
              
              
 DECLARE @VAR AS TABLE           
 (          
 ID INT          
 )          
              
              
---ID FETCH              
INSERT INTO @VAR          
(          
ID          
)          
          
SELECT                             
A.CleanLinenRequestId                                
FROM dbo.LLSCleanLinenRequestTxn A                                
INNER JOIN dbo.FMLovMst AS FMLovMst1                                 
ON A.IssueStatus = FMLovMst1.LovId                                
                                
INNER JOIN dbo.LLSUserAreaDetailsMst B                                
ON A.LLSUserAreaId = B.LLSUserAreaId                                
                                
INNER JOIN dbo.MstLocationUserArea  C                                
ON B.UserAreaCode = C.UserAreaCode                                
                                
INNER JOIN dbo.LLSUserAreaDetailsLocationMstDet D                                
ON A.LLSUserAreaLocationId = D.LLSUserAreaLocationId                                
                                
INNER JOIN dbo.MstLocationUserLocation E                                 
ON D.UserLocationCode = E.UserLocationCode                                
                                
INNER JOIN dbo.UMUserRegistration F                                
ON A.RequestedBy = F.UserRegistrationId                                
                                
INNER JOIN dbo.UserDesignation G                                
ON F.UserDesignationId = G.UserDesignationId             
                                
INNER JOIN dbo.FMLovMst AS FMLovMst2                                 
ON A.Priority = FMLovMst2.LovId                                
WHERE 
--FMLovMst1.FieldValue = 'Pending'                                
((ISNULL(@DocumentNo,'') = '' ) OR (ISNULL(@DocumentNo,'') <> '' AND ( A.CleanLinenRequestId= @DocumentNo OR A.CleanLinenRequestId = @DocumentNo  )))                         
AND ISNULL(A.IsDeleted,'')=''                 
          
              
              
----DATA FETCH              
              
              
SELECT                              
A.CleanLinenRequestId                                
 ,A.DocumentNo                                
,A.RequestDateTime                                
,B.UserAreaCode                                
,C.UserAreaName                                
,D.UserLocationCode                                
,E.UserLocationName                                
,F.StaffName AS RequestedBy                                
,G.Designation                                
,FMLovMst2.FieldValue AS Priority     
,FMLovMst2.LovId AS Priorityid     
,J.LinenCode                  
,J.LinenDescription                  
 --,Z.CleanLinenRequestId            
 , @TotalRecords AS TotalRecords            
            
            
       
    
FROM dbo.LLSCleanLinenRequestTxn A                                
INNER JOIN dbo.FMLovMst AS FMLovMst1                                 
ON A.IssueStatus = FMLovMst1.LovId                                
                                
INNER JOIN dbo.LLSUserAreaDetailsMst B                                
ON A.LLSUserAreaId = B.LLSUserAreaId                                
                                
INNER JOIN dbo.MstLocationUserArea  C                                
ON B.UserAreaCode = C.UserAreaCode                                
                                
INNER JOIN dbo.LLSUserAreaDetailsLocationMstDet D                                
ON A.LLSUserAreaLocationId = D.LLSUserAreaLocationId                                
                                
INNER JOIN dbo.MstLocationUserLocation E                                 
ON D.UserLocationCode = E.UserLocationCode                                
                                
INNER JOIN dbo.UMUserRegistration F                                
ON A.RequestedBy = F.UserRegistrationId                                
                                
INNER JOIN dbo.UserDesignation G                                
ON F.UserDesignationId = G.UserDesignationId                                
                                
INNER JOIN dbo.FMLovMst AS FMLovMst2                                 
ON A.Priority = FMLovMst2.LovId                                
                  
INNER JOIN (SELECT DISTINCT CleanLinenRequestId,LinenItemId FROM LLSCleanLinenRequestLinenItemTxnDet) H                  
ON A.CleanLinenRequestId=H.CleanLinenRequestId                  
                  
INNER JOIN (SELECT DISTINCT CleanLinenRequestId FROM LLSCleanLinenRequestLinenBagTxnDet) I                  
ON A.CleanLinenRequestId=I.CleanLinenRequestId                  
                  
INNER JOIN LLSLinenItemDetailsMst J                  
ON J.LinenItemId=H.LinenItemId                  
              
--INNER JOIN LLSCleanLinenIssueTxn Z                
--ON I.CleanLinenRequestId=Z.CleanLinenRequestId                
                  
                  
WHERE 
--FMLovMst1.FieldValue = 'Pending'                                
((ISNULL(@DocumentNo,'') = '' ) OR (ISNULL(@DocumentNo,'') <> '' AND ( A.CleanLinenRequestId = @DocumentNo  OR A.CleanLinenRequestId = @DocumentNo)))                         
AND ISNULL(A.IsDeleted,'')=''  
                   
                   
                  
               
              
SELECT * FROM LLSCleanLinenRequestLinenBagTxnDet              
WHERE CleanLinenRequestId  IN (SELECT ID FROM @VAR) ORDER BY LaundryBag               
              
SELECT * FROM LLSCleanLinenRequestLinenItemTxnDet                
WHERE CleanLinenRequestId IN (SELECT ID FROM @VAR) ORDER BY LinenitemId                    
              
              
END TRY                                    
BEGIN CATCH            
                                    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                                 
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                                    
                                    
THROW                                    
                
END CATCH                                    
SET NOCOUNT OFF                                    
                                  
                                
END             
      
GO
