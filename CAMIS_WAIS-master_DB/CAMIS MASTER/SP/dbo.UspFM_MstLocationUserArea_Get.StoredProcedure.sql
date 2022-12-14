USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstLocationUserArea_Get]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version				:               
File Name			:              
Procedure Name		: UspFM_CustomerMst_Get
Author(s) Name(s)	: Praveen N
Date				: 27-02-2017
Purpose				: SP to Get Customer details
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
  
EXEC Asis_EodParameterAnalysisRpt_L1 @MenuName = '' , @Level='national',@Option='85',@service=1, @Frequency='yearly',@Frequency_Key='',@Year='2017',@From_Date='',@To_Date='' 


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
Request Type: 973,974,975,976,977,978,979,980,983 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
Modified from Asis_EodParameterRpt_L1 to Asis_EodParameterExceptionRpt_L1  By Gosalai
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/    			          
	          

CREATE PROCEDURE  [dbo].[UspFM_MstLocationUserArea_Get]                           
( 
		@Id			        INT 
		  
)           
AS                                              
BEGIN                                
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


BEGIN TRY      
    SELECT 
UserAreaId
,CustomerId
,FacilityId
,'hello' UserLevelCode
,'hello' UserLevelName
,BlockId
,LevelId
,UserAreaCode
,UserAreaName
,CustomerUserId
,FacilityUserId
,'compny' HospitalStaffName
,'compny' CompanyStaffName
,Remarks
,Timestamp
,Active

   
   FROM MstLocationUserArea A 
   WHERE A.UserAreaId=@Id
         
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF
END
GO
