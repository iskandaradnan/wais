USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WebNotificationSingle_Save]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_WebNotificationSingle_Save
Description			: Web Notification alert
Authors				: Dhilip V
Date				: 24-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:


EXEC [uspFM_WebNotificationSingle_Save] @pNotificationId=93,@pCustomerId=1,@pFacilityId=1,@pUserId=1,@pNotificationAlerts='DD',@pRemarks=NULL,@pHyperLink=NULL,@pIsNew=0,@pNotificationDateTime='2018-07-01'

SELECT * FROM WebNotification
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_WebNotificationSingle_Save]

@pNotificationId		INT,
@pCustomerId			INT = NULL,
@pFacilityId			INT = NULL,
@pUserId				INT = NULL,
@pNotificationAlerts	NVARCHAR(500) = NULL,
@pRemarks				NVARCHAR(500) = NULL,
@pHyperLink				NVARCHAR(500) = NULL,
@pIsNew					BIT = NULL,
@pNotificationDateTime	DATETIME = NULL,
@pEmailTempId			[INT]		=	NULL,
@pmScreenName		varchar(500) = NULL,
@pMGuid				varchar(100)		= null,
@pMultipleUserIds varchar(1000) = NULL

AS                                              

BEGIN TRY

if isnull(@pUserId,0)=0 and isnull(nullif (@pMultipleUserIds,'0'),'')=''
begin
return
end



if isnull(nullif (@pMultipleUserIds,'0'),'')='' and isnull(@pUserId,0)!=0 
begin
select @pMultipleUserIds=@pUserId
END




	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @Table1 TABLE (ID INT)
-- Default Values


-- Execution



IF (ISNULL(@pNotificationId,0)=0)
BEGIN

 
							

declare @donedate datetime;
declare @TableNotification table (Id int,userid int)
declare @TableNotification1 table (Id int,UserId int)

set @donedate = convert(varchar(10), getdate(), 120);

	          INSERT INTO WebNotification (	CustomerId,
											FacilityId,
											UserId,
											NotificationAlerts,
											Remarks,
											HyperLink,
											IsNew,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC	,
											NotificationDateTime,
											IsNavigate							                                                                                                           
										)OUTPUT INSERTED.NotificationId INTO @Table
								select
									@pCustomerId,			
									@pFacilityId,			
									--@pUserId	,			
									splitdata,
									@pNotificationAlerts	,
									@pRemarks				,
									@pHyperLink				,
									@pIsNew		,
									@pUserId	,									
									GETDATE(),
									
									GETUTCDATE(),
									@pUserId,
									GETDATE(),
									GETUTCDATE()	,	
									--@pNotificationDateTime
									GETDATE(),
									--@donedate,
									0				   
						from dbo.fnSplitString(@pMultipleUserIds,',')  where (len(splitdata)>0 and splitdata>0)


if @pmScreenName is not null
begin
						INSERT INTO FENotification ( UserId,
							  NotificationAlerts,
							  Remarks,
							  CreatedBy,
							  CreatedDate,
							  CreatedDateUTC,
							  ModifiedBy,
							  ModifiedDate,
							  ModifiedDateUTC,
							  ScreenName,
							  DocumentId,
							  SingleRecord
							 ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotification
						  SELECT 
							--@pUserId,
							splitdata,
							@pNotificationAlerts,
							@pRemarks,
							@pUserId,
							GETDATE(),
							GETUTCDATE(),
							@pUserId,
							GETDATE(),
							GETUTCDATE(),
							@pmScreenName,
							@pMGuid,
							1
							from dbo.fnSplitString(@pMultipleUserIds,',') where (len(splitdata)>0 and splitdata>0)
						  --FROM #Temp
      
					  INSERT INTO QueueWebtoMobile (  TableName,
								Tableprimaryid,
								UserId
							  )
						  SELECT 'FENotification',
							ID,
							--@pUserId
							UserId
						  FROM @TableNotification
end

SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = @pEmailTempId


	
	SELECT	distinct A.UserRegistrationId,
			b.FacilityId,
			b.CustomerId		
		INTO	#TempUserEmails_all
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification)
	AND B.FacilityId	= @pFacilityId
	--IN (SELECT DISTINCT FacilityId FROM #Notification)
	
	


					INSERT INTO WebNotification (	CustomerId,
											FacilityId,
											UserId,
											NotificationAlerts,
											Remarks,
											HyperLink,
											IsNew,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC	,
											NotificationDateTime,
											IsNavigate							                                                                                                           
										)OUTPUT INSERTED.NotificationId INTO @Table1

										select  A.CustomerId,
												A.FacilityId,
												A.UserRegistrationId,
												@pNotificationAlerts,
												@pRemarks		,
												@pHyperLink		,
												@pIsNew		,
												@pUserId	,	
												GETDATE(),									
												GETUTCDATE(),
												@pUserId,
												GETDATE(),
												GETUTCDATE()	,
												GETDATE(),
												0	
										from #TempUserEmails_all a




if @pmScreenName is not null
begin

					INSERT INTO FENotification ( UserId,
							  NotificationAlerts,
							  Remarks,
							  CreatedBy,
							  CreatedDate,
							  CreatedDateUTC,
							  ModifiedBy,
							  ModifiedDate,
							  ModifiedDateUTC,
							  ScreenName,
							  DocumentId,
							  SingleRecord
							 ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotification1
						  SELECT UserRegistrationId,
							@pNotificationAlerts,
							@pRemarks,
							@pUserId,
							GETDATE(),
							GETUTCDATE(),
							@pUserId,
							GETDATE(),
							GETUTCDATE(),
							@pmScreenName,
							@pMGuid,
							1
						  FROM #TempUserEmails_all
      
					  INSERT INTO QueueWebtoMobile (  TableName,
								Tableprimaryid,
								UserId
							  )
						  SELECT 'FENotification',
							ID,
							UserId
						  FROM @TableNotification1

							
end 

			   	   SELECT	NotificationId,
							[Timestamp],
							NotificationAlerts,
							IsNew,
							'' as ErrorMessage
				   FROM		WebNotification
				   WHERE	NotificationId IN (SELECT ID FROM @Table) 
				    or 	 NotificationId	IN (SELECT ID FROM @Table1) 
				   


	
		END
  ELSE
	  BEGIN


			BEGIN

				UPDATE WebNotification SET	
								IsNew					= @pIsNew,
								ModifiedBy				= @pUserId,
								ModifiedDate			=	GETDATE(),
								ModifiedDateUTC			=	GETUTCDATE()
								OUTPUT INSERTED.NotificationId INTO @Table
				WHERE ISNULL(NotificationId,0) = @pNotificationId


			   	   SELECT	NotificationId,
							[Timestamp],
							NotificationAlerts,
							IsNew,
							'' as ErrorMessage
				   FROM		WebNotification
				WHERE	NotificationId IN (SELECT ID FROM @Table)

	END
	
	END

	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   


END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

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
