USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CARSummaryReport_L3]    Script Date: 20-09-2021 17:05:51 ******/
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
EXEC uspFM_CARSummaryReport_L2 @Level ='', @CARFromdate='2016-11-23',@CARTodate='2019-11-23',@Facilityid = 1, @IndicatorId ='' ,@CarStatus=1   
EXEC OtherEodParameterAnalysisRpt_L1 @From_Date='',@To_Date='',@Facilityid =     
     
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History            
Modified from Asis_EodParameterRpt_L1 to Asis_EodParameterExceptionRpt_L1  By Gosalai        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~               
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/    
CREATE PROCEDURE  [dbo].[uspFM_CARSummaryReport_L3] (    
          
        @CARFromdate  VARCHAR(50) = '',    
        @CARTodate  VARCHAR(50) = '',    
        @Facilityid VARCHAR(50) = '',     
        @IndicatorId VARCHAR(50) = '',   
         @CARNumber    varchar(300) = null   
        )    
AS    
BEGIN    
      
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
BEGIN TRY    
  
  
     
  
  
  
  SELECT   
      
     Car.CARNumber,  
     Cust.CustomerName,  
     Facility.FacilityName,  
     CASE WHEN Car.IsAutoCar=1 THEN 'Auto Generation CAR'  
     ELSE 'Manual CAR'  
   END  AS CARGeneration,  
   QAPInd.IndicatorCode,  
   format(cast(Car.CARDate as Date),'dd-MMM-yyyy') as CARDate,  
   format(cast(Car.FromDate as Date),'dd-MMM-yyyy') as FromDate,     
   format(cast(Car.ToDate as Date),'dd-MMM-yyyy') as ToDate,  
   FollowUpCar.CARNumber   AS FollowUpCARNumber,   
   AssignedUser.StaffName   AS AssignedUserName,  
   LovPriority.FieldValue   AS PriorityValue,  
   LovStatus.FieldValue   AS StatusValue,  
  
   IssuerUserReg.StaffName   AS IssuerUserName,  
   format(cast(Car.CARTargetDate as Date),'dd-MMM-yyyy') as CARTargetDate,  
   Car.ProblemStatement,  
   CarHistory.RootCause,  
   CarHistory.Solution,  
  
   format(cast(Cardet.TargetDate as Date),'dd-MMM-yyyy') as TargetDate,  
   format(cast(Cardet.CompletedDate as Date),'dd-MMM-yyyy') as ActualCompletionDate,  
   ResponsibleUser.StaffName  AS ResponsiblePerson,  
   Responsibility.FieldValue   AS Responsibility,
   format(cast(Car.VerifiedDate as Date),'dd-MMM-yyyy') as VerifiedDate,     
   VerifiedByUser.StaffName  AS VerifiedByName,    
   LovCARStatus.FieldValue   AS CARStatusValue,       
   CarHistory.Remarks  
 FROM QAPCarTxn      AS Car     WITH(NOLOCK)  
   INNER JOIN MstQAPIndicator  AS QAPInd    WITH(NOLOCK) ON Car.QAPIndicatorId   = QAPInd.QAPIndicatorId  
   LEFT JOIN EngAsset    AS Asset    WITH(NOLOCK) ON Car.AssetId     = Asset.AssetId  
   LEFT JOIN QAPCarTxn    AS FollowUpCar   WITH(NOLOCK) ON Car.FollowupCARId   = FollowUpCar.CarId  
   LEFT JOIN FMLovMst    AS LovPriority   WITH(NOLOCK) ON Car.PriorityLovId   = LovPriority.LovId  
   LEFT JOIN FMLovMst    AS LovStatus   WITH(NOLOCK) ON Car.Status     = LovStatus.LovId  
   LEFT JOIN UMUserRegistration AS IssuerUserReg  WITH(NOLOCK) ON Car.IssuerUserId   = IssuerUserReg.UserRegistrationId  
   LEFT JOIN UMUserRegistration AS AssignedUser  WITH(NOLOCK) ON Car.AssignedUserId   = AssignedUser.UserRegistrationId  
   LEFT JOIN UMUserRegistration AS VerifiedByUser  WITH(NOLOCK) ON Car.VerifiedBy    = VerifiedByUser.UserRegistrationId  
   LEFT JOIN EngAssetTypeCode  AS TypeCode   WITH(NOLOCK) ON Car.AssetTypeCodeId   = TypeCode.AssetTypeCodeId  
   --LEFT JOIN MstQAPQualityCause AS FailureSymCode  WITH(NOLOCK) ON Car.FailureSymptomId  = FailureSymCode.QualityCauseId  
   LEFT JOIN FMLovMst    AS LovCARStatus  WITH(NOLOCK) ON Car.CARStatus    = LovCARStatus.LovId  
   LEFT JOIN QAPCarHistory   AS CarHistory   WITH(NOLOCK) ON Car.CarId     = CarHistory.CarId AND Car.CARStatus = CarHistory.Status AND Car.CARStatus=369  
    LEFT JOIN MstCustomer   AS Cust     WITH(NOLOCK) ON Cust.CustomerId    = Car.CustomerId  
   LEFT JOIN MstLocationFacility AS Facility    WITH(NOLOCK) ON Facility.FacilityId   = Car.FacilityId  
   LEFT JOIN QAPCarTxnDet   AS Cardet    WITH(NOLOCK) ON Cardet.CarId    = Car.CarId  
   LEFT JOIN UMUserRegistration AS ResponsibleUser  WITH(NOLOCK) ON CarDet.ResponsiblePersonUserId    = ResponsibleUser.UserRegistrationId
   LEFT JOIN FMLovMst    AS Responsibility  WITH(NOLOCK) ON Cardet.ResponsibilityId    = Responsibility.LovId    
 WHERE Car.CARNumber = @CARNumber    
  
  
  
    
      
  
      
END TRY        
BEGIN CATCH        
        
 INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)        
 VALUES(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())        
        
END CATCH        
SET NOCOUNT OFF        
        
END
GO
