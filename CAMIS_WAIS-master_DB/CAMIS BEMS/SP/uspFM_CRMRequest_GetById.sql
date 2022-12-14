
/*========================================================================================================          
Application Name : UETrack-BEMS                        
Version    : 1.0          
Procedure Name  : UspFM_CRMRequest_GetById          
Description   : To Get the data from table CRMRequest using the Primary Key id          
Authors    : Balaji M S          
Date    : 30-Mar-2018          
-----------------------------------------------------------------------------------------------------------          
          
Unit Test:          
EXEC [uspFM_CRMRequest_GetById] @pCRMRequestId=19132,@pUserId=1,@pPageIndex=1,@pPageSize=20          
          
SELECT * FROM CRMRequestn          
-----------------------------------------------------------------------------------------------------------          
Version History           
-----:------------:---------------------------------------------------------------------------------------          
Init : Date       : Details          
========================================================================================================*/          
          
ALTER PROCEDURE  [dbo].[uspFM_CRMRequest_GetById]                                     
  @pUserId       INT = NULL,          
  @pCRMRequestId     INT,          
  @pPageIndex      INT,          
  @pPageSize      INT           
          
AS                                                        
          
BEGIN TRY          
          
          
          
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;          
          
 DECLARE   @TotalRecords  INT          
 DECLARE   @pTotalPage  NUMERIC(24,2)          
 DECLARE   @pTotalPageCalc INT          
          
 IF(ISNULL(@pCRMRequestId,0) = 0) RETURN          
          
 DECLARE   @StatusId   INT          
          
 SET @StatusId = (SELECT TypeOfRequest FROM CRMRequest WHERE CRMRequestId = @pCRMRequestId)          
          
          
          
 IF(@StatusId <> 374)          
 BEGIN          
    SELECT Request.CRMRequestId       AS CRMRequestId,          
   Request.CustomerId        AS CustomerId,          
   Request.FacilityId        AS FacilityId,          
   Request.ServiceId        AS ServiceId,          
      
   ServiceKey.ServiceKey       AS ServiceKey,          
   ServiceKey.ServiceKey       AS ServiceKey1,              
              
  -- CASE WHEN ServiceKey.ServiceKe=1 THEN 'FEMS'              
  --      WHEN ServiceKey.ServiceKey=2 THEN 'BEMS'              
  --WHEN ServiceKey.ServiceKey=3 THEN 'LLS'              
  --WHEN ServiceKey.ServiceKey=4 THEN 'CLS'              
  --END ServiceName,              
      
      
   Request.RequestNo        AS RequestNo,          
   Request.RequestDateTime       AS RequestDateTime,          
   Request.RequestDateTimeUTC      AS RequestDateTimeUTC,          
   Request.RequestStatus       AS RequestStatus,          
   RequestStatus.FieldValue      AS RequestStatusName,          
   Request.RequestDescription      AS RequestDescription,          
   Request.TypeOfRequest       AS TypeOfRequest,          
   TypeOfRequest.FieldValue      AS TypeOfRequestName,          
   Request.Remarks         AS Remarks,          
   Request.IsWorkOrder        AS IsWorkorderGen,          
      
   -----COLUMN ADDED ON 14042020               
   --4 AS Designation,            
   DESG.Designation AS Designation,                  
   Requester.MobileNumber AS MobileNumber,                  
   -----COLUMN ADDED ON 14042020                  
      
   IsReqTypeReferenced,          
   Request.ManufacturerId,          
   Manufacturer.Manufacturer,          
   Request.ModelId,          
   Model.Model,          
   UserArea.UserAreaId,          
   UserArea.UserAreaCode,          
   UserArea.UserAreaName,          
   Request.UserLocationId,          
   UserLocation.UserLocationCode,          
   UserLocation.UserLocationName,          
   LBlock.BlockId,          
   LBlock.BlockCode,          
   LBlock.BlockName,          
   Llevel.LevelId,        
   Llevel.LevelCode,        
  Llevel.LevelName,        
   Request.Timestamp,          
   StatusValue,          
      
   -----ADDED 15042020              
              
   CASE WHEN CRMRequest_PriorityId=3 THEN 'Normal'               
        WHEN CRMRequest_PriorityId=4 THEN 'Emergency'               
  END AS CRMRequest_PriorityStatus,              
               
   -----ADDED 15042020              
      
   UserRole.UMUserRoleId,          
   UserRole.Name AS UMUserRoleName,          
   Request.GuId,          
   Request.TargetDate,          
   case when cast( Request.TargetDate as date) is null  then  null          
     when cast( Request.TargetDate as date) >= cast(getdate() as date)  then 'InTargetDate'  else 'TargetDateOver' end as TargetDateStatus,          
   Request.RequestedPerson,          
   RequestedPerson.StaffName as RequestedPersonName,          
   Request.AssigneeId,          
   AssigneeId.StaffName as AssigneeIdName,          
   Request.Requester as RequesterId,          
   Requester.StaffName  as Requester  ,        
   Requester.Email AS RequesterEmail,        
   WO.AssignedUserId AS WOAssigneId,        
   WOAssigne.StaffName AS WOAssigne,        
   WOAssigne.Email AS WOAssigneEmail,        
   UserArea.CustomerUserId AS CustomerUserId,        
   UserArea.FacilityUserId AS FacilityUserId,        
   ( select top 1 Email  from UMUserRegistration  where UserArea.CustomerUserId= UserRegistrationId ) as  CustomerUserEmail,         
   ( select top 1 Email  from UMUserRegistration  where UserArea.FacilityUserId= UserRegistrationId ) as  FacilityUserEmail,  
   ISNULL(Request.WorkGroup,0) AS  WorkGroup,    
      ISNULL(Request.WasteCategory,0) AS WasteCategory,Request.Requested_Date 
        
 FROM CRMRequest          AS Request    WITH(NOLOCK)          
   INNER JOIN MstService       AS ServiceKey   WITH(NOLOCK) ON Request.ServiceId   = ServiceKey.ServiceId          
   INNER JOIN FMLovMst       AS RequestStatus  WITH(NOLOCK) ON Request.RequestStatus  = RequestStatus.LovId          
   INNER JOIN FMLovMst       AS TypeOfRequest  WITH(NOLOCK) ON Request.TypeOfRequest  = TypeOfRequest.LovId          
   LEFT JOIN EngAssetStandardizationManufacturer AS Manufacturer   WITH(NOLOCK) ON Request.ManufacturerId  = Manufacturer.ManufacturerId          
   LEFT JOIN EngAssetStandardizationModel  AS Model    WITH(NOLOCK) ON Request.ModelId    = Model.ModelId          
   LEFT JOIN MstLocationUserLocation    AS UserLocation   WITH(NOLOCK) ON Request.UserLocationId  = UserLocation.UserLocationId          
   LEFT JOIN MstLocationUserArea     AS UserArea    WITH(NOLOCK) ON UserLocation.UserAreaId  = UserArea.UserAreaId          
   LEFT JOIN MstLocationBlock     AS LBlock    WITH(NOLOCK) ON LBlock.BlockId    = UserLocation.BlockId          
   LEFT JOIN MstLocationLevel     AS Llevel    WITH(NOLOCK) ON Llevel.BlockId    = LBlock.BlockId          
        
   --LEFT JOIN MstLocationUserArea     AS UserArea    WITH(NOLOCK) ON Request.UserAreaId   = UserArea.UserAreaId          
   --LEFT JOIN MstLocationUserLocation    AS UserLocation   WITH(NOLOCK) ON Request.UserLocationId  = UserLocation.UserLocationId          
             
   LEFT JOIN UMUserRegistration     AS RequestedPerson  WITH(NOLOCK) ON Request.RequestedPerson  = RequestedPerson.UserRegistrationId          
   LEFT JOIN UMUserRegistration     AS AssigneeId   WITH(NOLOCK) ON Request.AssigneeId   = AssigneeId.UserRegistrationId          
   LEFT JOIN UMUserRegistration     AS Requester   WITH(NOLOCK) ON Request.Requester   = Requester.UserRegistrationId          
         
   ------MODIFIED ON 14042020                  
   LEFT OUTER JOIN UserDesignation AS DESG WITH (NOLOCK)  ON Requester.UserDesignationId=DESG.UserDesignationId                  
         
         
   INNER JOIN UMUserLocationMstDet     AS LocationMstDet  WITH(NOLOCK) ON Request.FacilityId   = LocationMstDet.FacilityId          
   INNER JOIN UMUserRole       AS UserRole    WITH(NOLOCK) ON LocationMstDet.UserRoleId = UserRole.UMUserRoleId          
 outer apply (select top 1  WO1.AssignedUserId from CRMRequestWorkOrderTxn AS WO1 WITH(NOLOCK) WHERE   Request.CRMRequestId = WO1.CRMRequestId)  WO        
 LEFT JOIN UMUserRegistration     AS WOAssigne   WITH(NOLOCK) ON WO.AssignedUserId   = WOAssigne.UserRegistrationId          
   OUTER APPLY (SELECT CASE WHEN COUNT(1)>0 THEN 1           
        ELSE 0 END AS IsReqTypeReferenced           
      FROM CRMRequestWorkOrderTxn CRMWO WHERE Request.CRMRequestId = CRMWO.CRMRequestId) AS IsReqTypeReferenced          
 WHERE Request.CRMRequestId = @pCRMRequestId           
   AND LocationMstDet.UserRegistrationId = @pUserId          
 ORDER BY Request.ModifiedDate ASC          
          
 SELECT ReqDet.CRMRequestDetId,          
   ReqDet.CRMRequestId,          
   ReqDet.AssetId,          
   Asset.AssetNo,          
   Asset.AssetDescription,          
   Asset.SoftwareKey,          
   Asset.SoftwareVersion,          
   Asset.SerialNo,          
   ReqDet.ModifiedDate          
 INTO #TempCRMRequestDet          
 FROM CRMRequest Req           
   INNER JOIN CRMRequestDet AS ReqDet WITH(NOLOCK) ON Req.CRMRequestId = ReqDet.CRMRequestId          
   INNER JOIN EngAsset   AS Asset WITH(NOLOCK) ON ReqDet.AssetId = Asset.AssetId          
 WHERE Req.CRMRequestId = @pCRMRequestId          
          
 SELECT @TotalRecords = COUNT(*)          
 FROM #TempCRMRequestDet          
          
 SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))          
 SET @pTotalPageCalc = CEILING(@pTotalPage)          
          
 SELECT CRMRequestDetId,          
   CRMRequestId,          
   AssetId,          
   AssetNo,          
   AssetDescription,          
   SoftwareKey,          
   SoftwareVersion,          
   SerialNo,          
   @TotalRecords  AS TotalRecords,          
   @pTotalPageCalc  AS TotalPageCalc          
 FROM #TempCRMRequestDet           
 ORDER BY ModifiedDate DESC          
 OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY          
          
 SELECT ROW_NUMBER() OVER(ORDER BY CRMRequestRemarksHistoryId ) SNo,          
   CRMRequestRemarksHistoryId,          
   CRMRequestId,          
   RemarksHis.Remarks,          
   RequestStatus,          
   --RequestStatusValue,          
   RequestStatus.FieldValue AS RequestStatusValue,        
   UserReg.StaffName DoneBy,          
   --donedateUTC as DoneDate           
   DoneDate as DoneDate          
 FROM CRMRequestRemarksHistory AS RemarksHis           
   INNER JOIN UMUserRegistration AS UserReg on RemarksHis.DoneBy = UserReg.UserRegistrationId          
   INNER JOIN FMLovMst       AS RequestStatus  WITH(NOLOCK) ON RemarksHis.RequestStatus  = RequestStatus.LovId          
 WHERE CRMRequestId = @pCRMRequestId          
 order by RemarksHis.CRMRequestRemarksHistoryId           
          
 END          
