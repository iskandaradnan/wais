USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UET_PPMchedule_Rpt_Frequency_L2]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : [UET_PPMchedule_Rpt_Frequency_L2]     
Description   : Get the BER Analysis Report(Level2 Frequency)    
Authors    : KRISHNA S    
Date    : 13-June-2018    
-----------------------------------------------------------------------------------------------------------    
exec UET_PPMchedule_Rpt_Frequency_L2 @TypeCodeId = 1057,@FacilityId=1, @Year = 2018, @TaskCodeOption = 365  
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
drop procedure UET_PPMchedule_Rpt_Frequency_L2  
========================================================================================================*/    
CREATE  PROCEDURE [dbo].[UET_PPMchedule_Rpt_Frequency_L2](            
			@TypeCodeId		INT,
			@Year			VARCHAR(100) = '',
			@FacilityId		int  ,
			@TaskCodeOption INT  ,	---364 ---> Manual, 365 ---> Frequency
			@Schedule		INT = null,
			@Status			INT = null,
			@AssetNo			VARCHAR(1100) = ''
 )
AS
BEGIN     
    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
BEGIN TRY    
     
     
select C.AssetNo,B.AssetTypeCode, B.AssetTypeDescription    
,   D.FieldValue as TaskCodeOption, --E.FieldValue as  ScheduleType , F.Fieldvalue as Status,   
format(cast(A.FirstDate as Date),'dd-MMM-yyyy') as FirstDate,
format(cast( A.NextDate as Date),'dd-MMM-yyyy') as NextDate, 
format(cast(A.LastDate as Date),'dd-MMM-yyyy') as LastDate,  ISNULL(@TaskCodeOption,0) TaskCodeOptionPARAM
from EngPlannerTxn A     
Inner join EngAssetTypeCode B on A.AssetTypeCodeId= B.AssetTypeCodeId    
left join  EngAsset C on A.AssetId = C.AssetId    
left join  FMLovMst D on A.GenerationType = D.LovId    
--left join  FMLovMst E on A.ScheduleType = E.LovId    
--left join  FMLovMst F on A.Status = F.LovId   
where((A.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))     
 AND ((A.AssetTypeCodeId = @TypeCodeId) OR (@TypeCodeId IS NULL) OR (@TypeCodeId = ''))     
 AND ((A.Year = @Year) OR (@Year IS NULL) OR (@Year = ''))     
 AND ((A.GenerationType = @TaskCodeOption) OR (@TaskCodeOption IS NULL) OR (@TaskCodeOption = ''))     
 AND ((A.ScheduleType = @Schedule) OR (@Schedule IS NULL) OR (@Schedule = ''))      
 AND ((A.Status = @Status) OR (@Status IS NULL) OR (@Status = ''))            
  and C.assetno=@AssetNo
    
    
    
END TRY    
BEGIN CATCH    
    
insert into ErrorLog(Spname,ErrorMessage,createddate)    
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    
    
END CATCH    
SET NOCOUNT OFF    
    
    
END
GO
