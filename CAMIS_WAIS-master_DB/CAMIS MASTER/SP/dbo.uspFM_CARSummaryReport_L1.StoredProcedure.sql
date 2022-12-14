USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CARSummaryReport_L1]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
      
Application Name : ASIS  
Version    :  
File Name   :  
Procedure Name  : Asis_EodParameterRpt_L1  
Author(s) Name(s) : Senthilkumar E  
Date    : 27-02-2017      
Purpose    : SP to EOD parameter report      
Sub Report sp name : Asis_EodParameterAnalysisRpt_L1_Details    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
EXEC uspFM_CARSummaryReport_L1 @Level ='', @CARFromdate='2016-11-23',@CARTodate='2019-11-23',@Facilityid = 1, @IndicatorId =''  
EXEC OtherEodParameterAnalysisRpt_L1 @From_Date='',@To_Date='',@Facilityid =   
   
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
Modification History          
Modified from Asis_EodParameterRpt_L1 to Asis_EodParameterExceptionRpt_L1  By Gosalai      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~             
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/  
CREATE PROCEDURE  [dbo].[uspFM_CARSummaryReport_L1] (  
        @Level   VARCHAR(20) = NULL,  
        @CARFromdate  VARCHAR(50) = '',  
        @CARTodate  VARCHAR(50) = '',  
        @Facilityid  INT = null,  
        @IndicatorId  INT = null  
        )  
