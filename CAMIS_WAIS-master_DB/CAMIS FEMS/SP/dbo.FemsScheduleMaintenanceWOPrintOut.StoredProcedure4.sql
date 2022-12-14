USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[FemsScheduleMaintenanceWOPrintOut]    Script Date: 24-11-2021 10:47:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
---riskrating                  
--servicestartdate,getdate()/365                  
---datepart(week/maintawd)                  
                  
--SELECT WorkOrderId,MaintenanceWorkNo FROM EngMaintenanceWorkOrderTxn                  
                  
--SELECT * FROM EngMaintenanceWorkOrderTxn WHERE AssetId=396                  
                  
--SELECT * FROM EngMaintenanceWorkOrderTxn WHERE MaintenanceWorkNo='CALWAC/B/2020/000005'                  
          
        
                  
--EXEC [FemsScheduleMaintenanceWOPrintOut] 43557                  
                    
ALTER PROCEDURE [dbo].[FemsScheduleMaintenanceWOPrintOut]                    
(                    
@WorkOrderNo INT                    
)                    
AS                    
                    
BEGIN                     
                  
DECLARE @DATE DATETIME            
--DECLARE @WorkOrderNo INT            
DECLARE @ASSETID INT            
DECLARE @TYPEOFWORKORDER INT            
DECLARE @USERAREA INT  
            
            
--SET @WorkOrderNo=3499            
          
SET @DATE=(SELECT MAX(MaintenanceWorkDateTime) FROM EngMaintenanceWorkOrderTxn A WITH(NOLOCK) WHERE WorkOrderId=@WorkOrderNo)             
SET @ASSETID=(SELECT MAX(AssetId)FROM EngMaintenanceWorkOrderTxn A WITH(NOLOCK) WHERE WorkOrderId=@WorkOrderNo )            
SET @TYPEOFWORKORDER=(SELECT MAX(TypeOfWorkOrder) FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId=@WorkOrderNo)       
SET @USERAREA=(SELECT MAX(UserAreaId) FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId=@WorkOrderNo) 
            
            
--SELECT @ASSETID,@TYPEOFWORKORDER,@DATE            
-------BRING  THE INFO OF CURRENT SCHEDULE WORK ORDER CONSODERING IT AS THE BASE            
            
            
;WITH CTE_CURRPPMWO AS            
(            
SELECT A.MaintenanceWorkNo            
,A.MaintenanceWorkDateTime            
,A.AssetId            
,A.WorkOrderId            
,CASE WHEN ISNULL(A.PreviousTargetDateTime,'')='' THEN A.TargetDateTime ELSE A.PreviousTargetDateTime END AS ScheduleDate                        
,CASE WHEN ISNULL(A.PreviousTargetDateTime,'')='' THEN '' ELSE a.TargetDateTime END AS ReScheduleDate                        
,'Scheduled' AS WorkOrderCategorySch                    
,B.FieldValue AS WOStatus            
,D.FieldValue AS MaintenanceWorkType          
,C.PPMAgreedDate            
,CASE WHEN TypeOfWorkOrder=34 THEN 'PPM'         
WHEN TypeOfWorkOrder=35 THEN 'RI'         
WHEN TypeOfWorkOrder=198 THEN 'Calibration'         
ELSE 'Manual PPM' END AS TypeOfWorkOrderSch                    
,A.UserAreaId AS RIAreaID      
,TypeOfWorkOrder      
,A.WorkOrderStatus    
,LF.FacilityName
FROM EngMaintenanceWorkOrderTxn A            
LEFT OUTER JOIN FMLovMst B            
ON A.WorkOrderStatus=B.LovId            
LEFT OUTER JOIN EngMwoCompletionInfoTxn C                  
ON A.WorkOrderId=C.WorkOrderId           
LEFT OUTER JOIN FMLovMst D          
ON A.MaintenanceWorkType=D.LovId  

LEFT OUTER JOIN MstLocationFacility LF
ON A.FacilityId=Lf.FacilityId
WHERE MaintenanceWorkCategory=187                    
AND A.TypeOfWorkOrder=@TYPEOFWORKORDER                    
AND A.WorkOrderId=@WorkOrderNo            
            
)            
--SELECT * FROM CTE_CURRPPMWO            
            
