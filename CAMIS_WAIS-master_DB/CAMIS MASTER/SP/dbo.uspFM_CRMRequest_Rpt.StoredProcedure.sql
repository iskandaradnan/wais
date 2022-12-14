USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_Rpt]    Script Date: 20-09-2021 16:43:00 ******/
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
CREATE PROCEDURE  [dbo].[uspFM_CRMRequest_Rpt](
  @Facility_Id      VARCHAR(10) = '',
  @From_Date       VARCHAR(50)= '',
  @To_Date        VARCHAR(50) = '',
  @RequestType     VARCHAR(50) = ''
 )
AS
BEGIN

SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

BEGIN TRY  

  if (@RequestType = 'null')
  begin
  set @RequestType = ''
  end 


--select    'Recall' as RequestType, 'CRM/PAN101/201807/000003' as CRM_Request_No , 'MobileFacilityUser' as Requestor,   
--'02-Jul-2018 15:17' as Received_Date_Time, '13-Jul-2018 19:57' as Responded_Date_Time, '11:04:04' as Response_Time,  'are' as Request_Details  

DECLARE  @@CRMReport TABLE(    
	RowId			INT IDENTITY(1,1),  
	RequestNo		NVARCHAR(100),  
	Requestor		NVARCHAR(200),  
	ReceivedDate    DATETIME,   
	--RespondedDate    DATETIME,  
	model			NVARCHAR(1024),  
	CRMWorkOrderNo	NVARCHAR(256),  
	--ResponseTime    INT,  
	Details			NVARCHAR(500),
	RequestDescription  NVARCHAR(500),
	RequestType			NVARCHAR(100)
)   

INSERT INTO @@CRMReport(RequestNo,Requestor,ReceivedDate,model,CRMWorkOrderNo, RequestDescription, Details, RequestType)

SELECT b.RequestNo, requestor.StaffName, b.RequestDateTime, modell.Model as ResponseDateTime, wo.CRMWorkOrderNo, 
b.RequestDescription, b.Remarks as Details, dbo.Fn_DisplayNameofLov(b.typeofrequest)--requestor.StaffName RequestorName, 
--b.ModelId, modell.Model,ASS.AssessmentStartDateTime as ResponseDateTime, DATEDIFF(MINUTE,b.RequestDateTime,ASS.AssessmentStartDateTime), 

From CRMRequest b      
left JOIN CRMRequestWorkOrderTxn WO      ON WO.CRMRequestId  = b.CRMRequestId  
left JOIN CRMRequestAssessment Ass   ON Ass.CRMRequestWOId=WO.CRMRequestWOId  
left JOIN UMUserRegistration staff                      ON staff.UserRegistrationId=WO.AssignedUserId  
left JOIN    UMUserRegistration requestor                 ON requestor.UserRegistrationId=b.Requester  
left Join EngAssetStandardizationModel modell on modell.ModelId=b.ModelId  
where	b.ServiceId       = 2
AND		b.RequestStatus       <> 143  
AND		b.FacilityId      =@Facility_Id
AND		CAST(b.RequestDateTime AS DATE)   BETWEEN CONVERT(DATE,@From_Date, 111) AND CONVERT(DATE,@To_Date ,111)  
AND		((b.typeofrequest = @RequestType) OR (@RequestType IS NULL) OR (@RequestType = ''))

DECLARE @FacilityNameParam	NVARCHAR(256)
DECLARE @CustomerNameParam	NVARCHAR(256)
DECLARE @RequestTypeParam	NVARCHAR(100)

IF(ISNULL(@Facility_Id,'') <> '')
BEGIN 
	
	SELECT @FacilityNameParam = FacilityName, @CustomerNameParam = CAST(Customerid AS NVARCHAR(50)) FROM mstlocationfacility 
						WHERE FacilityId = @Facility_Id
	SELECT @CustomerNameParam = CustomerName FROM MstCustomer WHERE CustomerId =  @CustomerNameParam
END

SELECT  RequestType  AS 'RequestType', 
  RequestNo          AS 'CRM_Request_No',  
  Requestor         AS 'Requestor',  
  ISNULL(FORMAT(ReceivedDate,'dd-MMM-yyyy HH:mm'),'')   AS 'Received_Date_Time',  
  model as Responded_Date_Time,  
  CRMWorkOrderNo as Response_Time,  
  Details           AS 'Request_Details',
  RequestDescription,
  ISNULL(@From_Date,'') AS FromDateParam,
  ISNULL(@To_Date,'')	AS ToDateParam,
  dbo.Fn_DisplayNameofLov(@RequestType) AS RequestTypeParam, 
  ISNULL(@FacilityNameParam,'') AS FacilityNameParam,
  ISNULL(@CustomerNameParam,'') AS CustomerNameParam
From @@CRMReport

--Drop table #RESULT  

END TRY  
BEGIN CATCH  
  
	insert into ErrorLog(Spname,ErrorMessage,createddate)  
	values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())  

END CATCH  

SET NOCOUNT OFF  

END
GO
