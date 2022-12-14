USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CARSummaryReport_L2]    Script Date: 20-09-2021 16:56:52 ******/
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
EXEC uspFM_CARSummaryReport_L2 @Level ='', @CARFromdate='2016-11-23',@CARTodate='2019-11-23',@Facilityid = 1, @IndicatorId ='' ,@StatusValue=1   
EXEC OtherEodParameterAnalysisRpt_L1 @From_Date='',@To_Date='',@Facilityid =     
     
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History            
Modified from Asis_EodParameterRpt_L1 to Asis_EodParameterExceptionRpt_L1  By Gosalai        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~               
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/    
CREATE PROCEDURE  [dbo].[uspFM_CARSummaryReport_L2] (    
      
        @CARFromdate  VARCHAR(50) = '',    
        @CARTodate  VARCHAR(50) = '',    
        @Facilityid   VARCHAR(50) = '',      
        @IndicatorId   VARCHAR(50) = '',    
        @StatusValue    varchar(30) = null   
        )    
AS    
BEGIN    
      
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
BEGIN TRY    
  
  
   Declare @Status INT , @CarStatus int   
    
   if(  @StatusValue='1' )  
   begin      
   set @Status= 300  
   Set @CarStatus= ''  
   end   
   else  if( @StatusValue='2') -------- approved   
   begin       
   set @Status= null  
    Set @CarStatus= 369  
   end   
   else  if(@StatusValue='3' ) -------- Rejected   
   begin  
       
   set @Status= null   
    Set @CarStatus= 368  
   end   
  
  
  
  
 SELECT   Car.CARNumber, car.FromDate, car.ToDate, format(cast(car.CARDate as Date),'dd-MMM-yyyy') as CARDate,  
         (case when Car.IsAutoCar = 1 then 'Auto Generation CAR' else 'Manual CAR' end ) Description,   
   --FollowUpCar.CARNumber   AS FollowUpCARNumber,   
   --Car.ProblemStatement,  
   --Car.PriorityLovId,  
   --LovPriority.FieldValue   AS PriorityValue,  
   --Car.Status,  
   LovStatus.FieldValue   AS StatusValue,  
   --Car.IssuerUserId,  
   --IssuerUserReg.StaffName   AS IssuerUserName,     
   --Car.CARStatus     AS CARStatus,  
   LovCARStatus.FieldValue   AS CARStatusValue  
  
 FROM QAPCarTxn      AS Car     WITH(NOLOCK)  
   INNER JOIN MstQAPIndicator  AS QAPInd    WITH(NOLOCK) ON Car.QAPIndicatorId   = QAPInd.QAPIndicatorId     
   LEFT JOIN FMLovMst    AS LovStatus   WITH(NOLOCK) ON Car.Status     = LovStatus.LovId        
   LEFT JOIN FMLovMst    AS LovCARStatus  WITH(NOLOCK) ON Car.CARStatus    = LovCARStatus.LovId  
  
     Where  ((Car.FacilityId = @Facilityid) OR (@Facilityid IS NULL) OR (@Facilityid = ''))   
         AND ((Car.QAPIndicatorId = @IndicatorId) OR (@IndicatorId IS NULL) OR (@IndicatorId  = ''))        
      and ((CAST(car.FromDate AS DATE) >= cast(@CARFromdate as date)and    CAST(car.FromDate AS DATE) <= cast(@CARTodate as date))and cast(car.ToDate as Date) <= cast(@CARTodate as date))    
      and ((Car.Status = @Status) OR (@Status IS NULL) OR (@Status = ''))   
      and  ((Car.CARStatus = @CarStatus) OR (@CarStatus IS NULL) OR (@CarStatus = ''))   
      
  
  
  
    
      
  
      
END TRY        
BEGIN CATCH        
        
 INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)        
 VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())        
        
END CATCH        
SET NOCOUNT OFF        
        
END
GO