----LOGIC TO CALCULATE THE LAST PPM DONE FOR THE ASSET             
      
      
      
            
,CTE_LASTPPMBASE AS            
(            
SELECT AssetId                    
,MaintenanceWorkNo AS LastMaintenanceWorkNoPPM                    
,MaintenanceWorkDateTime AS LastMaintainceDatePPM                    
,A.WorkOrderId  AS WorkOrderIdPPM            
,EngineerUserId AS  EngineerUserIdPPM                  
,ROW_NUMBER()OVER(PARTITION BY AssetId ORDER BY MaintenanceWorkDateTime DESC ) AS Rn                     
--,'Scheduled' AS WorkOrderCategory                    
--,CASE WHEN TypeOfWorkOrder=34 THEN 'PPM' ELSE 'OTHER' END AS TypeOfWorkOrder                    
--,B.FieldValue AS WOStatus                  
--,C.PPMAgreedDate                  
FROM EngMaintenanceWorkOrderTxn A WITH (NOLOCK)                    
LEFT OUTER JOIN FMLovMst B WITH (NOLOCK)                    
ON A.WorkOrderStatus=B.LovId                  
WHERE MaintenanceWorkCategory=187             
AND MaintenanceWorkType=34                    
AND A.MaintenanceWorkDateTime < @DATE            
AND A.AssetId=@ASSETID            
AND A.TypeOfWorkOrder=@TYPEOFWORKORDER            
)         
 ,CTE_LASTPPMBASE_RI AS                
(                
SELECT top 1 0 as AssetId                        
,MaintenanceWorkNo AS LastMaintenanceWorkNoPPM                        
,MaintenanceWorkDateTime AS LastMaintainceDatePPM                        
,A.WorkOrderId  AS WorkOrderIdPPM                
,EngineerUserId AS  EngineerUserIdPPM                      
,ROW_NUMBER()OVER(PARTITION BY MaintenanceWorkNo ORDER BY MaintenanceWorkDateTime DESC ) AS Rn
,@WorkOrderNo as CurrentWorkOrderNo                                              
FROM EngMaintenanceWorkOrderTxn A WITH (NOLOCK)                        
LEFT OUTER JOIN FMLovMst B WITH (NOLOCK)                        
ON A.WorkOrderStatus=B.LovId                      
WHERE MaintenanceWorkCategory=187                        
AND MaintenanceWorkType=35                        
AND A.MaintenanceWorkDateTime < @DATE                
AND a.UserAreaId=@USERAREA                
AND A.TypeOfWorkOrder=@TYPEOFWORKORDER  
 order by A.MaintenanceWorkDateTime desc   
)                        
       
--SELECT * FROM CTE_LASTPPMBASE            
            
,CTE_LASTPPM AS            
(            
SELECT AssetId             
,LastMaintenanceWorkNoPPM             
,LastMaintainceDatePPM             
,WorkOrderIdPPM        
,EngineerUserIdPPM             
,Rn            
FROM CTE_LASTPPMBASE            
WHERE RN=1            
)            
            
----LOGIC TO CALCULATE THE LAST USCH WORKMORDER FOR THE ASSET            
            
---SELECT * FROM CTE_LASTPPM            
,CTE_LASTUNSCHWOBASE AS             
(            
SELECT                     
 AssetId          
,MaintenanceWorkNo AS LastMaintenanceWorkNoUnSch                   
,MaintenanceWorkDateTime AS LastRepairDateUnsch                    
,CASE WHEN A.WorkOrderStatus=192 THEN  A.EngineerUserId       
      WHEN A.WorkOrderStatus=193 THEN  A.AssignedUserId      
   WHEN A.WorkOrderStatus IN (194,195) THEN  C.CompletedBy END      
AS EngineerUserIdUnsch                    
,ROW_NUMBER()OVER(PARTITION BY AssetId ORDER BY MaintenanceWorkDateTime DESC ) AS Rn                     
FROM EngMaintenanceWorkOrderTxn A WITH (NOLOCK)       
LEFT OUTER JOIN EngMwoAssesmentTxn B WITH (NOLOCK)       
ON A.WorkOrderId=B.WorkOrderId      
LEFT OUTER JOIN EngMwoCompletionInfoTxn C WITH (NOLOCK)       
ON A.WorkOrderId=C.WorkOrderId      
WHERE MaintenanceWorkCategory=188                    
AND MaintenanceWorkType=273                    
AND AssetId=@ASSETID            
AND MaintenanceWorkDateTime < @DATE            
        
)            
 
