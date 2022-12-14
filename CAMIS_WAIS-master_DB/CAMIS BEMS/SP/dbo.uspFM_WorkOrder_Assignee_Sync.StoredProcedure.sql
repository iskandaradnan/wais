USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WorkOrder_Assignee_Sync]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_WorkOrder_Assignee_Sync
Description			: Get the list of work orders for the particular assignee with a given period
Authors				: Dhilip V
Date				: 17-Aug-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_WorkOrder_Assignee_Sync @pUserId=32,@pStartDateTime='2018-10-10 00:08:00.793',@pEndDateTime='2018-10-29 23:08:00.793'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_WorkOrder_Assignee_Sync]

	@pUserId			INT,
	@pStartDateTime		DATETIME = NULL,
	@pEndDateTime		DATETIME = NULL
		
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
 


	INSERT INTO QueueWebtoMobile (TableName
				,Tableprimaryid
				,UserId)

	SELECT	'EngMaintenanceWorkOrderTxn',
			WorkOrderId,			
			AssignedUserId
	FROM	EngMaintenanceWorkOrderTxn
	WHERE	AssignedUserId = @pUserId
			AND MaintenanceWorkDateTime >=	@pStartDateTime
			AND MaintenanceWorkDateTime <=	@pEndDateTime
		
			INSERT INTO QueueWebtoMobile (TableName
				,Tableprimaryid
				,UserId)				
	SELECT	'CRMRequestWorkOrderTxn',
			CRMRequestWOId,			
			AssignedUserId
	FROM	CRMRequestWorkOrderTxn
	WHERE	AssignedUserId = @pUserId
			AND CRMWorkOrderDateTime >=	@pStartDateTime
			AND CRMWorkOrderDateTime <=	@pEndDateTime
	
			INSERT INTO QueueWebtoMobile (TableName
				,Tableprimaryid
				,UserId)				
	SELECT	'CRMRequestCompletionInfo',
			CRMCompletionInfoId,			
			b.AssignedUserId
	FROM	CRMRequestCompletionInfo a
	outer apply(	SELECT	
			CRMRequestWOId,			
			AssignedUserId
	FROM	CRMRequestWorkOrderTxn b1 
	WHERE	 a.CRMRequestWOId = b1.CRMRequestWOId
			AND b1.AssignedUserId = @pUserId
			AND b1.CRMWorkOrderDateTime >=	@pStartDateTime
			AND b1.CRMWorkOrderDateTime <=	@pEndDateTime) b
	where  b.AssignedUserId   is not null


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
