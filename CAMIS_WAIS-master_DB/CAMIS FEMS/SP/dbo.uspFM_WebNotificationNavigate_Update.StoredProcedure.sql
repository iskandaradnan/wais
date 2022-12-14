USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WebNotificationNavigate_Update]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoCompletionInfoTxn_Save
Description			: If Maintenance Work Order Completion Info already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @WebNotificationNavigate		[dbo].[udt_WebNotificationNavigate]
INSERT INTO @WebNotificationNavigate (NotificationId,IsNavigate,UserId) values
(95,1,2),
(96,1,2),
(97,1,2)
EXECUTE [uspFM_WebNotificationNavigate_Update] @WebNotificationNavigate

select * from WebNotification


-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_WebNotificationNavigate_Update]
		
		@WebNotificationNavigate			[dbo].[udt_WebNotificationNavigate]   READONLY
		
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT



--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.EngMwoCompletionInfoTxn

			IF((SELECT COUNT(*) FROM @WebNotificationNavigate) =0)

BEGIN
	
	RETURN

END

ELSE

BEGIN

		UPDATE B SET B.IsNavigate = 1 FROM @WebNotificationNavigate A INNER JOIN WebNotification B ON A.NotificationId = B.NotificationId

END



	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
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

-----------------------------------------------------------------------------------UDT CREATION ---------------------------------------------------

--drop proc [uspFM_WebNotificationNavigate_Update]
--drop type udt_WebNotificationNavigate


--CREATE TYPE [dbo].[udt_WebNotificationNavigate] AS TABLE(
--	[NotificationId] [int] NULL,
--	[IsNavigate] [bit] NULL,
--	[UserId] [int] NULL
--)
GO
