USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERApplicationTxn_BERSummary_Rpt_L2]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================

Application Name	: UETrack-BEMS              

Version				: 1.0

Procedure Name		: [uspFM_BERApplicationTxn_BERSummary_Rpt] 

Description			: Get the BER Summary Report

Authors				: Ganesan S

Date				: 06-June-2018

-----------------------------------------------------------------------------------------------------------
Unit Test:

exec [uspFM_BERApplicationTxn_BERSummary_Rpt] @Facility_Id = 1,@From_Month=6,@From_Year= '2018',

@To_Month= 7,@To_Year='2018' ,@MenuName = ''

-----------------------------------------------------------------------------------------------------------

Version History 

exec [uspFM_BERApplicationTxn_BERSummary_Rpt_L2] @FacilityId = 1,@From_Date='15-Oct-2018',@To_Date= '20-Feb-2019'
--,@MenuName = ''

-----:------------:---------------------------------------------------------------------------------------

Init : Date       : Details

========================================================================================================*/
CREATE PROCEDURE [dbo].[uspFM_BERApplicationTxn_BERSummary_Rpt_L2](                                                  
		  @From_Date		VARCHAR(100) = '',    
          @To_Date			VARCHAR(100) = ''  , 
          @FacilityId    int ,
		  @Level			VARCHAR(200) = '' 
 ) 
as                                                  
BEGIN                                    

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY
 			
			
	DECLARE @mydate DATETIME  
	SELECT @mydate = GETDATE()   
	Declare @CMFirstDay Datetime, @CMLastDay Datetime , @LMFirstDay Datetime, @LMlastDay Datetime    
	set @CMFirstDay=(SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)-1),@mydate),101))  
	set @CMLastDay = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))),DATEADD(mm,1,@mydate)),101))  
	set @LMFirstDay=(SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))-1),DATEADD(mm,1,@mydate)),101))  
	set @LMlastDay= (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)),@mydate),101))  

    
	--Current Month Count 
	IF(@Level = '1')		
	BEGIN 
			select		1 as SNo, 
			ber.BERno,
            Asset.AssetNo,
			Asset.AssetDescription,
            Ber.BERStatus			AS BERStatus,
			BERStatus.FieldValue    AS BERStatusValue ,
			ber.ApprovedDate        AS BerApprovedDate,
			ber.ApprovedDate        AS BerExpiryDate
			,ber.ApprovedDate        AS BerRecommendationDate
			,format(cast(ber.ModifiedDate   as Date),'dd-MMM-yyyy')    AS BERStatusDate,
			2 as DaysPending , 
			RequestorStaff.StaffName RequestorName, 
			RequestorStaffDes.Designation RequestorDesignation
			from BERApplicationTxn ber 
			
		    inner join MstCustomer cust on cust.CustomerId= ber.CustomerId
		    inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId
            LEFT  JOIN  EngAsset AS Asset				WITH(NOLOCK)	ON ber.AssetId				= Asset.AssetId
			--left join EngTestingandCommissioningTxnDet			AS  Test			     WITH(NOLOCK) ON	Asset.TestingandCommissioningDetId   = Test.TestingandCommissioningDetId           
			--inner join		EngTestingandCommissioningTxn		as te					 WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId
			--left join  MstContractorandVendor				as Contractor				 WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId
			LEFT  JOIN	FMLovMst								AS BERStatus			WITH(NOLOCK)	ON ber.BERStatus				= BERStatus.LovId
			LEFT  JOIN	UMUserRegistration						AS RequestorStaff		WITH(NOLOCK)	ON ber.RequestorUserId		= RequestorStaff.UserRegistrationId
			LEFT  JOIN	UserDesignation							AS RequestorStaffDes	WITH(NOLOCK)	ON RequestorStaff.UserDesignationId		= RequestorStaffDes.UserDesignationId
     where 
     ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))  and 
	 CAST(ber.ApplicationDate AS DATE) >= CAST(@CMFirstDay  AS DATE) AND CAST(ber.ApplicationDate  AS DATE) <= CAST(@CMLastDay AS DATE)
	--  (CAST(ber.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE))   
	END
