USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_NotificationTemplate_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_NotificationTemplate_Export]
AS
	SELECT	DISTINCT Temt.NotificationTemplateId,
			Module.ModuleName,
			Temt.Name AS NotificationName,
			Subject,
			CASE 
				WHEN TypeId = 344 THEN 'Email'
				ELSE NULL
			END		AS NotificationType,
			CASE 
				WHEN DisableNotification = 1 THEN 'Inactive'
				ELSE 'Active'
			END		AS DisableNotification,
			UserRole.UMUserRoleId,
			UserRole.Name AS UserRoleName,
			UserType.UserTypeId,
			UserType.Name AS UserTypeName,
			UserRegistration.StaffName,
			Temt.ModifiedDateUTC
	FROM	NotificationTemplate	     	   AS  Temt				WITH(NOLOCK)
	LEFT JOIN NotificationDeliveryDet          AS  Delivery			WITH(NOLOCK)     ON Temt.NotificationTemplateId = Delivery.NotificationTemplateId
	LEFT JOIN UMUserRole			           AS  UserRole			WITH(NOLOCK)     ON Delivery.UserRoleId			= UserRole.UMUserRoleId
	LEFT JOIN UMUserType			           AS  UserType			WITH(NOLOCK)     ON UserRole.UserTypeId			= UserType.UserTypeId
	LEFT JOIN UMUserRegistration	           AS  UserRegistration	WITH(NOLOCK)     ON Delivery.UserRegistrationId	= UserRegistration.UserRegistrationId
	LEFT JOIN FMModules	Module on Temt.ModuleId = Module.ModuleId
	WHERE Temt.IsConfigurable=1
GO
