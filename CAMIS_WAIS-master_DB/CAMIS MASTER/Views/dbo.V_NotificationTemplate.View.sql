USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_NotificationTemplate]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_NotificationTemplate]
AS
	SELECT	DISTINCT NotificationTemplateId,
			Module.ModuleName,
			Name AS NotificationName,
			Subject,
			CASE 
				WHEN TypeId = 344 THEN 'Email'
				ELSE NULL
			END		AS NotificationType,
			CASE 
				WHEN 	DisableNotification=1 THEN 'Inactive'
				 WHEN 	DisableNotification=0 THEN 'Active' end							AS DisableNotification,
			
			Temt.ModifiedDateUTC
	FROM	NotificationTemplate				AS	Temt		WITH(NOLOCK)
			LEFT JOIN FMModules	Module on Temt.ModuleId = Module.ModuleId
	WHERE	Temt.IsConfigurable=1
GO
