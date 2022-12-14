USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_Details_Rpt]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
Application Name : UE-Track                
Version    :                 
File Name   :                
Procedure Name  : uspFM_CRMRequest_Details_Rpt   
Author(s) Name(s) : Ganesan S  
Date    : 21/05/2018  
Purpose    : SP to Check Service Request  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
EXEC SPNAME Parameter      

EXEC [uspFM_CRMRequest_Details_Rpt] '@Facility_Id','@From_Date','@To_Date','@RequestType'    

EXEC uspFM_CRMRequest_Details_Rpt @Facility_Id= '2',@From_Date='2015-05-01 00:00:00.000',@To_Date='2019-09-01 00:00:00.000',@RequestType=136, @CRMWorkOrderNo = 'CRM/WO/PAN102/201807/000043'
EXEC uspFM_CRMRequest_Details_Rpt @Facility_Id= '2', @CRMWorkOrderNo = 'CRM/WO/PAN102/201807/000043'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
Modification History      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~         
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/     
CREATE PROCEDURE  [dbo].[uspFM_CRMRequest_Details_Rpt](
							@Facility_Id    VARCHAR(10),
							@From_Date      VARCHAR(50)= '',
							@To_Date		VARCHAR(50) = '',
							@RequestType    VARCHAR(50) = '',
							@CRMWorkOrderNo	VARCHAR(100) = ''
							)
AS
BEGIN

SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

BEGIN TRY  



DECLARE  @@CRMRequestDetailsReport TABLE(    
	RowId					INT IDENTITY(1,1),  
	RequestNo				NVARCHAR(100),  
	RequestDateTime			DATETIME,
	TypeOfRequest			NVARCHAR(100),
	AssigneeId				INT,
	AssigneeName			NVARCHAR(200),
	FacilityId				INT,
	FacilityName			NVARCHAR(200),
	CustomerName			NVARCHAR(200),
	ModelName				NVARCHAR(200),
	CRMWorkOrderNo			NVARCHAR(200),
	CRMWorkOrderDateTime	DATETIME,
	WorkOrderStatus			NVARCHAR(90),
	AssetNo					NVARCHAR(200),
	AssessmentStaffName		NVARCHAR(200),
	FeedBack				NVARCHAR(1000),
	AssessmentStartDateTime	DATETIME,
	AssessmentEndDateTime	DATETIME,
	CompletionStartDateTime	DATETIME,
	CompletionEndDateTime	DATETIME,
	HandoverDateTime		DATETIME,
	AcceptedBy				NVARCHAR(200),
	CompletedBy				NVARCHAR(200),
	CompletedbyRemarks		NVARCHAR(200),
	CompletedByDesignation	NVARCHAR(200),
	AcceptedById			INT,
	CompletedById			INT,
	ClosingRemarks			NVARCHAR(200)
)

 if (@From_Date = '')
 set @From_Date = NULL

 if (@To_Date = '')
 set @To_Date = NULL

 if (@RequestType = '')
 set @RequestType = NULL

 

 
INSERT INTO @@CRMRequestDetailsReport(RequestNo, RequestDateTime, TypeOfRequest, AssigneeId, FacilityId
, FacilityName, CustomerName, ModelName, CRMWorkOrderNo, CRMWorkOrderDateTime, WorkOrderStatus, AssetNo, AssessmentStaffName, FeedBack, 
AssessmentStartDateTime, AssessmentEndDateTime, CompletionStartDateTime, CompletionEndDateTime, HandoverDateTime, AcceptedBy, 
CompletedBy, CompletedbyRemarks, CompletedByDesignation, AssigneeName, AcceptedById, CompletedById, ClosingRemarks)

SELECT DISTINCT CRMR.RequestNo,  CRMR.RequestDateTime    , dbo.Fn_DisplayNameofLov(CRMR.TypeOfRequest) AS TypeOfRequest, 
CRMR.AssigneeId, CRMR.FacilityId, MLF.FacilityName, MC.CustomerName, EASM.Model, CRWO.CRMWorkOrderNo,
 CRWO.CRMWorkOrderDateTime, WoStatus.FieldValue , EA.AssetNo, URUSER.StaffName AS AssessmentStaffName, CRA.FeedBack, CRA.AssessmentStartDateTime, 
