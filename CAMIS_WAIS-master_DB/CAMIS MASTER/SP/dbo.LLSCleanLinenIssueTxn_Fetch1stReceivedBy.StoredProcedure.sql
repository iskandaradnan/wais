USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueTxn_Fetch1stReceivedBy]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
          
---EXEC LLSCleanLinenIssueTxn_Fetch1stReceivedBy 'h'          
            
CREATE PROCEDURE [dbo].[LLSCleanLinenIssueTxn_Fetch1stReceivedBy]          
 @StaffName AS VARCHAR(50)                
,@pPageIndex    INT         
,@pPageSize    INT         
AS         
        
           
            
BEGIN            
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
  
DECLARE @TotalRecords INT         
SELECT  @TotalRecords = COUNT(*)          
FROM dbo.UMUserRegistration A          
INNER JOIN dbo.UserDesignation B           
ON A.UserDesignationId = B.UserDesignationId          
WHERE (A.UserTypeId =1)            
AND ((ISNULL(@StaffName,'') = '' ) OR (ISNULL(@StaffName,'') <> '' AND ( A.StaffName LIKE + '%' + @StaffName + '%'  OR A.StaffName LIKE + '%' + @StaffName + '%' )))               
  
            
            
SELECT A.UserRegistrationId,A.StaffName          
      ,B.Designation , @TotalRecords AS TotalRecords
         
FROM dbo.UMUserRegistration A          
INNER JOIN dbo.UserDesignation B           
ON A.UserDesignationId = B.UserDesignationId          
WHERE (A.UserTypeId =1)            
AND ((ISNULL(@StaffName,'') = '' ) OR (ISNULL(@StaffName,'') <> '' AND ( A.StaffName LIKE + '%' + @StaffName + '%'  OR A.StaffName LIKE + '%' + @StaffName + '%' )))               
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
