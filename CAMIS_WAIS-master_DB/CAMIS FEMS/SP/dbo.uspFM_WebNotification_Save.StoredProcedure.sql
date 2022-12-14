USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WebNotification_Save]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_WebNotification_Save
Description			: Web Notification alert
Authors				: Dhilip V
Date				: 24-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @pWebNotification		dbo.udt_WebNotification
INSERT INTO @pWebNotification (NotificationId,CustomerId,FacilityId,UserId,NotificationAlerts,Remarks,HyperLink,IsNew,SessionUserId,NotificationDateTime) VALUES
(0,1,1,1,'Alert 1',null,'um/umchangepassword',1,1,getdate())

EXEC [uspFM_WebNotification_Save] @pWebNotification=@pWebNotification

SELECT * FROM WebNotification
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_WebNotification_Save]

	@pWebNotification  dbo.udt_WebNotification READONLY

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

-- Default Values


-- Execution

IF EXISTS (SELECT * FROM @pWebNotification WHERE ISNULL(NotificationId,0)=0)
BEGIN

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
											NotificationDateTime							                                                                                                           
										)OUTPUT INSERTED.NotificationId INTO @Table
								SELECT 
									CustomerId,
									FacilityId,
									UserId,
									NotificationAlerts,
									Remarks,
									HyperLink,
									IsNew,
									[SessionUserId],
									GETDATE(),
									GETUTCDATE(),
									[SessionUserId],
									GETDATE(),
									GETUTCDATE()	,
									--NotificationDateTime		
									GETDATE()						   
							FROM	@pWebNotification
							WHERE	ISNULL(NotificationId,0)=0


			   	   SELECT	NotificationId,
							[Timestamp],
							NotificationAlerts,
							IsNew,
							'' as ErrorMessage
				   FROM		WebNotification
				   WHERE	NotificationId IN (SELECT ID FROM @Table)
	
		END
  ELSE
	  BEGIN


			BEGIN

				UPDATE A SET	
								A.IsNew					= B.IsNew,
								ModifiedBy				= B.[SessionUserId],
								ModifiedDate			=	GETDATE(),
								ModifiedDateUTC			=	GETUTCDATE()
								OUTPUT INSERTED.NotificationId INTO @Table
				FROM	WebNotification A 
						INNER JOIN @pWebNotification B ON A.NotificationId = B.NotificationId
				WHERE ISNULL(A.NotificationId,0) >0


			   	   SELECT	NotificationId,
							[Timestamp],
							NotificationAlerts,
							IsNew,
							'' as ErrorMessage
				   FROM		WebNotification
				WHERE	NotificationId IN (SELECT ID FROM @Table)

	END
	
	END

	UPDATE A SET	
								A.IsNew					= 0,
								ModifiedBy				= (select top 1 [SessionUserId] from @pWebNotification B ),
								ModifiedDate			=	GETDATE(),
								ModifiedDateUTC			=	GETUTCDATE()
								OUTPUT INSERTED.NotificationId INTO @Table
				FROM	WebNotification A 						
				WHERE isnull(IsNew ,0)=1
				and FacilityId  in (select top 1 FacilityId from @pWebNotification )
				and UserId  in (select top 1 userid from @pWebNotification  )



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