CRA.AssessmentEndDateTime, CRCI.StartDateTime as CompletionStartDateTime, CRCI.EndDateTime as CompletionEndDateTime, CRCI.HandoverDateTime,
URAB.StaffName AS AcceptedBy, URC.StaffName AS CompletedBy, CRCI.CompletedbyRemarks, UD.Designation as CompletedByDesignation, 
ASSIGNEE.StaffName AssigneeId, CRCI.CompletedBy, CRCI.AcceptedBy, CRCI.remarks
FROM CRMRequest AS CRMR WITH (NOLOCK)
INNER JOIN	mstlocationfacility AS MLF WITH (NOLOCK) ON MLF.FacilityId	=	CRMR.FacilityId
INNER JOIN	MstCustomer AS MC WITH (NOLOCK) ON MC.CustomerId	=	CRMR.CustomerId
--INNER JOIN CRMRequestDet AS CRMRD WITH (NOLOCK) ON CRMR.CRMRequestId = CRMRD.CRMRequestId
INNER JOIN	CRMRequestWorkOrderTxn CRWO WITH (NOLOCK) ON CRMR.CRMRequestId = CRWO.CRMRequestId
LEFT JOIN	CRMRequestAssessment CRA WITH (NOLOCK) ON CRWO.CRMRequestWOId = CRA.CRMRequestWOId
LEFT JOIN	CRMRequestCompletionInfo CRCI WITH (NOLOCK) ON CRWO.CRMRequestWOId = CRCI.CRMRequestWOId
LEFT JOIN	EngAsset AS EA WITH (NOLOCK) ON CRWO.AssetId = EA.AssetId
LEFT JOIN	EngAssetStandardizationModel AS EASM WITH (NOLOCK) ON EASM.Modelid	=	CRMR.Modelid
LEFT JOIN	UMUserRegistration AS URC WITH (NOLOCK) ON URC.UserRegistrationId = CRCI.CompletedBy
LEFT JOIN	UserDesignation AS UD WITH (NOLOCK) ON UD.UserDesignationId = URC.UserDesignationId
LEFT JOIN	UMUserRegistration AS URAB WITH (NOLOCK) ON URAB.UserRegistrationId = CRCI.AcceptedBy
LEFT JOIN	UMUserRegistration AS URUSER WITH (NOLOCK) ON URUSER.UserRegistrationId = CRA.UserId
LEFT JOIN	UMUserRegistration AS ASSIGNEE WITH (NOLOCK) ON ASSIGNEE.UserRegistrationId = CRWO.AssignedUserId
LEFT JOIN	FMLovMst AS WoStatus WITH (NOLOCK) ON WoStatus.Lovid = CRWO.Status

WHERE	CRMR.ServiceId		= 2
AND		CRMR.RequestStatus	<> 143  
AND		((CRWO.CRMWorkOrderNo = @CRMWorkOrderNo) OR (@CRMWorkOrderNo IS NULL) OR (@CRMWorkOrderNo = ''))
AND		((CRMR.FacilityId = @Facility_Id) OR (@Facility_Id IS NULL) OR (@Facility_Id = ''))
AND		((CRMR.typeofrequest = @RequestType) OR (@RequestType IS NULL) OR (@RequestType = ''))
AND		CAST(CRMR.RequestDateTime AS DATE) BETWEEN CAST(ISNULL(@From_Date,CRMR.RequestDateTime) as date) and CAST(ISNULL(@To_Date,CRMR.RequestDateTime) as date)



--EXEC [uspFM_CRMRequest_Details_Rpt] @Facility_Id = 2 


DECLARE @FacilityNameParam	NVARCHAR(256)
DECLARE @CustomerNameParam	NVARCHAR(256)
DECLARE @RequestTypeParam	NVARCHAR(100)

IF(ISNULL(@Facility_Id,'') <> '')
BEGIN 
	
	SELECT @FacilityNameParam = FacilityName, @CustomerNameParam = CAST(Customerid AS NVARCHAR(50)) FROM mstlocationfacility 
						WHERE FacilityId = @Facility_Id
	select @CustomerNameParam = CustomerName from MstCustomer where CustomerId =  @CustomerNameParam
END


SELECT RequestNo,  FORMAT(RequestDateTime,'dd-MMM-yyyy HH:mm') as RequestDateTime, TypeOfRequest, AssigneeId, FacilityId, FacilityName, CustomerName, ModelName, 
CRMWorkOrderNo,  FORMAT(CRMWorkOrderDateTime,'dd-MMM-yyyy HH:mm') as CRMWorkOrderDateTime, WorkOrderStatus, AssetNo, AssessmentStaffName, FeedBack
, FORMAT(AssessmentStartDateTime,'dd-MMM-yyyy HH:mm') as AssessmentStartDateTime, 
FORMAT(AssessmentEndDateTime,'dd-MMM-yyyy HH:mm') as AssessmentEndDateTime,
FORMAT( CompletionStartDateTime,'dd-MMM-yyyy HH:mm') as CompletionStartDateTime 
, FORMAT(CompletionEndDateTime ,'dd-MMM-yyyy HH:mm') as CompletionEndDateTime, FORMAT( HandoverDateTime ,'dd-MMM-yyyy HH:mm') as HandoverDateTime , AcceptedBy, 
CompletedBy, CompletedbyRemarks, CompletedByDesignation, AssigneeName, AcceptedById, CompletedById, ClosingRemarks,
	ISNULL(@From_Date,'') AS FromDateParam,
	ISNULL(@To_Date,'')	AS ToDateParam,
	--dbo.Fn_DisplayNameofLov(@RequestType) AS RequestTypeParam, 
	TypeOfRequest as RequestTypeParam,
	ISNULL(@FacilityNameParam,'') AS FacilityNameParam,
	ISNULL(@CustomerNameParam,'') AS CustomerNameParam,
	ISNULL(@CRMWorkOrderNo,'')	AS CRMWorkOrderNoParam
FROM @@CRMRequestDetailsReport




END TRY  
BEGIN CATCH  
  
	insert into ErrorLog(Spname,ErrorMessage,createddate)  
	values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())  

END CATCH  

SET NOCOUNT OFF  

END
GO
