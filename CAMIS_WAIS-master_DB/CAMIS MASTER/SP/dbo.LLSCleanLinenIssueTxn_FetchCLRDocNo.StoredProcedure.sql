USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueTxn_FetchCLRDocNo]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                
                                          
---LLSCleanLinenIssueTxn_FetchCLRDocNo 'c',144,5,1                                        
                                 
CREATE PROCEDURE [dbo].[LLSCleanLinenIssueTxn_FetchCLRDocNo]                                            
 @DocumentNo AS VARCHAR(100)                                        
,@FacilityID AS INT                                        
,@pPageIndex    INT                        
,@pPageSize    INT                             
                        
                  
                                        
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
--INNER JOIN LLSCleanLinenRequestLinenItemTxnDet H                            
--ON A.CleanLinenRequestId=H.CleanLinenRequestId                            
--INNER JOIN LLSCleanLinenRequestLinenBagTxnDet I                            
--ON A.CleanLinenRequestId=I.CleanLinenRequestId                            
--INNER JOIN LLSLinenItemDetailsMst J                            
--ON J.LinenItemId=H.LinenItemId                            
--INNER JOIN LLSCleanLinenIssueTxn Z                          
--ON I.CleanLinenRequestId=Z.CleanLinenRequestId                          
WHERE A.CleanLinenRequestId NOT IN (SELECT A.CleanLinenRequestId FROM LLSCleanLinenIssueTxn A)      
--SELECT @TotalRecords      
--AND ((ISNULL(@DocumentNo,'') = '' ) OR (ISNULL(@DocumentNo,'') <> '' AND ( A.DocumentNo LIKE + '%' + @DocumentNo + '%'  OR A.DocumentNo LIKE + '%' + @DocumentNo + '%' )))                                   
AND ((ISNULL(@FacilityID,'')='' )  OR (ISNULL(@FacilityID,'') <> '' AND A.FacilityId = @FacilityID))                              
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
WHERE A.CleanLinenRequestId NOT IN (SELECT A.CleanLinenRequestId FROM LLSCleanLinenIssueTxn A)      
AND ((ISNULL(@DocumentNo,'') = '' ) OR (ISNULL(@DocumentNo,'') <> '' AND ( A.DocumentNo LIKE + '%' + @DocumentNo + '%'  OR A.DocumentNo LIKE + '%' + @DocumentNo + '%' )))                                   
AND ((ISNULL(@FacilityID,'')='' )  OR (ISNULL(@FacilityID,'') <> '' AND A.FacilityId = @FacilityID))                              
AND ISNULL(A.IsDeleted,'')=''                    
                        
                        
----DATA FETCH                        
                        
                        
SELECT                
A.LLSUserAreaId              
,A.LLSUserAreaLocationId              
,A.CleanLinenRequestId           
 ,A.DocumentNo                                          
,A.RequestDateTime                                          
,B.UserAreaCode                                          
,C.UserAreaName                                          
,D.UserLocationCode                                          
,E.UserLocationName                                          
,F.StaffName AS RequestedBy                                          
,G.Designation                                          
,FMLovMst1.FieldValue AS Priority              
,D.LinenSchedule    
,D.[1stScheduleStartTime]    
,D.[1stScheduleEndTime]    
,D.[2ndScheduleStartTime]    
,D.[2ndScheduleEndTime]    
,D.[3rdScheduleStartTime]    
,D.[3rdScheduleEndTime]   
,A.TotalBagRequested  
,A.TotalItemRequested  
    
-- ,Z.CleanLinenRequestId                      
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
      
      
                            
--INNER JOIN (SELECT DISTINCT CleanLinenRequestId,LinenItemId FROM LLSCleanLinenRequestLinenItemTxnDet) H                            
--ON A.CleanLinenRequestId=H.CleanLinenRequestId                            
                            
--INNER JOIN (SELECT DISTINCT CleanLinenRequestId FROM LLSCleanLinenRequestLinenBagTxnDet) I            
--ON A.CleanLinenRequestId=I.CleanLinenRequestId                            
                            
--INNER JOIN LLSLinenItemDetailsMst J                            
--ON J.LinenItemId=H.LinenItemId                            
                        
--INNER JOIN LLSCleanLinenIssueTxn Z                          
--ON I.CleanLinenRequestId=Z.CleanLinenRequestId                          
                            
WHERE A.CleanLinenRequestId NOT IN (SELECT A.CleanLinenRequestId FROM LLSCleanLinenIssueTxn A)      
AND ((ISNULL(@DocumentNo,'') = '' ) OR (ISNULL(@DocumentNo,'') <> '' AND ( A.DocumentNo LIKE + '%' + @DocumentNo + '%'  OR A.DocumentNo LIKE + '%' + @DocumentNo + '%' )))                                   
AND ((ISNULL(@FacilityID,'')='' )  OR (ISNULL(@FacilityID,'') <> '' AND A.FacilityId = @FacilityID))                              
AND ISNULL(A.IsDeleted,'')=''            
ORDER BY A.ModifiedDateUTC DESC                              
OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY                               
                            
                         
                        
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
