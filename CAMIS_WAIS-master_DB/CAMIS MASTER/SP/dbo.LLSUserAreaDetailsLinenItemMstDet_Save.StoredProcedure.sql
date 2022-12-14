USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLinenItemMstDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================          
APPLICATION  : UETrack 1.5          
NAME    : SaveUserAreaDetailsLLS         
DESCRIPTION  : SAVE RECORD IN [LLSUserAreaDetailsLocationMstDet] TABLE           
AUTHORS   : SIDDHANT          
DATE    : 19-DEC-2019        
-----------------------------------------------------------------------------------------------------------------------          
VERSION HISTORY           
------------------:---------------:---------------------------------------------------------------------------------------          
Init    : Date          : Details          
------------------:---------------:---------------------------------------------------------------------------------------          
SIDDHANT          : 19-DEC-2019 :           
-----:------------:----------------------------------------------------------------------------------------------------*/          
        
          
        
        
          
CREATE PROCEDURE  [dbo].[LLSUserAreaDetailsLinenItemMstDet_Save]                                     
          
(          
@LLSUserAreaDetailsLinenItemMstDet AS [dbo].[LLSUserAreaDetailsLinenItemMstDet] READONLY        
)                
          
AS                
          
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
        
DECLARE @Table TABLE (ID INT)          
          
INSERT INTO [dbo].[LLSUserAreaDetailsLinenItemMstDet]        
           ([LLSUserAreaId]        
           ,[UserLocationId]        
           ,[LinenItemId]        
           ,[Par1]        
           ,[Par2]        
           ,[DefaultIssue]        
           ,[AgreedShelfLevel]        
           ,[CreatedBy]        
           ,[CreatedDate]        
           ,[CreatedDateUTC]        
           ,[ModifiedBy]        
           ,[ModifiedDate]        
           ,[ModifiedDateUTC]        
 )        
         
 OUTPUT INSERTED.LLSUserAreaId INTO @Table          
 SELECT        
 LLSUserAreaId        
,UserLocationId        
,LinenItemId        
,Par1        
,Par2        
,DefaultIssue        
,(Par2 * 2 ) AS AgreedShelfLevel        
,CreatedBy        
,GETDATE()        
,GETUTCDATE()        
,ModifiedBy ----USERID PASSED NULL        
,GETDATE()        
,GETUTCDATE()        
        
FROM @LLSUserAreaDetailsLinenItemMstDet         
          
SELECT LLSUserAreaId        
      ,[Timestamp]        
   ,'' ErrorMsg        
      --,GuId         
FROM LLSUserAreaDetailsLinenItemMstDet WHERE LLSUserAreaId IN (SELECT ID FROM @Table)          
          
END TRY          
BEGIN CATCH          
          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());          
          
THROW          
          
END CATCH          
SET NOCOUNT OFF          
END
GO
