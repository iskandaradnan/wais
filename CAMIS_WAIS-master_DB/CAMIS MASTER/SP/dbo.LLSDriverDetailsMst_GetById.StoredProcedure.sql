USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSDriverDetailsMst_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
            
CREATE PROCEDURE [dbo].[LLSDriverDetailsMst_GetById]            
(            
 @Id INT            
)            
             
AS             
    -- Exec [LLSDriverDetailsMst_GetById] 135         
          
--/*=====================================================================================================================          
--APPLICATION  : UETrack          
--NAME    : LLSDriverDetailsMst_GetById         
--DESCRIPTION  : GETS THE DIRVER DETAILS          
--AUTHORS   : SIDDHANT          
--DATE    : 13-JAN-2020          
-------------------------------------------------------------------------------------------------------------------------          
--VERSION HISTORY           
--------------------:---------------:---------------------------------------------------------------------------------------          
--Init    : Date          : Details          
--------------------:---------------:---------------------------------------------------------------------------------------          
--SIDDHANT           : 13-JAN-2020 :           
-------:------------:----------------------------------------------------------------------------------------------------*/          
          
BEGIN            
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY            
             
SELECT        
 A.DriverId,      
 A.DriverCode,        
 B.LaundryPlantId as LaundryPlantName,        
 A.DriverName,        
 C.LovId as Status,        
 A.EffectiveFrom,        
 A.EffectiveTo,        
 A.ContactNo,        
 A.ICNo        
FROM        
 dbo.LLSDriverDetailsMst A        
INNER JOIN dbo.LLSLaundryPlantMst B        
ON A.LaundryPlantId =B.LaundryPlantId        
INNER JOIN dbo.FMLovMst C         
ON A.Status = C.LovId         
WHERE DriverId=@ID        
AND ISNULL(A.IsDeleted,'')=''
AND ISNULL(B.IsDeleted,'')=''

        
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
END
GO
