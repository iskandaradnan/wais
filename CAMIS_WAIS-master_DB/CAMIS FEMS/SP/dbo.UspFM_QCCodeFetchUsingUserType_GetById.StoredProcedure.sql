USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_QCCodeFetchUsingUserType_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================        
Application Name : UETrack-BEMS                      
Version    : 1.0        
Procedure Name  : UspFM_PorteringTransaction_GetById        
Description   : To Get the data from table PorteringTransaction using the Primary Key id        
Authors    : Balaji M S        
Date    : 30-Mar-2018        
-----------------------------------------------------------------------------------------------------------        
        
Unit Test:        
EXEC [UspFM_QCCodeFetchUsingUserType_GetById] @pQualityCauseDetId=30        
        
-----------------------------------------------------------------------------------------------------------        
Version History         
-----:------------:---------------------------------------------------------------------------------------        
Init : Date       : Details        
========================================================================================================*/        
CREATE PROCEDURE  [dbo].[UspFM_QCCodeFetchUsingUserType_GetById]                                   
 -- @pUserId    INT = NULL,        
  @pQualityCauseDetId   INT        
        
        
AS                                                      
        
BEGIN TRY        
        
        
        
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;        
         
         
 DECLARE @mCustomerId INT        
 DECLARE @mFacilityId INT,@mBlockId INT,@mLevelId INT        
 DECLARE @mUserLocationId INT,@mUserAreaId INT        
        
 IF(ISNULL(@pQualityCauseDetId,0) = 0) RETURN        
        
         
        
 SELECT QualityCause.QualityCauseId as QualityCauseDetId,        
   QualityCause.CauseCode as Details,        
   QualityCause.Description as QcCode        
        
 FROM MstQAPQualityCause           AS QualityCause        
 WHERE QualityCause.QualityCauseId = @pQualityCauseDetId  AND QualityCause.Active =1        
 ORDER BY QualityCause.CauseCode ASC        
        
        
 SELECT QualityCause.QualityCauseDetId as Lovid,        
   QualityCause.QcCode as FieldValue,        
   0     AS IsDefault        
 FROM MstQAPQualityCauseDet           AS QualityCause        
 WHERE QualityCause.QualityCauseId = @pQualityCauseDetId  AND QualityCause.Active =1        
 ORDER BY QualityCause.QcCode ASC        
        
        
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
