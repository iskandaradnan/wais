USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_CauseCodeFetchUsingUserType_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : [UspFM_CauseCodeFetchUsingUserType_GetById]  
Description   : To Get the data from table PorteringTransaction using the Primary Key id  
Authors    : Balaji M S  
Date    : 30-Mar-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC [UspFM_CauseCodeFetchUsingUserType_GetById] @pQualityCauseId=2 
  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
CREATE PROCEDURE  [dbo].[UspFM_CauseCodeFetchUsingUserType_GetById]                             
 -- @pUserId    INT = NULL,  
  @pQualityCauseId   INT  
  
  
AS                                                
  
BEGIN TRY  
  
  
  
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
   
   
 DECLARE @mCustomerId INT  
 DECLARE @mFacilityId INT,@mBlockId INT,@mLevelId INT  
 DECLARE @mUserLocationId INT,@mUserAreaId INT  
  
 IF(ISNULL(@pQualityCauseId,0) = 0) RETURN  
  
 --SELECT QualityCause.QualityCauseId,  
 --  QualityCause.CauseCode,  
 --  QualityCause.Description  
  
 --FROM MstQAPQualityCause           AS QualityCause  
 --WHERE QualityCause.QualityCauseId = @pQualityCauseId  AND QualityCause.Active =1  
 --ORDER BY QualityCause.CauseCode ASC  
  
  SELECT  QualityCauseDetId   AS QualityCauseId,  
         Details  AS CauseCode,   
       QcCode    AS Description  
   FROM MstQAPQualityCauseDet WITH(NOLOCK)   
   WHERE Active = 1   
   AND QualityCauseDetId = @pQualityCauseId   
   ORDER BY QcCode  
  
  
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
