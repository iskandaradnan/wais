USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRescheduling_Save]    Script Date: 20-09-2021 16:43:00 ******/
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
DECLARE @CRMRescheduling		[dbo].[udt_CRMRescheduling]
INSERT INTO @CRMRescheduling (CRMRequestWOId,AssignedUserId) values
(134,1),
(135,1)
EXECUTE [uspFM_CRMRescheduling_Save] @CRMRescheduling

select * from CRMRequestWorkOrderTxn
SELECT * FROM QueueWebtoMobile
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRescheduling_Save]
	
		@CRMRescheduling					[dbo].[udt_CRMRescheduling]   READONLY

AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values


-- Execution
 

			IF((SELECT COUNT(*) FROM @CRMRescheduling) =0)

BEGIN
	
	RETURN

END

ELSE

BEGIN

		UPDATE B SET B.AssignedUserId = A.AssignedUserId FROM @CRMRescheduling A INNER JOIN CRMRequestWorkOrderTxn B ON A.CRMRequestWOId = B.CRMRequestWOId

END
	


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

--drop proc [uspFM_CRMRescheduling_Save]
--drop type udt_CRMRescheduling


--CREATE TYPE [dbo].[udt_CRMRescheduling] AS TABLE(
--	[CRMRequestWOId] [int] NULL,
--	[AssignedUserId] [int] NULL
	
--)
GO
