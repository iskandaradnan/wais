USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_BemsUserTrainingRpt_L2]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version				: 1.0
File Name			: Asis_BemsUserTrainingRpt_L2
Procedure Name		: Asis_BemsUserTrainingRpt_L2
Author(s) Name(s)	:  
Date				:  
Purpose				: SP to User Training Report
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
     
EXEC Asis_BemsUserTrainingRpt_L2 @MenuName='',@Hospital_Id='163',@year='2016', @Quarter='Q1'
 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

*********************************************************************/              
CREATE PROCEDURE [dbo].[Asis_BemsUserTrainingRpt_L2]
( @MenuName Varchar(200) ,                                                
  @Hospital_Id		VARCHAR(30), 
  @Year             VARCHAR(30), 
  @Quarter          VARCHAR(30)
 )             
AS                                                
BEGIN                                  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY                                     


declare  @From_Date_local datetime, @to_Date_local datetime



 declare  @Quarter_tmp varchar(5)
 
/*******For Half Year*********/    
IF (@Quarter='Q1' ) 
BEGIN
	SET @Quarter_tmp='22'
	set @From_Date_local = CONVERT(VARCHAR(20),@Year) + '-01-01'
	set @to_Date_local	 = CONVERT(VARCHAR(20),@Year) + '-03-31'
END
ELSE IF (@Quarter='Q2') 
BEGIN
    SET @Quarter_tmp='23'
	set @From_Date_local = CONVERT(VARCHAR(20),@Year) + '-04-01'
	set @to_Date_local	 = CONVERT(VARCHAR(20),@Year) + '-06-30'
END
ELSE IF (@Quarter='Q3' ) 
BEGIN
	SET @Quarter_tmp='24'
	set @From_Date_local = CONVERT(VARCHAR(20),@Year) + '-07-01'
	set @to_Date_local	 = CONVERT(VARCHAR(20),@Year) + '-09-30'
END
ELSE IF (@Quarter='Q4' ) 
BEGIN
    SET @Quarter_tmp='25'
	set @From_Date_local = CONVERT(VARCHAR(20),@Year) + '-10-01'
	set @to_Date_local	 = CONVERT(VARCHAR(20),@Year) + '-12-31'
END


CREATE TABLE #FINAL (ROW_ID INT IDENTITY(1,1),Hospital_Id INT,TrainingScheduleId int,Training_Schedule_No VARCHAR(200),Training_Description VARCHAR(200),
Planned_Date DATETIME,Actual_Date DATETIME,[Status] VARCHAR(500),No_Of_Participants INT,
Presenter VARCHAR(200),Designation VARCHAR(200))

INSERT INTO #FINAL
SELECT A.facilityid as  HospitalId,a.TrainingScheduleId,A.TrainingScheduleNo,A.TrainingDescription,A.PlannedDate,
A.ActualDate,DBO.Fn_DisplayNameofLov(a.TrainingStatus),CAST(A.TotalParticipants AS INT),d.StaffName as Presenter,c.Designation
FROM EngTrainingScheduleTxn  A WITH(NOLOCK) 
left join EngTrainingScheduleTxnDet B WITH(NOLOCK) on A.TrainingScheduleId=B.TrainingScheduleId 
left join UMUserRegistration d WITH(NOLOCK) on a.TrainerUserId=d.UserRegistrationId 
left join  UserDesignation c  WITH(NOLOCK) on  d.UserDesignationId=c.UserDesignationId 
WHERE A.FacilityId = @Hospital_Id
AND A.YEAR       = @Year
and A.Quarter    = @Quarter_tmp
AND A.PlannedDate  BETWEEN @From_Date_local and @to_Date_local



SELECT
	--dbo.Fn_GetCompStateName(Hospital_Id,'Company') as 'Company_Name',
	--dbo.Fn_GetCompStateName(Hospital_Id,'State') as 'State_Name',
	Hospital_Id,
	TrainingScheduleId,
	--dbo.Fn_DisplayHospitalName(Hospital_Id) as 'Hospital_Name',
	Training_Schedule_No,
	Training_Description,
	format(cast(Planned_Date as Date),'dd-MMM-yyyy') as Planned_Date,
	format(cast(Actual_Date as Date),'dd-MMM-yyyy') as Actual_Date,
	[Status],
	ISNULL(No_Of_Participants,0) AS 'No_Of_Participants',
	Presenter,
	Designation
FROM #FINAL

DROP TABLE #FINAL

SET NOCOUNT OFF     
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF                                         
END
GO
