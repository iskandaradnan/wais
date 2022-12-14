USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_NotificationDeliveryDet_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoReschedulingTxn_Save
Description			: If Planner Reschedule details already exists then update else insert.
Authors				: Balaji M S
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @NotificationDeliveryDet		[dbo].[udt_NotificationDeliveryDet]
INSERT INTO @NotificationDeliveryDet ([NotificationDeliveryId],[NotificationTemplateId],[RecepientType],[UserRoleId],[UserRegistrationId],[FacilityId],[UserId],EmailId,CompanyId) values
(0,1,1,1,1,1,2,'',''),
(0,1,1,1,1,1,2,'','')
EXECUTE [uspFM_NotificationDeliveryDet_Save] @NotificationDeliveryDet

select * from NotificationDeliveryDet

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_NotificationDeliveryDet_Save]
	
		@NotificationDeliveryDet					[dbo].[udt_NotificationDeliveryDet] null   READONLY  ,
		@pDisableNotification						BIT,
		@pNotificationTemplateId					INT

AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	

-- Default Values

			
		UPDATE NotificationTemplate SET DisableNotification = @pDisableNotification WHERE NotificationTemplateId = @pNotificationTemplateId		

-- Execution
 IF NOT EXISTS (SELECT 1 FROM @NotificationDeliveryDet)  RETURN


 ELSE

	IF EXISTS (SELECT 1 FROM NotificationDeliveryDet	A  INNER JOIN @NotificationDeliveryDet B ON A.NotificationDeliveryId = B.NotificationDeliveryId)

		BEGIN
			UPDATE NotificationDelivery SET
							NotificationDelivery.RecepientType								= NotificationDeliveryType.RecepientType,
							NotificationDelivery.UserRoleId									= NotificationDeliveryType.UserRoleId,
							NotificationDelivery.UserRegistrationId							= NotificationDeliveryType.UserRegistrationId,
							NotificationDelivery.FacilityId									= NotificationDeliveryType.FacilityId,
							NotificationDelivery.ModifiedBy									= NotificationDeliveryType.UserId,
							NotificationDelivery.ModifiedDate								= GETDATE(),
							NotificationDelivery.ModifiedDateUTC							= GETUTCDATE(),
							NotificationDelivery.EmailId									= NotificationDeliveryType.EmailId,
							NotificationDelivery.CompanyId									= NotificationDeliveryType.CompanyId
							OUTPUT INSERTED.NotificationDeliveryId INTO @Table
			FROM			NotificationDeliveryDet 		AS NotificationDelivery
			INNER JOIN 		@NotificationDeliveryDet		AS NotificationDeliveryType		ON	NotificationDelivery.NotificationDeliveryId = NotificationDeliveryType.NotificationDeliveryId
			WHERE			ISNULL(NotificationDeliveryType.NotificationDeliveryId,0)>0

					UPDATE NotificationTemplate SET DisableNotification = @pDisableNotification WHERE NotificationTemplateId = @pNotificationTemplateId

					SELECT	NotificationDeliveryId,
				[Timestamp],
				'' AS ErrorMessage
		FROM	NotificationDeliveryDet
		WHERE	NotificationDeliveryId IN (SELECT ID FROM @Table)



		END

	IF EXISTS (SELECT 1 FROM  @NotificationDeliveryDet where ISNULL(NotificationDeliveryId,0)=0)

		BEGIN
			INSERT INTO NotificationDeliveryDet(
								NotificationTemplateId,
								RecepientType,
								UserRoleId,
								UserRegistrationId,
								FacilityId,
								CreatedBy,
								CreatedDate,
								CreatedDateUTC,
								ModifiedBy,
								ModifiedDate,
								ModifiedDateUTC,
								EmailId,
								CompanyId
							)	OUTPUT INSERTED.NotificationDeliveryId INTO @Table
							SELECT 
							
							 NotificationTemplateId,
							 RecepientType,
							 UserRoleId,
							 UserRegistrationId,
							 FacilityId,
							 UserId,
							 GETDATE(),
							 GETUTCDATE(),
							 UserId,
							 GETDATE(),
							 GETUTCDATE(),
							 EmailId,
							 CompanyId
						FROM @NotificationDeliveryDet WHERE ISNULL(NotificationDeliveryId,0) = 0
		END
	
	
	

		SELECT	NotificationDeliveryId,
				[Timestamp],
				'' AS ErrorMessage
		FROM	NotificationDeliveryDet
		WHERE	NotificationDeliveryId IN (SELECT ID FROM @Table)


	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           COMMIT TRANSACTION
 --       END   


END TRY

BEGIN CATCH

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           ROLLBACK TRAN
 --       END

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

-----------------------------------------------------------------------------------UDT CREATION ---------------------------------------------------

--drop proc [uspFM_NotificationDeliveryDet_Save]
--drop type [udt_NotificationDeliveryDet]

--CREATE TYPE [dbo].[udt_NotificationDeliveryDet] AS TABLE(
--	[NotificationDeliveryId] [int] NULL,
--	[NotificationTemplateId] [int] NULL,
--	[RecepientType] [int] NULL,
--	[UserRoleId] [int] NULL,
--	[UserRegistrationId] [int] NULL,
--	[FacilityId] [int] NULL,
--	[UserId] [int] NULL,
--	[EmailId] [nvarchar](100) null,
--	[CompanyId] [int] NULL
--)
GO