-- Previous month 
	ELSE IF(@Level = '2')		
	BEGIN 
			select		1 as SNo, 
			ber.BERno,
            Asset.AssetNo,
			Asset.AssetDescription,
            Ber.BERStatus			AS BERStatus,
			BERStatus.FieldValue    AS BERStatusValue ,
			ber.ApprovedDate        AS BerApprovedDate,
			ber.ApprovedDate        AS BerExpiryDate
			,ber.ApprovedDate        AS BerRecommendationDate
			,format(cast(ber.ModifiedDate   as Date),'dd-MMM-yyyy')    AS BERStatusDate,
			2 as DaysPending , 
			RequestorStaff.StaffName RequestorName, 
			RequestorStaffDes.Designation RequestorDesignation
			from BERApplicationTxn ber 
			
		    inner join MstCustomer cust on cust.CustomerId= ber.CustomerId
		    inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId
            LEFT  JOIN  EngAsset AS Asset				WITH(NOLOCK)	ON ber.AssetId				= Asset.AssetId
			--left join EngTestingandCommissioningTxnDet			AS  Test			     WITH(NOLOCK) ON	Asset.TestingandCommissioningDetId   = Test.TestingandCommissioningDetId           
			--inner join		EngTestingandCommissioningTxn		as te					 WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId
			--left join  MstContractorandVendor				as Contractor				 WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId
			LEFT  JOIN	FMLovMst								AS BERStatus			WITH(NOLOCK)	ON ber.BERStatus				= BERStatus.LovId
			LEFT  JOIN	UMUserRegistration						AS RequestorStaff		WITH(NOLOCK)	ON ber.RequestorUserId		= RequestorStaff.UserRegistrationId
			LEFT  JOIN	UserDesignation							AS RequestorStaffDes	WITH(NOLOCK)	ON RequestorStaff.UserDesignationId		= RequestorStaffDes.UserDesignationId
     where 
     ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))  and 
	 CAST(ber.ApplicationDate AS DATE) >= CAST(@LMFirstDay  AS DATE) AND CAST(ber.ApplicationDate  AS DATE) <= CAST(@LMlastDay AS DATE)
	--  (CAST(ber.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE))   
	END  
--Total Count 		
	ELSE IF(@Level = '3')		
	BEGIN 
			select		1 as SNo, 
			ber.BERno,
            Asset.AssetNo,
			Asset.AssetDescription,
            Ber.BERStatus			AS BERStatus,
			BERStatus.FieldValue    AS BERStatusValue ,
			ber.ApprovedDate        AS BerApprovedDate,
			ber.ApprovedDate        AS BerExpiryDate
			,ber.ApprovedDate        AS BerRecommendationDate
			,format(cast(ber.ModifiedDate   as Date),'dd-MMM-yyyy')    AS BERStatusDate,
			2 as DaysPending , 
			RequestorStaff.StaffName RequestorName, 
			RequestorStaffDes.Designation RequestorDesignation
			from BERApplicationTxn ber 
			
		    inner join MstCustomer cust on cust.CustomerId= ber.CustomerId
		    inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId
            LEFT  JOIN  EngAsset AS Asset				WITH(NOLOCK)	ON ber.AssetId				= Asset.AssetId
			--left join EngTestingandCommissioningTxnDet			AS  Test			     WITH(NOLOCK) ON	Asset.TestingandCommissioningDetId   = Test.TestingandCommissioningDetId           
			--inner join		EngTestingandCommissioningTxn		as te					 WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId
			--left join  MstContractorandVendor				as Contractor				 WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId
			LEFT  JOIN	FMLovMst								AS BERStatus			WITH(NOLOCK)	ON ber.BERStatus				= BERStatus.LovId
			LEFT  JOIN	UMUserRegistration						AS RequestorStaff		WITH(NOLOCK)	ON ber.RequestorUserId		= RequestorStaff.UserRegistrationId
			LEFT  JOIN	UserDesignation							AS RequestorStaffDes	WITH(NOLOCK)	ON RequestorStaff.UserDesignationId		= RequestorStaffDes.UserDesignationId
     where 
     ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))  and 
	 CAST(ber.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE) and ber.BERStatus not  in (206,210)
 
	END  
		
