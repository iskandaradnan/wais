USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSFacilityEquipToolsConsumeMst_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
          
CREATE PROCEDURE [dbo].[LLSFacilityEquipToolsConsumeMst_GetById]           
(          
 @Id INT          
)          
           
AS           
    -- Exec [LLSFacilityEquipToolsConsumeMst_GetById] 2       
        
--/*=====================================================================================================================        
--APPLICATION  : UETrack        
--NAME    : LLSFacilityEquipToolsConsumeMst_GetById        
--DESCRIPTION  : GETS THE FacilityEquipToolsConsume       
--AUTHORS   : SIDDHANT        
--DATE    : 9-JAN-2020        
-------------------------------------------------------------------------------------------------------------------------        
--VERSION HISTORY         
--------------------:---------------:---------------------------------------------------------------------------------------        
--Init    : Date          : Details        
--------------------:---------------:---------------------------------------------------------------------------------------        
--SIDDHANT           : 9-JAN-2020 :         
-------:------------:----------------------------------------------------------------------------------------------------*/        
        
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
           
SELECT      
 ItemCode,      
 ItemDescription,      
 B.LovId as ItemType,      
 C.LovId as Status,      
 EffectiveFromDate,      
 EffectiveToDate      
FROM      
 dbo.LLSFacilityEquipToolsConsumeMst A      
INNER JOIN      
 dbo.FMLovMst as B ON A.ItemType =B.LovId      
INNER JOIN      
 dbo.FMLovMst as C ON A.Status =C.LovId      
WHERE FETCId=@Id      
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
