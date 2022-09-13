USE [UetrackFemsdbPreProd]
GO

/****** Object:  StoredProcedure [dbo].[UspFM_EngLicenseandCertificateTxn_GetById]    Script Date: 30-11-2021 19:10:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--alter table EngLicenseandCertificateTxn add AssetTypeCodeId INT

--SP_HELPTEXT UspFM_EngLicenseandCertificateTxn_GetById

--SP_HELPTEXT uspFM_EngLicenseandCertificateTxn_Save

--drop procedure uspFM_EngLicenseandCertificateTxn_Save 

----udt_EngLicenseandCertificateTxnDet 

--DROP PROCEDURE SAVE (uspFM_EngLicenseandCertificateTxn_Save) AND THEN RECRAETE 
 
 --SP_HELPTEXT uspFM_CRMRequest_Save--BEMS FEMS MASGTER
--SP_HELPTEXT uspFM_CRMRequest_Save_Master--BEMS FEMS 
--SP_HELPTEXT uspFM_CRMRequest_GetById--MASTER
--SP_HELPTEXT uspFM_CRMRequest_GetAll--MASTER
--SP_HELPTEXT uspFM_CRMRequest_Update---MASTER
--SP_HELPTEXT uspFM_CRMRequest_Update_NCR--MASTER

--sp_helptext uspFM_EngSpareParts_Save

   
--DROP TYPE [dbo].[udt_EngLicenseandCertificateTxnDet]
--GO

--/****** Object:  UserDefinedTableType [dbo].[udt_EngLicenseandCertificateTxnDet]    Script Date: 30/12/2020 11:11:42 PM ******/
--CREATE TYPE [dbo].[udt_EngLicenseandCertificateTxnDet] AS TABLE(
--	[LicenseDetId] [int] NULL,
--	[CustomerId] [int] NULL,
--	[FacilityId] [int] NULL,
--	[ServiceId] [int] NULL,
--	[AssetId] [int] NULL,
--	[StaffId] [int] NULL,
--	[Remarks] [nvarchar](1000) NULL,
--	[StaffName] [nvarchar](100) NULL,
--	[Designation] [nvarchar](100) NULL,
--	[AssetTypeCode] [nvarchar](100) NULL
--)
    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : UspFM_EngLicenseandCertificateTxn_GetById    
Description   : To Get the data from table EngLicenseandCertificateTxn using the Primary Key id    
Authors    : Balaji M S    
Date    : 30-Mar-2018    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
EXEC [UspFM_EngLicenseandCertificateTxn_GetById] @pLicenseId=50    
SELECT * FROM EngLicenseandCertificateTxn    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
========================================================================================================*/    
    
ALTER PROCEDURE  [dbo].[UspFM_EngLicenseandCertificateTxn_GetById]                               
    
  @pLicenseId  INT    
    
AS                                                  
    
