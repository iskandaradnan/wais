USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_BemsUserTrainingRpt_L1]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: UETrack-BEMS              
Version				: 1.0
File Name			: BemsUserTrainingRpt_L1
Procedure Name		: BemsUserTrainingRpt_L1
Author(s) Name(s)	:  
Date				:  
Purpose				: SP to User Training Report
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

EXEC Asis_BemsUserTrainingRpt_L1 @MenuName='',@Level='national',@Option='1', @year='2016', @Quarter='Q1'
  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

*********************************************************************/                  
CREATE  PROCEDURE [dbo].[Asis_BemsUserTrainingRpt_L1]
(	  @MenuName Varchar(200) ,                                               
	  @Level            VARCHAR(30),
	  @Option           VARCHAR(30),
	  @Year             VARCHAR(30), 
	  @Quarter          VARCHAR(30)
 )             
AS                                                
BEGIN                                  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY      


declare  @From_Date_local datetime, @to_Date_local datetime


Declare  @Hospital_Master  table (  HospitalId int)     


 IF (@Level='national')         
 BEGIN       
	insert into  @Hospital_Master        
	Select FacilityId as   HospitalId FROM MstLocationFacility WITH(NOLOCK)    group by FacilityId      
 END   
 ELSE IF (@Level='Customer')         
 BEGIN  
	 insert into  @Hospital_Master         
	 Select  FacilityId as   HospitalId FROM MstLocationFacility WITH(NOLOCK) Where CustomerId=@Option   group by FacilityId  
 END 
 --ELSE IF (@Level='State')         
 --BEGIN  
	--insert into  @Hospital_Master         
 --   Select  FacilityId as   HospitalId  FROM MstLocationFacility WITH(NOLOCK) Where stateid=@Option  group by FacilityId 
 --END 
 ELSE IF (@Level='Facility')  
 begin  
	 insert into  @Hospital_Master    
	 select @Option
 END
 
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


;with CTE_Final
as
(
	SELECT A.facilityid as HospitalId,COUNT(1) as NoOfTrainingConducted
	FROM EngTrainingScheduleTxn A WITH(NOLOCK)
	join @Hospital_Master B on a.FacilityId = b.HospitalId
	AND A.Year		= @Year
	and A.Quarter	= @Quarter_tmp
	AND A.PlannedDate  BETWEEN @From_Date_local and @to_Date_local
	GROUP BY A.FacilityId
)

SELECT
		CustomerName as 'Customer_Name',
		--StateName as 'State_Name',
		h.FacilityName AS 'Hospital_Name',
		a.HospitalId as 'Hospital_Id',
		NoOfTrainingConducted as 'No_Of_Training_Conducted'
FROM CTE_Final a join V_MstLocationFacility h on a.HospitalId = h.FacilityId 





END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF      
                                      
END
GO
