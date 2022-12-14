USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VmVariationTxnVVF_GetAll_bak]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
CREATE PROCEDURE  [dbo].[uspFM_VmVariationTxnVVF_GetAll_bak]         
                                  
  @pYear       INT,        
  @pMonth       INT,        
  @pVariationStatus    INT = NULL,        
  @pVariationWFStatus    INT = NULL,        
  @pVariationApprovedStatus  INT = NULL,        
  @pPageIndex      INT,        
  @pPageSize      INT,        
  @pFacilityId     INT = NULL        
AS                                                       
        
BEGIN TRY        
        
-- Paramter Validation         
        
 SET NOCOUNT ON;         
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;        
        
-- Declaration        
        
 DECLARE @TotalRecords INT        
 DECLARE @pTotalPage  NUMERIC(24,2)        
        
-- Default Values        
         
 --DECLARE @mVariationWFStatus TABLE (WFStatusId int)        
 --select * from FMLovMst where LovKey='WorkFlowStatusValue'        
        
 --INSERT INTO @mVariationWFStatus        
 set @pVariationWFStatus= 232  --submit        
        
 IF(ISNULL(@pYear,0) = 0) RETURN        
        
 SET @pVariationWFStatus = (SELECT   CASE         
           --WHEN ISNULL(@pVariationWFStatus,0) IN (0) THEN 0        
           WHEN ISNULL(@pVariationWFStatus,0) = 232 then 0        
           WHEN ISNULL(@pVariationWFStatus,0) = 233 THEN 232                   
           WHEN ISNULL(@pVariationWFStatus,0) in(230,231) THEN 233                   
          END AS VariationWFStatus)        
        
        
        
 CREATE TABLE #TotalAssetList(AssetId int,AssetTypeCodeId INT,TypeCodeParameterId INT,VariationRate NUMERIC(24,2),ContractType int)        
        
 SELECT Asset.Assetid,Asset.AssetTypeCodeId,--TypeCodeVariation.TypeCodeParameterId,VariationRate,        
 Asset.ContractType        
 INTO #VmResult        
  FROM VmVariationTxn        AS Variation   WITH(NOLOCK)         
   INNER JOIN MstCustomer       AS Customer   WITH(NOLOCK) ON Variation.CustomerId     = Customer.CustomerId        
   INNER JOIN MstLocationFacility     AS Facility   WITH(NOLOCK) ON Variation.FacilityId     = Facility.FacilityId        
   INNER JOIN EngAsset        AS Asset    WITH(NOLOCK) ON Variation.AssetId     = Asset.AssetId        
   LEFT JOIN MstLocationUserArea     AS UserArea   WITH(NOLOCK) ON Asset.UserAreaId      = UserArea.UserAreaId        
   LEFT JOIN  FMLovMst        AS LovVariationStatus WITH(NOLOCK) ON Variation.VariationStatus   = LovVariationStatus.LovId        
   LEFT JOIN  FMLovMst        AS LovApproveStatus WITH(NOLOCK) ON Variation.VariationApprovedStatus = LovApproveStatus.LovId        
   LEFT JOIN  FMLovMst        AS LovWorkFlowStatus WITH(NOLOCK) ON Variation.VariationApprovedStatus = LovWorkFlowStatus.LovId        
   LEFT JOIN EngAssetStandardizationManufacturer AS Manufacturer  WITH(NOLOCK) ON Asset.Manufacturer     = Manufacturer.ManufacturerId        
   LEFT JOIN EngAssetStandardizationModel   AS Model  WITH(NOLOCK)  ON Asset.Model   = Model.ModelId        
 WHERE --AuthorizedStatus = 0    AND         
   YEAR(Variation.VariationRaisedDate)   = @pYear         
   AND  MONTH(Variation.VariationRaisedDate)  = @pMonth        
   
   AND ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus        
 
   AND ((ISNULL(@pVariationStatus,'') = '' ) OR (ISNULL(@pVariationStatus,'') <> '' AND Variation.VariationStatus = @pVariationStatus ))        
  AND Variation.IsMonthClosed = 1        
   AND Variation.FacilityId = isnull(nullif(@pFacilityId ,0),Variation.FacilityId)        
         
          --exec [uspFM_VmVariationTxnVVF_GetAll_bak] @pYear = 2018, @pMonth = 12, @pPageIndex = 1 , @pPageSize = 10       
  --select * from #VmResult
 SELECT Assetid,a.AssetTypeCodeId,        
 isnull(max(case when B.TypeCodeParameterId =1 then B.VariationRate else null end),0) as Parameter1,        
 isnull(max(case when B.TypeCodeParameterId =2 then B.VariationRate else null end),0) as Parameter2,        
 isnull(max(case when B.TypeCodeParameterId =3 then B.VariationRate else null end),0) as Parameter3,        
 isnull(max(case when B.TypeCodeParameterId =4 then B.VariationRate else null end),0) as Parameter4,        
 isnull(max(case when B.TypeCodeParameterId =5 then B.VariationRate else null end),0) as Parameter5,        
 isnull(max(case when B.TypeCodeParameterId =6 then B.VariationRate else null end),0) as Parameter6,        
 isnull(max(case when B.TypeCodeParameterId =7 then B.VariationRate else null end),0) as Parameter7,        
 isnull(max(case when B.TypeCodeParameterId =8 then B.VariationRate else null end),0) as Parameter8,        
 isnull(max(case when B.TypeCodeParameterId =9 then B.VariationRate else null end),0) as Parameter9,        
 isnull(max(case when B.TypeCodeParameterId =10 then B.VariationRate else null end),0) as Parameter10,        
 isnull(max(case when B.TypeCodeParameterId =11 then B.VariationRate else null end),0) as Parameter11,        
 isnull(max(case when B.TypeCodeParameterId =12 then B.VariationRate else null end),0) as Parameter12,        
 isnull(max(case when B.TypeCodeParameterId =13 then B.VariationRate else null end),0) as Parameter13         
 into #AssetTypeCodeVariationSep        
 FROM #VmResult a join EngAssetTypeCodeVariationRate b        
 on  A.AssetTypeCodeId = B.AssetTypeCodeId and b.active=1        
 group by Assetid,a.AssetTypeCodeId        
 
        --select * from #AssetTypeCodeVariationSep
         
        
    SELECT Variation.VariationId,        
   Variation.AssetId,        
   --UserArea.UserAreaName     AS UserAreaName,        
   Asset.AssetNo,                
   Variation.PurchaseProjectCost as PurchaseCost,               
   --Variation.CommissioningDate,        
   --Variation.StartServiceDate    AS StartServiceDate,        
   --Variation.WarrantyEndDate    AS WarrantyExpiryDate,        
   --Variation.ServiceStopDate    AS StopServiceDate,        
   Case when CAST(Asset.WarrantyEndDate AS DATE)>CAST(GETDATE() AS DATE)  Then Result.Parameter13             
     ELSE        
     0.00        
     END as [MaintenanceRateDW],        
        
    Case when CAST(Asset.WarrantyEndDate AS DATE)>CAST(GETDATE() AS DATE)  Then 0.00        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) < =5 and Asset.ContractType=279 then Parameter1        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) BETWEEN 5 AND 10 and Asset.ContractType=279 then Parameter2        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) >10 and Asset.ContractType=279 then Parameter3        
        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) < =5 and Asset.ContractType=280 then Parameter4        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) BETWEEN 5 AND 10 and Asset.ContractType=280 then Parameter5        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) >10 and Asset.ContractType=280 then Parameter6        
        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) < =5 and Asset.ContractType=281 then Parameter7        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) BETWEEN 5 AND 10 and Asset.ContractType=281 then Parameter8        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) >10 and Asset.ContractType=281 then Parameter9        
        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) < =5 and Asset.ContractType=282 then Parameter10        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) BETWEEN 5 AND 10 and Asset.ContractType=282 then Parameter11        
     when  DATEDIFF(YY,Asset.PurchaseDate,GETDATE()) >10 and Asset.ContractType=282 then Parameter12        
     ELSE        
     0.00        
     END as [MaintenanceRatePW],        
          
   --Asset.PurchaseCostRM,        
   Variation.PurchaseProjectCost as PurchaseCostRM,        
   --50.00         AS CountingDays,        
   --Variation.VariationApprovedStatus  AS Action,        
   --Variation.Remarks      AS Remarks,                
   --Variation.VariationWFStatus,        
   --Variation.[Timestamp]     AS [Timestamp], 
   Variation.VariationRaisedDate       
     
 INTO #VmVariationTxnResult        
  FROM VmVariationTxn         AS Variation   WITH(NOLOCK)         
   --INNER JOIN MstCustomer       AS Customer   WITH(NOLOCK) ON Variation.CustomerId     = Customer.CustomerId        
   INNER JOIN EngAsset        AS Asset    WITH(NOLOCK) ON Variation.AssetId     = Asset.AssetId        
   --LEFT  JOIN MstLocationUserArea     AS UserArea   WITH(NOLOCK) ON Asset.UserAreaId      = UserArea.UserAreaId        
   LEFT  JOIN #AssetTypeCodeVariationSep   AS  Result    WITH(NOLOCK) ON Asset.AssetId      =   Result.AssetId        
 WHERE --AuthorizedStatus = 0    AND         
   YEAR(Variation.VariationRaisedDate)   = @pYear         
   AND  MONTH(Variation.VariationRaisedDate)  = @pMonth        
    AND ISNULL(Variation.VariationWFStatus,0) = @pVariationWFStatus        
   AND ((ISNULL(@pVariationStatus,'') = '' ) OR (ISNULL(@pVariationStatus,'') <> '' AND Variation.VariationStatus = @pVariationStatus ))        
   AND Variation.IsMonthClosed = 1        
   AND Variation.FacilityId = isnull(nullif(@pFacilityId ,0),Variation.FacilityId)        
        
