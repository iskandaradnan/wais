USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_NotificationDeliveryDet_GetById]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_NotificationDeliveryDet_GetById
Description			: To Get the data from table EngPPMRescheduleTxnDet using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_NotificationDeliveryDet_GetById] @pNotificationTemplateId=19, @pUserId='1',@pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_NotificationDeliveryDet_GetById]                           
  @pUserId						INT  =null, 
  @pNotificationTemplateId					INT ,
  @pFacilityId					INT
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pNotificationTemplateId,0) = 0) RETURN

    SELECT	--NotificationDelivery.NotificationDeliveryId							AS NotificationDeliveryId,
			Template.NotificationTemplateId										AS NotificationTemplateId,
			Template.Name														AS Name,
			Template.Definition													AS Definition,
			Template.Subject													AS Subject,
			Template.TypeId														AS TypeId,
			TypeId.FieldValue													AS TypeValue,
			Template.ServiceId													AS ServiceId,
			Service.ServiceKey													AS ServiceKey,
			DisableNotification															AS DisableNotificationId,
			CASE WHEN 	DisableNotification=1 THEN 'Inactive'
				 WHEN 	DisableNotification=0 THEN 'Active' end							AS DisableNotification,
			Template.Timestamp										AS Timestamp
	FROM	NotificationTemplate												AS Template					WITH(NOLOCK)
			--LEFT  JOIN  NotificationDeliveryDet									AS NotificationDelivery		WITH(NOLOCK)		on NotificationDelivery.NotificationTemplateId			= Template.NotificationTemplateId
			LEFT  JOIN  MstService												AS Service					WITH(NOLOCK)		on Template.ServiceId									= Service.ServiceId
			LEFT  JOIN	FMLovMst												AS TypeId					WITH(NOLOCK)		on Template.TypeId										= TypeId.LovId
	WHERE	Template.NotificationTemplateId = @pNotificationTemplateId 


	 SELECT	NotificationDelivery.NotificationDeliveryId							AS NotificationDeliveryId,
			NotificationDelivery.NotificationTemplateId							AS NotificationTemplateId,
			NotificationDelivery.RecepientType									AS RecepientType,
			RecepientType.FieldValue											AS RecepientTypeValue,
			NotificationDelivery.UserRoleId										AS UserRoleId,
			UserRole.Name														AS UserRoleValue,
			UserType.UserTypeId													AS UserTypeId,
			UserType.Name														AS UserTypeName,
			NotificationDelivery.UserRegistrationId								AS UserRegistrationId,
			UserRegistration.StaffName											AS UserRegistrationStaffName,
			NotificationDelivery.FacilityId										AS FacilityId,
			Facility.FacilityCode												AS FacilityCode,
			Facility.FacilityName											    AS FacilityName,
			NotificationDelivery.EmailId										AS EmailId,
			NotificationDelivery.Timestamp										AS Timestamp,
			NotificationDelivery.GuId											AS GuId,
			NotificationDelivery.CompanyId										AS CompanyId,
			CustomerCompany.CustomerName										AS CompanyValue

	FROM	NotificationDeliveryDet												AS NotificationDelivery		WITH(NOLOCK)
			INNER JOIN  NotificationTemplate									AS Template					WITH(NOLOCK)		on NotificationDelivery.NotificationTemplateId			= Template.NotificationTemplateId
			INNER JOIN  MstService												AS Service					WITH(NOLOCK)		on Template.ServiceId									= Service.ServiceId
			INNER JOIN	FMLovMst												AS TypeId					WITH(NOLOCK)		on Template.TypeId										= TypeId.LovId
			INNER JOIN	FMLovMst												AS RecepientType			WITH(NOLOCK)		on NotificationDelivery.RecepientType					= RecepientType.LovId
			INNER JOIN	UMUserRole												AS UserRole					WITH(NOLOCK)		on NotificationDelivery.UserRoleId						= UserRole.UMUserRoleId
			INNER JOIN	UMUserType												AS UserType					WITH(NOLOCK)		on UserRole.UserTypeId									= UserType.UserTypeId
			INNER JOIN	UMUserRegistration										AS UserRegistration			WITH(NOLOCK)		on NotificationDelivery.UserRegistrationId				= UserRegistration.UserRegistrationId
			INNER JOIN	MstLocationFacility										AS Facility					WITH(NOLOCK)		on NotificationDelivery.FacilityId						= Facility.FacilityId
			INNER JOIN	MstCustomer												AS Customer					WITH(NOLOCK)		on Facility.CustomerId									= Customer.CustomerId
			LEFT JOIN	MstCustomer												AS CustomerCompany			WITH(NOLOCK)		on NotificationDelivery.CompanyId									= CustomerCompany.CustomerId
	WHERE	NotificationDelivery.NotificationTemplateId = @pNotificationTemplateId AND NotificationDelivery.FacilityId = @pFacilityId 
	ORDER BY NotificationDelivery.ModifiedDate DESC
END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		THROW;

END CATCH
GO
