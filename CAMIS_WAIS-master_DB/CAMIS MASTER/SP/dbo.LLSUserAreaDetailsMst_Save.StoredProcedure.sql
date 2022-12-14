USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsMst_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================                          
APPLICATION  : UETrack 1.5                          
NAME    : SaveUserAreaDetailsLLS                         
DESCRIPTION  : SAVE RECORD IN [LLSUserAreaDetailsMst] TABLE                           
AUTHORS   : SIDDHANT                          
DATE    : 19-DEC-2019                        
-----------------------------------------------------------------------------------------------------------------------                          
VERSION HISTORY                           
------------------:---------------:---------------------------------------------------------------------------------------                          
Init    : Date          : Details                          
------------------:---------------:---------------------------------------------------------------------------------------                          
SIDDHANT          : 19-DEC-2019 :                           
-----:------------:----------------------------------------------------------------------------------------------------*/                          
            
          
          
            
              
CREATE PROCEDURE  [dbo].[LLSUserAreaDetailsMst_Save]                                                     
                          
(                          
 @LLSUserAreaDetailsMst As [dbo].[LLSUserAreaDetailsMst] READONLY                          
)                                
                          
AS                                
                          
BEGIN                          
SET NOCOUNT ON                          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                          
BEGIN TRY                          
                        
DECLARE @Table TABLE (ID INT)                          
                          
INSERT INTO LLSUserAreaDetailsMst                         
(                        
 CustomerId                        
,FacilityId                        
,UserAreaId                        
,UserAreaCode                        
,HospitalRep                        
,EffectiveFromDate                        
,EffectiveToDate                        
,OperatingDays                        
,Status                        
,WhiteBag                        
,RedBag                        
,GreenBag                        
,BrownBag                        
,AlginateBag                        
,SoiledLinenBagHolder                        
,RejectBagHolder                        
,SoiledLinenRack                        
,LAADStartTime                        
,LAADEndTime                        
,CleaningSanitizing                        
,CreatedBy                        
,CreatedDate                        
,CreatedDateUTC                        
,ModifiedBy                        
,ModifiedDate                        
,ModifiedDateUTC                        
)                          
 OUTPUT INSERTED.LLSUserAreaId INTO @Table                          
 SELECT  CustomerId                        
  ,FacilityId                        
  ,UserAreaId                        
  ,UserAreaCode                        
  ,HospitalRep                        
  ,CAST(EffectiveFromDate AS DATETIME) AS  EffectiveFromDate                    
  ,CAST(EffectiveToDate AS DATETIME)  AS  EffectiveToDate                   
  ,OperatingDays                        
  --,CASE WHEN Status='Active'  THEN 1         
  --WHEN Status='Inactive' THEN 2        
  --WHEN Status='Open' THEN 10167        
  --WHEN Status='Approved' THEN 10168        
  --WHEN Status='Not Approved' THEN 10169        
  --WHEN Status='Cancelled' THEN 10170        
  --WHEN Status='Open' THEN 10226        
  --WHEN Status='Closed' THEN 10227        
  --WHEN Status='Done' THEN 10248        
  --WHEN Status='Not Done' THEN 10249        
  --END AS STATUS           
  ,Status              
  ,WhiteBag                        
  ,RedBag                        
  ,GreenBag                        
  ,BrownBag                        
  ,AlginateBag              
  ,SoiledLinenBagHolder                        
  ,RejectBagHolder                        
  ,SoiledLinenRack                        
  ,CAST(LAADStartTime AS DATETIME) AS LAADStartTime                       
  ,DATEADD(HOUR,2,CAST(LAADStartTime AS DATETIME)) AS LAADEndTime                        
  ,CleaningSanitizing                        
  ,CreatedBy                        
  ,GETDATE()           
  ,GETUTCDATE()                        
  ,ModifiedBy                      
  ,GETDATE()                        
  ,GETUTCDATE()                        
FROM @LLSUserAreaDetailsMst                          
                          
SELECT LLSUserAreaId                        
      ,[Timestamp]                        
   ,'' ErrorMsg                        
      --,GuId                         
FROM LLSUserAreaDetailsMst WHERE LLSUserAreaId IN (SELECT ID FROM @Table)                          
                          
END TRY                          
BEGIN CATCH                          
                          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                          
                          
THROW                          
                          
END CATCH                SET NOCOUNT OFF                          
END
GO
