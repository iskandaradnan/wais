USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstLocationFacility_Get]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version				:               
File Name			:              
Procedure Name		: UspFM_MstLocationFacility_Get
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
	          

CREATE PROCEDURE  [dbo].[UspFM_MstLocationFacility_Get]                           
( 
		@FacilityId			        INT,
		@Operation			        NVARCHAR(30)=NULL
		  
)           
AS                                              
BEGIN                                
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-------------------------------------------------------------------------------------
--Declare Variables  
-------------------------------------------------------------------------------------
--DECLARE @Error_Code             INT

---------------------------------------------------------------------------------------
----Initialize Variables  
---------------------------------------------------------------------------------------
--SET @Error_Code = 0
--SET @IsUpdatedSuccessfullyParameter = 1

BEGIN TRY  


    IF(@Operation ='Get')

	   BEGIN    
       SELECT 
           FacilityId
          ,facility.CustomerId
		  ,cust.CustomerCode
		  ,cust.CustomerName
          ,FacilityName
          ,FacilityCode
          ,facility.Address [Address]
          ,facility.Latitude
          ,facility.Longitude
          ,facility.ActiveFrom
          ,facility.ActiveFromUTC
          ,facility.ActiveTo
          ,facility.ActiveToUTC
          ,facility.CreatedBy
          ,facility.CreatedDate
          ,facility.CreatedDateUTC
          ,facility.ModifiedBy
          ,facility.ModifiedDate
          ,facility.ModifiedDateUTC
          ,facility.Timestamp
          ,facility.Active
		  ,facility.WeeklyHoliday
          ,facility.Address2
          ,facility.Postcode
          ,facility.State
          ,facility.Country
          ,facility.ContractPeriodInMonths
          ,facility.InitialProjectCost
          ,facility.MonthlyServiceFee
          ,facility.DocumentId,
		  facility.TypeOfNomenclature,
		--  facility.LifeExpectancy,
		  facility.Logo,
		  FacilityImage,
		  facility.GuId
		  ,facility.ContactNo
		  ,facility.Faxno
		  ,isnull(IsContractPeriodChanged,0)IsContractPeriodChanged
		  ,facility.WarrantyRenewalNoticeDays
   FROM MstLocationFacility facility 
   inner join MstCustomer cust on cust.CustomerId = facility.CustomerId
   WHERE facility.FacilityId=@FacilityId

   select * from MstLocationFacilityContactInfo where FacilityId= @FacilityId

   END
   IF(@Operation ='GetTimestamp')

	   BEGIN   
	       SELECT Timestamp FROM MstLocationFacility WHERE FacilityId = @FacilityId;
	   End 
         
END TRY
BEGIN CATCH


 ----------------------------------
---- SET Output Status and Message
-----------------------------------
--SET @Error_Code = @@ERROR

--IF @Error_Code <> 0 
--		BEGIN
--			SET @DB_ERROR = 'Procedure:' + 'UspFM_CustomerMst_Ge' +'- Error Code: '+ @Error_Code+' - '+ ERROR_MESSAGE();
--			SET @IsUpdatedSuccessfullyParameter = 0
--		END


insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())



END CATCH
SET NOCOUNT OFF
END
GO
