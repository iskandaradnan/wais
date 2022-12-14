USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueTxn_FetchCLRDocNoNew]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
                                
---LLSCleanLinenIssueTxn_FetchCLRDocNoNew 'CLR',144,1,5                              
                       
CREATE PROCEDURE [dbo].[LLSCleanLinenIssueTxn_FetchCLRDocNoNew]                                  
 @DocumentNo AS VARCHAR(100)                              
,@FacilityID AS INT                              
,@pPageIndex    INT              
,@pPageSize    INT                   
              
        
                              
AS                                  
                                  
BEGIN                                  
SET NOCOUNT ON                                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                    
BEGIN TRY                                    


--DECLARE @DocumentNo  VARCHAR(100)                              
--DECLARE @FacilityID  INT                              
--DECLARE @pPageIndex  INT=1              
--DECLARE @pPageSize   INT=40     

--SET @DocumentNo=''
--SET @FacilityID=
--SET @pPageIndex=
--SET @pPageSize=
--`              
              
DECLARE @TotalRecords INT                   
SELECT  @TotalRecords = COUNT(*)                    
FROM dbo.LLSCleanLinenRequestTxn A                                
WHERE A.IssueStatus =10103                                            
AND ((ISNULL(@DocumentNo,'') = '' ) OR (ISNULL(@DocumentNo,'') <> '' AND ( A.DocumentNo LIKE + '%' + @DocumentNo + '%'  OR A.DocumentNo LIKE + '%' + @DocumentNo + '%' )))                         
AND ((ISNULL(@FacilityID,'')='' )  OR (ISNULL(@FacilityID,'') <> '' AND A.FacilityId = @FacilityID))                    
AND ISNULL(A.IsDeleted,'')=''                               

SELECT DocumentNo
FROM dbo.LLSCleanLinenRequestTxn A                                
WHERE A.IssueStatus =10103                                
AND ((ISNULL(@DocumentNo,'') = '' ) OR (ISNULL(@DocumentNo,'') <> '' AND ( A.DocumentNo LIKE + '%' + 'CLR' + '%'  OR A.DocumentNo LIKE + '%' + 'CLR' + '%' )))                         
AND ((ISNULL(@FacilityID,'')='' )  OR (ISNULL(@FacilityID,'') <> '' AND A.FacilityId = 144))                    
AND ISNULL(A.IsDeleted,'')=''  
ORDER BY A.ModifiedDateUTC DESC                    
OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY                     



              
 
              
              
END TRY                                    
BEGIN CATCH            
                                    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                                 
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                                    
                                    
THROW                                    
                
END CATCH                                    
SET NOCOUNT OFF                                    
                                  
                                
END             
GO
