USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsMst_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================              
APPLICATION  : UETrack 1.5              
NAME    : SaveUserAreaDetailsLLS             
DESCRIPTION  : UPDATE RECORD IN [LLSUserAreaDetailsMst_Update] TABLE               
AUTHORS   : SIDDHANT              
DATE    : 24-DEC-2019            
-----------------------------------------------------------------------------------------------------------------------              
VERSION HISTORY               
------------------:---------------:---------------------------------------------------------------------------------------              
Init    : Date          : Details              
------------------:---------------:---------------------------------------------------------------------------------------              
SIDDHANT          : 24-DEC-2019 :               
-----:------------:----------------------------------------------------------------------------------------------------*/              
            
              
            
            
              
CREATE PROCEDURE  [dbo].[LLSUserAreaDetailsMst_Update]                                           
                
(   
 @UserAreaId AS INT  
,@HospitalRep AS INT            
,@EffectiveFromDate AS NVARCHAR(50)                
,@EffectiveToDate AS NVARCHAR(50)                
,@OperatingDays AS NVARCHAR(50)            
,@Status AS INT            
,@WhiteBag AS INT            
,@RedBag AS INT            
,@GreenBag AS INT            
,@BrownBag AS INT            
,@AlginateBag AS INT            
,@SoiledLinenBagHolder AS INT            
,@RejectBagHolder AS INT            
,@SoiledLinenRack AS INT            
,@LAADStartTime AS NVARCHAR(40)           
,@CleaningSanitizing AS NVARCHAR(40)             
,@ModifiedBy AS INT            
--,@ModifiedDate AS DATETIME            
--,@ModifiedDateUTC AS DATETIME            
            
)                      
                
AS                      
                
BEGIN                
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                
BEGIN TRY                
              
DECLARE @Table TABLE (ID INT)         
declare @LAADStartTime1 datetime       
set @LAADStartTime1 = CONVERT(time,@LAADStartTime, 103)      
              
UPDATE A              
SET              
 HospitalRep = @HospitalRep,              
 --EffectiveFromDate = @EffectiveFromDate,              
 --EffectiveToDate = @EffectiveToDate,              
 OperatingDays = @OperatingDays,              
 Status = @Status,              
 WhiteBag = @WhiteBag,              
 RedBag = @RedBag,              
 GreenBag = @GreenBag,              
 BrownBag = @BrownBag,              
 AlginateBag = @AlginateBag,              
 SoiledLinenBagHolder = @SoiledLinenBagHolder,              
 RejectBagHolder = @RejectBagHolder,              
 SoiledLinenRack = @SoiledLinenRack,              
 LAADStartTime =CONVERT(Time, @LAADStartTime1),              
 LAADEndTime = DATEADD(HOUR,2,@LAADStartTime1),              
 CleaningSanitizing = @CleaningSanitizing,             
 ModifiedBy = @ModifiedBy    
 --ModifiedDate = @ModifiedDate,              
 --ModifiedDateUTC = @ModifiedDateUTC              
 FROM LLSUserAreaDetailsMst A              
WHERE UserAreaId = @UserAreaId        
      
declare @test datetime       
set @test = CONVERT(time,'23/4/2020 2:22:00 PM', 103)      
  select    DATEADD(HOUR,2,@test),    CONVERT(time,'23/4/2020 2:22:00 PM', 103)      
        
              
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
                
END CATCH                
SET NOCOUNT OFF                
END    
    
  
  select * from LLSUserAreaDetailsMst
GO
