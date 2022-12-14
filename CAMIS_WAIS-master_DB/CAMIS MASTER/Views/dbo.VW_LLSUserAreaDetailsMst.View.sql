USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSUserAreaDetailsMst]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSUserAreaDetailsMst]
AS
SELECT             
   A.LLSUserAreaId             
  ,B.CustomerId                      
  ,B.FacilityId                      
  ,B.UserAreaId                      
  ,C.StaffName AS HospitalRep                
  ,A.EffectiveFromDate                      
  ,A.EffectiveToDate                      
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
  ,A.UserAreaCode                     
  ,B.UserAreaName                    
  ,C.StaffName                 
  ,A.ModifiedDate
  ,A.ModifiedDateUTC
  ,A.IsDeleted
  --,@TotalRecords AS TotalRecords                        
                      
FROM dbo.LLSUserAreaDetailsMst A                       
INNER JOIN dbo.MstLocationUserArea B                       
ON A.UserAreaId=B.UserAreaId                      
INNER JOIN [dbo].[UMUserRegistration] C                      
ON A.HospitalRep =C.UserRegistrationId             
WHERE ISNULL(A.IsDeleted,'')=''
GO
