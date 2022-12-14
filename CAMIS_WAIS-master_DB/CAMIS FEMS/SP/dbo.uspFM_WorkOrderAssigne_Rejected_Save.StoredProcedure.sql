USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WorkOrderAssigne_Rejected_Save]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_WorkOrderAssigne_Rejected_Save
Description			: staff rejected the work order
Authors				: Dhilip V
Date				: 24-Aug-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_WorkOrderAssigne_Rejected_Save @pWorkOrderId=554

SELECT * FROM FENotification

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_WorkOrderAssigne_Rejected_Save]
		
		@pWorkOrderId  INT

AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE @mDateFmt NVARCHAR(100)
	DECLARE @mDateFmtValue NVARCHAR(100)
	DECLARE @PrimaryKeyId int

-- Default Values


-- Execution

		DELETE FROM FEUserAssigned WHERE Userid IN (SELECT AssignedUserId FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId)

		
		UPDATE EngMaintenanceWorkOrderTxn SET	AssignedUserId	=	null,
												AssigneeLovId	=	330
		WHERE WorkOrderId =	@pWorkOrderId
		

	SELECT	WorkOrderId,
			AssignedUserId,
			AssigneeLovId
	FROM EngMaintenanceWorkOrderTxn
	WHERE WorkOrderId =	@pWorkOrderId


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
GO
