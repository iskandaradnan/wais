USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_Rpt_New]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              

Application Name	: UE-Track              

Version				:               

File Name			:              

Procedure Name		: uspFM_CRMRequest_Rpt 

Author(s) Name(s)	: Ganesan S

Date				: 21/05/2018

Purpose				: SP to Check Service Request

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

EXEC SPNAME Parameter    

EXEC [uspFM_CRMRequest_Rpt] '@Facility_Id','@From_Date','@To_Date','@RequestType'  

EXEC uspFM_CRMRequest_Rpt @Facility_Id=1,@From_Date='2018-05-01 00:00:00.000',@To_Date='2018-09-01 00:00:00.000',@RequestType=136



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     

Modification History    

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/   

 			      

CREATE PROCEDURE  [dbo].[uspFM_CRMRequest_Rpt_New]( 
		@Facility_Id						VARCHAR(10),   
		--@Request_Id							INT,                            
		@From_Date							VARCHAR(10), 
		@To_Date								VARCHAR(10),  
		--@Year								VARCHAR(10),  
		@RequestType						VARCHAR(10)
 )
AS
BEGIN

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRY

CREATE TABLE #RESULT(  
RowId						INT IDENTITY(1,1),
RequestNo					NVARCHAR(100),
Requestor					NVARCHAR(200),
ReceivedDate 				DATETIME, 
RespondedDate				DATETIME,
ResponseTime				INT,
Details						NVARCHAR(500)
) 
--IF @Request_Id = 1
--begin

INSERT	INTO #RESULT(RequestNo,Requestor,ReceivedDate,RespondedDate,ResponseTime,Details) 

SELECT	b.RequestNo,
		Staff.StaffName,
		b.RequestDateTime,
		ASS.AssessmentStartDateTime as ResponseDateTime,
		DATEDIFF(MINUTE,b.RequestDateTime,ASS.AssessmentStartDateTime),
		b.RequestDescription as Details
From	CRMRequest b				
JOIN	CRMRequestWorkOrderTxn WO		    ON WO.CRMRequestId		= b.CRMRequestId
JOIN	CRMRequestAssessment Ass			ON Ass.CRMRequestWOId=WO.CRMRequestWOId
JOIN    UMUserRegistration staff                      ON staff.UserRegistrationId=WO.AssignedUserId
where	b.FacilityId						=@Facility_Id
AND		b.ServiceId							= 2
AND		CAST(b.RequestDateTime AS DATE)			BETWEEN @From_Date AND @To_Date
AND		b.RequestStatus							<> 143
--END

Select 	dbo.Fn_DisplayNameofLov(@RequestType)  AS 'RequestType',
		RequestNo										AS 'CRM_Request_No',
		Requestor									AS 'Requestor',
		ISNULL(FORMAT(ReceivedDate,'dd-MMM-yyyy HH:mm'),'')			AS 'Received_Date_Time',
		ISNULL(FORMAT(RespondedDate,'dd-MMM-yyyy HH:mm'),'')			AS 'Responded_Date_Time',
		CASE WHEN (ResponseTime/1440) = 0
		          THEN CASE WHEN (ResponseTime)/60 = 0
				                 THEN '0:00:'+(CASE WHEN LEN(ResponseTime) = 1 THEN STUFF(CAST(ResponseTime AS VARCHAR(10)),1,0,'0') ELSE CAST(ResponseTime AS VARCHAR(10)) END )
							ELSE '0:'+CAST((CASE WHEN LEN(ResponseTime/60) = 1 THEN STUFF(CAST(ResponseTime/60 AS VARCHAR(10)),1,0,'0') ELSE CAST(ResponseTime/60 AS VARCHAR(10)) END ) +':'+ --CAST(@ResponseTime%60 AS VARCHAR(10)) AS VARCHAR(10)
							       (CASE WHEN LEN(ResponseTime%60) = 1 THEN STUFF(CAST(ResponseTime%60 AS VARCHAR(10)),1,0,'0') ELSE CAST(ResponseTime%60 AS VARCHAR(10)) END ) AS VARCHAR(10)
							)
						END 
				  ELSE CAST(CAST(ResponseTime/1440 AS VARCHAR(10)) +':'+ --CAST((@ResponseTime%1440)/60 AS VARCHAR(10)) +':'+ CAST((@ResponseTime%1440)%60 AS VARCHAR(10)) AS VARCHAR(10))
				            CAST((CASE WHEN LEN((ResponseTime%1440)/60) = 1 THEN STUFF(CAST((ResponseTime%1440)/60 AS VARCHAR(10)),1,0,'0') ELSE CAST((ResponseTime%1440)/60 AS VARCHAR(10)) END ) +':'+ --CAST(@ResponseTime%60 AS VARCHAR(10)) AS VARCHAR(10)
							       (CASE WHEN (ResponseTime%1440) < 60 THEN right('00'+cast(ResponseTime%1440 as VARCHAR(10)),2)  ELSE CAST((ResponseTime%1440)/60 AS VARCHAR(10)) END ) AS VARCHAR(10)
							)AS VARCHAR(10) )
		END AS 'Response_Time',
		Details											AS 'Request_Details'	
From	#RESULT      


Drop table #RESULT

END TRY

BEGIN CATCH



insert into ErrorLog(Spname,ErrorMessage,createddate)

		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())



END CATCH

SET NOCOUNT OFF

END
GO
