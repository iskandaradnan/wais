USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLocationMstDet_Delete]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
-- Exec [LLSUserAreaDetailsLocationMstDet_Delete]       
      
--/*=====================================================================================================================      
--APPLICATION  : UETrack 1.5      
--NAME    : SaveUserAreaDetailsLLS     
--DESCRIPTION  : DELETE RECORD  (UPDATE ISELDETED COLUMN)IN [LLSUserAreaDetailsLocationMstDet] TABLE       
--AUTHORS   : SIDDHANT      
--DATE    : 19-DEC-2019    
-------------------------------------------------------------------------------------------------------------------------      
--VERSION HISTORY       
--------------------:---------------:---------------------------------------------------------------------------------------      
--Init    : Date          : Details      
--------------------:---------------:---------------------------------------------------------------------------------------      
--SIDDHANT          : 19-DEC-2019 :       
-------:------------:----------------------------------------------------------------------------------------------------*/      
    
      
    
    
      
CREATE PROCEDURE  [dbo].[LLSUserAreaDetailsLocationMstDet_Delete]                                 
      
(      
@ID AS INT    
)            
      
AS            
      
BEGIN      
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
BEGIN TRY      
    
UPDATE A    
SET A.IsDeleted = 1    
FROM LLSUserAreaDetailsLocationMstDet A    
WHERE LLSUserAreaId = @ID     
      
END TRY      
BEGIN CATCH      
      
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)      
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());      
      
THROW      
      
END CATCH      
SET NOCOUNT OFF      
END
GO