AS  
BEGIN  
    
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
BEGIN TRY  



  
DECLARE @@CAR_Report TABLE(    
ID   INT IDENTITY(1,1),    
CustomerName   NVARCHAR(200),    
FacilityName NVARCHAR(200),    
OpenCARCount  INT,    
ClosedCARCount  INT,     
RejectedCARCount INT,  
ApprovedCARCount      INT
)    
--select @From_Date_local, @to_Date_local, @service    
  
  


	INSERT INTO @@CAR_Report(CustomerName, FacilityName, OpenCARCount,ClosedCARCount,RejectedCARCount,ApprovedCARCount )

	SELECT distinct  Cust.CustomerName,	 Facility.FacilityName,
			(select count(1) from QAPCarTxn a where a.Status= 300 and  

			((CAST(a.FromDate AS DATE) >= cast(@CARFromdate as date)and    CAST(a.FromDate AS DATE) <= cast(@CARTodate as date))and cast(a.ToDate as Date) <= cast(@CARTodate as date))  

					  
					  and ((a.FacilityId = @Facilityid) OR (@Facilityid IS NULL) OR (@Facilityid = '')) 
					  
					  and  ((a.QAPIndicatorId = @IndicatorId) OR (@IndicatorId IS NULL) OR (@IndicatorId  = ''))   
					  
					  
					   ) as OpenCARCount, 		
			(select count(1) from QAPCarTxn a where a.Status= 301 and  
			
			
			((CAST(a.FromDate AS DATE) >= cast(@CARFromdate as date)and    CAST(a.FromDate AS DATE) <= cast(@CARTodate as date))and cast(a.ToDate as Date) <= cast(@CARTodate as date))  
			 
			 
		       and ((a.FacilityId = @Facilityid) OR (@Facilityid IS NULL) OR (@Facilityid = '')) 
					  
					  and  ((a.QAPIndicatorId = @IndicatorId) OR (@IndicatorId IS NULL) OR (@IndicatorId  = ''))  	 
			 
			 
			 
			  ) as ClosedCARCount, 
			(select count(1) from QAPCarTxn a where a.CARStatus= 368 and  
			((CAST(a.FromDate AS DATE) >= cast(@CARFromdate as date)and    CAST(a.FromDate AS DATE) <= cast(@CARTodate as date))and cast(a.ToDate as Date) <= cast(@CARTodate as date))   
			 
			 
			   and ((a.FacilityId = @Facilityid) OR (@Facilityid IS NULL) OR (@Facilityid = '')) 
					  
					  and  ((a.QAPIndicatorId = @IndicatorId) OR (@IndicatorId IS NULL) OR (@IndicatorId  = ''))  
			 
			 
			  ) as RejectedCARCount, 
			(select count(1) from QAPCarTxn a where a.CARStatus= 369  and 
			((CAST(a.FromDate AS DATE) >= cast(@CARFromdate as date)and    CAST(a.FromDate AS DATE) <= cast(@CARTodate as date))and cast(a.ToDate as Date) <= cast(@CARTodate as date))  
			 
			   and ((a.FacilityId = @Facilityid) OR (@Facilityid IS NULL) OR (@Facilityid = '')) 
					  
					  and  ((a.QAPIndicatorId = @IndicatorId) OR (@IndicatorId IS NULL) OR (@IndicatorId  = ''))  
			 
			 
			 
			   ) as ApprovedCARCount		
			--FollowUpCar.CARNumber			AS FollowUpCARNumber, 
			--Car.ProblemStatement,
			--Car.PriorityLovId,
			--LovPriority.FieldValue			AS	PriorityValue,
			--Car.Status,
			--LovStatus.FieldValue			AS	StatusValue,
			--Car.IssuerUserId,
			--IssuerUserReg.StaffName			AS IssuerUserName,			
			--Car.CARStatus					AS	CARStatus,
			--LovCARStatus.FieldValue			AS	CARStatusValue

	FROM	QAPCarTxn						AS	Car					WITH(NOLOCK)
			INNER JOIN MstQAPIndicator		AS	QAPInd				WITH(NOLOCK) ON Car.QAPIndicatorId			=	QAPInd.QAPIndicatorId			
			LEFT JOIN FMLovMst				AS	LovStatus			WITH(NOLOCK) ON Car.Status					=	LovStatus.LovId
		    LEFT JOIN MstCustomer			AS Cust					WITH(NOLOCK) ON Cust.CustomerId				=	Car.CustomerId
			LEFT JOIN MstLocationFacility	AS Facility				WITH(NOLOCK) ON Facility.FacilityId			=	Car.FacilityId
			LEFT JOIN FMLovMst				AS	LovCARStatus		WITH(NOLOCK) ON Car.CARStatus				=	LovCARStatus.LovId

     Where  ((Car.FacilityId = @Facilityid) OR (@Facilityid IS NULL) OR (@Facilityid = '')) 
	      AND ((Car.QAPIndicatorId = @IndicatorId) OR (@IndicatorId IS NULL) OR (@IndicatorId  = ''))   
		  --AND  (CAST(car.CARDate AS DATE) BETWEEN CAST(@CARFromdate  AS DATE) AND CAST(@CARTodate AS DATE)
		  
		  --AND ((CAST(Car.FromDate AS DATE) BETWEEN CAST(@CARFromdate  AS DATE) AND CAST(@CARTodate AS DATE)
			
		--	 and cast(Car.ToDate as Date) < cast(@CARTodate as date))
		--  ) 
		  
		  
		  and ((CAST(car.FromDate AS DATE) >= cast(@CARFromdate as date)and    CAST(car.FromDate AS DATE) <= cast(@CARTodate as date))and cast(car.ToDate as Date) <= cast(@CARTodate as date))  
		   --)



  
    
declare @indicatorName nvarchar(1024)      
if(isnull(@IndicatorId,'') <> '')    
begin    
 SELECT @indicatorName = IndicatorCode from MstQAPIndicator WITH (NOLOCK) WHERE QAPIndicatorId = @IndicatorId    
end    
    
SELECT *  
,  ISNULL(@CARFromdate, '') as FromDateParam, ISNULL(@CARTodate, '') as ToDateParam  
,  ISNULL(@indicatorName, '') as IndicatorCode   
, ISNULL(@Level, '') as LevelParam   
FROM @@CAR_Report    
    
END TRY      
BEGIN CATCH      
      
 INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)      
 VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())      
      
END CATCH      
SET NOCOUNT OFF      
      
END
GO