--Facility Manager 																				   	
   ELSE IF(@Level = '4')		
	BEGIN 
			select		1 as SNo, 
			ber.BERno,
            Asset.AssetNo,
			Asset.AssetDescription,
            Ber.BERStatus			AS BERStatus,
			BERStatus.FieldValue    AS BERStatusValue ,
			ber.ApprovedDate        AS BerApprovedDate,
			ber.ApprovedDate        AS BerExpiryDate
			,ber.ApprovedDate        AS BerRecommendationDate
			,format(cast(ber.ModifiedDate   as Date),'dd-MMM-yyyy')    AS BERStatusDate,
			2 as DaysPending , 
			RequestorStaff.StaffName RequestorName, 
			RequestorStaffDes.Designation RequestorDesignation
			from BERApplicationTxn ber 
			
		    inner join MstCustomer cust on cust.CustomerId= ber.CustomerId
		    inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId
            LEFT  JOIN  EngAsset AS Asset				WITH(NOLOCK)	ON ber.AssetId				= Asset.AssetId
			--left join EngTestingandCommissioningTxnDet			AS  Test			     WITH(NOLOCK) ON	Asset.TestingandCommissioningDetId   = Test.TestingandCommissioningDetId           
			--inner join		EngTestingandCommissioningTxn		as te					 WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId
			--left join  MstContractorandVendor				as Contractor				 WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId
			LEFT  JOIN	FMLovMst								AS BERStatus			WITH(NOLOCK)	ON ber.BERStatus				= BERStatus.LovId
			LEFT  JOIN	UMUserRegistration						AS RequestorStaff		WITH(NOLOCK)	ON ber.RequestorUserId		= RequestorStaff.UserRegistrationId
			LEFT  JOIN	UserDesignation							AS RequestorStaffDes	WITH(NOLOCK)	ON RequestorStaff.UserDesignationId		= RequestorStaffDes.UserDesignationId
     where 
     ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))  and 
	 CAST(ber.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE) 
	 and ber.BERStatus in (202,204,205)
 
	END  
--HD 																				   	
   ELSE IF(@Level = '5')		
	BEGIN 
			select		1 as SNo, 
			ber.BERno,
            Asset.AssetNo,
			Asset.AssetDescription,
            Ber.BERStatus			AS BERStatus,
			BERStatus.FieldValue    AS BERStatusValue ,
			ber.ApprovedDate        AS BerApprovedDate,
			ber.ApprovedDate        AS BerExpiryDate
			,ber.ApprovedDate        AS BerRecommendationDate
			,format(cast(ber.ModifiedDate   as Date),'dd-MMM-yyyy')    AS BERStatusDate,
			2 as DaysPending , 
			RequestorStaff.StaffName RequestorName, 
			RequestorStaffDes.Designation RequestorDesignation
			from BERApplicationTxn ber 
			
		    inner join MstCustomer cust on cust.CustomerId= ber.CustomerId
		    inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId
            LEFT  JOIN  EngAsset AS Asset				WITH(NOLOCK)	ON ber.AssetId				= Asset.AssetId
			--left join EngTestingandCommissioningTxnDet			AS  Test			     WITH(NOLOCK) ON	Asset.TestingandCommissioningDetId   = Test.TestingandCommissioningDetId           
			--inner join		EngTestingandCommissioningTxn		as te					 WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId
			--left join  MstContractorandVendor				as Contractor				 WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId
			LEFT  JOIN	FMLovMst								AS BERStatus			WITH(NOLOCK)	ON ber.BERStatus				= BERStatus.LovId
			LEFT  JOIN	UMUserRegistration						AS RequestorStaff		WITH(NOLOCK)	ON ber.RequestorUserId		= RequestorStaff.UserRegistrationId
			LEFT  JOIN	UserDesignation							AS RequestorStaffDes	WITH(NOLOCK)	ON RequestorStaff.UserDesignationId		= RequestorStaffDes.UserDesignationId
     where 
     ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))  and 
	 CAST(ber.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE) 
	 and ber.BERStatus in (203,208,209)
 
	END  
