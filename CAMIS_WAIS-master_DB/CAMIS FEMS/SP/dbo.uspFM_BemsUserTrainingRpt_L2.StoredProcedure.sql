USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BemsUserTrainingRpt_L2]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--drop proc [usp_BemsUserTrainingRpt_L2]            
--------------------------------------------------------------------------------------------------      
--------------------------------------------------------------------------------------------------      
      
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
            
Application Name : ASIS                          
            
Version    : 1.0            
            
File Name   : usp_BemsUserTrainingRpt_L2            
            
Procedure Name  : usp_BemsUserTrainingRpt_L2            
            
Author(s) Name(s) : Hari Haran N            
            
Date    :              
            
Purpose    : SP to User Training Report            
            
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
           
EXEC uspFM_BemsUserTrainingRpt_L2 @Facility_Id='1',@year='2018', @Quarter=null, @TrainingType = null, @NoofParticipants = 76 
EXEC uspFM_BemsUserTrainingRpt_L2 @Facility_Id='1',@year='2018', @TrainingType = 254, @NoofParticipants = 5    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
            
Modification History                
            
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
            
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS                
            
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
        
*********************************************************************/                          
            
CREATE PROCEDURE [dbo].[uspFM_BemsUserTrainingRpt_L2](                                                             
  @Facility_Id  VARCHAR(30),               
  @Year             VARCHAR(30),             
  @Quarter          VARCHAR(30) =NULL  ,          
  @MenuName			VARCHAR(1000)=NULL,    
  @TrainingType		INT = NULL,    
  @NoofParticipants INT = NULL    
    
  --@TrainingType  varchar(15) = NULL,    
 -- @NoofParticipants varchar(50) = NULL    
 )      
AS      
BEGIN      
      
SET NOCOUNT ON      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
BEGIN TRY      
        
declare  @From_Date_local datetime, @to_Date_local datetime            
      
 declare  @Quarter_tmp varchar(5) = NULL   
 Declare @ParticipantsNumber varchar(200) = null     
            
/*******For Half Year*********/                
        
IF (@Quarter='Q1 (Jan - Mar)' )             
BEGIN            
            
  --SET @Quarter_tmp='22'            
  set @From_Date_local = CONVERT(VARCHAR(20),@Year) + '-01-01'            
  set @to_Date_local  = CONVERT(VARCHAR(20),@Year) + '-03-31'            
             
END            
ELSE IF (@Quarter='Q2 (Apr - Jun)')             
BEGIN            
            
--SET @Quarter_tmp='23'            
            
 set @From_Date_local = CONVERT(VARCHAR(20),@Year) + '-04-01'            
 set @to_Date_local  = CONVERT(VARCHAR(20),@Year) + '-06-30'            
            
END            
ELSE IF (@Quarter='Q3 (Jul - Sep)' )             
BEGIN            
            
 --SET @Quarter_tmp='24'            
  set @From_Date_local = CONVERT(VARCHAR(20),@Year) + '-07-01'            
  set @to_Date_local  = CONVERT(VARCHAR(20),@Year) + '-09-30'            
             
END            
ELSE IF (@Quarter='Q4 (Oct - Dec)' )             
BEGIN            
            
 --SET @Quarter_tmp='25'            
 set @From_Date_local = CONVERT(VARCHAR(20),@Year) + '-10-01'            
 set @to_Date_local  = CONVERT(VARCHAR(20),@Year) + '-12-31'            
            
END  

ELSE IF (@Quarter is null  or  @Quarter = '')             
BEGIN            
            
 --SET @Quarter_tmp='25'            
 set @From_Date_local = CONVERT(VARCHAR(20),@Year) + '-01-01'            
 set @to_Date_local  = CONVERT(VARCHAR(20),@Year) + '-12-31'            
            
END  

          
        
--SELECT @From_Date_local, @to_Date_local, @Quarter_tmp        
        
declare  @@FINAL TABLE(ROW_ID INT IDENTITY(1,1),Hospital_Id INT,TrainingScheduleId int,Training_Schedule_No VARCHAR(200),      
Training_Description VARCHAR(1000),            
Planned_Date DATETIME,Actual_Date DATETIME,[Status] VARCHAR(500),No_Of_Participants INT,            
Presenter VARCHAR(200),Designation VARCHAR(200), Dummmy varchar(200) )            
            
