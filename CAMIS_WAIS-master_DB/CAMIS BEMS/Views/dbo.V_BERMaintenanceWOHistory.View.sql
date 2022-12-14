USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_BERMaintenanceWOHistory]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_BERMaintenanceWOHistory]
AS
    SELECT	BERApplication.ApplicationId						AS ApplicationId,
			BERApplication.BERno								AS BERno,
			BERApplication.ApplicationDate						AS ApplicationDate,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS MaintenanceWorkDateTime,
			MaintenanceCategory.FieldValue						AS MaintenanceWorkCategory,
			MaintenanceType.FieldValue							AS MaintenanceWorkType,
			MwoCompletionInfo.DowntimeHoursMin					AS DowntimeHoursMin,
			MwoCompletionInfo.TotalCost							AS TotalCost,
			MaintenanceWorkOrder.ModifiedDateUTC
	FROM	BERApplicationTxn									AS BERApplication			WITH(NOLOCK)
			INNER JOIN EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder		WITH(NOLOCK)	ON BERApplication.AssetId						= MaintenanceWorkOrder.AssetId
			INNER JOIN EngMwoCompletionInfoTxn					AS MwoCompletionInfo		WITH(NOLOCK)	ON MaintenanceWorkOrder.WorkOrderId				= MwoCompletionInfo.WorkOrderId
			INNER JOIN FMLovMst									AS MaintenanceCategory		WITH(NOLOCK)	ON MaintenanceWorkOrder.MaintenanceWorkCategory	= MaintenanceCategory.LovId
			INNER JOIN FMLovMst									AS MaintenanceType			WITH(NOLOCK)	ON MaintenanceWorkOrder.MaintenanceWorkType		= MaintenanceType.LovId
GO
