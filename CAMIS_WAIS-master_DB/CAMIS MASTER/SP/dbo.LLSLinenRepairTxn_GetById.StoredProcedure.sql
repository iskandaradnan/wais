USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRepairTxn_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
            
CREATE PROCEDURE [dbo].[LLSLinenRepairTxn_GetById]            
(            
 @Id INT            
)            
             
AS             
    -- Exec [LLSLinenRepairTxn_GetById] 135         
          
--/*=====================================================================================================================          
--APPLICATION  : UETrack          
--NAME    : LLSLinenRepairTxn_GetById         
--DESCRIPTION  : GETS THE LLSLinenRepairTxn          
--AUTHORS   : SIDDHANT          
--DATE    : 17-JAN-2020          
-------------------------------------------------------------------------------------------------------------------------          
--VERSION HISTORY           
--------------------:---------------:---------------------------------------------------------------------------------------          
--Init    : Date          : Details          
--------------------:---------------:---------------------------------------------------------------------------------------          
--SIDDHANT           : 17-JAN-2020 :           
-------:------------:----------------------------------------------------------------------------------------------------*/          
          
BEGIN            
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY            
             
SELECT       
 A.LinenRepairId,      
 A.DocumentNo,        
 A.DocumentDate,        
 UMUserRegistration1.StaffName AS RepairedBy,        
 UMUserRegistration2.StaffName AS CheckBy,        
 A.Remarks        
FROM dbo.LLSLinenRepairTxn A        
INNER JOIN dbo.UMUserRegistration AS UMUserRegistration1         
ON A.RepairedBy = UMUserRegistration1.UserRegistrationId        
INNER JOIN dbo.UMUserRegistration AS UMUserRegistration2         
ON A.CheckedBy = UMUserRegistration2.UserRegistrationId         
WHERE LinenRepairId=@Id    
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
