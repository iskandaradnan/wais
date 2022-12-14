USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenCondemnationTxn_FetchInspectedBy]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LLSLinenCondemnationTxn_FetchInspectedBy]                
        
 @FacilityId AS INT          
,@StaffName AS VARCHAR(100)          
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
INNER JOIN dbo.UserDesignation  B              
ON A.UserDesignationId = B.UserDesignationId              
WHERE (A.UserTypeId = 2)             
AND ((ISNULL(@StaffName,'') = '' ) OR (ISNULL(@StaffName,'') <> '' AND ( A.StaffName LIKE + '%' + @StaffName + '%'  OR A.StaffName LIKE + '%' + @StaffName + '%' )))           
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))      
  
              
              
SELECT A.UserRegistrationId,A.StaffName , @TotalRecords AS TotalRecords             
FROM dbo.UMUserRegistration A              
INNER JOIN dbo.UserDesignation  B              
ON A.UserDesignationId = B.UserDesignationId              
WHERE (A.UserTypeId = 2)             
AND ((ISNULL(@StaffName,'') = '' ) OR (ISNULL(@StaffName,'') <> '' AND ( A.StaffName LIKE + '%' + @StaffName + '%'  OR A.StaffName LIKE + '%' + @StaffName + '%' )))           
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))      
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