,CTE_LASTUNSCHWOBASE_RI AS                 
(                
SELECT   top 1                      
 0 as AssetId              
,MaintenanceWorkNo AS LastMaintenanceWorkNoUnSch                       
,MaintenanceWorkDateTime AS LastRepairDateUnsch                        
,CASE WHEN A.WorkOrderStatus=192 THEN  A.EngineerUserId           
      WHEN A.WorkOrderStatus=193 THEN  A.AssignedUserId          
   WHEN A.WorkOrderStatus IN (194,195) THEN  C.CompletedBy END          
AS EngineerUserIdUnsch                        
,ROW_NUMBER()OVER(PARTITION BY AssetId ORDER BY MaintenanceWorkDateTime DESC ) AS Rn     
,@WorkOrderNo as CurrentWorkOrderNo                      
FROM EngMaintenanceWorkOrderTxn A WITH (NOLOCK)           
LEFT OUTER JOIN EngMwoAssesmentTxn B WITH (NOLOCK)           
ON A.WorkOrderId=B.WorkOrderId          
LEFT OUTER JOIN EngMwoCompletionInfoTxn C WITH (NOLOCK)           
ON A.WorkOrderId=C.WorkOrderId          
WHERE MaintenanceWorkCategory=188                        
AND MaintenanceWorkType=273                        
AND UserAreaId=@USERAREA               
AND MaintenanceWorkDateTime < @DATE 
--AND TypeOfWorkOrder=@TYPEOFWORKORDER  
order by  MaintenanceWorkDateTime desc             
           
)             
,CTE_LASTUSCH AS            
(            
SELECT AssetId             
,LastMaintenanceWorkNoUnSch             
,LastRepairDateUnsch             
,EngineerUserIdUnsch             
,Rn             
FROM CTE_LASTUNSCHWOBASE            
WHERE RN=1            
)            
            
----CALCULATE THE NEXT DUE DATE            
            
--,CTE_NEXTDUEDATEBASE AS            
--(            
--SELECT B.AssetId,A.WorkOrderId,A.MaintenanceWorkNo,ISNULL(A.TargetDateTime,B.RescheduleDate) AS NextDueDate          
--,ROW_NUMBER()OVER(PARTITION BY B.AssetId ORDER BY A.MaintenanceWorkDateTime ASC) AS RN           
--FROM CTE_CURRPPMWO B           
--LEFT OUTER JOIN EngMaintenanceWorkOrderTxn A  WITH(NOLOCK)          
--ON A.AssetId=B.AssetId            
--WHERE A.MaintenanceWorkDateTime > @DATE            
--AND A.AssetId=@ASSETID            
--AND A.TypeOfWorkOrder=@TYPEOFWORKORDER            
--)            
          
----SELECT * FROM CTE_NEXTDUEDATEBASE          
          
            
--,CTE_NEXTDUEDATE AS            
--(            
--SELECT AssetId          
--,WorkOrderId          
--,MaintenanceWorkNo           
--,NextDueDate           
--FROM CTE_NEXTDUEDATEBASE            
--WHERE RN=1            
--)            
            
--SELECT * FROM CTE_NEXTDUEDATE            
            
----TO GET THE TASK CODE            
            