--LA  																				   	
   ELSE IF(@Level = '6')		
	BEGIN 
			select		1 as SNo, 
			ber.BERno,
            Asset.AssetNo,
			Asset.AssetDescription,
            Ber.BERStatus			AS BERStatus,
			BERStatus.FieldValue    AS BERStatusValue ,
			ber.ApprovedDate        AS BerApprovedDate,
			ber.ApprovedDate        AS BerExpiryDate
			,ber.ApprovedDate        AS BerRecommendationDate
			,format(cast(ber.ModifiedDate   as Date),'dd-MMM-yyyy')    AS BERStatusDate,
			2 as DaysPending , 
			RequestorStaff.StaffName RequestorName, 
			RequestorStaffDes.Designation RequestorDesignation
			from BERApplicationTxn ber 
			
		    inner join MstCustomer cust on cust.CustomerId= ber.CustomerId
		    inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId
            LEFT  JOIN  EngAsset AS Asset				WITH(NOLOCK)	ON ber.AssetId				= Asset.AssetId
			--left join EngTestingandCommissioningTxnDet			AS  Test			     WITH(NOLOCK) ON	Asset.TestingandCommissioningDetId   = Test.TestingandCommissioningDetId           
			--inner join		EngTestingandCommissioningTxn		as te					 WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId
			--left join  MstContractorandVendor				as Contractor				 WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId
			LEFT  JOIN	FMLovMst								AS BERStatus			WITH(NOLOCK)	ON ber.BERStatus				= BERStatus.LovId
			LEFT  JOIN	UMUserRegistration						AS RequestorStaff		WITH(NOLOCK)	ON ber.RequestorUserId		= RequestorStaff.UserRegistrationId
			LEFT  JOIN	UserDesignation							AS RequestorStaffDes	WITH(NOLOCK)	ON RequestorStaff.UserDesignationId		= RequestorStaffDes.UserDesignationId
     where 
     ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))  and 
	 CAST(ber.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE) 
	 and  ber.BERStatus in (207)
 
	END  

