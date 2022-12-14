USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_Rpt_L2]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
Application Name : UE-Track                
Version    :                 
File Name   :                
Procedure Name  : uspFM_CRMRequest_Rpt   
Author(s) Name(s) : Ganesan S  
Date    : 21/05/2018  
Purpose    : SP to Check Service Request  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
EXEC SPNAME Parameter      

EXEC [uspFM_CRMRequest_Rpt] '@Facility_Id','@From_Date','@To_Date','@RequestType'    

EXEC uspFM_CRMRequest_Rpt @Facility_Id= '1',@From_Date='2015-05-01 00:00:00.000',@To_Date='2018-09-01 00:00:00.000',@RequestType=136  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
Modification History      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~         
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/     
CREATE  PROCEDURE  [dbo].[uspFM_CRMRequest_Rpt_L2](
  @Facility_Id      VARCHAR(10) = '',
  @From_Date       VARCHAR(50)= '',
  @To_Date        VARCHAR(50) = '',
  @RequestType     VARCHAR(50) = '',
  @CRMWorkOrderNo     VARCHAR(50) = ''
 )
 
AS
BEGIN

SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

BEGIN TRY  

    
SELECT 
       cust.CustomerName
	   ,facility.FacilityName
	   ,dbo.Fn_DisplayNameofLov(b.typeofrequest) RequestType
	   ,'' fromDate
	   ,'' ToDate 
	   ,WO.CRMWorkOrderNo
	   ,b.RequestNo
	   ,Wo.CRMWorkOrderDateTime
	   ,asset.AssetNo	  
	   , Staff.StaffName StaffAssigned
	   ,WOStatus.FieldValue WOStatus
	   ,modell.Model

	   -- Assessment
	   ,AsseStaff.StaffName AssessmentStafFName
	   ,Assessment.FeedBack
	   ,Assessment.AssessmentStartDateTime
	   ,Assessment.AssessmentEndDateTime

	   -- Complete info 
	   ,WOComp.StartDateTime CompletionStatDate
	   ,WOComp.EndDateTime   CompletionEndDate
	   ,CompleteStaff.StaffName CompletedStaffName
	   ,desination.Designation  CompletedStaffDesignation
	   ,WOComp.Remarks
	   ,WOComp.HandoverDateTime
	   ,WOComp.CompletedbyRemarks
	   ,WOComp.AcceptedBy
	   ,Accepted.StaffName AcceptedBy 
	     

From CRMRequest b      
JOIN CRMRequestWorkOrderTxn WO			 ON WO.CRMRequestId  = b.CRMRequestId  
left JOIN CRMRequestCompletionInfo WOComp	 ON WOComp.CRMRequestWOId  = b.CRMRequestId  
left JOIN CRMRequestAssessment Assessment	 ON Assessment.CRMRequestWOId=WO.CRMRequestWOId  
JOIN UMUserRegistration staff			 ON staff.UserRegistrationId=WO.AssignedUserId  
Join EngAssetStandardizationModel modell on modell.ModelId=b.ModelId  
 inner JOIN MstCustomer Cust			 ON Cust.CustomerId=b.CustomerId 
 inner JOIN MstLocationFacility facility ON facility.FacilityId=b.FacilityId 
 Left JOIN EngAsset asset				 ON asset.AssetId=Wo.AssetId 
 Left JOIN FMLovMst WOStatus			 ON WOStatus.LovId=Wo.Status 
 left JOIN UMUserRegistration AsseStaff			 ON AsseStaff.UserRegistrationId=Assessment.UserId  
 left JOIN UMUserRegistration CompleteStaff ON CompleteStaff.UserRegistrationId=WOComp.CompletedBy  
 left JOIN UserDesignation desination    ON desination.UserDesignationId=CompleteStaff.UserDesignationId
 left JOIN UMUserRegistration Accepted	 ON Accepted.UserRegistrationId=WOComp.AcceptedBy  
where	b.ServiceId       = 2
AND		b.RequestStatus   <> 143 
and		WO.CRMWorkOrderNo  = @CRMWorkOrderNo 
--AND		b.FacilityId      =@Facility_Id
--AND		CAST(b.RequestDateTime AS DATE)   BETWEEN CONVERT(DATE,@From_Date, 111) AND CONVERT(DATE,@To_Date ,111)  
--AND		((b.typeofrequest = @RequestType) OR (@RequestType IS NULL) OR (@RequestType = ''))


END TRY  
BEGIN CATCH  
  
	insert into ErrorLog(Spname,ErrorMessage,createddate)  
	values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())  

END CATCH  

SET NOCOUNT OFF  

END
GO