,CTE_PPMTASKCODE AS                    
(                    
SELECT A.AssetId           
--,C.TaskCode          
--,F.AssetTypeDescription AS TaskDescription          
--,E.FieldValue AS PPMFrequency   
,TaskInfo.TaskCode
,TaskInfo.TaskDescription
 
,TaskInfo.FieldValue AS PPMFrequency             

        
,CASE       
   WHEN E.LovId=44 THEN DATEADD(DAY,364,ScheduleDate)          
   WHEN E.LovId=45 THEN DATEADD(DAY,182,ScheduleDate)          
   WHEN E.LovId=46 THEN DATEADD(DAY,91,ScheduleDate)          
   WHEN E.LovId=47 THEN DATEADD(DAY,56,ScheduleDate)          
   WHEN E.LovId=48 THEN DATEADD(DAY,28,ScheduleDate)          
   WHEN E.LovId=49 THEN DATEADD(DAY,14,ScheduleDate)          
   WHEN E.LovId=50 THEN DATEADD(DAY,7,ScheduleDate)          
   END AS NextDueDate          
--,G.NextDueDate AS NextDueDate            
FROM EngAsset  A WITH (NOLOCK)                   
LEFT OUTER JOIN EngAssetStandardization B  WITH (NOLOCK)                   
ON A.AssetTypeCodeId=B.AssetTypeCodeId               
AND A.Model=B.ModelId  AND A.Manufacturer=B.ManufacturerId                   
LEFT OUTER JOIN EngAssetPPMCheckList C WITH (NOLOCK)                  
ON C.AssetTypeCodeId=B.AssetTypeCodeId                   
AND C.Modelid=B.ModelId  AND C.Manufacturerid=B.ManufacturerId                   
LEFT OUTER JOIN  CTE_CURRPPMWO G            
ON A.AssetId=G.AssetId            
LEFT OUTER JOIN FMLovMst E WITH (NOLOCK)                   
ON C.PPMFrequency=E.LovId                
LEFT OUTER JOIN EngAssetTypeCode F              
ON A.AssetTypeCodeId=F.AssetTypeCodeId              

outer apply(
select top 1	hepppmservice.PPMChecklistNo,
	hepppmservice.TaskCode,
	hepppmservice.TaskDescription,
	hepppmservice.PPMCheckListId,
	planner.StandardTaskDetId,
	hepppmservice.AssetTypeCodeId,
	document.[FileName] ,
    document.DocumentId,
    document.[DocumentGuId],	E.FieldValue from  [UetrackMasterdbPreProd]..EngAssetPPMCheckList hepppm inner join EngAssetPPMCheckList hepppmservice on hepppmservice.ppmchecklistno=hepppm.ppmchecklistnoinner join [UetrackMasterdbPreProd]..FMDocument document on hepppm.[guid] = document.DocumentGuId
inner join  engplannertxn planner 
on planner.AssetTypeCodeId=hepppmservice.AssetTypeCodeId  and planner.StandardTaskDetId=hepppmservice.PPMCheckListId 
join engasset engasset on planner.AssetTypeCodeId=engasset.AssetTypeCodeId AND engasset.AssetId=planner.AssetId
join EngMaintenanceWorkOrderTxn work on work.PlannerId=planner.PlannerId


LEFT OUTER JOIN FMLovMst E WITH (NOLOCK)                     
ON hepppm.PPMFrequency=e.LovId
where 
engasset.AssetId=@ASSETID and work.WorkOrderId= @WorkOrderNo
and hepppm.ServiceId in (1) and hepppmservice.ServiceId in (1)
--and hepppmservice.PPMCheckListId=6758
order by document.DocumentId desc 
)TaskInfo            

WHERE A.AssetId=@ASSETID            
            and TaskInfo.DocumentId is not null          
            
)                    
            
,CTE_WEEK AS       
(      
      
SELECT TOP 1 WeekNo,TypeOfPlanner FROM EngScheduleGenerationWeekLog x     
WHERE x.WeekStartDate <= (SELECT MAX(ScheduleDate) FROM CTE_CURRPPMWO)     
AND TypeOfPlanner=@TYPEOFWORKORDER     
ORDER BY x.WeekEndDate DESC      
)      
      
      
-----FINAL LOGIC            
            
