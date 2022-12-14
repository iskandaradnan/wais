USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_FinMonthlyFeeTxn_GetById_bak_06122018]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : UspFM_FinMonthlyFeeTxn_GetById  
Description   : To Get the data from table FinMonthlyFeeTxn using the Primary Key id  
Authors    : Dhilip V  
Date    : 30-Mar-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC [UspFM_FinMonthlyFeeTxn_GetById] @pYear=2018,@pFacilityId=1  
  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
CREATE PROCEDURE  [dbo].[UspFM_FinMonthlyFeeTxn_GetById_bak_06122018]                             
  
  @pYear  INT,  
  @pFacilityId INT  
  
AS                                                
  
BEGIN TRY  
  
  
  
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
 DECLARE   @TotalRecords  INT  
 DECLARE   @pTotalPage  NUMERIC(24,2)  
 DECLARE   @pTotalPageCalc NUMERIC(24,2)  
  
 IF(ISNULL(@pYear,0) = 0) RETURN  
  
  
  
    SELECT MonthlyFeeTxn.MonthlyFeeId       AS MonthlyFeeId,  
   MonthlyFeeTxn.CustomerId       AS CustomerId,  
   MonthlyFeeTxn.FacilityId       AS FacilityId,  
   Facility.FacilityCode        AS FacilityCode,  
   Facility.FacilityName        AS FacilityName,  
   MonthlyFeeTxn.Year         AS Year,  
   MonthlyFeeTxnDet.MonthlyFeeDetId     AS MonthlyFeeDetId,  
   MonthlyFeeTxnDet.MonthlyFeeId      AS MonthlyFeeId,  
   MonthlyFeeTxnDet.Month        AS Month,  
   MonthlyFeeMonth.Month        AS MonthlyFeeMonth,  
   MonthlyFeeTxnDet.VersionNo       AS VersionNo,  
   ISNULL(MonthlyFeeTxnDet.BemsMSF ,0)      AS BemsMSF,  
   ISNULL(MonthlyFeeTxnDet.BemsCF,0)      AS BemsCF,  
   ISNULL(MonthlyFeeTxnDet.BemsKPIF,0)       AS BemsKPIF,  
   ISNULL(MonthlyFeeTxnDet.BemsPercent,0)      AS BemsPercent,  
   ISNULL(MonthlyFeeTxnDet.TotalFee,0)       AS TotalFee,  
   MonthlyFeeTxn.Timestamp        AS Timestamp  
 FROM FinMonthlyFeeTxn         AS MonthlyFeeTxn WITH(NOLOCK)  
   INNER JOIN  FinMonthlyFeeTxnDet      AS MonthlyFeeTxnDet WITH(NOLOCK) ON MonthlyFeeTxn.MonthlyFeeId = MonthlyFeeTxnDet.MonthlyFeeId  
   INNER JOIN FMTimeMonth        AS MonthlyFeeMonth WITH(NOLOCK) ON MonthlyFeeTxnDet.Month  = MonthlyFeeMonth.MonthId  
   INNER JOIN MstLocationFacility      AS Facility   WITH(NOLOCK) ON MonthlyFeeTxn.FacilityId  = Facility.FacilityId  
 WHERE MonthlyFeeTxn.Year = @pYear  
   AND MonthlyFeeTxn.FacilityId = @pFacilityId  
 ORDER BY MonthlyFeeTxnDet.Month ASC  
  
  
  
  
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
