USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLaundryPlantMst_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[LLSLaundryPlantMst_GetById]        
(        
 @Id INT        
)        
         
AS         
    -- Exec [LLSLaundryPlantMst_GetById] 135     
      
--/*=====================================================================================================================      
--APPLICATION  : UETrack      
--NAME    : LLSLaundryPlantMst_GetById     
--DESCRIPTION  : GETS THE LaundryPlantMst DETAILS      
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
  A.LaundryPlantCode    
 ,A.LaundryPlantName    
 ,B.LovId AS Ownership    
 ,A.Capacity    
 ,A.ContactPerson    
 ,C.LovId AS Status    
FROM    
 dbo.LLSLaundryPlantMst A    
INNER JOIN    
 dbo.FMLovMst AS B ON A.Ownership =B.LovId    
INNER JOIN    
 dbo.FMLovMst AS C ON A.Status =C.LovId     
WHERE A.LaundryPlantId=@Id      
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