SELECT                     
A.WorkOrderCategorySch AS WorkOrderCategory                    
,A.TypeOfWorkOrderSch AS TypeOfWorkOrder                    
,AB.AssetClassificationDescription  AS WorkGroup                    
--,CONCAT('Week ',CONCAT(CONCAT(CAST(DATEPART(WEEK,A.ScheduleDate) AS VARCHAR(20)),'/'),YEAR(A.ScheduleDate))) AS WeekPeriod                    
,CONCAT('Week ',CONCAT(CONCAT(CAST(Z.WeekNo AS VARCHAR(20)),'/'),YEAR(A.ScheduleDate)))  AS WeekPeriod                    
,C.AssetNo               
  
,F.AssetTypeDescription AS AssetDescription                 /*MADE CHANGES AS PER AINNA ON 17-11-2020*/   
  
,(D.UserLocationCode+ ' / '+ D.UserLocationName) AS AssetLocationName                    
,CASE WHEN A.TypeOfWorkOrder=35 THEN Q.UserAreaName ELSE E.UserAreaName  END AS AssetAreaName                    
,CASE WHEN A.TypeOfWorkOrder=35 THEN Q.UserAreaCode ELSE E.UserAreaCode  END AS UserAreaCode                    
--,E.UserAreaCode          
,F.AssetTypeCode                     
,CASE 
   WHEN (A.TypeOfWorkOrder=35 and q.Category=1) THEN 'Critical' 
   WHEN (A.TypeOfWorkOrder=35 and q.Category=2) THEN 'Non-Critical'  
   ELSE N.FieldValue
   END AS AssetCriticality                        
--,N.FieldValue  AS AssetCriticality 
,CASE 
   WHEN (A.TypeOfWorkOrder=35 and q.Active=0) THEN 'Inactive' 
   WHEN (A.TypeOfWorkOrder=35 and q.Active=1) THEN 'Active'  
   ELSE G.FieldValue
   END AS AssetStatus                       
--,G.FieldValue AS AssetStatus                     
,H.Manufacturer                     
,I.Model                    
,C.SerialNo                    
,DATEDIFF(DAY,C.ServiceStartDate,GETDATE())/365 AS ServiceLife                    
,A.AssetId                    
,A.MaintenanceWorkNo AS PPMWorkOrderNumber                    
--,B.LastMaintenanceWorkNoUnSch AS UnScheduleWokOrderNumber                    
,CASE WHEN A.TypeOfWorkOrder=35 THEN  RISC.LastMaintainceDatePPM ELSE AA.LastMaintainceDatePPM END AS LastMaintainceDate                         
--,AA.LastMaintainceDatePPM AS LastMaintainceDate                      
--,CASE WHEN A.WorkOrderStatus=192 THEN '' ELSE A.RescheduleDate END AS  RescheduleDate                   
,A.RescheduleDate AS  RescheduleDate                   
,B.LastRepairDateUnsch AS LastRepairDate                    
,'' AS CurrentStatus     
,CASE WHEN A.TypeOfWorkOrder=35 THEN  RISC.LastMaintenanceWorkNoPPM ELSE AA.LastMaintenanceWorkNoPPM END AS LastMaintenanceWorkNo                    
--,AA.LastMaintenanceWorkNoPPM LastMaintenanceWorkNo                      
,B.LastMaintenanceWorkNoUnSch AS LastRepairMaintenanceWorkNo   
,CASE WHEN A.TypeOfWorkOrder=35 THEN  SU.StaffName ELSE J.StaffName END AS LastMaintenancePerson                   
--,J.StaffName AS LastMaintenancePerson                     
,K.StaffName AS LastRepairPerson                    
,CASE WHEN A.TypeOfWorkOrder=35 THEN 'RI-001' ELSE L.TaskCode END AS TaskCode 
,CASE WHEN A.TypeOfWorkOrder=35 THEN 'Annually' ELSE L.PPMFrequency END as PPMFrequency                     
,CASE WHEN A.TypeOfWorkOrder=35 THEN DATEADD(DAY,364,ScheduleDate) ELSE L.NextDueDate  END AS NextDueDate                    
,CASE WHEN A.TypeOfWorkOrder=35 THEN 'Routine Inspection' ELSE L.TaskDescription END as TaskDescription                
,A.WOStatus                  
,A.PPMAgreedDate                  
,AB.AssetClassificationDescription AS WorkGroupDescription                  
,P.FieldValue AS VariationStatus                 
,A.MaintenanceWorkNo            
,A.MaintenanceWorkDateTime            
,A.ScheduleDate          
,A.MaintenanceWorkType          
,A.FacilityName
FROM CTE_CURRPPMWO A            
LEFT OUTER JOIN EngAsset C WITH (NOLOCK)              
ON A.AssetId=C.AssetId                    
LEFT OUTER JOIN CTE_LASTUSCH B            
ON B.AssetId=C.AssetId            
LEFT OUTER JOIN CTE_LASTPPM AA            
ON AA.AssetId=C.AssetId            
LEFT OUTER JOIN MstLocationUserLocation D WITH (NOLOCK)                    
ON C.UserLocationId=D.UserLocationId                    
LEFT OUTER JOIN MstLocationUserArea E WITH (NOLOCK)                    
ON D.UserAreaId=E.UserAreaId         
      
