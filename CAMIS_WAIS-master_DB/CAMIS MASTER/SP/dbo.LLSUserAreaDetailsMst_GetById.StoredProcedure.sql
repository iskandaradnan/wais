USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsMst_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM LLSUserAreaDetailsLocationMstDet    
--SELECT * FROM LLSUserAreaDetailsLinenItemMstDet    
    
    
    
CREATE PROCEDURE [dbo].[LLSUserAreaDetailsMst_GetById]                    
(                    
 @Id INT                    
)                    
                     
AS                     
    -- Exec [LLSUserAreaDetailsMst_GetById] 97                 
                  
--/*=====================================================================================================================                  
--APPLICATION  : UETrack                  
--NAME    : GetUserRoleTimestamp                  
--DESCRIPTION  : GETS THE TIMESTAMP FOR CHECKING CONCURRENCY ISSUES                  
--AUTHORS   : BIJU NB                  
--DATE    : 20-March-2018                  
-------------------------------------------------------------------------------------------------------------------------                  
--VERSION HISTORY                   
--------------------:---------------:---------------------------------------------------------------------------------------                  
--Init    : Date          : Details                  
--------------------:---------------:---------------------------------------------------------------------------------------                  
--BIJU NB           : 20-March-2018 :                   
-------:------------:----------------------------------------------------------------------------------------------------*/                  
                  
BEGIN                    
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY                    
                     
SELECT              
   LLSUserAreaId            
  ,B.CustomerId                  
  ,B.FacilityId                  
  ,B.UserAreaId                  
  ,B.UserAreaCode AS UserAreaCode                  
  ,B.UserAreaName AS UserAreaName           
  ,C.StaffName AS HospitalRep                 
  ,C.UserRegistrationId AS HospitalRepID                  
  ,D.Designation AS HospitalDesignation                  
  ,A.EffectiveFromDate                  
  ,A.EffectiveToDate                  
  ,A.OperatingDays                  
  ,A.Status                  
  ,A.WhiteBag                  
  ,A.RedBag                  
  ,A.GreenBag                  
  ,A.BrownBag                  
  ,A.AlginateBag                  
  ,A.SoiledLinenBagHolder                  
  ,A.RejectBagHolder                  
  ,A.SoiledLinenRack                  
  ,A.LAADStartTime                  
  ,A.LAADEndTime                  
  ,A.CleaningSanitizing                  
                  
                  
FROM dbo.LLSUserAreaDetailsMst A                   
INNER JOIN dbo.MstLocationUserArea B                   
ON A.UserAreaId=B.UserAreaId                  
INNER JOIN dbo.UMUserRegistration C                  
ON A.HospitalRep=C.UserRegistrationId                   
INNER JOIN dbo.UserDesignation D                  
ON C.UserDesignationId=D.UserDesignationId                  
WHERE A.UserAreaId=@Id                  
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
