USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Call_Indicators_Demerit]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
CREATE PROCEDURE [dbo].[Call_Indicators_Demerit]      
      
AS       
      
-- Exec [DeleteUserRole]       
      
--/*=====================================================================================================================      
--APPLICATION  : UETrack      
--NAME    : Indicators      
--DESCRIPTION  : calculate      
--AUTHORS   : vijay      
--DATE    : 31-JAN-2020      
-------------------------------------------------------------------------------------------------------------------------      
--VERSION HISTORY       
--------------------:---------------:---------------------------------------------------------------------------------------      
--Init    : Date          : Details      
--------------------:---------------:---------------------------------------------------------------------------------------      
--VIJAY IND           : 31-JAN-2020 :       
-------:------------:----------------------------------------------------------------------------------------------------*/      
BEGIN      
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
BEGIN TRY      
      
IF OBJECT_ID('tempdb..#EngMaintenanceWorkOrderStatusHistorys') IS NOT NULL                
DROP TABLE #EngMaintenanceWorkOrderStatusHistorys        
      
IF OBJECT_ID('tempdb..#EngMaintenanceWorkOrderStatusHistoryN') IS NOT NULL         
DROP TABLE #EngMaintenanceWorkOrderStatusHistoryN      
IF OBJECT_ID('tempdb..#EngMaintenanceWorkOrderStatusHistoryD') IS NOT NULL         
DROP TABLE #EngMaintenanceWorkOrderStatusHistoryD      
 --CREATE TABLE #EngMaintenanceWorkOrderStatusHistorys(      
 --[WorkOrderHistoryId] [int] NOT NULL,      
 --[CustomerId] [int] NOT NULL,      
 --[FacilityId] [int] NOT NULL,      
 --[ServiceId] [int] NOT NULL,      
 --[WorkOrderId] [int] NOT NULL,      
 --[Status] [int] NOT NULL,      
 --[CreatedBy] [int] NOT NULL,      
 --[CreatedDate] [datetime] NOT NULL,      
 --[CreatedDateUTC] [datetime] NOT NULL,      
 --[ModifiedBy] [int] NULL,      
 --[ModifiedDate] [datetime] NULL,      
 --[ModifiedDateUTC] [datetime] NULL,      
 --[Timestamp] [timestamp] NOT NULL,      
 --[GuId] [uniqueidentifier] NOT NULL,      
 --[nextStatus] [int] NOT NULL      
 --)      
      
select *,Status+1 as [nextStatus] into #EngMaintenanceWorkOrderStatusHistorys from EngMaintenanceWorkOrderStatusHistory      
      
select A.WorkOrderHistoryId,A.WorkOrderId,datediff(minute, A.CreatedDate, B.CreatedDate) as [minute] ,A.Status,B.Status,* from EngMaintenanceWorkOrderStatusHistory as A LEFT JOIN #EngMaintenanceWorkOrderStatusHistorys AS B      
ON A.WorkOrderId =B.WorkOrderId  and  A.Status = B.nextStatus  WHERE A.CreatedDate>=dateadd(MM,-1,getdate()) and B.CreatedDate>=dateadd(HH,-25,getdate())     
      
select * into #EngMaintenanceWorkOrderStatusHistoryN from #EngMaintenanceWorkOrderStatusHistorys      
      
select datediff(minute, D.CreatedDate, C.CreatedDate) as [Duration] , datediff(HOUR, C.CreatedDate, GETDATE()) as [HOUR],D.WorkOrderPriority,D.MaintenanceWorkType,datediff(minute, C.CreatedDate, GETDATE()) as [minute],D.AssetId,D.MaintenanceWorkNo,
D.WorkOrderId,C.WorkOrderHistoryId into #EngMaintenanceWorkOrderStatusHistoryD from #EngMaintenanceWorkOrderStatusHistoryN as C LEFT JOIN EngMaintenanceWorkOrderTxn as D on c.WorkOrderId=D.WorkOrderId where C.CreatedDate  
    
>=dateadd(MM,-1,getdate()) and C.CreatedDate>=dateadd(HH,-25,getdate())     
      
select * from #EngMaintenanceWorkOrderStatusHistoryD  
  
DECLARE @PractitionerId int = 0  
DECLARE @PractitionerIds int = 0  
DECLARE @Duration int = 0  
DECLARE @WorkOrderPriority int=0  
DECLARE @AssetId int=0  
DECLARE @WorkOrderId int=0  
DECLARE @pWorkOrderHistoryId int=0  
DECLARE @MaintenanceWorkType int=0  
  
  
  
WHILE(1 = 1)  
BEGIN  
  SELECT @PractitionerId = MIN(WorkOrderHistoryId)  
  FROM dbo.#EngMaintenanceWorkOrderStatusHistoryD WHERE WorkOrderHistoryId > @PractitionerId  
  IF @PractitionerId IS NULL BREAK  
  --SELECT @PractitionerId as aa  
  select * from #EngMaintenanceWorkOrderStatusHistoryD 
  select @Duration=Duration,@WorkOrderPriority=WorkOrderPriority,@MaintenanceWorkType=MaintenanceWorkType, @AssetId=AssetId,@WorkOrderId=WorkOrderId,@pWorkOrderHistoryId=WorkOrderHistoryId from #EngMaintenanceWorkOrderStatusHistoryD where WorkOrderHistoryId=@PractitionerId  
   --Add Facility ID
  exec insert_Indicators_Dud @ptime=@Duration ,@pWorkOrderPriority=@WorkOrderPriority ,@pMaintenanceWorkType=@MaintenanceWorkType ,@pAssetId=@AssetId ,@pWorkOrderId=@WorkOrderId ,@pWorkOrderHistoryId=@pWorkOrderHistoryId  
END  
  
END TRY      
BEGIN CATCH      
      
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)      
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());      
      
THROW      
      
END CATCH      
SET NOCOUNT OFF      
END 
GO