----- BER Summary report  Total 	

   ELSE IF(@Level = '11')		
	BEGIN 
			select		1 as SNo, 
			ber.BERno,
            Asset.AssetNo,
			Asset.AssetDescription,
            Ber.BERStatus			AS BERStatus,
			BERStatus.FieldValue    AS BERStatusValue ,
			(case when ber.BERStatus=206 then format(cast(ber.ApprovedDate  as Date),'dd-MMM-yyyy') 
			else '' end ) AS BerApprovedDate,
			--format(cast(ber.ApprovedDate  as Date),'dd-MMM-yyyy')       AS BerApprovedDate,
			format(cast(ber.ApprovedDate  as Date),'dd-MMM-yyyy')       AS BerExpiryDate
				,(case when ber.BERStatus=208 then format(cast(ber.ModifiedDate  as Date),'dd-MMM-yyyy') 
			else '' end ) as BerRecommendationDate
			--,format(cast(ber.ApprovedDate as Date),'dd-MMM-yyyy')        AS BerRecommendationDate
			,format(cast(ber.ModifiedDate   as Date),'dd-MMM-yyyy')    AS BERStatusDate,
			2 as DaysPending , 
			RequestorStaff.StaffName RequestorName, 
			RequestorStaffDes.Designation RequestorDesignation
			from BERApplicationTxn ber 
			
		    inner join MstCustomer cust on cust.CustomerId= ber.CustomerId
		    inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId
            LEFT  JOIN  EngAsset AS Asset				WITH(NOLOCK)	ON ber.AssetId				= Asset.AssetId
			--left join EngTestingandCommissioningTxnDet			AS  Test			     WITH(NOLOCK) ON	Asset.TestingandCommissioningDetId   = Test.TestingandCommissioningDetId           
			--inner join		EngTestingandCommissioningTxn		as te					 WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId
			--left join  MstContractorandVendor				as Contractor				 WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId
			LEFT  JOIN	FMLovMst								AS BERStatus			WITH(NOLOCK)	ON ber.BERStatus				= BERStatus.LovId
			LEFT  JOIN	UMUserRegistration						AS RequestorStaff		WITH(NOLOCK)	ON ber.RequestorUserId		= RequestorStaff.UserRegistrationId
			LEFT  JOIN	UserDesignation							AS RequestorStaffDes	WITH(NOLOCK)	ON RequestorStaff.UserDesignationId		= RequestorStaffDes.UserDesignationId
     where 
     ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))  and 
	 CAST(ber.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE) 
	
 
	END  
    ELSE IF(@Level = '12')		
	BEGIN 
			select		1 as SNo, 
			ber.BERno,
            Asset.AssetNo,
			Asset.AssetDescription,
            Ber.BERStatus			AS BERStatus,
			BERStatus.FieldValue    AS BERStatusValue ,

			(case when ber.BERStatus=206 then format(cast(ber.ApprovedDate  as Date),'dd-MMM-yyyy') 
			else '' end ) AS BerApprovedDate,


			--format(cast(ber.ApprovedDate  as Date),'dd-MMM-yyyy')       AS BerApprovedDate,
			format(cast(ber.ApprovedDate  as Date),'dd-MMM-yyyy')       AS BerExpiryDate,
			(case when ber.BERStatus=208 then format(cast(ber.ModifiedDate  as Date),'dd-MMM-yyyy') 
			else '' end ) as BerRecommendationDate
			--,format(cast(ber.ApprovedDate as Date),'dd-MMM-yyyy')        AS BerRecommendationDate
			,format(cast(ber.ModifiedDate   as Date),'dd-MMM-yyyy')    AS BERStatusDate,
			2 as DaysPending , 
			RequestorStaff.StaffName RequestorName, 
			RequestorStaffDes.Designation RequestorDesignation
			from BERApplicationTxn ber 
			
		    inner join MstCustomer cust on cust.CustomerId= ber.CustomerId
		    inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId
            LEFT  JOIN  EngAsset AS Asset				WITH(NOLOCK)	ON ber.AssetId				= Asset.AssetId
			--left join EngTestingandCommissioningTxnDet			AS  Test			     WITH(NOLOCK) ON	Asset.TestingandCommissioningDetId   = Test.TestingandCommissioningDetId           
			--inner join		EngTestingandCommissioningTxn		as te					 WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId
			--left join  MstContractorandVendor				as Contractor				 WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId
			LEFT  JOIN	FMLovMst								AS BERStatus			WITH(NOLOCK)	ON ber.BERStatus				= BERStatus.LovId
			LEFT  JOIN	UMUserRegistration						AS RequestorStaff		WITH(NOLOCK)	ON ber.RequestorUserId		= RequestorStaff.UserRegistrationId
			LEFT  JOIN	UserDesignation							AS RequestorStaffDes	WITH(NOLOCK)	ON RequestorStaff.UserDesignationId		= RequestorStaffDes.UserDesignationId
     where 
     ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))  and 
	 CAST(ber.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE) 
	 and ber.BERStatus=206
 
	END  
	  ELSE IF(@Level = '13')		
	BEGIN 
			select		1 as SNo, 
			ber.BERno,
            Asset.AssetNo,
			Asset.AssetDescription,
            Ber.BERStatus			AS BERStatus,
			BERStatus.FieldValue    AS BERStatusValue ,
				(case when ber.BERStatus=206 then format(cast(ber.ApprovedDate  as Date),'dd-MMM-yyyy') 
			else '' end ) AS BerApprovedDate,
			--format(cast(ber.ApprovedDate  as Date),'dd-MMM-yyyy')       AS BerApprovedDate,
			format(cast(ber.ApprovedDate  as Date),'dd-MMM-yyyy')       AS BerExpiryDate,
				(case when ber.BERStatus=208 then format(cast(ber.ModifiedDate  as Date),'dd-MMM-yyyy') 
			else '' end ) as BerRecommendationDate
			--,format(cast(ber.ApprovedDate as Date),'dd-MMM-yyyy')        AS BerRecommendationDate
			,format(cast(ber.ModifiedDate   as Date),'dd-MMM-yyyy')    AS BERStatusDate,
			2 as DaysPending , 
			RequestorStaff.StaffName RequestorName, 
			RequestorStaffDes.Designation RequestorDesignation
			from BERApplicationTxn ber 
			
		    inner join MstCustomer cust on cust.CustomerId= ber.CustomerId
		    inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId
            LEFT  JOIN  EngAsset AS Asset				WITH(NOLOCK)	ON ber.AssetId				= Asset.AssetId
			--left join EngTestingandCommissioningTxnDet			AS  Test			     WITH(NOLOCK) ON	Asset.TestingandCommissioningDetId   = Test.TestingandCommissioningDetId           
			--inner join		EngTestingandCommissioningTxn		as te					 WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId
			--left join  MstContractorandVendor				as Contractor				 WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId
			LEFT  JOIN	FMLovMst								AS BERStatus			WITH(NOLOCK)	ON ber.BERStatus				= BERStatus.LovId
			LEFT  JOIN	UMUserRegistration						AS RequestorStaff		WITH(NOLOCK)	ON ber.RequestorUserId		= RequestorStaff.UserRegistrationId
			LEFT  JOIN	UserDesignation							AS RequestorStaffDes	WITH(NOLOCK)	ON RequestorStaff.UserDesignationId		= RequestorStaffDes.UserDesignationId
     where 
     ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))  and 
	 CAST(ber.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE) 
	 and ber.BERStatus not in (206,210 )
 
	END  
	
	ELSE
	begin
		select		1 as SNo, 
			ber.BERno,
            Asset.AssetNo,
			Asset.AssetDescription,
            Ber.BERStatus			AS BERStatus,
			BERStatus.FieldValue    AS BERStatusValue ,
			
				(case when ber.BERStatus=206 then format(cast(ber.ApprovedDate  as Date),'dd-MMM-yyyy') 
			else '' end ) AS BerApprovedDate,
			--format(cast(ber.ApprovedDate  as Date),'dd-MMM-yyyy')       AS BerApprovedDate,
			format(cast(ber.ApprovedDate  as Date),'dd-MMM-yyyy')       AS BerExpiryDate,

			
				(case when ber.BERStatus=208 then format(cast(ber.ModifiedDate  as Date),'dd-MMM-yyyy') 
			else '' end ) as BerRecommendationDate

			--,format(cast(ber.ApprovedDate as Date),'dd-MMM-yyyy')        AS BerRecommendationDate
			,format(cast(ber.ModifiedDate   as Date),'dd-MMM-yyyy')    AS BERStatusDate,
			2 as DaysPending , 
			RequestorStaff.StaffName RequestorName, 
			RequestorStaffDes.Designation RequestorDesignation
			from BERApplicationTxn ber 
			
		    inner join MstCustomer cust on cust.CustomerId= ber.CustomerId
		    inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId
            LEFT  JOIN  EngAsset AS Asset				WITH(NOLOCK)	ON ber.AssetId				= Asset.AssetId
			--left join EngTestingandCommissioningTxnDet			AS  Test			     WITH(NOLOCK) ON	Asset.TestingandCommissioningDetId   = Test.TestingandCommissioningDetId           
			--inner join		EngTestingandCommissioningTxn		as te					 WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId
			--left join  MstContractorandVendor				as Contractor				 WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId
			LEFT  JOIN	FMLovMst								AS BERStatus			WITH(NOLOCK)	ON ber.BERStatus				= BERStatus.LovId
			LEFT  JOIN	UMUserRegistration						AS RequestorStaff		WITH(NOLOCK)	ON ber.RequestorUserId		= RequestorStaff.UserRegistrationId
			LEFT  JOIN	UserDesignation							AS RequestorStaffDes	WITH(NOLOCK)	ON RequestorStaff.UserDesignationId		= RequestorStaffDes.UserDesignationId
     where 
     ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))  and 
	 CAST(ber.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE) 
	-- and  ber.BERStatus in (207)
	end 
END TRY
BEGIN CATCH

INSERT INTO ERRORLOG(Spname,ErrorMessage,createddate)
values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH

SET NOCOUNT OFF                                             

END
GO