INSERT INTO @@FINAL(Hospital_Id,TrainingScheduleId ,Training_Schedule_No, Training_Description,            
Planned_Date, Actual_Date,[Status], No_Of_Participants, Presenter, Designation , Dummmy)        
            
SELECT   distinct  A.facilityid as  HospitalId,a.TrainingScheduleId,A.TrainingScheduleNo,A.TrainingDescription,A.PlannedDate,            
A.ActualDate,DBO.Fn_DisplayNameofLov(a.TrainingStatus),CAST(A.MinimumNoofParticipants AS INT),d.StaffName as Presenter,c.Designation,      
lov.FieldValue  Dummmy          
FROM EngTrainingScheduleTxn  A WITH(NOLOCK)             
left join EngTrainingScheduleTxnDet B WITH(NOLOCK) on A.TrainingScheduleId=B.TrainingScheduleId             
left join UMUserRegistration d WITH(NOLOCK) on a.TrainerUserId=d.UserRegistrationId             
left join  UserDesignation c  WITH(NOLOCK) on  d.UserDesignationId=c.UserDesignationId   
left join  FMLovMst lov  WITH(NOLOCK) on  lov.LovId=A.TrainingType   

          
WHERE A.FacilityId = @Facility_Id           
AND A.YEAR       = @Year            
and ((A.Quarter    = @Quarter_tmp) or (@Quarter is null) or (@Quarter = '') OR(@Quarter_tmp IS NULL) OR(@Quarter_tmp ='') )        
AND ((CAST(A.PlannedDate AS DATE) BETWEEN CAST(isnull(@From_Date_local,A.PlannedDate) AS DATE)       
           AND CAST(isnull(@to_Date_local, A.PlannedDate) AS DATE))   or a.TrainingType =255)          
AND ((A.TrainingType = @TrainingType) OR (@TrainingType IS NULL))    
AND ((A.MinimumNoofParticipants = @NoofParticipants) OR (@NoofParticipants IS NULL))    
    
    
	if(@Quarter is null or @Quarter ='null' or @Quarter= '' )
	begin
	set @Quarter= ''
	end 
--if(@NoofParticipants is null or @NoofParticipants ='null' or @NoofParticipants= '' or @NoofParticipants =0  or @NoofParticipants = '0')
--begin
--set @NoofParticipants= null
--end 

set @ParticipantsNumber = isnull(@NoofParticipants,'')
print @NoofParticipants
SELECT            
 --dbo.Fn_GetCompStateName(Hospital_Id,'Company') as 'Company_Name',            
 --dbo.Fn_GetCompStateName(Hospital_Id,'State') as 'State_Name',            
 Hospital_Id,           
 Dummmy,           
 TrainingScheduleId,            
 --dbo.Fn_DisplayHospitalName(Hospital_Id) as 'Hospital_Name',            
 Training_Schedule_No,            
 Training_Description,            
 format(cast(Planned_Date as Date),'dd-MMM-yyyy') as Planned_Date,            
 format(cast(Actual_Date as Date),'dd-MMM-yyyy') as Actual_Date,            
 [Status],            
 ISNULL(No_Of_Participants,'') AS 'No_Of_Participants',            
 Presenter,            
 Designation,          
 ISNULL(@Quarter,' ') as Quarter           
  ,isnull(@Year,'') as Year  
  , CASE WHEN  @TrainingType = 254 THEN 'Planned ' WHEN @TrainingType = 255 THEN 'Unplanned' END TrainingType  
  , case  when @NoofParticipants =0 or @NoofParticipants is null or @NoofParticipants = '' then ''  else  @ParticipantsNumber end  AS NoofParticipants  
  --, isnull(@NoofParticipants,'')  AS NoofParticipants1   
FROM @@FINAL            
 

--DROP TABLE #FINAL            
            
SET NOCOUNT OFF                 
            
END TRY            
BEGIN CATCH            
       
 insert into ErrorLog(Spname,ErrorMessage,createddate)            
 values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())      
      
END CATCH            
SET NOCOUNT OFF                                                     
            
END
GO