select * from #VmVariationTxnResult        
           
 --exec [uspFM_VmVariationTxnVVF_GetAll_bak] @pYear = 2018, @pMonth = 12, @pPageIndex = 1 , @pPageSize = 10       
         
 --SELECT @TotalRecords = COUNT(*)        
 -- FROM #VmVariationTxnResult         
 --SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))                
 --SET @pTotalPage = CEILING(@pTotalPage)        
       
 select VariationId,AssetId,AssetNo, PurchaseCost,
 --CommissioningDate,StartServiceDate,WarrantyExpiryDate,StopServiceDate,        
 cast(MaintenanceRateDW as numeric(30,2)) as MaintenanceRateDW, cast(MaintenanceRatePW  as numeric(30,2)) as  MaintenanceRatePW,      
 cast(cast( (t.PurchaseCostRM * t.MaintenanceRateDW) / 100.00  as numeric(30,2))/12.00 as numeric(30,2)) as   [MonthlyProposedFeeDW],        
 cast(cast((t.PurchaseCostRM * t.MaintenanceRatePW) / 100.00  as numeric(30,2))/12.00 as numeric(30,2)) as  [MonthlyProposedFeePW]        
 --cast(isnull(datediff(dd,VariationRaisedDate,getdate()),0) as decimal(30,2)) as CountingDays
 --Action,Remarks,        
 --case when VariationWFStatus =230    then 371        
 --  when VariationWFStatus = 231   then 372        
 --  when  VariationWFStatus = 0    then 373        
 --  else null end VariationWFStatus       
 --Timestamp
 --VariationRaisedDate , @TotalRecords AS TotalRecords,@pTotalPage AS TotalPageCalc        
        
 from #VmVariationTxnResult t        
 --order by Timestamp        
 --OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY        

     
          
END TRY        
        
BEGIN CATCH        
        
 INSERT INTO ErrorLog(        
    Spname,        
 ErrorMessage,        
    createddate)        
 VALUES(  OBJECT_NAME(@@PROCID),        
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),        
    getdate()        
     );        
  THROW;        
        
END CATCH
GO
