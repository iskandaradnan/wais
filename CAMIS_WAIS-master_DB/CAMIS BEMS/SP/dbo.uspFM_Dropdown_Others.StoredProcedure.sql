USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Dropdown_Others]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : uspFM_Dropdown_Others  
Description   : Dropdown Values apart form lov table  
Authors    : Dhilip V  
Date    : 02-April-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC uspFM_Dropdown_Others  @pLovKey=null, @pTableName='EngEODParameterMapping'  
  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  

DROP PROCEDURE  [dbo].[uspFM_Dropdown_Others]                             
  GO

CREATE PROCEDURE  [dbo].[uspFM_Dropdown_Others]                             
  @pLovKey   nvarchar(200)=NULL,  
  @pTableName  nvarchar(200)=NULL  
  
AS                                                

BEGIN TRY  
  
-- Paramter Validation   
  
 SET NOCOUNT ON;   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
-- Declaration  
  
  
-- Default Values  
  
  
-- Execution  
 IF(@pTableName='MstCustomer')   
  BEGIN  
  --1  
     
   SELECT CustomerId     AS LovId,  
     CustomerName    AS FieldValue, 0 AS IsDefault  
        
   FROM MstCustomer WITH(NOLOCK)  
   WHERE Active = 1  
  END  
  ELSE IF(@pTableName='MstLocationFacilityLovs')   
  BEGIN  
  --1  
   SELECT CustomerId     ,  
     CustomerName,   
     CustomerCode  
   FROM MstCustomer WITH(NOLOCK)  
   WHERE Active = 1   
   ORDER BY CustomerName  
  END  
 ELSE IF(@pTableName='MstLocationFacility')   
  BEGIN  
  --1  
   SELECT FacilityId     AS LovId,  
     FacilityName    AS FieldValue, 0 AS IsDefault   
   FROM MstLocationFacility WITH(NOLOCK)  
   WHERE Active = 1  
  END  
 ELSE IF(@pTableName='MstStaff')   
  BEGIN  
  --1  
   SELECT UserRoleId    AS LovId,  
     UserRole    AS FieldValue, 0 AS IsDefault   
   FROM UserRole WITH(NOLOCK)  
   WHERE Active = 1  
  --2  
   SELECT UserCompetencyId  AS LovId,  
     Competency    AS FieldValue, 0 AS IsDefault   
   FROM UserCompetency WITH(NOLOCK)  
   WHERE Active = 1   
  --3  
   SELECT UserDesignationId  AS LovId,  
     Designation    AS FieldValue, 0 AS IsDefault   
   FROM UserDesignation WITH(NOLOCK)  
   WHERE Active = 1  
  --4  
   SELECT UserGradeId   AS LovId,  
     UserGrade   AS FieldValue, 0 AS IsDefault   
   FROM UserGrade WITH(NOLOCK)  
   WHERE Active = 1  
  --5  
   SELECT UserSpecialityId  AS LovId,  
     Speciality    AS FieldValue, 0 AS IsDefault   
   FROM UserSpeciality WITH(NOLOCK)  
   WHERE Active = 1    
  --6  
   SELECT UserDepartmentId  AS LovId,  
     Department    AS FieldValue, 0 AS IsDefault   
   FROM UserDepartment WITH(NOLOCK)  
   WHERE Active = 1                
  END   
 ELSE IF(@pTableName='EngAssetSupplierWarranty')   
  BEGIN  
  --1  
   SELECT LovId    AS LovId,  
     FieldValue    AS FieldValue, 0 AS IsDefault   
   FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1   
     AND LovKey='WarrantyCategoryValue' AND FieldValue='Main Supplier'  
   ORDER BY SortNo ASC  
  --2  
   SELECT LovId  AS LovId,  
     FieldValue    AS FieldValue, 0 AS IsDefault   
   FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1   
     AND LovKey='WarrantyCategoryValue' AND FieldValue='Local Authorised Representative'  
     ORDER BY SortNo ASC  
  --3  
   SELECT LovId   AS LovId,  
     FieldValue    AS FieldValue, 0 AS IsDefault   
   FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1  
     AND LovKey='WarrantyCategoryValue' AND FieldValue='3rd Party Service Provider'  
     ORDER BY SortNo ASC  
  END  
  
 ELSE IF(@pTableName='FMDocument')   
  BEGIN  
  --1  
   SELECT FileTypeId    AS LovId,  
     FileType    AS FieldValue, 0 AS IsDefault   
   FROM FMDocumentFileType WITH(NOLOCK)  
   WHERE Active = 1       
  END  
  
 ELSE IF(@pTableName='EngAsset')   
  BEGIN  
  --1  
   SELECT WorkGroupId    AS LovId,  
     WorkGroupCode   AS FieldValue, 0 AS IsDefault   
   FROM EngAssetWorkGroup WITH(NOLOCK)  
   WHERE Active = 1   
  --2  
   SELECT AssetClassificationId   AS LovId,  
     AssetClassificationDescription   AS FieldValue, 0 AS IsDefault   
   FROM EngAssetClassification WITH(NOLOCK)  
   WHERE Active = 1   
  --3  
   SELECT ServiceId   AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END   AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1   
  --4  
   SELECT FacilityId   AS LovId,  
     FacilityName  AS  FieldValue, 0 AS IsDefault   
   FROM MstLocationFacility WITH(NOLOCK)  
   WHERE Active = 1   
     AND CustomerId = @pLovKey  
  END  
 ELSE IF(@pTableName='Service')  
  BEGIN  
   SELECT ServiceId   AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END   AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1   
  END  
 --ELSE IF(@pTableName='MstContractorandVendorSpecialization')  
 -- BEGIN  
 --  SELECT SpecializationId   AS LovId,  
 --    Specialization    AS FieldValue, 0 AS IsDefault   
 --  FROM MstContractorandVendorSpecialization WITH(NOLOCK)  
 --  WHERE Active = 1   
 -- END   
  
 ELSE IF(@pTableName='EngPlannerTxn')   
  BEGIN  
  --1  
   SELECT WorkGroupId    AS LovId,  
     WorkGroupCode   AS FieldValue, 0 AS IsDefault   
   FROM EngAssetWorkGroup WITH(NOLOCK)  
   WHERE Active = 1   
  --2  
   SELECT AssetClassificationId   AS LovId,  
     AssetClassificationDescription AS FieldValue, 0 AS IsDefault   
   FROM EngAssetClassification WITH(NOLOCK)  
   WHERE Active = 1   
  --3  
   SELECT MonthId   AS LovId,  
     Month   AS FieldValue, 0 AS IsDefault   
   FROM FMTimeMonth WITH(NOLOCK)  
   WHERE Active = 1  
  --4  
   SELECT WeekDayId   AS LovId,  
     WeekDay   AS FieldValue, 0 AS IsDefault   
   FROM FMTimeWeekDay WITH(NOLOCK)  
   WHERE Active = 1  
  --5  
   SELECT YearId   AS LovId,  
     Year   AS FieldValue, 0 AS IsDefault   
   FROM FMTimeYear WITH(NOLOCK)  
   WHERE Active = 1     
  
   --SELECT ServiceId   AS LovId,  
   --  CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
   --   ELSE 'Others'   
   --  END   AS FieldValue, 0 AS IsDefault   
   --FROM MstService WITH(NOLOCK)  
   --WHERE Active = 1   
  END  
  
 ELSE IF(@pTableName='MstDedPenalty')  
  BEGIN  
   SELECT CriteriaId   AS LovId,  
     Criteria   AS FieldValue, 0 AS IsDefault   
   FROM MstDedCriteria WITH(NOLOCK)  
   WHERE Active = 1   
  
   SELECT ServiceId   AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END   AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1   
  END   
  
 ELSE IF(@pTableName='EngFacilitiesWorkshopTxn')  
  BEGIN  
  --1  
   SELECT ServiceId   AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END   AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1   
  --2  
   SELECT YearId   AS LovId,  
     Year   AS FieldValue, 0 AS IsDefault   
   FROM FMTimeYear WITH(NOLOCK)  
   WHERE Active = 1   
  --3  
   SELECT LovId   AS LovId,  
     FieldValue    AS FieldValue, 0 AS IsDefault   
   FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1  
     AND LovKey='TypeofFacilityValue'  
   ORDER BY SortNo ASC  
  --4  
   SELECT LovId   AS LovId,  
     FieldValue    AS FieldValue, 0 AS IsDefault   
   FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1  
     AND LovKey='FWCategoryValue'  
   ORDER BY SortNo ASC  
  --5  
   SELECT LovId   AS LovId,  
     FieldValue    AS FieldValue, 0 AS IsDefault   
   FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1  
     AND LovKey='FWLocationValue'  
   ORDER BY SortNo ASC  
  END   
  
 ELSE IF(@pTableName='EngAssetTypeCode')  
  BEGIN  
  --1  
   SELECT ServiceId   AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END   AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1  
  --2  
   SELECT TypeCodeParameterId   AS LovId,  
     TypeCodeParameter   AS FieldValue, 0 AS IsDefault   
   FROM EngAssetTypeCodeParameter WITH(NOLOCK)  
   WHERE Active = 1   
  END   
  
 ELSE IF(@pTableName='MstDedSubParameter')  
  BEGIN  
  --1  
   SELECT ServiceId   AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END   AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1  
  --2  
   SELECT IndicatorDetId  AS LovId,  
     IndicatorNo   AS FieldValue, 0 AS IsDefault,  
     IndicatorDesc  
   FROM MstDedIndicatorDet WITH(NOLOCK)  
   WHERE Active = 1   
  END   
  
 ELSE IF(@pTableName='FinMonthlyFeeTxn')  
  BEGIN  
  
   SELECT MonthId  AS LovId,  
     Month  AS FieldValue, 0 AS IsDefault  
   FROM FMTimeMonth WITH(NOLOCK)  
   WHERE Active = 1  
     
  END   
  
 ELSE IF(@pTableName='EngLicenseandCertificateTxn')  
  BEGIN  
  
   SELECT ServiceId     AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END       AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1  
  
   SELECT IssuingBodyId   AS LovId,  
     IssuingBodyName   AS FieldValue, 0 AS IsDefault  
   FROM MstIssuingBody WITH(NOLOCK)  
   WHERE Active = 1   
  
   SELECT UserDesignationId  AS LovId,  
     Designation    AS FieldValue, 0 AS IsDefault  
   FROM UserDesignation WITH(NOLOCK)  
   WHERE Active = 1         
  END   
  
 ELSE IF(@pTableName='EngEODCategorySystemDet')  
  BEGIN  
  
   SELECT ServiceId     AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END       AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1  
  
   SELECT CategorySystemId   AS LovId,  
     CategorySystemName   AS FieldValue, 0 AS IsDefault  
   FROM EngEODCategorySystem WITH(NOLOCK)  
   WHERE Active = 1   
        
  END   
  
 ELSE IF(@pTableName='EngSpareParts')  
  BEGIN  
  
   SELECT ServiceId     AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END       AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1  
  
   SELECT UOMId    AS LovId,  
     UnitOfMeasurement AS FieldValue, 0 AS IsDefault  
   FROM FMUOM WITH(NOLOCK)  
   WHERE Active = 1 and UOMId in (1,2,3)  
  
   SELECT SparePartsCategoryId  AS LovId,  
     Category     AS FieldValue, 0 AS IsDefault  
   FROM EngSparePartsCategory WITH(NOLOCK)  
   WHERE Active = 1   
        
  END   
  
 ELSE IF(@pTableName='Modules')  
  BEGIN  
  
   SELECT ModuleId    AS LovId,  
     ModuleName    AS FieldValue, 0 AS IsDefault  
   FROM FMModules WITH(NOLOCK)  
   WHERE Active = 1   
        
  END   
  
    ELSE IF(@pTableName='MaintenanceYear')                
  BEGIN                
                
   SELECT [Year]    AS LovId,                
     [Year]    AS FieldValue, 0 AS IsDefault                
   FROM UetrackMasterdbPreProd..GmMaintenanceYearDetailsMst WITH(NOLOCK)                
   WHERE IsDeleted = 0                 
                      
  END  

 ELSE IF(@pTableName='EngEODParameterMapping')  
  BEGIN  
  
   SELECT ServiceId     AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END       AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1  
  
   SELECT AssetClassificationId   AS LovId,  
     AssetClassificationDescription   AS FieldValue, 0 AS IsDefault  
   FROM EngAssetClassification WITH(NOLOCK)  
   WHERE Active = 1   
  
   SELECT UOMId      AS LovId,  
     UnitOfMeasurement   AS FieldValue, 0 AS IsDefault  
   FROM FMUOM WITH(NOLOCK)   
   WHERE Active = 1   
     --AND UOMId NOT IN (2,3)   
        ORDER BY UnitOfMeasurement  
  
   SELECT LovId,  
     FieldValue, 0 AS IsDefault  
   FROM FMLovMst WITH(NOLOCK)   
   WHERE LovKey = 'StatusValue'  
   ORDER BY SortNo ASC  
           
  END  
  
 ELSE IF(@pTableName='EngEODCaptureTxn')  
  BEGIN  
  
   SELECT ServiceId     AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END       AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1  
  
   SELECT AssetClassificationId   AS LovId,  
     AssetClassificationCode   AS FieldValue, 0 AS IsDefault  
   FROM EngAssetClassification WITH(NOLOCK)  
   WHERE Active = 1   
        
  END   
  
 ELSE IF(@pTableName='KPIGeneration')  
  BEGIN  
   SELECT MonthId   AS LovId,  
     Month   AS FieldValue, 0 AS IsDefault   
   FROM FMTimeMonth WITH(NOLOCK)  
   WHERE Active = 1   
   ORDER BY MonthId  
  
   SELECT ServiceId AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END   AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1   
  
   SELECT IndicatorDetId   AS LovId,  
     IndicatorNo   AS FieldValue, 0 AS IsDefault   
   FROM MstDedIndicatorDet WITH(NOLOCK)  
   WHERE Active = 1   
   ORDER BY IndicatorDetId  
  END     
  
  
 ELSE IF(@pTableName='BERApplicationTxn')  
  BEGIN  
  
  SELECT * INTO #Temp from dbo.SplitString(@pLovKey,',')  
  
   SELECT FacilityCode   AS FacilityCode,  
     FacilityName   AS FacilityName   
   FROM MstLocationFacility WITH(NOLOCK)  
   WHERE Active = 1  
     AND FacilityId = (SELECT ITEM FROM #Temp WHERE id=1)  
  
   SELECT TOP 1 UM.UserRegistrationId  AS StaffMasterId,  
     UM.StaffName     AS StaffName,  
     Designation.Designation   AS Designation   
   FROM UMUserRegistration   AS UM   WITH(NOLOCK)  
     left JOIN UserDesignation AS Designation WITH(NOLOCK) ON UM.UserDesignationId  = Designation.UserDesignationId  
   WHERE UM.Status = 1  
     AND UM.UserRegistrationId = (SELECT ITEM FROM #Temp WHERE id=2)  
     ORDER BY UM.StaffName ASC  
  
  END    
  
 ELSE IF(@pTableName='FMTimeMonth')  
  BEGIN  
   SELECT MonthId   AS LovId,  
     Month   AS FieldValue, 0 AS IsDefault   
   FROM FMTimeMonth WITH(NOLOCK)  
   WHERE Active = 1   
   ORDER BY MonthId  
  
  END   
  
 ELSE IF(@pTableName='EngMaintenanceWorkOrderTxn')  
  BEGIN  
   SELECT QualityCauseId    AS LovId,  
        CauseCode  AS FieldValue, 0 AS IsDefault,  
       Description    AS CauseCodeDescription  
   FROM MstQAPQualityCause WITH(NOLOCK)  
   WHERE Active = 1   
   ORDER BY CauseCode  
  
   SELECT QualityCauseDetId   AS LovId,  
     QcCode      AS FieldValue, 0 AS IsDefault,  
       Details    AS QcCodeDescription  
   FROM MstQAPQualityCauseDet WITH(NOLOCK)  
   WHERE Active = 1   
   ORDER BY QcCode  
    
  END   
  
 ELSE IF(@pTableName='PorteringTransaction')  
  BEGIN  
   SELECT FacilityId    AS LovId,  
     FacilityName   AS FieldValue, 0 AS IsDefault  
   FROM MstLocationFacility WITH(NOLOCK)  
   WHERE Active = 1   
     AND CustomerId = @pLovKey  
  
  END   
      
  
 ELSE IF(@pTableName='VMSummaryFee')  
  BEGIN  
   SELECT AssetClassificationId   AS LovId,  
     AssetClassificationDescription   AS FieldValue, 0 AS IsDefault  
   FROM EngAssetClassification WITH(NOLOCK)  
   WHERE Active = 1   
  
  END   
  
 ELSE IF(@pTableName='UserReg')  
  BEGIN  
   SELECT LovId,   
   FieldValue,   
   IsDefault   
   FROM FmLovMst  
   WHERE LovKey = 'CommonGender'   
   ORDER BY SortNo  
  
  
   SELECT UserTypeId LovId,   
     Name FieldValue,   
     0 AS IsDefault   
   FROM UMUserType   
   ORDER BY Name  
  
   SELECT LovId,   
     FieldValue,   
     IsDefault   
   FROM FmLovMst   
   WHERE LovKey = 'StatusValue'   
   ORDER BY SortNo  
  
   SELECT CustomerId LovId,   
     CustomerName FieldValue,   
     0 AS IsDefault   
   FROM MstCustomer  
   WHERE (ActiveToDate IS NULL OR cast(ActiveToDate as date) >= cast(GETDATE() as date))  
   ORDER BY CustomerName  
  
  --2  
   --SELECT UserCompetencyId  AS LovId,  
   --  Competency    AS FieldValue, 0 AS IsDefault   
   --FROM UserCompetency WITH(NOLOCK)  
   --WHERE Active = 1   
  --3  
   select AssetClassificationId AS LovId,   
   AssetClassificationDescription AS FieldValue,   
   0 AS IsDefault    
   from EngAssetClassification  
   WHERE Active = 1   
   order by AssetClassificationDescription  
  
   SELECT UserDesignationId  AS LovId,  
     Designation    AS FieldValue,  
     0 AS IsDefault   
   FROM UserDesignation WITH(NOLOCK)  
   WHERE Active = 1  
   ORDER BY Designation  
  --4  
   SELECT UserGradeId   AS LovId,  
     UserGrade   AS FieldValue,   
     0 AS IsDefault   
   FROM UserGrade WITH(NOLOCK)  
   WHERE Active = 1  
   ORDER BY UserGrade  
  --5  
   SELECT UserSpecialityId  AS LovId,  
     Speciality    AS FieldValue,   
     0 AS IsDefault   
   FROM UserSpeciality WITH(NOLOCK)  
   WHERE Active = 1    
   ORDER  BY Speciality  
  --6  
   SELECT UserDepartmentId  AS LovId,  
     Department    AS FieldValue,   
     0 AS IsDefault   
   FROM UserDepartment WITH(NOLOCK)  
   WHERE Active = 1   
   ORDER BY Department   
  
  --7  
   SELECT LovId,   
     FieldValue,   
     IsDefault   
   FROM FmLovMst   
   WHERE LovKey = 'CommonAccessLevel'   
   ORDER BY SortNo   
  --8  
   SELECT LovId,   
     FieldValue,   
     IsDefault   
   FROM FmLovMst   
   WHERE LovKey = 'NationalityValue'   
   ORDER BY SortNo  
  END     
  
 ELSE IF(@pTableName='EngTrainingScheduleTxn')  
  BEGIN  
   SELECT ServiceId   AS LovId,  
     CASE WHEN ServiceKey='BEMS' THEN 'BEMS'  
      ELSE 'Others'   
     END   AS FieldValue, 0 AS IsDefault   
   FROM MstService WITH(NOLOCK)  
   WHERE Active = 1   
  
  
   SELECT FacilityId   AS LovId,  
     FacilityCode  AS FieldValue, 0 AS IsDefault ,  
     FacilityName  
   FROM MstLocationFacility WITH(NOLOCK)  
   WHERE Active = 1 and FacilityId = @pLovKey  
  END   
  
 ELSE IF(@pTableName='Rescheduling')  
  BEGIN  
   SELECT LovId,  
     --CASE WHEN LovId IN (36,198) THEN 'Others'  
     -- ELSE FieldValue, 0 AS IsDefault   
     --END   AS FieldValue, 0 AS IsDefault   ,  
     FieldValue, 0 AS IsDefault     
   FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1   
     AND LovKey = 'PlannerClassificationValue'  
   ORDER BY SortNo ASC  
  
  END  
  
 ELSE IF(@pTableName='FMConfigCustomerValues')  
  BEGIN  
   --SELECT IndicatorDetId   AS ConfigKeyId,  
   --  'KPIIndicator' + ' - ' + IndicatorNo    AS KeyName   
   --FROM MstDedIndicatorDet WITH(NOLOCK)  
   --WHERE Active = 1   
  
   --SELECT QAPIndicatorId   AS ConfigKeyId,  
   --  'QAPIndicator' + ' - ' + IndicatorCode  AS KeyName   
   --FROM MstQAPIndicator WITH(NOLOCK)  
   --WHERE Active = 1  
  
--Date  
   SELECT ConfigKeyId AS LovId,  
     KeyName  AS FieldValue, 0 AS IsDefault  
   FROM FMConfigKeys  WHERE ConfigKeyId = 1  
--Currency  
   SELECT ConfigKeyId AS LovId,  
     KeyName  AS FieldValue, 0 AS IsDefault  
   FROM FMConfigKeys  WHERE ConfigKeyId = 2  
--QAPIndicator  
   SELECT ConfigKeyId AS LovId,  
     KeyName  AS FieldValue, 0 AS IsDefault  
   FROM FMConfigKeys  WHERE ConfigKeyId IN (3,4)  
--KPIIndicator  
   SELECT ConfigKeyId AS LovId,  
     KeyName  AS FieldValue, 0 AS IsDefault  
   FROM FMConfigKeys  WHERE ConfigKeyId IN (5,6,7,8,9,10)  
  
  END   
  
 ELSE IF(@pTableName='QAPCarTxn')  
  BEGIN  
   SELECT QAPIndicatorId AS LovId,  
     IndicatorCode AS FieldValue, 0 AS IsDefault     
   FROM MstQAPIndicator WITH(NOLOCK)  
   WHERE Active = 1   
  
   SELECT QualityCause.QualityCauseId AS LovId,  
   QualityCause.Description AS FieldValue, 0 AS IsDefault  
  
   FROM MstQAPQualityCause            AS QualityCause  
   Order by QualityCause.Description asc   
  
   --SELECT QualityCauseDet.QualityCauseDetId AS LovId,  
   --QualityCauseDet.Details AS FieldValue, 0 AS IsDefault  
  
   --FROM MstQAPQualityCauseDet           AS QualityCauseDet  
   --Order by QualityCauseDet.Details asc  
  END  
  
 ELSE IF(@pTableName='NotificationTemplate')  
  BEGIN  
   SELECT UserTypeId AS LovId,  
     Name  AS FieldValue, 0 AS IsDefault     
   FROM UMUserType WITH(NOLOCK)  
   WHERE Active = 1   
   ORDER By FieldValue  
   SELECT UMUserRoleId AS LovId,  
     Name   AS FieldValue, 0 AS IsDefault,  
     UserTypeId as LovKey   
   FROM UMUserRole WITH(NOLOCK)  
   WHERE Active = 1  
   ORDER By FieldValue  
     --AND UserTypeId = CAST(@pLovKey AS INT)  
  
  END  
                                              
 ELSE  
  BEGIN  
   SELECT LovId  AS LovId,  
     FieldValue AS FieldValue, 0 AS IsDefault   
   FROM FMLovMst WITH(NOLOCK)  
   WHERE Active = 1   
     AND LovKey=@pLovKey  
   ORDER BY SortNo ASC  
  END   
  
  
END TRY  
  
BEGIN CATCH  
  
 INSERT INTO ErrorLog(  
    Spname,  
    ErrorMessage,  
    createddate)  
 VALUES(  OBJECT_NAME(@@PROCID),  
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),  
    getdate()  
     )  
  
END CATCH