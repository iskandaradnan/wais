USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenItemDetailsMst_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LLSLinenItemDetailsMst_GetById]                
(                
 @Id INT                
)                
                 
AS                 
    -- Exec [LLSLinenItemDetailsMst_GetById] 27             
              
--/*=====================================================================================================================              
--APPLICATION  : UETrack              
--NAME    : LLSLinenItemDetailsMst_GetById             
--DESCRIPTION  : GETS THE LINEN DETAILS              
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
  A.LinenItemId          
  ,A.LinenCode            
 ,A.LinenDescription            
 ,B.LovId as UOM            
 ,C.LovId as Material            
 ,D.LovId as Status            
 ,A.EffectiveDate            
 ,A.Size            
 ,E.LovId as Colour            
 ,F.LovId as Standard            
 ,A.IdentificationMark            
 ,A.LinenPrice                  
FROM            
 dbo.LLSLinenItemDetailsMst A            
INNER JOIN            
 dbo.FMLovMst  B ON A.UOM =            
B.LovId            
INNER JOIN            
 dbo.FMLovMst C ON A.material =            
C.LovId            
INNER JOIN             
 dbo.FMLovMst D ON A.Status =            
D.LovId            
INNER JOIN            
 dbo.FMLovMst E ON A.Colour =            
E.LovId            
INNER JOIN            
dbo.FMLovMst F ON A.Standard =F.LovId            
WHERE LinenItemId=@Id            
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