----AREA CODE JOIN ADDED FOR RI      
LEFT OUTER JOIN MstLocationUserArea Q WITH (NOLOCK)                    
ON A.RIAreaID=Q.UserAreaId         
LEFT OUTER JOIN EngAssetTypeCode F WITH (NOLOCK)                    
ON C.AssetTypeCodeId=F.AssetTypeCodeId                    
LEFT OUTER JOIN FMLovMst G                    
ON C.RealTimeStatusLovId=G.LovId                    
LEFT OUTER JOIN EngAssetStandardizationManufacturer H WITH (NOLOCK)                    
ON C.Manufacturer=H.ManufacturerId                    
LEFT OUTER JOIN EngAssetStandardizationModel I WITH (NOLOCK)                    
ON C.Model=I.ModelId                    
LEFT OUTER JOIN UMUserRegistration J WITH (NOLOCK)                    
ON AA.EngineerUserIdPPM=J.UserRegistrationId           
LEFT OUTER JOIN UMUserRegistration K WITH (NOLOCK)                    
ON B.EngineerUserIdUnsch=K.UserRegistrationId                    
LEFT OUTER JOIN CTE_PPMTASKCODE L WITH (NOLOCK)                    
ON A.AssetId=L.AssetId                    
LEFT OUTER JOIN EngAssetWorkGroup M WITH (NOLOCK)                    
ON C.WorkGroupId=M.WorkGroupId                  
LEFT OUTER JOIN FMLovMst N                  
ON C.RiskRating=N.LovId                  
LEFT OUTER JOIN VmVariationTxn O                  
ON C.AssetId=O.AssetId                  
LEFT OUTER JOIN FMLovMst P                  
ON O.VariationStatus=P.LovId                  
      
      
---WEEK LOGIC      
LEFT OUTER JOIN CTE_WEEK Z      
ON (CASE WHEN A.TypeOfWorkOrder=82 THEN 34 ELSE A.TypeOfWorkOrder END )=Z.TypeOfPlanner      
      
LEFT OUTER JOIN EngAssetClassification AB      
ON C.AssetClassification=AB.AssetClassificationId      
      
      
 --RI Logic
  LEFT OUTER JOIN CTE_LASTPPMBASE_RI RISC                       
ON A.WorkOrderId =RISC.CurrentWorkOrderNo   

  LEFT OUTER JOIN CTE_LASTUNSCHWOBASE_RI RIUSC                       
ON A.WorkOrderId =RIUSC.CurrentWorkOrderNo   
            
LEFT OUTER JOIN UMUserRegistration SU WITH (NOLOCK)               
ON RISC.EngineerUserIdPPM=SU.UserRegistrationId 
                        
LEFT OUTER JOIN UMUserRegistration UU WITH (NOLOCK)                        
ON RIUSC.EngineerUserIdUnsch=UU.UserRegistrationId                      
                             
            
END                    
                    
--SELECT * FROM EngAsset                     
                    
                    
                    
--SELECT * FROM FMLovMst WHERE LovId IN (55,56) 
