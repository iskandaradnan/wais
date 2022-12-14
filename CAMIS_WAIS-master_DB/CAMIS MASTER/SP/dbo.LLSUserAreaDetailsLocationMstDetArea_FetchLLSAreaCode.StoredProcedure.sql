USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLocationMstDetArea_FetchLLSAreaCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--EXEC LLSUserAreaDetailsLocationMstDetArea_FetchLLSAreaCode 166  
CREATE PROCEDURE [dbo].[LLSUserAreaDetailsLocationMstDetArea_FetchLLSAreaCode]  
(  
@UserAreaId INT  
)  
AS  
BEGIN  
  
BEGIN TRY  
SELECT A.LLSUserAreaId,A.UserAreaId,A.UserAreaCode FROM LLSUserAreaDetailsMst A  
INNER JOIN MstLocationUserArea B                            
ON A.UserAreaId=B.UserAreaId          
WHERE B.UserAreaId=@UserAreaId  
AND ISNULL(A.IsDeleted,'')=''
  
END TRY  
BEGIN CATCH  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                    
                    
THROW                    
                    
END CATCH                    
SET NOCOUNT OFF                    
END            
GO
