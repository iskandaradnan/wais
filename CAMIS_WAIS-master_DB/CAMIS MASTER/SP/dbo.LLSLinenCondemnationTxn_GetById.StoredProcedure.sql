USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenCondemnationTxn_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
CREATE PROCEDURE [dbo].[LLSLinenCondemnationTxn_GetById]                
(                
 @Id INT                
)                
                 
AS                 
    -- Exec [LLSLinenCondemnationTxn_GetById] 1           
--/*=====================================================================================================================              
--APPLICATION  : UETrack              
--NAME    : LLSLicenseTypeMst_GetById             
--DESCRIPTION  : GETS THE LLSLinenCondemnation            
--AUTHORS   : SIDDHANT              
--DATE    : 16-JAN-2020              
-------------------------------------------------------------------------------------------------------------------------              
--VERSION HISTORY               
--------------------:---------------:---------------------------------------------------------------------------------------              
--Init    : Date          : Details              
--------------------:---------------:---------------------------------------------------------------------------------------              
--SIDDHANT           : 16-JAN-2020 :               
-------:------------:----------------------------------------------------------------------------------------------------*/              
              
BEGIN                
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                
BEGIN TRY                
                 
SELECT      
      
 A.DocumentNo,            
 A.DocumentDate,            
 UMUserRegistration1.StaffName as InspectedBy,            
 UMUserRegistration2.StaffName as VerifiedBy,            
 SUM(B.Torn+B.Stained+B.Faded+B.Vandalism+B.WearTear+B.StainedByChemical) as TotalCondemns,            
 0.00 as Value,            
 C.LovId as LocationOfCondemns,            
 A.Remarks            
            
FROM dbo.LLSLinenCondemnationTxn A            
INNER JOIN dbo.UMUserRegistration AS UMUserRegistration1             
ON A.InspectedBy = UMUserRegistration1.UserRegistrationId            
INNER JOIN dbo.UMUserRegistration as UMUserRegistration2             
ON A.VerifiedBy = UMUserRegistration2.UserRegistrationId             
INNER JOIN dbo.LLSLinenCondemnationTxnDet B            
ON A.LinenCondemnationId =B.LinenCondemnationId            
INNER JOIN dbo.FMLovMst C             
ON A.LocationOfCondemnation=C.LovId            
WHERE A.LinenCondemnationId = @Id  
AND ISNULL(A.IsDeleted,'')=''
           
GROUP BY            
 A.DocumentNo,            
 A.DocumentDate,            
 UMUserRegistration1.StaffName,            
 UMUserRegistration2.StaffName,            
 C.LovId,            
 A.Remarks             
            
END TRY                
BEGIN CATCH                
                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                
                
THROW                
                
END CATCH                
SET NOCOUNT OFF                
END
GO
