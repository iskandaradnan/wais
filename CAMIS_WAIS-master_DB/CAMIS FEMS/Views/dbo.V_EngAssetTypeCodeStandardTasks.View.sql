USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngAssetTypeCodeStandardTasks]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_EngAssetTypeCodeStandardTasks]
AS
	SELECT	StandardTasks.StandardTaskId, 
			Service.ServiceKey as ServiceName,
			WorkGroup.WorkGroupDescription	AS WorkGroupName,
		    TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			StandardTasks.Active,
			StandardTasks.ModifiedDateUTC
	FROM  EngAssetTypeCodeStandardTasks	AS StandardTasks	
	--INNER JOIN  EngAssetTypeCodeStandardTasksDet AS StandardTasksDet on StandardTasks.StandardTaskId =StandardTasksDet.StandardTaskId
	INNER JOIN MstService AS Service on StandardTasks.ServiceId=Service.ServiceId
	INNER JOIN EngAssetTypeCode AS	TypeCode on StandardTasks.AssetTypeCodeId= TypeCode.AssetTypeCodeId
	INNER JOIN EngAssetWorkGroup	AS	WorkGroup ON	StandardTasks.WorkGroupId	=	WorkGroup.WorkGroupId 
	WHERE StandardTasks.Active= 1 and TypeCode.Active=1
GO
