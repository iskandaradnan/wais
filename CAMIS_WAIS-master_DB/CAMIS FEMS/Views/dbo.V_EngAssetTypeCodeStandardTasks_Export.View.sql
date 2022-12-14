USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngAssetTypeCodeStandardTasks_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_EngAssetTypeCodeStandardTasks_Export]
AS
	SELECT	Service.ServiceKey as ServiceName, 
			WorkGroup.WorkGroupCode,
			WorkGroup.WorkGroupDescription	AS WorkGroupName,
			TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			StandardTasksDet.TaskCode,
			StandardTasksDet.TaskDescription,
			CASE WHEN StandardTasks.Active=1 THEN 'Active'
				 WHEN StandardTasks.Active=0 THEN 'InActive'
			END								AS		StatusValue,					
			StandardTasks.ModifiedDateUTC
	 FROM	EngAssetTypeCodeStandardTasks					AS	StandardTasks		WITH(NOLOCK)
			INNER JOIN  EngAssetTypeCodeStandardTasksDet	AS	StandardTasksDet	WITH(NOLOCK) ON StandardTasks.StandardTaskId	=	StandardTasksDet.StandardTaskId
			INNER JOIN	MstService							AS	Service				WITH(NOLOCK) ON StandardTasks.ServiceId			=	Service.ServiceId
			INNER JOIN	EngAssetTypeCode					AS	TypeCode			WITH(NOLOCK) ON StandardTasks.AssetTypeCodeId	=	TypeCode.AssetTypeCodeId
			INNER JOIN EngAssetWorkGroup					AS	WorkGroup 			WITH(NOLOCK) ON	StandardTasks.WorkGroupId		=	WorkGroup.WorkGroupId
GO
