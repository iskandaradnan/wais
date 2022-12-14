USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QAPWorkOrderDetails_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_QAPWorkOrderDetails_Save
Description			: QAP Work Order Details Save
Authors				: DHILIP V
Date				: 20-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_QAPWorkOrderDetails_Save] 

SELECT Timestamp,* FROM EngSpareParts WHERE SparePartsId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/


create PROCEDURE  [dbo].[uspFM_QAPWorkOrderDetails_Save]

	@WorkOrderDetails [dbo].[udt_QapB1AdditionalInformationTxn] READONLY
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @ItemTable TABLE (ID INT)
	DECLARE @mItemId int = null 
-- Default Values


-- Execution

update AddInfo set	AddInfo.CauseCodeId	=	udt_AddInfo.CauseCodeId,
					AddInfo.QcCodeId	=	udt_AddInfo.QcCodeId,
					AddInfo.ModifiedBy	=	udt_AddInfo.UserId,
					ModifiedDate		=	GETDATE(),
					ModifiedDateUTC		=	GETUTCDATE()
from QapB1AdditionalInformationTxn as AddInfo inner join @WorkOrderDetails as  udt_AddInfo on AddInfo.AdditionalInfoId = udt_AddInfo.AdditionalInfoId


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

-------------------------------------------------------------------------UDT Creation-----------------------------------------------------------------------


--drop proc uspFM_QAPWorkOrderDetails_Save

--drop type udt_QapB1AdditionalInformationTxn

--CREATE TYPE [dbo].[udt_QapB1AdditionalInformationTxn] AS TABLE(
--	[AdditionalInfoId] [int] NULL,
--	[CustomerId] [int] NULL,
--	[FacilityId] [int] NULL,
--	[ServiceId] [int] NULL,
--	[CarId] [int] NULL,
--	[AssetId] [int] NULL,
--	[WorkOrderId] [int] NULL,
--	[TargetDateTime] [datetime] NULL,
--	[EndDateTime] [datetime] NULL,
--	[CauseCodeId] [int] null,
--	[QcCodeId] [int] null,
--	[UserId] [int] NULL
--)
--GO
GO