--------------------------------------------------------------------------------------------------------------------------------------------------          
 ELSE          
          
 BEGIN          
    SELECT Request.CRMRequestId       AS CRMRequestId,          
   Request.CustomerId        AS CustomerId,          
   Request.FacilityId        AS FacilityId,          
   Request.ServiceId        AS ServiceId,          
   ServiceKey.ServiceKey       AS ServiceKey,        
         
      -----ADDED 15042020              
   ServiceKey.ServiceKey       AS ServiceKey1,              
      
      
   Request.RequestNo        AS RequestNo,          
   Request.RequestDateTime       AS RequestDateTime,          
   Request.RequestDateTimeUTC      AS RequestDateTimeUTC,          
   Request.RequestStatus       AS RequestStatus,          
   RequestStatus.FieldValue      AS RequestStatusName,          
   Request.RequestDescription      AS RequestDescription,          
   Request.TypeOfRequest       AS TypeOfRequest,          
   TypeOfRequest.FieldValue      AS TypeOfRequestName,          
   Request.Remarks         AS Remarks,          
   Request.IsWorkOrder        AS IsWorkorderGen,          
         
      -----COLUMN ADDED ON 14042020                  
  --4 AS Designation,            
   DESG.Designation AS Designation,                  
   Requester.MobileNumber AS MobileNumber,                  
   -----COLUMN ADDED ON 14042020                  
      
         
   IsReqTypeReferenced,          
   Request.ManufacturerId,          
   Manufacturer.Manufacturer,          
   Request.ModelId,          
   Model.Model,          
   UserArea.UserAreaId,          
   UserArea.UserAreaCode,          
   UserArea.UserAreaName,          
   Request.UserLocationId,          
   UserLocation.UserLocationCode,          
   UserLocation.UserLocationName,          
   LBlock.BlockId,          
   LBlock.BlockCode,          
   LBlock.BlockName,          
   Llevel.LevelId,        
   Llevel.LevelCode,        
   Llevel.LevelName,        
   Request.Timestamp,          
   StatusValue,          
   -----ADDED 15042020              
              
   CASE WHEN CRMRequest_PriorityId=3 THEN 'Normal'               
        WHEN CRMRequest_PriorityId=4 THEN 'Emergency'               
  END AS CRMRequest_PriorityStatus,              
               
   -----ADDED 15042020              
      
      
      
   UserRole.UMUserRoleId,          
   UserRole.Name AS UMUserRoleName,          
   Request.GuId,          
   Request.TargetDate,          
   case when cast( Request.TargetDate as date) is null  then  null          
     when cast( Request.TargetDate as date) >= cast(getdate() as date)  then 'InTargetDate'  else 'TargetDateOver' end as TargetDateStatus,          
   Request.RequestedPerson,          
   RequestedPerson.StaffName as RequestedPersonName,          
   Request.AssigneeId,          
   AssigneeId.StaffName as AssigneeIdName,          
   Request.Requester as RequesterId,          
   Requester.StaffName  as Requester ,        
    Requester.Email AS RequesterEmail,        
    WO.AssignedUserId AS WOAssigneId,        
   WOAssigne.StaffName AS WOAssigne,        
   WOAssigne.Email AS WOAssigneEmail ,        
    UserArea.CustomerUserId AS CustomerUserId,        
   UserArea.FacilityUserId AS FacilityUserId,        
   ( select top 1 Email  from UMUserRegistration  where UserArea.CustomerUserId= UserRegistrationId ) as  CustomerUserEmail,         
   ( select top 1 Email  from UMUserRegistration  where UserArea.FacilityUserId= UserRegistrationId ) as  FacilityUserEmail,  
   ISNULL(Request.WorkGroup,0) AS  WorkGroup,    
      ISNULL(Request.WasteCategory,0) AS WasteCategory,Request.Requested_Date
        
 FROM CRMRequest          AS Request    WITH(NOLOCK)          
   INNER JOIN MstService       AS ServiceKey   WITH(NOLOCK) ON Request.ServiceId   = ServiceKey.ServiceId          
   INNER JOIN FMLovMst       AS RequestStatus  WITH(NOLOCK) ON Request.RequestStatus  = RequestStatus.LovId          
   INNER JOIN FMLovMst       AS TypeOfRequest  WITH(NOLOCK) ON Request.TypeOfRequest  = TypeOfRequest.LovId          
   LEFT JOIN EngAssetStandardizationManufacturer AS Manufacturer   WITH(NOLOCK) ON Request.ManufacturerId  = Manufacturer.ManufacturerId          
   LEFT JOIN EngAssetStandardizationModel  AS Model    WITH(NOLOCK) ON Request.ModelId    = Model.ModelId          
   LEFT JOIN MstLocationUserLocation    AS UserLocation   WITH(NOLOCK) ON Request.UserLocationId  = UserLocation.UserLocationId          
   LEFT JOIN MstLocationUserArea     AS UserArea    WITH(NOLOCK) ON UserLocation.UserAreaId  = UserArea.UserAreaId          
   LEFT JOIN MstLocationBlock     AS LBlock    WITH(NOLOCK) ON LBlock.BlockId    = UserLocation.BlockId          
   LEFT JOIN MstLocationLevel     AS Llevel    WITH(NOLOCK) ON Llevel.BlockId    = LBlock.BlockId          
   --LEFT JOIN MstLocationUserArea     AS UserArea    WITH(NOLOCK) ON Request.UserAreaId   = UserArea.UserAreaId          
   --LEFT JOIN MstLocationUserLocation    AS UserLocation   WITH(NOLOCK) ON Request.UserLocationId  = UserLocation.UserLocationId          
   LEFT JOIN UMUserRegistration     AS RequestedPerson  WITH(NOLOCK) ON Request.RequestedPerson  = RequestedPerson.UserRegistrationId          
   LEFT JOIN UMUserRegistration     AS AssigneeId   WITH(NOLOCK) ON Request.AssigneeId   = AssigneeId.UserRegistrationId          
   LEFT JOIN UMUserRegistration     AS Requester   WITH(NOLOCK) ON Request.Requester   = Requester.UserRegistrationId          
      
     ----MODIFIED ON 14042020                  
   LEFT OUTER JOIN UserDesignation AS DESG WITH (NOLOCK)  ON Requester.UserDesignationId=DESG.UserDesignationId                  
      
      
   INNER JOIN UMUserLocationMstDet     AS LocationMstDet  WITH(NOLOCK) ON Request.FacilityId   = LocationMstDet.FacilityId          
   INNER JOIN UMUserRole       AS UserRole    WITH(NOLOCK) ON LocationMstDet.UserRoleId = UserRole.UMUserRoleId          
   outer apply (select top 1  WO1.AssignedUserId from CRMRequestWorkOrderTxn AS WO1 WITH(NOLOCK) WHERE   Request.CRMRequestId = WO1.CRMRequestId)  WO        
 LEFT JOIN UMUserRegistration     AS WOAssigne   WITH(NOLOCK) ON WO.AssignedUserId   = WOAssigne.UserRegistrationId          
   OUTER APPLY (SELECT CASE WHEN COUNT(1)>0 THEN 1           
        ELSE 0 END AS IsReqTypeReferenced           
      FROM CRMRequestWorkOrderTxn CRMWO WHERE Request.CRMRequestId = CRMWO.CRMRequestId) AS IsReqTypeReferenced          
 WHERE Request.CRMRequestId = @pCRMRequestId           
   AND LocationMstDet.UserRegistrationId = @pUserId          
 ORDER BY Request.ModifiedDate ASC          
          
 SELECT ReqDet.CRMRequestDetId,          
   ReqDet.CRMRequestId,          
   ReqDet.AssetId,          
   Asset.AssetNo,         
   Asset.AssetDescription,          
   Asset.SoftwareKey,          
   Asset.SoftwareVersion,          
   Asset.SerialNo,          
   ReqDet.ModifiedDate          
 INTO #TempCRMRequestDet1          
 FROM CRMRequest Req           
   INNER JOIN CRMRequestDet AS ReqDet WITH(NOLOCK) ON Req.CRMRequestId = ReqDet.CRMRequestId          
   INNER JOIN EngAsset   AS Asset WITH(NOLOCK) ON ReqDet.AssetId = Asset.AssetId          
 WHERE Req.CRMRequestId = @pCRMRequestId          
          
          
          
 SELECT CRMRequestDetId,          
   CRMRequestId,          
   AssetId,          
   AssetNo,          
   AssetDescription,          
   SoftwareKey,          
   SoftwareVersion,          
   SerialNo          
 FROM #TempCRMRequestDet1           
 ORDER BY ModifiedDate DESC          
          
          
 SELECT ROW_NUMBER() OVER(ORDER BY CRMRequestRemarksHistoryId ) SNo,          
   CRMRequestRemarksHistoryId,          
   CRMRequestId,          
   RemarksHis.Remarks,          
   RequestStatus,          
   --RequestStatusValue,          
   RequestStatus.FieldValue AS RequestStatusValue,        
   UserReg.StaffName DoneBy,          
   --DoneDate          
   donedateUTC as DoneDate          
 FROM CRMRequestRemarksHistory AS RemarksHis           
   INNER JOIN UMUserRegistration AS UserReg on RemarksHis.DoneBy = UserReg.UserRegistrationId          
   INNER JOIN FMLovMst       AS RequestStatus  WITH(NOLOCK) ON RemarksHis.RequestStatus  = RequestStatus.LovId          
 WHERE CRMRequestId = @pCRMRequestId          
 order by RemarksHis.CRMRequestRemarksHistoryId           
          
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