BEGIN TRY    
    
    
    
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    
 IF(ISNULL(@pLicenseId,0) = 0) RETURN    
    
	select distinct LicenseId,LicenseNo into #temp from EngLicenseandCertificateTxn_History where LicenseId=@pLicenseId

    SELECT LicenseandCertificate.LicenseId       AS LicenseId,    
   LicenseandCertificate.CustomerId      AS CustomerId,    
   LicenseandCertificate.FacilityId      AS FacilityId,    
   LicenseandCertificate.ServiceId       AS ServiceId,    
   ServiceKey.ServiceKey         AS ServiceName,    
   LicenseandCertificate.LicenseNo       AS LicenseNo,    
   LicenseandCertificate.LicenseDescription    AS LicenseDescription,    
   LicenseandCertificate.Status       AS Status,    
   StatusValue.FieldValue         AS StatusValue,    
   LicenseandCertificate.Category       AS Category,    
   CategoryValue.FieldValue        AS CategoryValue,    
   LicenseandCertificate.IfOthersSpecify     AS IfOthersSpecify,    
   LicenseandCertificate.Type        AS Type,    
   TypeValue.FieldValue         AS TypeValue,    
   LicenseandCertificate.ClassGrade      AS ClassGrade,    
   LicenseandCertificate.ContactPersonUserId    AS ContactPersonStaffId,    
   ContactPerson.StaffName         AS ContactPersonName,    
   LicenseandCertificate.AssetTypeCodeId    AS AssetTypeCodeId,       
   AssetTypeCode.AssetTypeCode    AS AssetTypeCode,      
   AssetTypeCode.AssetTypeDescription    AS AssetTypeDescription,     
   LicenseandCertificate.IssuingBody      AS IssuingBody,    
   IssuingBodyValue.FieldValue        AS IssuingBodyValue,    
   LicenseandCertificate.IssuingDate      AS IssuingDate,    
   LicenseandCertificate.IssuingDateUTC     AS IssuingDateUTC,    
   LicenseandCertificate.NotificationForInspection   AS NotificationForInspection,    
   LicenseandCertificate.NotificationForInspectionUTC  AS NotificationForInspectionUTC,    
   LicenseandCertificate.InspectionConductedOn    AS InspectionConductedOn,    
   LicenseandCertificate.InspectionConductedOnUTC   AS InspectionConductedOnUTC,    
   LicenseandCertificate.NextInspectionDate    AS NextInspectionDate,    
   LicenseandCertificate.NextInspectionDateUTC    AS NextInspectionDateUTC,    
   LicenseandCertificate.[ExpireDate]      AS [ExpireDate],    
   LicenseandCertificate.ExpireDateUTC      AS ExpireDateUTC,    
   LicenseandCertificate.PreviousExpiryDate    AS PreviousExpiryDate,    
   LicenseandCertificate.PreviousExpiryDateUTC    AS PreviousExpiryDateUTC,    
   LicenseandCertificate.RegistrationNo     AS RegistrationNo,    
   LicenseandCertificate.Timestamp       AS [Timestamp],    
   LicenseandCertificate.GuId   ,
    (select  distinct STUFF((SELECT ',' + LicenseNo FROM #temp a  where a.LicenseId=b.LicenseId
         FOR XML PATH('')   ), 1, 1, '') LicenseNo  from #temp b ) as LicenseNohistory  
 FROM EngLicenseandCertificateTxn        AS LicenseandCertificate   WITH(NOLOCK)    
 LEFT  JOIN EngAssetTypeCode       AS AssetTypeCode     WITH(NOLOCK)   on LicenseandCertificate.AssetTypeCodeId = AssetTypeCode.AssetTypeCodeId        
  
   INNER JOIN  MstService         AS ServiceKey      WITH(NOLOCK)   on LicenseandCertificate.ServiceId    = ServiceKey.ServiceId    
   LEFT  JOIN UMUserRegistration       AS ContactPerson     WITH(NOLOCK)   on LicenseandCertificate.ContactPersonUserId = ContactPerson.UserRegistrationId    
   LEFT  JOIN FMLovMst         AS StatusValue      WITH(NOLOCK)   on LicenseandCertificate.Status     = StatusValue.LovId    
   LEFT  JOIN FMLovMst         AS CategoryValue     WITH(NOLOCK)   on LicenseandCertificate.Category    = CategoryValue.LovId    
   LEFT  JOIN FMLovMst         AS TypeValue      WITH(NOLOCK)   on LicenseandCertificate.Type     = TypeValue.LovId    
   LEFT  JOIN FMLovMst         AS IssuingBodyValue     WITH(NOLOCK)   on LicenseandCertificate.IssuingBody   = IssuingBodyValue.LovId    
 WHERE LicenseandCertificate.LicenseId = @pLicenseId     
 ORDER BY LicenseandCertificate.ModifiedDate ASC    
    
 DECLARE @mCategory INT    
 SET @mCategory = (SELECT Category FROM EngLicenseandCertificateTxn WHERE LicenseId = @pLicenseId)    
    
    
 IF(@mCategory=144)    
 BEGIN    
    
    
    
  SELECT  LicenseandCertificate.LicenseId       AS LicenseId,    
    LicenseandCertificateTxnDet.LicenseDetId    AS LicenseDetId,    
    LicenseandCertificateTxnDet.AssetId      AS AssetId,    
    Asset.AssetNo           AS Asset,    
    Asset.AssetDescription         AS AssetDescription,    
    LicenseandCertificateTxnDet.Remarks      AS Remarks    
  FROM EngLicenseandCertificateTxn        AS LicenseandCertificate   WITH(NOLOCK)    
    INNER JOIN  EngLicenseandCertificateTxnDet    AS LicenseandCertificateTxnDet  WITH(NOLOCK)   on LicenseandCertificate.LicenseId    = LicenseandCertificateTxnDet.LicenseId    
    INNER  JOIN EngAsset         AS Asset       WITH(NOLOCK)   on LicenseandCertificateTxnDet.AssetId   = Asset.AssetId    
  WHERE LicenseandCertificate.LicenseId = @pLicenseId     
     
 END    
    
 ELSE IF(@mCategory=146)    
 BEGIN    
    
    
  SELECT  LicenseandCertificate.LicenseId       AS LicenseId,    
    LicenseandCertificateTxnDet.LicenseDetId    AS LicenseDetId,    
    LicenseandCertificateTxnDet.UserId      AS UserId,    
    LicenseandCertificateTxnDet.StaffName     AS StaffName,    
    LicenseandCertificateTxnDet.Designation,    
    LicenseandCertificateTxnDet.Remarks      AS Remarks    
  FROM EngLicenseandCertificateTxn        AS LicenseandCertificate   WITH(NOLOCK)    
    INNER JOIN  EngLicenseandCertificateTxnDet    AS LicenseandCertificateTxnDet  WITH(NOLOCK) ON LicenseandCertificate.LicenseId    = LicenseandCertificateTxnDet.LicenseId    
  WHERE LicenseandCertificate.LicenseId = @pLicenseId     
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


GO


